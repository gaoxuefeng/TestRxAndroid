package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.ArrayList;
import java.util.HashMap;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.RequestSuccessBean;
import cn.com.ethank.yunge.app.demandsongs.beans.maintheme.MainThemeBean;
import cn.com.ethank.yunge.app.demandsongs.beans.maintheme.ThemeChildBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.JsonCacheKeyUtil;
import cn.com.ethank.yunge.app.util.JsonCacheUtil;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestMainTheme extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private String offUrl;

	public RequestMainTheme(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		this.offUrl = Constants.REQUEST_UI_THEME_LIST;

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				JSONObject result = null;
				if (!Constants.getKTVIP().isEmpty() && Constants.isStarting()) {
					url = Constants.getKTVIP().concat(offUrl);
					result = HttpUtils.getJsonByPost(url, hashMap);
				}

				if (result == null) {
					url = Constants.hostUrlCloud.concat(offUrl);
					result = HttpUtils.getJsonByPost(url, hashMap);
				}
				return result;
			}

			@Override
			protected void onCompletion(Object result, Throwable exception, boolean cancelled) {
				super.onCompletion(result, exception, cancelled);
				boolean success = resloveResult(requestCallBack, result);
				if (!success) {
					requestCallBack.onLoaderFail();
				}
			}

			private boolean resloveResult(final RequestCallBack requestCallBack, Object result) {
				RequestSuccessBean requestSuccessBean = new RequestSuccessBean();
				try {
					if (result != null && result instanceof JSONObject) {
						requestSuccessBean = JSONObject.parseObject(result.toString(), RequestSuccessBean.class);
						if (requestSuccessBean.isSuccess()) {
							MainThemeBean mainThemeBean = JSONObject.parseObject(requestSuccessBean.getJsonObject().toJSONString(),
									MainThemeBean.class);
							if (mainThemeBean != null) {
								ArrayList<ThemeChildBean> arrayList = mainThemeBean.getTheme();
								if (arrayList != null && arrayList.size() != 0) {
									JsonCacheUtil.saveCacheData(JsonCacheKeyUtil.musicThemeList, JSON.toJSONString(arrayList));
								}
								HashMap<String, MainThemeBean> map = new HashMap<String, MainThemeBean>();
								map.put("data", mainThemeBean);
								requestCallBack.onLoaderFinish(map);
								return true;
							}

						}

					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				return false;
			}
		}.run();

	}

}
