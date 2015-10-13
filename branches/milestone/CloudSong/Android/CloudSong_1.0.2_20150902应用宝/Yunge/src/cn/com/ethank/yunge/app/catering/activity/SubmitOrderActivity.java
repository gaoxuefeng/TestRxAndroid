package cn.com.ethank.yunge.app.catering.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sourceforge.simcpux.Constants;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.adapter.SubmitOrderListAdapter;
import cn.com.ethank.yunge.app.catering.bean.TypeContentItem;
import cn.com.ethank.yunge.app.catering.utils.ConstantsUtils;
import cn.com.ethank.yunge.app.catering.utils.SubZeroAndDot;
import cn.com.ethank.yunge.app.mine.activity.ConsumeActivity;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.PayOrderUtils;
import cn.com.ethank.yunge.app.util.PayOrderWeiXinUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.isWXAppInstalled;
import cn.com.ethank.yunge.view.MyListView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

/**
 * @author yinzhengwei
 * 
 *         订单支付页面
 */
public class SubmitOrderActivity extends BaseTitleActivity {

	private ScrollView submitcontent_layout_id;
	private TextView username_tv_id, usertele_tv_id, useraddress_tv_id, ordernum_tv_id, tv_totalright_id, tv_pay_id;
	private MyListView typelistview_id;
	private RelativeLayout apaylayout_id, weichatlayout_id;
	private ImageView alipaychenk_iv_id, wechatchenk_iv_id;
	private int payType = 0;// 0表示是支付宝；1表示是微信支付
	final IWXAPI msgApi = WXAPIFactory.createWXAPI(this, null);
	String orderId = "";
	String price = "0";
	private PopupWindow window;
	private View orderExit;
	private Button order_exit_but_nav; // --否--
	private Button order_exit_but_pos; // --是--

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		super.setContentView(R.layout.activity_submitorder);
		BaseApplication.getInstance().cacheActivityList.add(this);

		msgApi.registerApp(Constants.APP_ID);

		String cartingorderInfo = SharePreferencesUtil.getStringData("cartingorderInfo");
		try {
			JSONObject obj = JSONObject.parseObject(cartingorderInfo);
			orderId = obj.getString("reserveGoodsId");
			price = obj.getString("sumPrice");
		} catch (Exception e) {
		}

		title.setBtnBackText(" 超市");
		title.setBtnFunctionImage(0);
		title.setTitle("订单支付");

		initViewMthod();

