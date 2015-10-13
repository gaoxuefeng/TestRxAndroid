package cn.com.ethank.yunge.app.room.request;

import java.util.HashMap;
import java.util.Map;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.RequestSuccessBean;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.home.bean.BoxDetailInfo;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestRoomInfo extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private boolean isShort = false;

	public RequestRoomInfo(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		this.url = Constants.hostUrlCloud + Constants.boxDetail;

	}

	public RequestRoomInfo(Context context, HashMap<String, String> hashMap, boolean isShort) {
		this.context = context;
		this.hashMap = hashMap;
		this.isShort = isShort;
		this.url = Constants.hostUrlCloud + Constants.boxDetail;

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				JSONObject result = null;
				if (isShort) {
					result = HttpUtils.getJsonByPostShortTime(url, hashMap);
				} else {
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
					if (result != null && result instanceof JSONObject) {
						BoxDetailInfo boxDetailInfo = JSON.parseObject(result.toString(), BoxDetailInfo.class);
						if (boxDetailInfo.getCode() == 0) {
							Map<String, BoxDetail> map = new HashMap<String, BoxDetail>();
							// 原来
							if (!Constants.getBoxInfo().getReserveBoxId().isEmpty() && Constants.getBoxInfo().isFromLocal()
									&& Constants.getBoxInfo().getKtvIP().isEmpty()) {
								boxDetailInfo.getData().setKtvIP(Constants.getBoxInfo().getKtvIP());
								boxDetailInfo.getData().setFromLocal(true);
								map.put("data", boxDetailInfo.getData());
							} else {
								map.put("data", boxDetailInfo.getData());
							}

							requestCallBack.onLoaderFinish(map);
							return true;
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
