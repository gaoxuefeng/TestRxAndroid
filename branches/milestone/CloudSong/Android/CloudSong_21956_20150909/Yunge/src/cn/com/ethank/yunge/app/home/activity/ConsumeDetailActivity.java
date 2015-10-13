package cn.com.ethank.yunge.app.home.activity;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import android.annotation.SuppressLint;
import android.app.ActivityManager;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager.LayoutParams;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.ScrollView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.bean.CancleOrderInfo;
import cn.com.ethank.yunge.app.home.utils.JZADScoreTextView;
import cn.com.ethank.yunge.app.mine.network.CancelOrderNetwork;
import cn.com.ethank.yunge.app.mine.network.GetRoomNetwork;
import cn.com.ethank.yunge.app.mine.network.GetUserInfo.OnSuccess;
import cn.com.ethank.yunge.app.room.adapter.GetRoomData;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

/** 消费详情界面 */
public class ConsumeDetailActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.consume_but_cancel)
	private Button consume_but_cancel; // --取消活动--

	@ViewInject(R.id.consume_ll)
	private LinearLayout consume_ll;

	@ViewInject(R.id.consume_tv_state)
	private JZADScoreTextView consume_tv_state; // --支付状态--

	@ViewInject(R.id.detail_iv_exit)
	private ImageView detail_iv_exit; // --退出--

	@ViewInject(R.id.detail_tv_orderId)
	private TextView detail_tv_orderId; // --订单号--

	@ViewInject(R.id.detail_tv_uname)
	private TextView detail_tv_uname; // --用户名--

	@ViewInject(R.id.detail_tv_phoneNum)
	private TextView detail_tv_phoneNum; // --手机号--

	@ViewInject(R.id.detail_tv_theme)
	private TextView detail_tv_theme; // --主题--

	@ViewInject(R.id.detail_tv_day)
	private TextView detail_tv_day;

	@ViewInject(R.id.detail_tv_week)
	private TextView detail_tv_week;

	@ViewInject(R.id.detail_tv_hour)
	private TextView detail_tv_hour;

	@ViewInject(R.id.detail_tv_boxType)
	private TextView detail_tv_boxType;

	@ViewInject(R.id.detail_tv_price)
	private TextView detail_tv_price;

	@ViewInject(R.id.detail_tv_showName)
	private TextView detail_tv_showName;

	@ViewInject(R.id.consume_detail_tv_address)
	private TextView consume_detail_tv_address;

	@ViewInject(R.id.detail_tv_cancel)
	private TextView detail_tv_cancel; // --取消预订--

	@ViewInject(R.id.detail_tv_confirm)
	private TextView detail_tv_confirm; // --完成支付--

	@ViewInject(R.id.consume_sv_parent)
	private ScrollView consume_sv_parent;
	private View cancel;
	private TextView pop_tv_text1, pop_tv_text2;

	private PopupWindow window;

	private Button yes;

	private Button point;

	private cn.com.ethank.yunge.app.home.bean.Order orderDetail;

	private int state;

	private boolean isHistoryConsumeDetail;

	private SimpleDateFormat dateFormat;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_consume_detail);

		ViewUtils.inject(this);
		detail_iv_exit.setOnClickListener(this); 
	
		BaseApplication.getInstance().cacheActivityList.add(this);
		initData();
	

	}

	private void initData() {
		Intent intent = getIntent();
		final Map<String, String> map = new HashMap<String, String>();
		map.put("reserveBoxId", intent.getStringExtra(SharePreferenceKeyUtil.reserveBoxId));
		map.put("token", Constants.getToken());
		OnSuccess success = new OnSuccess() {
			@Override
			public void success() {
				String result = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.orderDetail);
				isHistoryConsumeDetail = getIntent().getBooleanExtra("isHistoryConsumeDetail", false);
				if (!TextUtils.isEmpty(result)) {
					orderDetail = JSON.parseObject(result, cn.com.ethank.yunge.app.home.bean.Order.class);
				}
				initView();
			}
		};
		new GetRoomNetwork(map, success).run();
	}

	@SuppressLint("SimpleDateFormat")
	private void initView() {

		

		detail_tv_orderId.setText(orderDetail.getData().getReserveBoxId());
		detail_tv_uname.setText(orderDetail.getData().getNickName());
		detail_tv_phoneNum.setText(orderDetail.getData().getPhoneNum());

		dateFormat = new SimpleDateFormat("MM-dd");
		String day = dateFormat.format(new Date(orderDetail.getData().getRbStartTime() * 1000L));

		dateFormat = new SimpleDateFormat("E");
		String week = dateFormat.format(new Date(orderDetail.getData().getRbStartTime() * 1000L));

		detail_tv_day.setText(day);
		detail_tv_week.setText(week);

		dateFormat = new SimpleDateFormat("HH:mm");
		String hour1 = dateFormat.format(new Date(orderDetail.getData().getRbStartTime() * 1000L));
		String hour2 = dateFormat.format(new Date(orderDetail.getData().getRbEndTime() * 1000L));

		detail_tv_hour.setText(hour1 + "至" + hour2);

		detail_tv_boxType.setText(orderDetail.getData().getRoomNum());
		detail_tv_price.setText("￥" + orderDetail.getData().getPrice());
		detail_tv_showName.setText(orderDetail.getData().getKTVName());
		consume_detail_tv_address.setText(orderDetail.getData().getAddress());

		cancel = View.inflate(getApplicationContext(), R.layout.pop_utils, null);
		pop_tv_text1 = (TextView) cancel.findViewById(R.id.pop_tv_text1);
		pop_tv_text2 = (TextView) cancel.findViewById(R.id.pop_tv_text2);
		pop_tv_text2.setVisibility(View.GONE);
			
		yes = (Button) cancel.findViewById(R.id.pop_but_left);
		point = (Button) cancel.findViewById(R.id.pop_but_right);

		int state = orderDetail.getData().getPayState();
		if (state == 0) {
			consume_ll.setVisibility(View.GONE);
			consume_but_cancel.setVisibility(View.VISIBLE);
			if(isHistoryConsumeDetail){
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setText("已消费");
				consume_tv_state.setText("已消费");
				
			}else{
				consume_but_cancel.setClickable(true);
				consume_tv_state.setText("已支付");
				
				yes.setText("是的");
				point.setText("点错");
				
				pop_tv_text1.setText("包厢已预留，真的要取消该订单吗?");
				consume_but_cancel.setText("取消订单");
			}
		} else if (state == 1) {
			consume_ll.setVisibility(View.GONE);
			consume_but_cancel.setVisibility(View.VISIBLE);
			consume_but_cancel.setClickable(false);
			if(isHistoryConsumeDetail){
				
				consume_but_cancel.setText("已消费");
				consume_tv_state.setText("已消费");
				
			}else{
				
				consume_tv_state.setText("已支付");
				consume_but_cancel.setText("即将开始");
			}
		} else if (state == 2) {
			if(isHistoryConsumeDetail){
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("已消费");
				consume_ll.setVisibility(View.GONE);
				consume_tv_state.setText("已消费");
			}else{
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("已消费");
				consume_ll.setVisibility(View.GONE);
				consume_tv_state.setText("已支付");
			
			}
		} else if (state == 3) {
		
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("已取消");
				consume_ll.setVisibility(View.GONE);
				consume_tv_state.setText("已取消");
			
			
		} else if (state == 4) {
			if(isHistoryConsumeDetail){
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("已取消");
				consume_ll.setVisibility(View.GONE);
				consume_tv_state.setText("已取消");
			}else{
				/*consume_but_cancel.setVisibility(View.GONE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("已取消");
				consume_ll.setVisibility(View.VISIBLE);
				consume_tv_state.setText("未支付");*/
				
				consume_but_cancel.setVisibility(View.GONE);
				consume_ll.setVisibility(View.VISIBLE);
				consume_tv_state.setText("未支付");
				yes.setText("否");
				point.setText("是");
				pop_tv_text1.setText("是否要取消该订单?");
			}
			
		}else if(state == 5){
			consume_but_cancel.setVisibility(View.VISIBLE);
			consume_but_cancel.setClickable(false);
			consume_but_cancel.setEnabled(false);
			consume_ll.setVisibility(View.GONE);
			if(isHistoryConsumeDetail){
				consume_but_cancel.setText("已取消");
				consume_tv_state.setText("已取消");
				
			}else{
				consume_but_cancel.setText("已退款");
				consume_tv_state.setText("已退款"); 
			}
		}
		consume_but_cancel.setOnClickListener(this);
		yes.setOnClickListener(this);
		point.setOnClickListener(this);
		

		detail_tv_cancel.setOnClickListener(this);
		detail_tv_confirm.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.consume_but_cancel:
			if(orderDetail.getData().getPayState() == 0){
				showBoxType();
			}else if (orderDetail.getData().getPayState() == 1) {
				initView();
				showBoxType();
			}
			break;
		case R.id.pop_but_left:
			// 退单页面
			if(orderDetail.getData().getPayState() == 0){
				Map<String, String> map = new HashMap<String, String>();
				map.put("reserveBoxId", orderDetail.getData().getReserveBoxId());
				map.put("token", Constants.getToken());
				OnSuccess onSuccess = new OnSuccess() {
					@Override
					public void success() {
						Intent intent = new Intent(getApplicationContext(), ChargeBackActivity.class);
						intent.putExtra("Price", orderDetail.getData().getPrice());
						startActivity(intent);
						consume_but_cancel.setVisibility(View.GONE);
						consume_ll.setVisibility(View.VISIBLE);
					}
				};
				new CancelOrderNetwork(map, onSuccess,window).run();
				
			}else{
				window.dismiss(); 
			}
			
			break;
		case R.id.pop_but_right:
			if (orderDetail.getData().getPayState() == 4) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("reserveBoxId", orderDetail.getData().getReserveBoxId());
				map.put("token", Constants.getToken());
				OnSuccess onSuccess = new OnSuccess() {
					@Override
					public void success() {
						consume_but_cancel.setText("已取消");
						consume_tv_state.setText("已取消");
						consume_but_cancel.setVisibility(View.VISIBLE);
						consume_ll.setVisibility(View.GONE);
					}
				};
				new CancelOrderNetwork(map, onSuccess,window).run();
				
			} else{
				window.dismiss();
			}
			break;
		case R.id.detail_iv_exit:
			finish();
			break;
		case R.id.detail_tv_cancel:
			showBoxType();
			break;
		case R.id.detail_tv_confirm:
			Intent order = new Intent(getApplicationContext(), OrderFormActivity.class);
			startActivity(order);
			finish();
			break;
		}

	}

	/**
	 * 弹出取消包厢的popupwindow
	 */
	private void showBoxType() {
		int width = UICommonUtil.dip2px(getApplicationContext(), 300);
		int height = UICommonUtil.dip2px(getApplicationContext(), 145);

		window = new PopupWindow(cancel, android.widget.RelativeLayout.LayoutParams.MATCH_PARENT,
				LayoutParams.MATCH_PARENT);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(consume_sv_parent, Gravity.CENTER, 0, 0);

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}

}