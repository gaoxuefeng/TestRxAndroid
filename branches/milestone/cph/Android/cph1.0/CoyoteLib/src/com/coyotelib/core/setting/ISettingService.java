package com.coyotelib.core.setting;

public interface ISettingService {

	long getLong(String key, long defaultVal);

	void setLong(String key, long value);

	boolean getBoolean(String key, boolean defValue);

	void setBoolean(String key, boolean value);

	float getFloat(String key, float defValue);

	void setFloat(String key, float value);

	int getInt(String key, int defValue);

	void setInt(String key, int value);

	String getString(String key, String defValue);

	void setString(String key, String value);
}
