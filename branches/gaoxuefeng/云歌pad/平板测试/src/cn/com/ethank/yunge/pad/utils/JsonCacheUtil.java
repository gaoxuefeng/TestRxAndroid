package cn.com.ethank.yunge.pad.utils;

import java.util.List;

import android.content.Context;
import android.content.SharedPreferences;
import cn.com.ethank.yunge.pad.BaseApplication;

import com.alibaba.fastjson.JSONArray;

public class JsonCacheUtil {
	private static SharedPreferences sharedPreferences;

	// 存String(上下文,key,value)
	public static void saveCacheData(String key, String value) {
		if (sharedPreferences == null) {
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("cache", Context.MODE_PRIVATE);
		}

		sharedPreferences.edit().putString(key, value).commit();
	}

	// 取
	public static String getCacheData(String key) {
		if (sharedPreferences == null) {
			sharedPreferences = BaseApplication.getInstance().getApplicationContext().getSharedPreferences("cache", Context.MODE_PRIVATE);
		}
		return sharedPreferences.getString(key, "");
	}

	// 把cache转化为list
	public static List<?> getArrayList(String key, Class<?> myClass) {
		
		String jsonStr = getCacheData(key);
		List<?> resList = null;
		if (jsonStr != null && !jsonStr.isEmpty() && jsonStr.startsWith("[")) {
			resList = JSONArray.parseArray(jsonStr, myClass);
		}

		return resList;

	}

}
