package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestSearchSongByKeyTask extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private BackgroundTask<Object> backgroundTask;
	private String offUrl;

	public RequestSearchSongByKeyTask(Context context, HashMap<String, String> hashMap, String offUrl) {
		this.context = context;
		this.hashMap = hashMap;
		this.offUrl = offUrl;

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		backgroundTask = new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				JSONObject result = null;
				if (!Constants.getKTVIP().isEmpty()&&Constants.isStarting()) {
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
				try {
					
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
				} catch (Exception e) {
					e.printStackTrace();
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
