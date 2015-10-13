package cn.com.ethank.yunge.app.manoeuvre.request;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.MyFastJson;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.manoeuvre.bean.TagsBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestActivityCitys extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestActivityCitys(Context context) {
		this.context = context;
		HashMap<String, String> hashMap=new HashMap<String, String>();
		this.hashMap = hashMap;
		this.url = Constants.hostUrlCloud.concat(Constants.REQUEST_ACTIVITYS_CITYS);

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
						JSONObject jsonObject = MyFastJson.getJsonObject(result, "data");
						JSONArray jsonArray=MyFastJson.getJsonArray(jsonObject, "cityNames");
						if (jsonArray != null) {
							List<String> cityList = JSONArray.parseArray(jsonArray.toJSONString(), String.class);
							if (cityList != null) {
								HashMap<String, List<String>> map = new HashMap<String, List<String>>();
								map.put("data", cityList);
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
