package cn.com.ethank.yunge.pad;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.app.Application;

import com.coyotelib.core.network.HttpService;
import com.coyotelib.framework.network.DefaultHttpService;
import com.coyotelib.framework.network.INetworkStatusService;
import com.lidroid.xutils.BitmapUtils;

/**
 * Created by lvhonghe on 14/12/14.
 */
public class BaseApplication extends Application {

	private static BaseApplication instance;
	public static final int DB_VERSION = 1;

	public static HttpService mHttpService;
	public INetworkStatusService mNetworkStatusSvc;
	public static BitmapUtils bitmapUtils;

	@Override
	public void onCreate() {
		super.onCreate();
		instance = this;
		initCrashCatcher();
		initSys();
		initJpush();
		bitmapUtils = BitmapHelp.getBitmapUtils(getApplicationContext());
	}

	private void initJpush() {
		

	}

	private void initCrashCatcher() {
		// Thread.setDefaultUncaughtExceptionHandler(new
		// UncaughtExceptionHandler(this.getApplicationContext()));
	}

	private void initSys() {





		mHttpService = new DefaultHttpService();


	}

	public List<Activity> cacheActivityList = new ArrayList<Activity>();

	public void exit() {
		if (cacheActivityList.size() > 0) {
			for (int i = 0; i < cacheActivityList.size(); i++) {
				cacheActivityList.get(i).finish();
			}
		}
	}

	public void exitObjectActivity(Class c) {
		if (cacheActivityList.size() > 0) {
			for (int i = 0; i < cacheActivityList.size(); i++) {
				if (cacheActivityList.get(i).getClass() == c) {
					cacheActivityList.get(i).finish();
				}
			}
		}
	}

	public static BaseApplication getInstance() {

		return instance;
	}
}
