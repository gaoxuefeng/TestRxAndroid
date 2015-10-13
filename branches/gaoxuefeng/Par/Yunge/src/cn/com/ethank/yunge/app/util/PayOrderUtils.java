package cn.com.ethank.yunge.app.util;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import cn.com.ethank.yunge.app.catering.activity.MenuActivity;
import cn.com.ethank.yunge.app.catering.activity.SubmitOrderActivity;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.home.activity.OrderFormActivity;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.room.request.RequestRoomInfo;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;

import com.alibaba.fastjson.JSONObject;
import com.alipay.sdk.app.PayTask;

/**
 * call alipay sdk pay. 调用SDK支付
 * 
 */

public class PayOrderUtils {

	public Activity activity;
	public String name;
	public String orderTypeName;
	public String orderid;
	public String money;
	public boolean isFromKTVBox = false;
	Intent intent = null;

	public Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case Constants.SDK_PAY_FLAG: {
				PayResult payResult = new PayResult((String) msg.obj);

				// 支付宝返回此次支付结果及加签，建议对支付宝签名信息拿签约时支付宝提供的公钥做验签
				// String resultInfo = payResult.getResult();

				String resultStatus = payResult.getResultStatus();
				// 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
				if (TextUtils.equals(resultStatus, "9000")) {
					intent = new Intent(activity, MainTabActivity.class);
					// if (isFromKTVBox) {
					if (Constants.isFromKtvBox) {

						HashMap<String, String> hashMap = new HashMap<String, String>();
						hashMap.put(SharePreferenceKeyUtil.reserveBoxId, orderid);
						hashMap.put(SharePreferenceKeyUtil.token, Constants.getToken());
						RequestRoomInfo requestRoomInfo = new RequestRoomInfo(activity, hashMap);
						requestRoomInfo.start(new RequestCallBack() {

							@Override
							public void onLoaderFinish(Map<String, ?> map) {
								BoxDetail boxDetail = (BoxDetail) map.get("data");
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo, JSONObject.toJSONString(boxDetail));
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, boxDetail.getReserveBoxId());
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.preBoxId, boxDetail.getReserveBoxId());
								Constants.setBinded(true);
								intent.setType(MainTabActivity.TAB_RESERVE);
								// 临时先这样
								if (!Constants.isBinded()) {
									Constants.setBinded(true);
								}
								ToastUtil.show("支付成功");
								BaseApplication.getInstance().exitObjectActivity(OrderFormActivity.class);
								BaseApplication.getInstance().exitObjectActivity(SubmitOrderActivity.class);
								BaseApplication.getInstance().exitObjectActivity(MenuActivity.class);
								activity.startActivity(intent);
							}

							@Override
							public void onLoaderFail() {

								activity.startActivity(intent);
							}
						});
					} else {
						Constants.setBinded(true);
						intent.setType(MainTabActivity.TAB_RESERVE);
						// 临时先这样
						if (!Constants.isBinded()) {
							Constants.setBinded(true);
						}
						ToastUtil.show("支付成功");
						BaseApplication.getInstance().exitObjectActivity(OrderFormActivity.class);
						BaseApplication.getInstance().exitObjectActivity(SubmitOrderActivity.class);
						BaseApplication.getInstance().exitObjectActivity(MenuActivity.class);
						activity.startActivity(intent);
					}
				} else {

					if (TextUtils.equals(resultStatus, "8000")) {
						ToastUtil.show("支付结果确认中");
					} else if (TextUtils.equals(resultStatus, "6001")) {
						// 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
						ToastUtil.show("您已取消支付");
					} else {
						// 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
						ToastUtil.show("支付失败");
					}
				}

				break;
			}
			case Constants.SDK_CHECK_FLAG: {
				ToastUtil.show("检查结果为：" + msg.obj);
				break;
			}
			default:
				break;
			}
		};
	};

	public PayOrderUtils(Activity activity, boolean isFromKTVBox, String name, String orderTypeName, String orderid, String money) {
		super();
		this.activity = activity;
		this.isFromKTVBox = isFromKTVBox;
		this.name = name;
		this.orderTypeName = orderTypeName;
		this.orderid = orderid;
		this.money = money;
	}

	public void payOrder() {

		// 订单
		String orderInfo = OrderInfoUtils.getOrderInfo(name, orderTypeName, money, orderid);
		// 对订单做RSA 签名
		String sign = sign(orderInfo);
		try {
			// 仅需对sign 做URL编码
			sign = URLEncoder.encode(sign, "UTF-8");
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 完整的符合支付宝参数规范的订单信息
		final String payInfo = orderInfo + "&sign=\"" + sign + "\"&" + getSignType();
		Runnable payRunnable = new Runnable() {
			@Override
			public void run() {
				// 构造PayTask 对象
				PayTask alipay = new PayTask(activity);
				// 调用支付接口，获取支付结果
				String result = alipay.pay(payInfo);

				Message msg = new Message();
				msg.what = Constants.SDK_PAY_FLAG;
				msg.obj = result;
				mHandler.sendMessage(msg);
			}
		};

		// 必须异步调用
		Thread payThread = new Thread(payRunnable);
		payThread.start();
	}

	/**
	 * check whether the device has authentication alipay account.
	 * 查询终端设备是否存在支付宝认证账户
	 * 
	 */
	// public void check(View v) {
	// Runnable checkRunnable = new Runnable() {
	//
	// @Override
	// public void run() {
	// // 构造PayTask 对象
	// PayTask payTask = new PayTask(SubmitOrderActivity.this);
	// // 调用查询接口，获取查询结果
	// boolean isExist = payTask.checkAccountIfExist();
	//
	// Message msg = new Message();
	// msg.what = ConstantUtils.SDK_CHECK_FLAG;
	// msg.obj = isExist;
	// mHandler.sendMessage(msg);
	// }
	// };
	//
	// Thread checkThread = new Thread(checkRunnable);
	// checkThread.start();
	// }

	/**
	 * sign the order info. 对订单信息进行签名
	 * 
	 * @param content
	 *            待签名订单信息
	 */
	public static String sign(String content) {
		return SignUtils.sign(content, Constants.RSA_PRIVATE);
	}

	/**
	 * get the sign type we use. 获取签名方式
	 * 
	 */
	public static String getSignType() {
		return "sign_type=\"RSA\"";
	}
}