package cn.com.ethank.yunge.app.util;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class FastJson {
	public static JSONArray getArray(JSONObject j, String key, JSONArray def) {
		try {
			return null != j && j.containsKey(key) ? j.getJSONArray(key) : def;
		} catch (Exception e) {
			return def;
		}
	}
}
