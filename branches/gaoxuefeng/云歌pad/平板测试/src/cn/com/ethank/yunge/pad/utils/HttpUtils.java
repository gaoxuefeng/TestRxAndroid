package cn.com.ethank.yunge.pad.utils;

import java.net.URI;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import cn.com.ethank.yunge.pad.BaseApplication;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.network.HttpService;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.sys.SysInfo;
import com.coyotelib.core.util.coding.Base64Coding;
import com.coyotelib.core.util.coding.UrlCoding;

/**
 * Created by dddd on 2015/5/12.
 */

public class HttpUtils {
	static HttpService httpService = BaseApplication.mHttpService;

	public static JSONObject getJsonByGet(String strUri) {

		try {
			URI uri = new URI(strUri);
			String result = httpService.fetchStringByGet(uri, new UrlCoding());
			return JSON.parseObject(result);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static JSONObject getJsonByPost(String strUri, Map map) {
		// if (map == null) {
		// map = new HashMap<String, String>();
		// }
		// map = addSysInfoMap(map);
		try {
			URI uri = new URI(strUri);
			// addSysInfoMap(map);
			String result = httpService.fetchStringByPost(uri, map, new UrlCoding());
			return JSON.parseObject(result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static JSONObject getJsonByPostShortTime(String strUri, Map map) {
		if (map == null) {
			map = new HashMap<String, String>();
		}
		map = addSysInfoMap(map);
		try {

			URI uri = new URI(strUri);
			String result = httpService.fetchStringByPost(uri, map, 5000, new UrlCoding());

			return JSON.parseObject(result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static JSONObject getJsonByGetShortTime(String strUri, Map map) {

		if (map == null) {
			map = new HashMap<String, String>();
		}
		map = addSysInfoMap(map);
		try {
			strUri = builderGetUri(strUri, map);
			URI uri = new URI(strUri);
			String result = httpService.fetchStringByGet(uri, 5000, new UrlCoding());
			return JSON.parseObject(result);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	private static String builderGetUri(String uri, Map<String, String> map) {
		StringBuilder sb = new StringBuilder();
		try {

			while (uri.endsWith("/")) {
				try {
					uri = uri.substring(0, uri.length() - 1);
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			sb.append(uri).append("?");

			if (map != null && map.size() != 0) {

				for (Map.Entry<String, String> entry : map.entrySet()) {

					// 如果请求参数中有中文，需要进行URLEncoder编码

					sb.append(entry.getKey()).append("=").append(URLEncoder.encode(entry.getValue(), "utf-8"));

					sb.append("&");

				}

				sb.deleteCharAt(sb.length() - 1);

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();

	}

	@SuppressWarnings("unchecked")
	private static Map addSysInfoMap(Map map) {
		SysInfo sysInfo = CoyoteSystem.getCurrent().getSysInfo();

		map.put("did", sysInfo.getIMEI());// 设备号
		map.put("dev", "0");// 设备类型Android 0/1iOS 1
		/*
		 * map.put("appver", sysInfo.getAppVersionName());// app版本
		 */map.put("rom", new String(new Base64Coding().decodeUTF8ToBytes(sysInfo.getRomInfo())).toString());// 已经被Base64转码,转回来可以看到数据
		map.put("androidId", sysInfo.getAndroidID());// (Android ID 也是广告用
		// map.put("registrationId",
		// JPushInterface.getRegistrationID(BaseApplication.getInstance()));
		return map;

	}

	public static String getStringByGet(String strUri) {

		try {
			URI uri = new URI(strUri);
			// http://192.168.1.223:9000/ethank-KTVCenter-deploy/search/all?keyWord=xx&pageNum=1&perPage=2

			return httpService.fetchStringByGet(uri, new UrlCoding());

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

}