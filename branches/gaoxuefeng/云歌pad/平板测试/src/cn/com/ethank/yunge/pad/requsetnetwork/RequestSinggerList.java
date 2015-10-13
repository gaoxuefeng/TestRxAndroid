package cn.com.ethank.yunge.pad.requsetnetwork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.pad.bean.SinglerOnLine;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.utils.HttpUtils;
import cn.com.ethank.yunge.pad.utils.JsonCacheKeyUtil;
import cn.com.ethank.yunge.pad.utils.JsonCacheUtil;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestSinggerList extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestSinggerList(Context context, HashMap<String, String> hashMap, String url) {
		this.context = context;
		this.hashMap = hashMap;
		this.url = url;

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
						JSONArray jsonArray = MyFastJson.getJsonArray(result, "data");
						if (jsonArray != null) {
							List<SinglerOnLine> singlerOnLines = JSONArray.parseArray(jsonArray.toJSONString(), SinglerOnLine.class);
							if (singlerOnLines != null) {
								//保存Json
								if(singlerOnLines.size()!=0&&url.endsWith(Constants.REQUEST_TOP_6_SINGER_LIST)){
									//如果是前六个歌手,则保存到cache
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
