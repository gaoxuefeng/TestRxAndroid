package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import android.content.Context;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSONObject;

public class ResoloveResult {
	// 20房间未绑定,21房间已关闭
	public static boolean getDataSuccess(Context context, JSONObject objJson) {
		try {
			if (objJson == null) {
				return false;
			}
			if (objJson.getString("code").equals("0")) {

				return true;
			} else if (objJson.getString("code").equals("1")) {
				// 暂时不处理
				// ToastUtil.show("没有绑定房间");
			} else {
				if (objJson.getString("code").equals("20")) {
					// ToastUtil.show("房间未绑定");
					// Constants.setBinded(false);
				} else if (objJson.getString("code").equals("21")) {
					// ToastUtil.show("房间已关闭");
					// Constants.setBinded(false);
				}

				return false;
				// 如果有回传值,在这儿回调
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;

	}
}