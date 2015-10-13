package com.example.ducksdemo.takepic;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

public class SharePreferencesUtil {

	public SharedPreferences sp;
	public static SharePreferencesUtil instance = null;
	static final String name = "mcc";
	private Context ctx;

	public SharePreferencesUtil() {
	}

	public static SharePreferencesUtil getInstance() {
		if (instance == null) {
			instance = new SharePreferencesUtil();
		}
		return instance;
	}

	public void init(Context c) {
		try {
			sp = c.getSharedPreferences(name, 0);
			this.ctx = c;
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public boolean getBoolValue(String key) {
		getinit();
		return sp.getBoolean(key, false);
	}

	public String getStringValue(String key) {
		getinit();
		String value = sp.getString(key, null);
		if (value != null) {
			return value;
		}
		return "";
	}

	public String getStringValueDefault(String key, String defaultValue) {
		getinit();
		String value = sp.getString(key, defaultValue);
		if (value != null) {
			return value;
		}
		return "";
	}

	public boolean getBoolValueDefault(String key, boolean defaultValue) {
		getinit();
		return sp.getBoolean(key, defaultValue);
	}

	public int getIntValue(String key) {
		try {
			getinit();
			return sp.getInt(key, 0);
		} catch (Exception e) {
			return MyInterger.parseInt(getStringValue(key));
		}

	}

	public void setUpBool(String key, boolean value) {
		getinit();
		Editor editor = sp.edit();
		editor.putBoolean(key, value);
		editor.commit();
	}

	public void setUpString(String key, String value) {
		getinit();
		Editor editor = sp.edit();
		editor.putString(key, value);
		editor.commit();
	}

	public void setUpInt(String key, int value) {
		getinit();
		Editor editor = sp.edit();
		editor.putInt(key, value);
		editor.commit();
	}

	public void deleteValue(String... keys) {
		getinit();
		Editor editor = sp.edit();
		for (String key : keys) {
			editor.remove(key);
			editor.commit();
		}
	}

	public void clearall() {
		getinit();
		Editor editor = sp.edit();
		editor.clear();
		editor.commit();
	}

	public void getinit() {
		if (sp == null) {
			init(ctx);
		}
	}
}