		getDataMethod();
	}

	void initViewMthod() {

		orderExit = View.inflate(getApplicationContext(), R.layout.order_exit_layout, null);
		order_exit_but_nav = (Button) orderExit.findViewById(R.id.order_exit_but_nav);
		order_exit_but_pos = (Button) orderExit.findViewById(R.id.order_exit_but_pos);

		submitcontent_layout_id = (ScrollView) findViewById(R.id.submitcontent_layout_id);
		username_tv_id = (TextView) findViewById(R.id.username_tv_id);
		usertele_tv_id = (TextView) findViewById(R.id.usertele_tv_id);
		useraddress_tv_id = (TextView) findViewById(R.id.useraddress_tv_id);
		ordernum_tv_id = (TextView) findViewById(R.id.ordernum_tv_id);
		tv_totalright_id = (TextView) findViewById(R.id.tv_totalright_id);
		tv_pay_id = (TextView) findViewById(R.id.tv_pay_id);
		typelistview_id = (MyListView) findViewById(R.id.typelistview_id);
		apaylayout_id = (RelativeLayout) findViewById(R.id.apaylayout_id);
		weichatlayout_id = (RelativeLayout) findViewById(R.id.weichatlayout_id);
		alipaychenk_iv_id = (ImageView) findViewById(R.id.alipaychenk_iv_id);
		wechatchenk_iv_id = (ImageView) findViewById(R.id.wechatchenk_iv_id);

		String logininfo = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result);
		UserInfo uerinfo = JSONObject.parseObject(logininfo, UserInfo.class);
		String name = uerinfo.getData().getUserInfo().getNickName();
		if (!name.isEmpty() && name.length() > 6) {
			name = name.substring(0, 6) + "...";
		}
		username_tv_id.setText(" " + name);
		usertele_tv_id.setText(" " + uerinfo.getData().getUserInfo().getPhoneNum());
		// useraddress_tv_id.setText();

		try {
			BoxDetail box = cn.com.ethank.yunge.app.util.Constants.getBoxInfo();
			String ktvname = box.getKtvName(), roomname = box.getRoomName();
			useraddress_tv_id.setText(ktvname + "-" + roomname);
		} catch (Exception e) {
			// TODO: handle exception
		}
		apaylayout_id.setOnClickListener(this);
		weichatlayout_id.setOnClickListener(this);
		tv_pay_id.setOnClickListener(this);
		order_exit_but_nav.setOnClickListener(this);
		order_exit_but_pos.setOnClickListener(this);
	}

	void getDataMethod() {
		// 获取选择的酒水
		List<TypeContentItem> list = getaddShoppingDataMethod();

		// 计算总数
		int sum = 0;
		for (int i = 0; i < list.size(); i++) {
			sum += list.get(i).getAddNum();
		}
		// 计算总数量
		ordernum_tv_id.setText("共" + String.valueOf(sum) + "件");
		// 计算总价
		// getPayMoney(list);
		String sumprice = SubZeroAndDot.subZeroAndDot(String.valueOf(price));
		tv_totalright_id.setText("合计：¥" + sumprice);

		SubmitOrderListAdapter adapter = new SubmitOrderListAdapter(list, this);
		typelistview_id.setAdapter(adapter);

		hand.postDelayed(new Runnable() {

			@Override
			public void run() {
				// TODO Auto-generated method stub
				submitcontent_layout_id.scrollTo(0, -500);
			}
		}, 200);
	}

	Handler hand = new Handler();

	// 计算总价
	// void getPayMoney(List<TypeContentItem> list) {
	// // float类型的价格计算总价
	// BigDecimal paysum = BigDecimal.ZERO;
	// for (int i = 0; i < list.size(); i++) {
	// TypeContentItem bean = list.get(i);
	// int itemsum = bean.getAddNum();
	// BigDecimal unitpriceBigDecimal =
	// BigDecimal.valueOf(Double.valueOf(bean.getInfoitem().getGPrice()));
	// BigDecimal oneDetailSum =
	// unitpriceBigDecimal.multiply(BigDecimal.valueOf(itemsum));
	// paysum = paysum.add(oneDetailSum);
	// }
	// String sumprice = SubZeroAndDot.subZeroAndDot(String.valueOf(paysum));
	// tv_totalright_id.setText("合计：¥" + sumprice);
	// }

	// 获取已选择的餐点
	private List<TypeContentItem> getaddShoppingDataMethod() {
		List<TypeContentItem> list = ConstantsUtils.TYPECONTENT_LIST;
		List<TypeContentItem> addlist = new ArrayList<TypeContentItem>();
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getAddNum() > 0) {
				addlist.add(list.get(i));
			}
		}
		return addlist;
	}

	@Override
	public void onClick(View view) {
		// TODO Auto-generated method stub
		switch (view.getId()) {
		case R.id.btn_back:
			showBoxType();
			break;
		case R.id.order_exit_but_nav:
			window.dismiss();
			break;
		case R.id.order_exit_but_pos:
			window.dismiss();
			finish();
			break;
		case R.id.apaylayout_id:
			payType = 0;
			// ToastUtil.show("支付宝支付");
			alipaychenk_iv_id.setBackgroundResource(R.drawable.paytypecheck);
			wechatchenk_iv_id.setBackgroundResource(R.drawable.paytypenocheck);
			break;
		case R.id.weichatlayout_id:
			payType = 1;
			// ToastUtil.show("微信支付");
			alipaychenk_iv_id.setBackgroundResource(R.drawable.paytypenocheck);
			wechatchenk_iv_id.setBackgroundResource(R.drawable.paytypecheck);
			break;
		case R.id.tv_pay_id:
			// 0表示是支付宝；1表示是微信支付
			if (payType == 0) {
				new PayOrderUtils(this, false, "宝乐迪", "包厢", orderId, price).payOrder();
			} else {
				if (!isWXAppInstalled.isWXAppInstalledAndSupported(msgApi)) {
					ToastUtil.show("微信支付目前无法调用，请先安装微信客户端");
					return;
				}
				// 微信
				WeiXinPayRequestMethod(orderId, price);
			}
			break;
		default:
			super.onClick(view);
			break;
		}
	}

	/**
	 * 这里主要是为了防止微信支付时进入微信登录页后返回界面，让界面直接进入下一步
	 */
	boolean isOnClick = false;

	@Override
	protected void onRestart() {
		// TODO Auto-generated method stub
		super.onRestart();
		if (isOnClick) {
			Intent intent = new Intent(this, ConsumeActivity.class);
			BaseApplication.getInstance().exitObjectActivity(MenuActivity.class);
			startActivity(intent);
			finish();
		}
	}

	// 获取微信预订单号
	private void WeiXinPayRequestMethod(final String orderId, final String price) {
		ProgressDialogUtils.show(this);
		final Map<String, String> map = new HashMap<String, String>();
		map.put("reserveBoxId", orderId);
		map.put("token", cn.com.ethank.yunge.app.util.Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(cn.com.ethank.yunge.app.util.Constants.GETWEIXINPREPAYID, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					try {
						JSONObject obj = JSON.parseObject(result);
						if (obj.getIntValue("code") == 0) {
							isOnClick = true;
							JSONObject data = JSON.parseObject(obj.getString("data"));
							// 微信预订单号
							String preOrderId = data.getString("preOrderId");
							Log.d("preOrderId", preOrderId);

							new PayOrderWeiXinUtils(msgApi, false, orderId, preOrderId, price).payOrder();
						} else {
							ToastUtil.show(obj.getString("message"));
						}
					} catch (Exception e) {
						// TODO: handle exception
						ToastUtil.show("数据处理异常");
					}
				} else {
					ToastUtil.show("联网失败");
				}
				ProgressDialogUtils.dismiss();
			};
		}.run();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			showBoxType();
			return true;
		} else {
			finish();
			return false;
		}
	}

	/**
	 * 弹出包厢类型的popupwindow
	 */
	private void showBoxType() {
		int width = UICommonUtil.dip2px(getApplicationContext(), 300);
		int height = UICommonUtil.dip2px(getApplicationContext(), 130);

		window = new PopupWindow(orderExit, width, height);
		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(tv_pay_id, Gravity.CENTER, 0, 0);

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
