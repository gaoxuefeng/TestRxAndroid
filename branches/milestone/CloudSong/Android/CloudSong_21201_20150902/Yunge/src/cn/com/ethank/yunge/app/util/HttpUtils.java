package cn.com.ethank.yunge.app.util;

import java.net.URI;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import cn.com.ethank.yunge.app.crypt.Base64CryptoCoding;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.jpush.android.api.JPushInterface;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.network.HttpService;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.sys.SysInfo;
import com.coyotelib.core.util.coding.AbstractCoding;
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
	
	public static JSONObject getJsonByGet(String strUri, AbstractCoding coding) {

		try {
			URI uri = new URI(strUri);
			String result = httpService.fetchStringByGet(uri,coding);
			return JSON.parseObject(result);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	private static AbstractCoding coding = new Base64CryptoCoding();

	public static JSONObject getJsonByPost(String strUri, Map<String, String> map) {
		if (map == null) {
			map = new HashMap<String, String>();
		}
		map = addSysInfoMap(map);
		try {
			// String testUrl =
			// "http://192.168.1.70:8480/ethank-KTVCenter-deploy/test.json?activitytype=";
			URI uri = new URI(strUri);
			HashMap<String, String> pMap = new HashMap<String, String>();

			pMap.put("param", coding.encodeUTF8ToUTF8(JSONObject.toJSONString(map)));
			pMap.put("v", "1.0");
			String result = httpService.fetchStringByPost(uri, pMap, new Base64CryptoCoding());
			// String result = httpService.fetchStringByPost(uri, map, new
			// UrlCoding());
			if (result != null) {
				return JSON.parseObject(result.trim());
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static JSONObject getJsonByPostShortTime(String strUri, Map<String, String> map) {
		if (map == null) {
			map = new HashMap<String, String>();
		}
		map = addSysInfoMap(map);

		try {
			HashMap<String, String> pMap = new HashMap<String, String>();

			pMap.put("param", coding.encodeUTF8ToUTF8(map.toString()));
			pMap.put("v", "1.0");
			URI uri = new URI(strUri);
			String result = httpService.fetchStringByPost(uri, pMap, 3000, new UrlCoding());

			return JSON.parseObject(result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static JSONObject getJsonByGetShortTime(String strUri, Map<String, String> map) {

		if (map == null) {
			map = new HashMap<String, String>();
		}
		map = addSysInfoMap(map);

		try {
			String param = setMapToParam(map);
			HashMap<String, String> paramHashMap = new HashMap<String, String>();
			AbstractCoding base64CryptoCoding = new Base64CryptoCoding();
			paramHashMap.put("param", base64CryptoCoding.encodeUTF8ToUTF8(param));
			strUri = builderGetUri(strUri, paramHashMap);
			URI uri = new URI(strUri);
			String result = httpService.fetchStringByGet(uri, 5000, base64CryptoCoding).trim();
			return JSON.parseObject(result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	private static String setMapToParam(Map<String, String> hashMap) {
		StringBuilder param = new StringBuilder();
		if (hashMap != null && hashMap.size() != 0) {

			for (Map.Entry<String, String> entry : hashMap.entrySet()) {

				// 如果请求参数中有中文，需要进行URLEncoder编码
				if (entry.getValue() != null) {
					try {
						param.append(entry.getKey()).append("=").append(URLEncoder.encode(entry.getValue(), "utf-8"));
						param.append("&");
					} catch (Exception e) {
						e.printStackTrace();
					}

				}

			}
			if (param.length() > 0) {
				param.deleteCharAt(param.length() - 1);
			}

		}
		return param.toString();

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

	private static Map<String, String> addSysInfoMap(Map<String, String> map) {
		SysInfo sysInfo = CoyoteSystem.getCurrent().getSysInfo();

		map.put("did", sysInfo.getIMEI());// 设备号
		map.put("dev", "0");// 设备类型Android 0/1iOS 1
		/*
		 * map.put("appver", sysInfo.getAppVersionName());// app版本
		 */map.put("rom", new String(new Base64Coding().decodeUTF8ToBytes(sysInfo.getRomInfo())).toString());// 已经被Base64转码,转回来可以看到数据
		map.put("androidId", sysInfo.getAndroidID());// (Android ID 也是广告用
		map.put("registrationId", JPushInterface.getRegistrationID(BaseApplication.getInstance()));
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