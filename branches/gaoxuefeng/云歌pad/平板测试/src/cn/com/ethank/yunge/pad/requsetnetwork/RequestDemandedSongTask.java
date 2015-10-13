package cn.com.ethank.yunge.pad.requsetnetwork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.pad.bean.SongOnlineDemanded;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.utils.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;
/**
 * 请求已点和已唱歌曲列表
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
		this.url = Constants.hostUrl.concat(Constants.REQUEST_DEMANDED_SONG_BY_ROOM_URL);

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
