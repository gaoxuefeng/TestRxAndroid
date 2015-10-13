package cn.com.ethank.yunge.wxapi;

import java.util.HashMap;
import java.util.Map;

import net.sourceforge.simcpux.Constants;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.activity.MenuActivity;
import cn.com.ethank.yunge.app.catering.activity.SubmitOrderActivity;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.home.activity.OrderFormActivity;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.room.request.RequestRoomInfo;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSONObject;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {

	private static final String TAG = "MicroMsg.SDKSample.WXPayEntryActivity";

	private IWXAPI api;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.pay_result);

		api = WXAPIFactory.createWXAPI(this, Constants.APP_ID);

		api.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
		api.handleIntent(intent, this);
	}

	@Override
	public void onReq(BaseReq req) {
		Log.d(TAG, "onPayFinish, errCode = " + req.getType());
	}

	@Override
	public void onResp(BaseResp resp) {
		Log.d(TAG, "onPayFinish, errCode = " + resp.errCode);

		// if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
		// AlertDialog.Builder builder = new AlertDialog.Builder(this);
		// builder.setTitle(R.string.app_tip);
		// builder.setMessage(getString(R.string.pay_result_callback_msg,
		// resp.errStr + ";code=" + String.valueOf(resp.errCode)));
		// builder.show();
		// }
		// Intent intent = null;
		switch (resp.errCode) {
		case 0:
			ToastUtil.show("支付成功");
			// if (PayOrderWeiXinUtils.isFromKTVBox) {
			// intent = new Intent(this, CompartmentActivity.class);
			// } else {
			// intent = new Intent(this, ConsumeActivity.class);
			// }
			// if (PayOrderWeiXinUtils.isFromKTVBox) {
			// GetRoomInfoRequest getRoomInfoRequest = new
			// GetRoomInfoRequest(this);
			// getRoomInfoRequest.start(new RequestCallBack() {
			//
			// @Override
			// public void onLoaderFinish(Map<String, ?> map) {
			// String reserveBoxId =
			// LoadingActivity.myRooms.get(0).getReserveBoxId();
			// SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId,
			// reserveBoxId);
			//
			// BaseApplication.getInstance().exitObjectActivity(OrderFormActivity.class);
			// BaseApplication.getInstance().exitObjectActivity(MenuActivity.class);
			// BaseApplication.getInstance().exitObjectActivity(SubmitOrderActivity.class);
			// }
			//
			// @Override
			// public void onLoaderFail() {
			// // 正伟说失败了什么都不用干
			//
			// }
			// });

			// Intent intent = new Intent(this, MainTabActivity.class);
			// startActivity(intent);
			// BaseApplication.getInstance().exitObjectActivity(OrderFormActivity.class);
			// } else {
			// BaseApplication.getInstance().exitObjectActivity(MenuActivity.class);
			// BaseApplication.getInstance().exitObjectActivity(SubmitOrderActivity.class);
			// }

			final Intent intent = new Intent(this, MainTabActivity.class);
			// if (isFromKTVBox) {
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put(SharePreferenceKeyUtil.reserveBoxId, cn.com.ethank.yunge.app.util.Constants.orderId);
			hashMap.put(SharePreferenceKeyUtil.token, cn.com.ethank.yunge.app.util.Constants.getToken());
			RequestRoomInfo requestRoomInfo = new RequestRoomInfo(this, hashMap);
			requestRoomInfo.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					BoxDetail boxDetail = (BoxDetail) map.get("data");
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo, JSONObject.toJSONString(boxDetail));
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, boxDetail.getReserveBoxId());
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.preBoxId, boxDetail.getReserveBoxId());
					cn.com.ethank.yunge.app.util.Constants.setBinded(true);
					intent.setType(MainTabActivity.TAB_RESERVE);
					// 临时先这样
					if (!cn.com.ethank.yunge.app.util.Constants.isBinded()) {
						cn.com.ethank.yunge.app.util.Constants.setBinded(true);
					}
					ToastUtil.show("支付成功");
					BaseApplication.getInstance().exitObjectActivity(OrderFormActivity.class);
					BaseApplication.getInstance().exitObjectActivity(SubmitOrderActivity.class);
					BaseApplication.getInstance().exitObjectActivity(MenuActivity.class);
					startActivity(intent);
				}

				@Override
				public void onLoaderFail() {
					startActivity(intent);
				}
			});
			break;
		case -1:
			// intent = new Intent(this, ConsumeActivity.class);
			ToastUtil.show("支付失败,返回码：" + "-1");
			// startActivity(intent);
			break;
		case -2:
			// intent = new Intent(this, ConsumeActivity.class);
			ToastUtil.show("您已取消支付");
			// startActivity(intent);
			break;
		default:
			break;
		}
		// if (PayOrderWeiXinUtils.isFromKTVBox) {
		// BaseApplication.getInstance().exitObjectActivity(MerchantDetailActivity.class);
		// // TODO 修改了正伟的一行代码
		// BaseApplication.getInstance().exitObjectActivity(MainTabActivity.class);
		// BaseApplication.getInstance().exitObjectActivity(OrderFormActivity.class);
		// } else {
		// }
		// startActivity(intent);
		finish();
	}
}