package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.RequestSuccessBean;
import cn.com.ethank.yunge.app.demandsongs.beans.SinglerOnLine;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.JsonCacheKeyUtil;
import cn.com.ethank.yunge.app.util.JsonCacheUtil;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestSinggerList extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private String offUrl;

	public RequestSinggerList(Context context, HashMap<String, String> hashMap, String offUrl) {
		this.context = context;
		this.hashMap = hashMap;
		this.offUrl = offUrl;

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				JSONObject result = null;
				if (!Constants.getKTVIP().isEmpty() && Constants.isStarting()) {
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
				RequestSuccessBean requestSuccessBean = new RequestSuccessBean();
				try {
					if (result != null && result instanceof JSONObject) {
						requestSuccessBean = JSONObject.parseObject(result.toString(), RequestSuccessBean.class);

						JSONArray jsonArray = requestSuccessBean.getJsonArray();
						if (jsonArray != null) {
							List<SinglerOnLine> singlerOnLines = JSONArray.parseArray(jsonArray.toJSONString(), SinglerOnLine.class);
							if (singlerOnLines != null) {
								// 保存Json
								if (singlerOnLines.size() != 0 && url.endsWith(Constants.REQUEST_TOP_6_SINGER_LIST)) {
									// 如果是前六个歌手,则保存到cache
									JsonCacheUtil.saveCacheData(JsonCacheKeyUtil.top6Singer, JSON.toJSONString(jsonArray));
								}
								HashMap<String, List<SinglerOnLine>> map = new HashMap<String, List<SinglerOnLine>>();
								map.put("data", singlerOnLines);
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
