package cn.com.ethank.yunge.app.mine.activity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;

import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class AboutActivity extends BaseActivity implements OnClickListener{
	@ViewInject(R.id.about_tv_exit)
	private TextView about_tv_exit;  //--退后到设置--
	
	@ViewInject(R.id.set_rl_service)
	private RelativeLayout set_rl_service;
	
	@ViewInject(R.id.about_tv_phone)
	private TextView about_tv_phone;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_about);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
		ViewUtils.inject(this);
		about_tv_exit.setOnClickListener(this);
		
		set_rl_service.setOnClickListener(this);
		about_tv_phone.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.about_tv_exit:
			finish();
			break;
		case R.id.set_rl_service:
			Intent intent = new Intent(getApplicationContext(), ServiceActivity.class);
			startActivity(intent);
			finish();
			break;
		case R.id.about_tv_phone:
			Intent intent2 = new Intent(Intent.ACTION_CALL, Uri.parse("tel:010-84775234"));
			startActivity(intent2);
			break;
		}
	}
}
