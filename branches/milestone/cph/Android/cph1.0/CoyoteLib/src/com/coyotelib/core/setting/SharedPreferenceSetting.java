package com.coyotelib.core.setting;

import android.content.Context;
import android.content.SharedPreferences;

public final class SharedPreferenceSetting implements ISettingService {

	private SharedPreferences appSettingPre;
	private SharedPreferences.Editor editor;

	public SharedPreferenceSetting(Context context, String settingName,
			int accessMode) {
		appSettingPre = context.getSharedPreferences(settingName, accessMode);
		editor = appSettingPre.edit();
	}

	@Override
	public long getLong(String key, long defaultVal) {
		return appSettingPre.getLong(key, defaultVal);
	}

	@Override
	public void setLong(String key, long value) {
		editor.putLong(key, value);
		editor.commit();
	}

	@Override
	public boolean getBoolean(String key, boolean defValue) {
		return appSettingPre.getBoolean(key, defValue);
	}

	@Override
	public void setBoolean(String key, boolean value) {
		editor.putBoolean(key, value);
		editor.commit();
	}

	@Override
	public float getFloat(String key, float defValue) {
		return appSettingPre.getFloat(key, defValue);
	}

	@Override
	public void setFloat(String key, float value) {
		editor.putFloat(key, value);
		editor.commit();
	}

	@Override
	public int getInt(String key, int defValue) {
		return appSettingPre.getInt(key, defValue);
	}

	@Override
	public void setInt(String key, int value) {
		editor.putInt(key, value);
		editor.commit();
	}

	@Override
	public String getString(String key, String defValue) {
		return appSettingPre.getString(key, defValue);
	}

	@Override
	public void setString(String key, String value) {
		editor.putString(key, value);
		editor.commit();
	}
}
