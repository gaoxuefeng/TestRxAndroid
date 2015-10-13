package cn.com.ethank.yunge.app.home.activity;

import android.os.Bundle;
import cn.com.ethank.yunge.app.home.BaseWebActivity;
import cn.com.ethank.yunge.app.home.bean.HomeInfo;

public class WebMerchantDetailActivity extends BaseWebActivity {
	private HomeInfo homeInfo;
	private String shopUrl;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//BaseWebActivity
		initData();
		showData();
	}

	private void showData() {
		web.loadUrl(shopUrl);
	}

	private void initData() {
		Bundle bundle = getIntent().getExtras();
		if (bundle.containsKey("homeInfo")) {
			homeInfo = (HomeInfo) bundle.get("homeInfo");

		} else {
			homeInfo = new HomeInfo();
		}
		title.setTitle(homeInfo.getKTVName());
		shopUrl = homeInfo.getShopUrl();
	}

}
