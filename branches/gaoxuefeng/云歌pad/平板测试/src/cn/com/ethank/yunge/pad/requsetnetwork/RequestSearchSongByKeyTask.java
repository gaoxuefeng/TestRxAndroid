package cn.com.ethank.yunge.pad.requsetnetwork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.pad.bean.SongOnline;
import cn.com.ethank.yunge.pad.utils.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestSearchSongByKeyTask extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private BackgroundTask<Object> backgroundTask;

	public RequestSearchSongByKeyTask(Context context, HashMap<String, String> hashMap, String url) {
		this.context = context;
		this.hashMap = hashMap;
		this.url = url;

	}

	
	@Override
	public void start(final RequestCallBack requestCallBack) {
		backgroundTask = new BackgroundTask<Object>() {

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
				if (result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {
					JSONArray jsonArray = MyFastJson.getJsonArray(result, "data");
					if (jsonArray != null) {
						List<SongOnline> songOnLines = JSONArray.parseArray(jsonArray.toJSONString(), SongOnline.class);
						if (songOnLines != null) {
							HashMap<String, List<SongOnline>> map = new HashMap<String, List<SongOnline>>();
							map.put("data", songOnLines);
							requestCallBack.onLoaderFinish(map);
							return true;
						}

					}

				}
				return false;
			}
		};
		backgroundTask.run();
	}

	public void cancelBackTask() {
		if (backgroundTask != null) {
			try {
				backgroundTask.cancel(true);
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}
}
