package cn.com.ethank.yunge.app.home.activity;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import net.sourceforge.simcpux.Constants;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.RelativeLayout.LayoutParams;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.bean.OrderInfo;
import cn.com.ethank.yunge.app.home.bean.OrderInfo.Order;
import cn.com.ethank.yunge.app.mine.activity.ConsumeActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.PayOrderUtils;
import cn.com.ethank.yunge.app.util.PayOrderWeiXinUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.isWXAppInstalled;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

/** 订单支付页面 */
@SuppressLint("SimpleDateFormat")
public class OrderFormActivity extends Activity implements OnClickListener {

	private TextView form_tv_exit;

	@ViewInject(R.id.order_rl_head)
	private RelativeLayout order_rl_head;

	@ViewInject(R.id.form_tv_username)
	private TextView form_tv_username; // --用户名--

	@ViewInject(R.id.form_tv_phoneNum)
	private TextView form_tv_phoneNum; // --手机号--

	@ViewInject(R.id.form_tv_day)
	private TextView form_tv_day; // --6月5日

	@ViewInject(R.id.form_tv_week)
	private TextView form_tv_week; // --周五--

	@ViewInject(R.id.form_tv_time)
	private TextView form_tv_time; // --19:00-22:00

	@ViewInject(R.id.form_tv_boxType)
	private TextView form_tv_boxType; // --小包--

	@ViewInject(R.id.form_tv_price)
	private TextView form_tv_price; // --价格

	@ViewInject(R.id.form_tv_shopName)
	private TextView form_tv_shopName; // --门店

	@ViewInject(R.id.form_tv_address)
	private TextView form_tv_address; // --地址--

	@ViewInject(R.id.form_tv_allPrice)
	private TextView form_tv_allPrice; // --总价--

	@ViewInject(R.id.order_ll_parent)
	private LinearLayout order_ll_parent;

	private Button order_exit_but_nav; // --否--
	private Button order_exit_but_pos; // --是--

	private PopupWindow window;
	private RelativeLayout orderExit;

	@ViewInject(R.id.order_form_tv_pay)
	private TextView order_form_tv_pay; // --立即支付--

	@ViewInject(R.id.order_rl_weixin)
	private RelativeLayout order_rl_weixin; // --微信支付--

	@ViewInject(R.id.order_iv_weixin)
	private ImageView order_iv_weixin; // --微信图片--

	@ViewInject(R.id.order_rl_alipay)
	private RelativeLayout order_rl_alipay; // --支付宝支付--

	@ViewInject(R.id.order_iv_alipay)
	private ImageView order_iv_alipay; // --支付宝图片--

	private int payType = 0;// 0表示是支付宝；1表示是微信支付

	final IWXAPI msgApi = WXAPIFactory.createWXAPI(this, null);

