package cn.com.ethank.yunge.app.homepager;

import android.os.Bundle;
import android.view.View;
import cn.com.ethank.yunge.app.home.BaseWebActivity;
import cn.com.ethank.yunge.app.home.bean.HomeInfo;
import cn.jpush.android.util.ac;

public class WebWithTitleActivity extends BaseWebActivity {
	private ActivityBean activityBean;
	private String shopUrl;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// BaseWebActivity
		title.setVisibility(View.VISIBLE);
		initData();
		showData();
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
		String activityTheme = activityBean.getActivityTheme();
		if (activityTheme.isEmpty()) {
			activityTheme = "潮趴汇活动";
		}
		title.setTitle(activityTheme);
		shopUrl = activityBean.getHtmlUrl();
	}

}
