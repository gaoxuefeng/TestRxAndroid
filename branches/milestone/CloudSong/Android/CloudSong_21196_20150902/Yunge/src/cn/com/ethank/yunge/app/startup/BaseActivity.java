package cn.com.ethank.yunge.app.startup;

import android.app.Activity;
import android.os.Bundle;
import cn.com.ethank.yunge.app.util.AppManager;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;

import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.network.OnNetworkChangedListener;
import com.umeng.analytics.MobclickAgent;

/**
 * 包括友盟统计 Created by dddd on 2015/5/8. 所有的Activity继承这个activity
 */
public abstract class BaseActivity extends Activity implements OnNetworkChangedListener {
	protected BaseActivity context;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		context = this;
		AppManager.getAppManager().addActivity(this);
		BaseApplication.getInstance().mNetworkStatusSvc.addNetworkStatusChangeListener(this);
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

	@Override
	public void onNetworkChanged(INetworkStatus status) {
	}

	@Override
	public abstract void onNetworkConnectChanged(boolean isConnect);

}
