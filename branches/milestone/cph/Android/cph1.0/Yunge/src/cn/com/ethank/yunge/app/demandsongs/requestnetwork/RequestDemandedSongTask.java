package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnlineDemanded;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 请求已点和已唱歌曲列表
 * 
 * @author Gao Xuefeng
 * 
 */
public class RequestDemandedSongTask extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private BackgroundTask<Object> backgroundTask;

	public RequestDemandedSongTask(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		backgroundTask = new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				JSONObject result=null;
				if(!Constants.getKTVIP().isEmpty()&&Constants.isStarting()){
					url = Constants.getKTVIP().concat(Constants.REQUEST_DEMANDED_SONG_BY_ROOM_URL);
					 result = HttpUtils.getJsonByPost(url, hashMap);
				}
			
				if (result == null) {
					url = Constants.hostUrlCloud.concat(Constants.REQUEST_DEMANDED_SONG_BY_ROOM_URL);
					result = HttpUtils.getJsonByPost(url, hashMap);
				} else if (!ResoloveResult.getDataSuccess(context, (JSONObject) result) && !((JSONObject) result).getString("code").equals("1")) {
					url = Constants.hostUrlCloud.concat(Constants.REQUEST_DEMANDED_SONG_BY_ROOM_URL);
					result = HttpUtils.getJsonByPost(url, hashMap);
				}
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
						JSONArray jsonArray = MyFastJson.getJsonArray(result, "data");
						if (jsonArray != null) {
							List<SongOnlineDemanded> songOnLineDemandded = JSONArray.parseArray(jsonArray.toJSONString(), SongOnlineDemanded.class);
							if (songOnLineDemandded != null) {
								HashMap<String, List<SongOnlineDemanded>> map = new HashMap<String, List<SongOnlineDemanded>>();
								map.put("data", songOnLineDemandded);
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
