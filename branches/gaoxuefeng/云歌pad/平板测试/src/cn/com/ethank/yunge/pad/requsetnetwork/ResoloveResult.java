package cn.com.ethank.yunge.pad.requsetnetwork;

import android.content.Context;
import cn.com.ethank.yunge.pad.utils.ToastUtil;

import com.alibaba.fastjson.JSONObject;

public class ResoloveResult {

	public static boolean getDataSuccess(Context context, JSONObject objJson) {
		try {
			if (objJson != null && objJson.getString("code").equals("0")) {

				return true;
			} else {
				ToastUtil.show( "网络请求错误");
				return false;
				// 如果有回传值,在这儿回调
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;

	}
}