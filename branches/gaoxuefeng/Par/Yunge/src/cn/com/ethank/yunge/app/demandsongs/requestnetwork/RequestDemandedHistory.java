package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.RequestSuccessBean;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnlineDemanded;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 请求已点和已唱歌曲列表
 * 
 * @author Gao Xuefeng
 * 
 */
public class RequestDemandedHistory extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private BackgroundTask<Object> backgroundTask;

	public RequestDemandedHistory(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		backgroundTask = new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				url = Constants.hostUrlCloud.concat(Constants.REQUEST_DEMANDED_SONG_HISTORY);

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
				RequestSuccessBean requestSuccessBean = new RequestSuccessBean();
				try {
					if (result != null && result instanceof JSONObject) {
						requestSuccessBean = JSONObject.parseObject(result.toString(), RequestSuccessBean.class);
						if (requestSuccessBean.isSuccess()) {
							JSONArray jsonArray = requestSuccessBean.getJsonArray();
							if (jsonArray != null) {
								List<SongOnline> songOnLineDemandHisTory = JSONArray.parseArray(jsonArray.toJSONString(), SongOnline.class);
								if (songOnLineDemandHisTory != null) {
									HashMap<String, List<SongOnline>> map = new HashMap<String, List<SongOnline>>();
									map.put("data", songOnLineDemandHisTory);
									requestCallBack.onLoaderFinish(map);
									return true;
								}

							}

						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				ToastUtil.show(requestSuccessBean.getMessage());
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
