package net.sourceforge.simcpux.wxapi;

import net.sourceforge.simcpux.Constants;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.activity.MenuActivity;
import cn.com.ethank.yunge.app.catering.activity.SubmitOrderActivity;
import cn.com.ethank.yunge.app.home.activity.CompartmentActivity;
import cn.com.ethank.yunge.app.home.activity.MerchantDetailActivity1;
import cn.com.ethank.yunge.app.mine.activity.ConsumeActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.PayOrderWeiXinUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

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
		Intent intent = null;
		switch (resp.errCode) {
		case 0:
			ToastUtil.show("支付成功");
			if (PayOrderWeiXinUtils.isFromKTVBox) {
				intent = new Intent(this, CompartmentActivity.class);
			} else {
				intent = new Intent(this, ConsumeActivity.class);
			}
			break;
		case -1:
			intent = new Intent(this, ConsumeActivity.class);
			ToastUtil.show("支付失败");
			break;
		case -2:
			intent = new Intent(this, ConsumeActivity.class);
			ToastUtil.show("您已取消支付");
			break;
		default:
			break;
		}
		if (PayOrderWeiXinUtils.isFromKTVBox) {
			BaseApplication.getInstance().exitObjectActivity(MerchantDetailActivity1.class);
			//--修改了正伟的页面
			BaseApplication.getInstance().exitObjectActivity(MainTabActivity.class);
		} else {
			BaseApplication.getInstance().exitObjectActivity(MenuActivity.class);
			BaseApplication.getInstance().exitObjectActivity(SubmitOrderActivity.class);
		}
		startActivity(intent);
		finish();
	}
}