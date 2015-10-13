package cn.com.ethank.yunge.app.home.requestNetWork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.MyFastJson;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.home.bean.HomeInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestKTVList extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;

	public RequestKTVList(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {

				return HttpUtils.getJsonByPost(Constants.hostUrlCloud.concat(Constants.SEARCH_KTV), hashMap);

			}

			@Override
			protected void onCompletion(Object result, Throwable exception, boolean cancelled) {
				super.onCompletion(result, exception, cancelled);
				boolean success = resloveResult(requestCallBack, result);
				if (!success) {
					// 测试
					requestCallBack.onLoaderFail();
				} else {
					// requestCallBack.onLoaderFinish(hashMap);
				}

			}

			private boolean resloveResult(RequestCallBack requestCallBack, Object result) {
				try {
					if (result!=null&&result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {

						JSONArray myResult = MyFastJson.getJsonArray(result, "data");
						if (myResult != null) {
							List<HomeInfo> homeInfos = JSONObject.parseArray(myResult.toJSONString(), HomeInfo.class);
							if (homeInfos != null) {
								HashMap<String, List<HomeInfo>> map = new HashMap<String, List<HomeInfo>>();
								map.put("data", homeInfos);
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
