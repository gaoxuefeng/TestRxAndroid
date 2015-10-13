package cn.com.ethank.yunge.pad.requsetnetwork;

import java.util.HashMap;

import android.content.Context;
import cn.com.ethank.yunge.pad.bean.RoomBean;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.utils.HttpUtils;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestPhoneSong extends BaseRequest {
	private Context context; 
	private HashMap<String, String> hashMap;
	private String url;
	public RequestPhoneSong(Context context, HashMap<String, String> hashMap){
		this.context = context;
		this.hashMap = hashMap;
		this.url = Constants.TWO_DIMENSIONAL_CODE;
		
	}
	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<Object>() {
			//用作请求
			@Override
			protected Object doWork() throws Exception {
				return HttpUtils.getJsonByPost(url, hashMap);
			}
			/**
			 * 
			 */
			@Override
			protected void onCompletion(Object result, Throwable exception, boolean cancelled) {
				super.onCompletion(result, exception, cancelled);
				boolean success = resloveResult(requestCallBack, result);
				if (!success) {
					requestCallBack.onLoaderFail();
				}
			}
			/**
			 * 解析数据
			 * @param requestCallBack
			 * @param result
			 * @return
			 */
			private boolean resloveResult(final RequestCallBack requestCallBack, Object result) {
				if (result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {
					JSONObject myResult = MyFastJson.getJsonObject(result, "data");
					if (myResult != null) {
						RoomBean roomBean = JSONObject.parseObject(myResult.toJSONString(), RoomBean.class);
						if (roomBean != null) {
							HashMap<String, RoomBean> map = new HashMap<String, RoomBean>();
							map.put("data", roomBean);
							requestCallBack.onLoaderFinish(map);
							return true;
						}

					}

				}
				return false;
			}
		}.run();
	}

}
