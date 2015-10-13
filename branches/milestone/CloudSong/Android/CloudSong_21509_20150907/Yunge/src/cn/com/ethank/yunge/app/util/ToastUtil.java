package cn.com.ethank.yunge.app.util;

import cn.com.ethank.yunge.app.startup.BaseApplication;
import android.content.Context;
import android.widget.Toast;

/**
 * Toast工具类
 * 
 */
public class ToastUtil {
	static Toast toast;

	public static void show(String text) {
		if (toast == null) {
			toast = Toast.makeText(BaseApplication.getInstance(), text, Toast.LENGTH_SHORT);
		} else {
			toast.setText(text);
		}
		toast.show();
	}

	public static void show(String text, Boolean LENGTH_LONG) {
		if (toast == null) {
			toast = Toast.makeText(BaseApplication.getInstance(), text, Toast.LENGTH_LONG);
		} else {
			toast.setText(text);
		}
		toast.show();
	}

	public static void show(int resId, Boolean LENGTH_LONG) {
		if (toast == null) {
			toast = Toast.makeText(BaseApplication.getInstance(), resId, Toast.LENGTH_LONG);
		} else {
			toast.setText(resId);
		}
		toast.show();
	}

	public static void show(int resId) {
		if (toast == null) {
			toast = Toast.makeText(BaseApplication.getInstance(), resId, Toast.LENGTH_SHORT);
		} else {
			toast.setText(resId);
		}
		toast.show();
	}

	public void dismisstoast() {
		if (toast != null) {
			toast.cancel();
			toast = null;
		}
	}
}
