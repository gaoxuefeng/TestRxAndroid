package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.HashMap;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import cn.com.ethank.yunge.app.demandsongs.beans.RequestSuccessBean;
import cn.com.ethank.yunge.app.mine.fragment.CustomDialogNewData;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;
import com.coyotelib.core.util.JSON;

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
	private CustomDialogNewData customDialogNewData;
	private RequestCallBack requestCallBack;

	/**
	 * 
	 * 
	 * @param context
	 * @param hashMap
	 * @param isForce
	 *            可传true跟false true是强制,false不是强制
	 */
	public RequestDemandSong(Context context, HashMap<String, String> hashMap, boolean isForce) {
		this.context = context;
		this.hashMap = hashMap;
		hashMap.put("isForce", isForce + "");

	}

	/**
	 * 默认不是强制点歌
	 * 
	 * @param context
	 * @param hashMap
	 */
	public RequestDemandSong(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		hashMap.put("isForce", false + "");

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		this.requestCallBack = requestCallBack;
		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				if (hashMap != null) {
					if (Constants.getBoxIP().contains(":")) {
						hashMap.put("ip", Constants.getBoxIP().substring(0, Constants.getBoxIP().indexOf(":")));
					}

				}
				JSONObject result = null;
				if (((!Constants.getKTVIP().isEmpty() && Constants.isStarting()) || Constants.getBoxInfo().isFromLocal())&&!Constants.getBoxInfo().getKtvIP().isEmpty()) {
					url = Constants.getKTVIP().concat(Constants.REQUEST_DEMAND_SONG);
					result = HttpUtils.getJsonByPost(url, hashMap);
				}
				if (result == null) {
					url = Constants.hostUrlCloud.concat(Constants.REQUEST_DEMAND_SONG);
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
							ToastUtil.show("点歌成功");
							return true;
						} else if (requestSuccessBean.getCode().equals("1")) {
							// 已点过
							showAlert((Activity) context);
							return false;
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

	protected void showAlert(final Activity activity) {
		if (customDialogNewData != null && customDialogNewData.isShowing()) {
			return;
		}
		CustomDialogNewData.Builder builder = new CustomDialogNewData.Builder(context);
		builder.setMessage("已经点过这首歌,是否继续点歌?");
		builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {

			@SuppressLint("InlinedApi")
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
				hashMap.put("isForce", true + "");
				start(requestCallBack);
			}
		});

		builder.setNegativeButton("取消", new android.content.DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
			}
		});
		customDialogNewData = builder.create();
		customDialogNewData.show();
	}

}
