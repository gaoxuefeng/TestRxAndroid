package cn.com.ethank.yunge.pad.requsetnetwork;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class MyFastJson {

	public static JSONArray getJsonArray(Object result, String key) {

		if (result != null && result instanceof JSONObject && key != null) {
			JSONObject myResult = (JSONObject) result;
			return myResult.getJSONArray(key);
		}
		return null;

	}

	public static JSONObject getJsonObject(Object result, String key) {

		if (result != null && result instanceof JSONObject && key != null) {
			JSONObject myResult = (JSONObject) result;
			if (myResult.containsKey(key)) {
				return myResult.getJSONObject(key);
			}

		}
		return null;

	}

}
