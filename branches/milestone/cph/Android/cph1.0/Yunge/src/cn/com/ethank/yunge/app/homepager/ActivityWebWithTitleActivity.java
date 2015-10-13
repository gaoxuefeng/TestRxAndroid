package cn.com.ethank.yunge.app.homepager;

import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.BaseWebActivity;
import cn.com.ethank.yunge.app.manoeuvre.ShareBean;
import cn.com.ethank.yunge.app.manoeuvre.SharePopUpWindow;

public class ActivityWebWithTitleActivity extends BaseWebActivity {
	private ActivityBean activityBean;
	private String shopUrl;
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
		shareLayout = LayoutInflater.from(this).inflate(R.layout.layout_pre_share, null);
		sharePopUpWindow = new SharePopUpWindow(this, shareLayout);

	}

	private void showData() {
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
			shareBean.setShareContent(activityBean.getActivityTime());
			shareBean.setShareUrl(activityBean.getHtmlUrl());
			shareBean.setShareImageResource(R.drawable.ic_launch);
			sharePopUpWindow.showAtLocation(web, shareBean);
			break;

		default:
			super.onClick(view);
			break;
		}

	}
}
