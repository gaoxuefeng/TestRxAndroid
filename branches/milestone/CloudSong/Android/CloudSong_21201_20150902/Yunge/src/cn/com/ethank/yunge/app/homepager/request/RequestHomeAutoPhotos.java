package cn.com.ethank.yunge.app.homepager.request;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.MyFastJson;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.homepager.bean.AutoPlayPhotos;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestHomeAutoPhotos extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestHomeAutoPhotos(Context context) {
		this.context = context;
		HashMap<String, String> hashMap = new HashMap<String, String>();
		this.hashMap = hashMap;
		this.url = Constants.hostUrlCloud.concat(Constants.REQUEST_HOMEPAGER_PICS);
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

			@SuppressWarnings("unchecked")
			private boolean resloveResult(final RequestCallBack requestCallBack, Object result) {
				try {
					if (result != null && result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {
						JSONArray myResult = MyFastJson.getJsonArray(result, "data");
						if (myResult != null) {
							List<AutoPlayPhotos> autoPlayPhotos = (List<AutoPlayPhotos>) JSONArray.parseArray(myResult.toString(),
									AutoPlayPhotos.class);
							if (autoPlayPhotos != null) {
								HashMap<String, List<AutoPlayPhotos>> hashMapResult = new HashMap<String, List<AutoPlayPhotos>>();
								hashMapResult.put("data", autoPlayPhotos);
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
