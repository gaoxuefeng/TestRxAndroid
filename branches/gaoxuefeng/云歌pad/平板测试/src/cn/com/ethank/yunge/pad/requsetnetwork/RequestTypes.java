package cn.com.ethank.yunge.pad.requsetnetwork;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.pad.bean.MusicStyleBean;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.utils.HttpUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 获取分类列表的网络请求
 * 
 * @author dddd
 * 
 */
public class RequestTypes extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestTypes(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		// this.url =
		// Constants.getBetterHost().concat(Constants.REQUEST_SONG_TYPE_LIST);
		this.url = Constants.hostUrl.concat(Constants.REQUEST_SONG_TYPE_LIST);

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
						JSONArray myResult = MyFastJson.getJsonArray(result, "data");
						if (myResult != null) {
							List<MusicStyleBean> musicStyleBeans = JSON.parseArray(myResult.toString(), MusicStyleBean.class);
							if (musicStyleBeans != null) {
								HashMap<String, List<MusicStyleBean>> map = new HashMap<String, List<MusicStyleBean>>();
								map.put("data", musicStyleBeans);
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
