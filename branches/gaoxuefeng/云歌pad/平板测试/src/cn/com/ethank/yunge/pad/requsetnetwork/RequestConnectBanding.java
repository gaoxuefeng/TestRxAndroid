package cn.com.ethank.yunge.pad.requsetnetwork;

import java.util.HashMap;

import android.content.Context;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.utils.HttpUtils;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 连接包厢
 * 
 * @author dddd
 * 
 */
public class RequestConnectBanding extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private String roomNum = "";
	private String code = "";
	private String token;

	public RequestConnectBanding(Context context, String strQRCode) {
		this.context = context;
		HashMap<String, String> hashMap = new HashMap<String, String>();
		String[] connectMsg = strQRCode.split("\\|");
		// roomNum=201&code=1679&token=2
		if (connectMsg.length == 3) {
			roomNum = connectMsg[1];
			code = connectMsg[2];
			token = Constants.getToken();
		}
		hashMap.put("roomNum", roomNum);
		hashMap.put("code", code);
		hashMap.put("token", token);
		this.hashMap = hashMap;
		this.url = Constants.hostUrl.concat(Constants.REQUEST_CONNECT_BANDING_URL);

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
				} else {
					requestCallBack.onLoaderFinish(null);
				}
			}

			private boolean resloveResult(final RequestCallBack requestCallBack, Object result) {
				if (result != null && result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {
					return true;
				}
				return false;
			}
		}.run();

	}

}
