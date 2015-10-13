package cn.com.ethank.yunge.app.util;

import com.tencent.mm.sdk.openapi.IWXAPI;

public class isWXAppInstalled {
	// 判断设备里是否安装微信
	public static boolean isWXAppInstalledAndSupported(IWXAPI api) {
		return api.isWXAppInstalled() && api.isWXAppSupportAPI();
	}
}
