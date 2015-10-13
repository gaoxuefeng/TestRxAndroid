package cn.com.ethank.yunge.app.startup;

import java.util.ArrayList;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.sys.SysInfo;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.View.OnClickListener;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

public class LoadingImagesActivity extends BaseActivity {
	private ViewPager vp_loading;
	private LoadingViewPagerAdapter loadingViewPagerAdapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_loaing_images);
		vp_loading = (ViewPager) findViewById(R.id.vp_loading);
		initLoadingData();
		SysInfo sysInfo = CoyoteSystem.getCurrent().getSysInfo();
		int currentCode = sysInfo.getAppVersionCode();
		SharePreferencesUtil.saveIntData(SharePreferenceKeyUtil.lastTimeBuildCode, currentCode);
	}

	private void initLoadingData() {

		ArrayList<View> mListViews = new ArrayList<View>();
		View view1 = getLayoutInflater().inflate(R.layout.layout_loading1, null);
		mListViews.add(view1);
		View view2 = getLayoutInflater().inflate(R.layout.layout_loading2, null);
		mListViews.add(view2);
		View view3 = getLayoutInflater().inflate(R.layout.layout_loading3, null);
		mListViews.add(view3);
		View view4 = getLayoutInflater().inflate(R.layout.layout_loading4, null);
		mListViews.add(view4);
		loadingViewPagerAdapter = new LoadingViewPagerAdapter(this, mListViews);
		vp_loading.setAdapter(loadingViewPagerAdapter);
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {

	}

}