	private OrderInfo orderInfo;
	private Order order;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_order_form);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);
		try {
			orderInfo = JSON.parseObject(cn.com.ethank.yunge.app.util.Constants.getOrderInfo(), OrderInfo.class);
			if (orderInfo != null) {
				order = orderInfo.getData();
			}
		} catch (Exception e) {
			// TODO: handle exception
		}

		findById();

		msgApi.registerApp(Constants.APP_ID);

		form_tv_exit = (TextView) order_rl_head.findViewById(R.id.form_tv_exit);
		form_tv_exit.setOnClickListener(this);
	}

	@SuppressLint("SimpleDateFormat")
	private void findById() {
		orderExit = (RelativeLayout) View.inflate(getApplicationContext(), R.layout.order_exit_layout, null);
		order_exit_but_nav = (Button) orderExit.findViewById(R.id.order_exit_but_nav);
		order_exit_but_pos = (Button) orderExit.findViewById(R.id.order_exit_but_pos);

		if (order != null) {
			form_tv_username.setText(order.getNickName());
			form_tv_phoneNum.setText(order.getPhoneNum());
			//form_tv_day.setText(order.getDay());
			//form_tv_time.setText(order.getHour());
			form_tv_boxType.setText(order.getBoxTypeName());
			form_tv_price.setText("￥" + order.getPrice());
			form_tv_address.setText(order.getAddress());
			form_tv_shopName.setText(order.getKtvName());
			form_tv_allPrice.setText("合计 ： ￥" + order.getPrice());
			//form_tv_week.setText(order.getReserveDayOfWeek());
			form_tv_boxType.setText(order.getBoxTypeName());
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("MM月dd日");
			String day = dateFormat.format(new Date(order.getRbStartTime() * 1000L));

			dateFormat = new SimpleDateFormat("E");
			String week = dateFormat.format(new Date(order.getRbStartTime() * 1000L));

			form_tv_day.setText(day);
			form_tv_week.setText(week);

			dateFormat = new SimpleDateFormat("HH:mm");
			String startHour = dateFormat.format(new Date(order.getRbStartTime() * 1000L));
			
			String endHour = dateFormat.format(new Date(order.getRbEndTime() * 1000L));
			form_tv_time.setText(startHour+"-"+endHour);
		}

		/*SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd");
		Date date = null;
		try {
			Order order = orderInfo.getData();
			if (order != null) {

				date = dateFormat.parse(order.getDay());
				if (order.getDay().startsWith("0")) {
					dateFormat = new SimpleDateFormat("M月dd日");
					Character character = order.getDay().charAt(3);
					character.toString();
					if (character.toString().equals("0")) {
						dateFormat = new SimpleDateFormat("M月d日");
					}
				} else {
					dateFormat = new SimpleDateFormat("MM月dd日");
					Character character = order.getDay().charAt(3);
					if (character.toString().equals("0")) {
						dateFormat = new SimpleDateFormat("M月d日");
					}
				}
				String day = dateFormat.format(date);
				//form_tv_day.setText(day);
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
*/
		

		order_exit_but_nav.setOnClickListener(this);
		order_exit_but_pos.setOnClickListener(this);
		order_form_tv_pay.setOnClickListener(this);
		order_rl_weixin.setOnClickListener(this);
		order_rl_alipay.setOnClickListener(this);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.form_tv_exit:
			showBoxType();
			break;
		case R.id.order_exit_but_nav:
			window.dismiss();
			break;
		case R.id.order_exit_but_pos:
			SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.preState, "preState");
			window.dismiss();
			finish();
			break;
		case R.id.order_form_tv_pay:
			
			cn.com.ethank.yunge.app.util.Constants.isFromKtvBox = true;
			
			// 0表示是支付宝；1表示是微信支付
			if (order != null) {
				if (payType == 0) {
					new PayOrderUtils(this, true, order.getKtvName(), order.getBoxTypeName(), order.getReserveBoxId(), order.getPrice()).payOrder();
				} else {
					if (!isWXAppInstalled.isWXAppInstalledAndSupported(msgApi)) {
						ToastUtil.show("微信支付目前无法调用，请先安装微信客户端");
						return;
					}
					// 微信
					WeiXinPayRequestMethod();
				}
			}
			break;
		case R.id.order_rl_weixin:
			payType = 1;
			order_iv_weixin.setBackgroundResource(R.drawable.paytypecheck);
			order_iv_alipay.setBackgroundResource(R.drawable.paytypenocheck);
			break;
		case R.id.order_rl_alipay:
			payType = 0;
			order_iv_weixin.setBackgroundResource(R.drawable.paytypenocheck);
			order_iv_alipay.setBackgroundResource(R.drawable.paytypecheck);
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
			BaseApplication.getInstance().exitObjectActivity(MerchantDetailActivity.class);
			BaseApplication.getInstance().exitObjectActivity(MainTabActivity.class);
			startActivity(intent);
			finish();
		}
	}

	// 获取微信预订单号
	private void WeiXinPayRequestMethod() {
		ProgressDialogUtils.show(this);
		final Map<String, String> map = new HashMap<String, String>();
		map.put("reserveBoxId", order.getReserveBoxId());
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
							// new PayOrderWeiXinUtils(msgApi,
							// order.getShopName(), order.getBoxTypeName(),
							// order.getReserveBoxId(), preOrderId,
							// order.getPrice()).payOrder();
							new PayOrderWeiXinUtils(msgApi, true, order.getReserveBoxId(), preOrderId, order.getPrice()).payOrder();
						} else {
							ToastUtil.show(obj.getString("message"));
						}
					} catch (Exception e) {
						ToastUtil.show(R.string.connectfailtoast);
					}
				} else {
					ToastUtil.show(R.string.connectfailtoast);
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
		}
		return false;
	}

	/**
	 * 弹出房间类型的popupwindow
	 */
	private void showBoxType() {

		int width = UICommonUtil.dip2px(getApplicationContext(), 300);
		int height = UICommonUtil.dip2px(getApplicationContext(), 130);

		window = new PopupWindow(orderExit, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(order_ll_parent, Gravity.CENTER, 0, 0);

	}
}
