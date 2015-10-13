package cn.com.ethank.yunge.app.homepager;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.crypt.Base64CryptoCoding;
import cn.com.ethank.yunge.app.home.BaseWebActivity;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.manoeuvre.ShareBean;
import cn.com.ethank.yunge.app.manoeuvre.SharePopUpWindow;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.mine.bean.UserInfo.Data.User;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.util.coding.AbstractCoding;

public class ActivityWebWithTitleActivity extends BaseWebActivity {
	private ActivityBean activityBean;
	private String shopUrl = "";
	private View shareLayout;
	private SharePopUpWindow sharePopUpWindow;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// BaseWebActivity
		title.setVisibility(View.VISIBLE);
		title.showBtnFunction(true);
		title.setFunctionDrawable(0);
		title.setBtnFunctionText("分享");
		title.setOnBtnFunctionClickAction(this);
		initData();
		showData();
		initSharePop();
	}

	private void initSharePop() {
		shareLayout = LayoutInflater.from(this).inflate(R.layout.activity_layout_pre_share, null);
		sharePopUpWindow = new SharePopUpWindow(this, shareLayout);

	}

	private void showData() {
		if (activityBean.getUidpass() == 1) {
			String token = Constants.getToken();

			if (!SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result).isEmpty()) {
				UserInfo userinfo = JSON.parseObject(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result), UserInfo.class);
				if (userinfo != null) {
					UserInfo.Data data = userinfo.getData();
					if (data != null) {
						User user = data.getUserInfo();
						if (user != null) {
							String name = "";
							try {
								name = URLEncoder.encode(user.getNickName(), "utf-8");
							} catch (UnsupportedEncodingException e) {
								e.printStackTrace();
							}
							shopUrl = shopUrl + "?uid=" + token + "&userName=" + name;
							// shopUrl =
							// "http://192.168.1.141:8080/ethank-yunge-deploy/luckydraw/html/luckdraw.html?uid="
							// + token + "&userName=" + name;
						}
					}
				}
			}
		}
		web.loadUrl(shopUrl);
	}

	private void initData() {
		Bundle bundle = getIntent().getExtras();
		if (bundle != null && bundle.containsKey("activityBean")) {
			activityBean = (ActivityBean) bundle.get("activityBean");

		} else {
			activityBean = new ActivityBean();
		}
		// String activityTheme = activityBean.getActivityTheme();
		// if (activityTheme.isEmpty()) {
		// activityTheme = "潮趴汇活动";
		// }
		title.setTitle("活动详情");
		shopUrl = activityBean.getHtmlUrl();
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {

		case R.id.title_function:
			if (sharePopUpWindow == null) {
				initSharePop();

			}
			ShareBean shareBean = new ShareBean();

			shareBean.setShareTitle(activityBean.getActivityTheme());
			shareBean.setShareContent(activityBean.getShareTitle());
			shareBean.setShareUrl(activityBean.getShareUrl());
			shareBean.setShareImageResource(R.drawable.ic_launch);
			sharePopUpWindow.showAtLocation(web, shareBean);
			break;

		default:
			super.onClick(view);
			break;
		}

	}
}
