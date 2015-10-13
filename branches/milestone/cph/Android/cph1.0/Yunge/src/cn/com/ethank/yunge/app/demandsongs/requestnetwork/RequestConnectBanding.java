package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import cn.com.ethank.yunge.app.demandsongs.beans.RequestSuccessBean;
import cn.com.ethank.yunge.app.home.bean.BoxDetailInfo;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.room.request.RequestRoomInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 连接房间
 * 
 * @author dddd
 * 
 */
public class RequestConnectBanding extends BaseRequest {

	private Activity context;
	private HashMap<String, String> hashMap;
	private String url;
	private String reserveBoxId = "";
	private String code = "";
	private String token;
	private String ktvIp;

	public RequestConnectBanding(Activity context, String strQRCode) {
		this.context = context;
		HashMap<String, String> hashMap = new HashMap<String, String>();
		String[] connectMsg = strQRCode.split("\\|");
		// reserveBoxId=201&code=1679&token=2
		if (connectMsg.length == 3) {
			reserveBoxId = connectMsg[1];
			code = connectMsg[2];
			token = Constants.getToken();
		}
		this.ktvIp = connectMsg[0];
		hashMap.put("reserveBoxId", reserveBoxId);
		hashMap.put("code", code);
		hashMap.put("token", token);
		this.hashMap = hashMap;
		this.url = getKTVIP(this.ktvIp).concat(Constants.REQUEST_CONNECT_BANDING_URL);

	}

	private String getKTVIP(String iP) {
		if (iP != null) {
			return "http://" + iP + "/ethank-KTVCenter-deploy/";
		}

		return "";
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
					// 设置为链接成功

					ToastUtil.show(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.boxIp));

					HashMap<String, String> map = new HashMap<String, String>();
					map.put(SharePreferenceKeyUtil.reserveBoxId, reserveBoxId);
					map.put(SharePreferenceKeyUtil.token, Constants.getToken());
					RequestRoomInfo requestRoomInfo = new RequestRoomInfo(context, map);
					requestRoomInfo.start(new RequestCallBack() {

						@Override
						public void onLoaderFinish(Map<String, ?> map) {
							BoxDetail boxDetail = (BoxDetail) map.get("data");
							boxDetail.setKtvIP(ktvIp);
							boxDetail.setFromLocal(true);
							SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo, JSONObject.toJSON(boxDetail).toString());
							SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.scanBoxId, reserveBoxId);
							SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, reserveBoxId);
							Constants.setBinded(true);
							ProgressDialogUtils.dismiss();
							context.finish();
							context.setResult(1);
							ToastUtil.show("连接房间成功");
						}

						@Override
						public void onLoaderFail() {
							context.finish();
							context.setResult(1);
							ProgressDialogUtils.dismiss();

						}
					});

				}

			}

			private boolean resloveResult(final RequestCallBack requestCallBack, Object result) {
				RequestSuccessBean requestSuccessBean = new RequestSuccessBean();
				try {

					if (result != null && result instanceof JSONObject) {
						requestSuccessBean = JSONObject.parseObject(result.toString(), RequestSuccessBean.class);
						if (requestSuccessBean.isSuccess()) {
							JSONObject dataJson = requestSuccessBean.getJsonObject();
							if (dataJson.containsKey("boxIP") && dataJson.containsKey("boxToken")) {
								String boxIp = dataJson.getString("boxIP");
								String boxToken = dataJson.getString("boxToken");
								String roomName = dataJson.getString("roomName");
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxIp, boxIp);
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxToken, boxToken);
								// TODO临时操作
								BoxDetail boxDetail = new BoxDetail();
								boxDetail.setBoxIP(boxIp);
								boxDetail.setBoxToken(boxToken);
								boxDetail.setRoomName(roomName);
								boxDetail.setKtvIP(ktvIp);
								boxDetail.setReserveBoxId(reserveBoxId);
								boxDetail.setFromLocal(true);
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo, JSONObject.toJSON(boxDetail).toString());
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, reserveBoxId);
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.scanBoxId, reserveBoxId);
								Constants.setBinded(true);
								// /////////////////////////////////////////////////////////////////////

								return true;
							}
						}
					}

				} catch (Exception e) {
					e.printStackTrace();
				}
				if (requestSuccessBean.getMessage().isEmpty() || requestSuccessBean.getMessage().equals("网络请求失败")) {
					ToastUtil.show("连接服务器异常,请连接KTV房间WIFI");
				} else {
					ToastUtil.show(requestSuccessBean.getMessage());
				}

				return false;
			}
		}.run();

	}

}
