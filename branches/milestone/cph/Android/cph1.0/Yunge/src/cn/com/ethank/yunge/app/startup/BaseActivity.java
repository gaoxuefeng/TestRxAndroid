package cn.com.ethank.yunge.app.startup;

import android.app.Activity;
import android.os.Bundle;
import cn.com.ethank.yunge.app.util.AppManager;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;

import com.umeng.analytics.MobclickAgent;

/**
 * 包括友盟统计 Created by dddd on 2015/5/8. 所有的Activity继承这个activity
 */
public class BaseActivity extends Activity {
	protected BaseActivity context;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		context = this;
		AppManager.getAppManager().addActivity(this);
	}

	@Override
	protected void onRestart() {
		super.onRestart();
	}

	@Override
	protected void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
	}

	@Override
	protected void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		try {
			ProgressDialogUtils.dismiss();
			AppManager.getAppManager().removeActivity(this);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
