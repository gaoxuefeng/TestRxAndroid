package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.HashMap;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.RequestSuccessBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 置顶或者删除歌曲
 * 
 * @author Gao Xuefeng
 * 
 */
public class RequestChangeSongPosition extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestChangeSongPosition(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		this.url = Constants.getKTVIP().concat(Constants.REQUEST_MOVE_OR_DELETE_SONG);

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
				RequestSuccessBean requestSuccessBean = new RequestSuccessBean();
				try {

					if (result != null && result instanceof JSONObject) {
						requestSuccessBean = JSONObject.parseObject(result.toString(), RequestSuccessBean.class);
						if (requestSuccessBean.isSuccess()) {
							return true;
						}
					}

				} catch (Exception e) {
					e.printStackTrace();
				}
				ToastUtil.show(requestSuccessBean.getMessage());
				return false;
			}
		}.run();

	}
}
