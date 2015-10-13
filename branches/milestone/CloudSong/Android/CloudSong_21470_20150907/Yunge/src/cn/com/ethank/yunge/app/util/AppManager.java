package cn.com.ethank.yunge.app.util;

import java.util.Stack;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;

/**
 * Activity管理系统
 * 
 * @author dddd
 * 
 */
public class AppManager {
	private static Stack<Activity> activityStack = new Stack<Activity>();
	private static AppManager instance;

	public static void clear() {
		if (activityStack != null) {
			activityStack.clear();
		}
	}

	/**
	 * 单一实例
	 */

	public static AppManager getAppManager() {

		if (instance == null) {

			instance = new AppManager();

		}

		return instance;

	}

	/**
	 * 
	 * 添加Activity到堆栈
	 */

	public void addActivity(Activity activity) {

		if (activityStack == null) {

			activityStack = new Stack<Activity>();

		}

		activityStack.add(activity);
	}

	public boolean isCurrentActivity(Activity activity) {
		if (activity != null && currentActivity() != null) {
			return activity == currentActivity();
		}
		return false;

	}

	/**
	 * 
	 * 移除Activity到堆栈,调用onDestroy时调用此方法
	 */

	public void removeActivity(Activity activity) {
		try {
			if (activityStack != null) {
				if (activityStack.contains(activity)) {
					activityStack.remove(activity);
					try {

						if (activity != null) {
							activity.finish();
							activity = null;
						}

					} catch (Exception e) {
						e.printStackTrace();
					}

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 
	 * 获取当前Activity（堆栈中最后一个压入的）
	 */

	public Activity currentActivity() {

		Activity activity = activityStack.lastElement();

		return activity;

	}

	/**
	 * 
	 * 结束当前Activity（堆栈中最后一个压入的）
	 */

	public void finishActivity() {

		Activity activity = activityStack.lastElement();

		if (activity != null) {

			activity.finish();

			activity = null;

		}

	}

	/**
	 * 
	 * 结束指定类名的Activity
	 */

	public void finishActivity(Class<?> cls) {

		for (Activity activity : activityStack) {

			if (activity.getClass().equals(cls)) {
				removeActivity(activity);
			}

		}

	}

	/**
	 * 
	 * 结束所有Activity
	 */

	public void finishAllActivity() {

		for (int i = 0, size = activityStack.size(); i < size; i++) {

			if (null != activityStack.get(i)) {
				removeActivity(activityStack.get(i));

			}

		}
	}

	public void finishOtherActivity(Activity activity) {
		if (activityStack == null) {
			return;
		}
		for (int i = 0, size = activityStack.size(); i < size; i++) {

			if (null != activityStack.get(i) && activityStack.get(i) != activity) {
				removeActivity(activityStack.get(i));

			}

		}
	}

	/**
	 * 
	 * 退出应用程序
	 */

	public void AppExit(Context context) {

		try {

			finishAllActivity();

			ActivityManager activityMgr = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);

			activityMgr.killBackgroundProcesses(context.getPackageName());
			System.exit(0);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
