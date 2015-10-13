package cn.com.ethank.yunge.pad.requsetnetwork;

import java.util.HashMap;

import android.content.Context;
import android.util.Log;
import cn.com.ethank.yunge.pad.utils.HttpUtils;
import cn.com.ethank.yunge.pad.utils.ToastUtil;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 点歌请求
 * 
 * @author Gao Xuefeng
 * 
 */
public class RequestDemandSong extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	private static String tag = "RequestDemandSong";

	public RequestDemandSong(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		String host = "http://192.168.1.226:9000/ethank-KTVCenter-deploy/roomsong/addRoomSong.json";
		// String host =
		// "http://192.168.1.226:8791/roomsong/addRoomSong.json";// 测试
		// this.url = Constants.hostUrl.concat(Constants.REQUEST_DEMAND_SONG);
		this.url = host;

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				// if (hashMap != null) {
				// hashMap.put("ip", Constants.boxIp);
				// }
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
					ToastUtil.show("点歌成功");
					Log.e(tag, "点歌成功");
					return true;
				} else {
					ToastUtil.show("点歌失败");
					Log.e(tag, "点歌失败");
				}
				return false;
			}
		}.run();

	}

}
