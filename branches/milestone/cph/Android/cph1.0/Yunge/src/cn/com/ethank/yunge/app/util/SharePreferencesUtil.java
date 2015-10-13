package cn.com.ethank.yunge.app.util;

import android.content.Context;
import android.content.SharedPreferences;
import cn.com.ethank.yunge.app.startup.BaseApplication;

public class SharePreferencesUtil {
	private static SharedPreferences sharedPreferences;

	// 存String(上下文,key,value)
	public static void saveStringData(String key, String value) {
		if (sharedPreferences == null) {
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("config", Context.MODE_PRIVATE);
		}

		sharedPreferences.edit().putString(key, value).commit();
	}

	
	public static void saveBooleanData(String key, boolean value) {
		if (sharedPreferences == null) {
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("config", Context.MODE_PRIVATE);
		}

		sharedPreferences.edit().putBoolean(key, value).commit();
	}

	public static void saveIntData(String key, int value) {
		if (sharedPreferences == null) {
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("config", Context.MODE_PRIVATE);
		}

		sharedPreferences.edit().putInt(key, value).commit();
	}

	public static boolean getBooleanData(String key) {
		if (sharedPreferences == null) {
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("config", Context.MODE_PRIVATE);
		}

		return sharedPreferences.getBoolean(key, false);
	}

	// 取
	public static String getStringData(String key) {
		if (sharedPreferences == null) {
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("config", Context.MODE_PRIVATE);
		}
		return sharedPreferences.getString(key, "");
	}

	// 取
	public static int getIntData(String key) {
		if (sharedPreferences == null) {
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("config", Context.MODE_PRIVATE);
		}
		return sharedPreferences.getInt(key, 0);
	}
	
	//-- 删除一天数据
	public static void deleteData(String key){
		if(sharedPreferences == null){
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("config", Context.MODE_PRIVATE);
		}
		sharedPreferences.edit().remove(key).commit();
	}
	
}
