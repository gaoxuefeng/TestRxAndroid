package cn.com.ethank.yunge.app.homepager.request;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.MyFastJson;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.homepager.bean.ActivityTypeBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestActivityTypes extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestActivityTypes(Context context) {
		this.context = context;
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("lat", Constants.latitude + "");
		hashMap.put("lng", Constants.longitude + "");
		hashMap.put("cityName", Constants.locationCity + "");
		this.hashMap = hashMap;
		this.url = Constants.hostUrlCloud.concat(Constants.REQUEST_NAVIGATION_LIST);
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
					if (result != null && result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {
						JSONArray myResult = MyFastJson.getJsonArray(result, "data");
						if (myResult != null) {
							List<ActivityTypeBean> activityTypeBeans = (List<ActivityTypeBean>) JSONArray.parseArray(myResult.toString(), ActivityTypeBean.class);
							if (activityTypeBeans != null) {
								HashMap<String, List<ActivityTypeBean>> hashMapResult = new HashMap<String, List<ActivityTypeBean>>();
								hashMapResult.put("data", activityTypeBeans);
								requestCallBack.onLoaderFinish(hashMapResult);
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
