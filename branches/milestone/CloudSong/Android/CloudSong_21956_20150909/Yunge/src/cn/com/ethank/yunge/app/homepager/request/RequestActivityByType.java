package cn.com.ethank.yunge.app.homepager.request;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.crypt.Base64CryptoCoding;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.MyFastJson;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;
import com.coyotelib.core.util.coding.AbstractCoding;

public class RequestActivityByType extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestActivityByType(Context context, HashMap<String, String> hashMap, String requestUrl) {
		this.context = context;
		hashMap.put("lat", Constants.latitude + "");
		hashMap.put("lng", Constants.longitude + "");
		this.hashMap = hashMap;
		this.url = requestUrl;
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
						JSONArray myResult = MyFastJson.getJsonArray(result, "data");
						if (myResult != null) {
							List<ActivityBean> activityBeans = JSONArray.parseArray(myResult.toJSONString(), ActivityBean.class);
							if (activityBeans != null && activityBeans.size() != 0) {
								HashMap<String, List<ActivityBean>> hashMap = new HashMap<String, List<ActivityBean>>();
								hashMap.put("data", activityBeans);
								requestCallBack.onLoaderFinish(hashMap);
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
