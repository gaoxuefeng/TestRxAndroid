package cn.com.ethank.yunge.app.demandsongs.beans;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class RequestSuccessBean {
	private String code;
	private String message;
	private Object data;

	public JSONObject getJsonObject() {
		if (data != null && data instanceof JSONObject) {
			return (JSONObject) data;
		} else {
			return new JSONObject();
		}

	}

	public JSONArray getJsonArray() {
		if (data != null && data instanceof JSONArray) {
			return (JSONArray) data;
		} else {
			return new JSONArray();
		}
	}

	public void setData(Object data) {
		this.data = data;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		if (message == null) {
			return "网络请求失败";
		}
		return message.toString();
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public boolean isSuccess() {
		if (code != null) {
			return code.equals("0");
		}
		return false;

	}
}
