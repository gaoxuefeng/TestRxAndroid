package cn.com.ethank.yunge.pad.requsetnetwork;

import java.util.ArrayList;
import java.util.HashMap;

import android.content.Context;
import cn.com.ethank.yunge.pad.bean.mainthemebean.MainThemeBean;
import cn.com.ethank.yunge.pad.bean.mainthemebean.ThemeChildBean;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.utils.HttpUtils;
import cn.com.ethank.yunge.pad.utils.JsonCacheKeyUtil;
import cn.com.ethank.yunge.pad.utils.JsonCacheUtil;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestMainTheme extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestMainTheme(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		this.url = Constants.hostUrl.concat(Constants.REQUEST_UI_THEME_LIST);

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				return HttpUtils.getJsonByPost(url, hashMap);
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
				try {
					if (result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {
						JSONObject myResult = MyFastJson.getJsonObject(result, "data");
						if (myResult != null) {
							MainThemeBean mainThemeBean = JSONObject.parseObject(myResult.toJSONString(), MainThemeBean.class);
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
