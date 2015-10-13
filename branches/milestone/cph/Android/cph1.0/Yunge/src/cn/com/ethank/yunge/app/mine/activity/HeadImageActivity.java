package cn.com.ethank.yunge.app.mine.activity;

import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;

public class HeadImageActivity extends BaseActivity {
	@Override
	public void setContentView(int layoutResID) {
		super.setContentView(layoutResID);
		setContentView(R.layout.activity_head_big);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
	}
}
