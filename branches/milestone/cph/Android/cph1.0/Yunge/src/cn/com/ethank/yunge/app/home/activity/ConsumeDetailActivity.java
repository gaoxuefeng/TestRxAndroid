package cn.com.ethank.yunge.app.home.activity;

import java.text.SimpleDateFormat;
import java.util.Date;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.ScrollView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.utils.JZADScoreTextView;
import cn.com.ethank.yunge.app.startup.BaseActivity;
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
	private TextView detail_tv_cancel; // --取消预定--

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

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_consume_detail);

		String result = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.orderDetail);
		isHistoryConsumeDetail = getIntent().getBooleanExtra("isHistoryConsumeDetail", false);
		if (!TextUtils.isEmpty(result)) {
			orderDetail = JSON.parseObject(result, cn.com.ethank.yunge.app.home.bean.Order.class);
		} /*
		 * else { OrderInfo orderInfo = new OrderInfo(); orderInfo.setCode(0);
		 * Order order = orderInfo.new Order(); order.setAddress("壹尚科技-嗨歌吧");
		 * order.setBoxTypeName("中包"); order.setTheme("壹尚可以团队建设-嗨歌");
		 * order.setDay("07-11"); order.setRoomNum("A226");
		 * order.setHour("19:00-21:00"); order.setNickName("保罗 沃克");
		 * order.setPhoneNum("18911239901"); order.setReserveBoxId("11");
		 * order.setShopName("宝乐迪九棵松店"); order.setPrice("200");
		 * orderInfo.setData(order); }
		 */

		initView();

	}

	private void initView() {

		ViewUtils.inject(this);

		detail_tv_orderId.setText(orderDetail.getData().getReserveBoxId());
		detail_tv_uname.setText(orderDetail.getData().getNickName());
		detail_tv_phoneNum.setText(orderDetail.getData().getPhoneNum());
		// detail_tv_theme.setText(orderDetail.getData().getTheme());

		/*
		 * SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd"); Date
		 * date; try { date = dateFormat.parse(orderInfo.getData().getDay());
		 * if(orderInfo.getData().getDay().startsWith("0")){ dateFormat = new
		 * SimpleDateFormat("M月dd日"); Character character =
		 * orderInfo.getData().getDay().charAt(3); character.toString();
		 * if(character.toString().equals("0")){ dateFormat = new
		 * SimpleDateFormat("M月d日"); } }else{ dateFormat = new
		 * SimpleDateFormat("MM月dd日"); Character character =
		 * orderInfo.getData().getDay().charAt(3);
		 * if(character.toString().equals("0")){ dateFormat = new
		 * SimpleDateFormat("M月d日"); } } String day = dateFormat.format(date);
		 * detail_tv_day.setText(day); } catch (ParseException e) {
		 * e.printStackTrace(); }
		 */

		SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd");
		String day = dateFormat.format(new Date(orderDetail.getData().getRbStartTime() * 1000L));

		SimpleDateFormat dateFormat2 = new SimpleDateFormat("E");
		String week = dateFormat2.format(new Date(orderDetail.getData().getRbStartTime() * 1000L));

		detail_tv_day.setText(day);
		detail_tv_week.setText(week);

		SimpleDateFormat dateFormat1 = new SimpleDateFormat("HH:mm");
		String hour1 = dateFormat1.format(new Date(orderDetail.getData().getRbStartTime() * 1000L));
		String hour2 = dateFormat1.format(new Date(orderDetail.getData().getRbEndTime() * 1000L));

		detail_tv_hour.setText(hour1 + "至" + hour2);

		detail_tv_boxType.setText(orderDetail.getData().getRoomNum());
		detail_tv_price.setText("￥" + orderDetail.getData().getPrice());
		detail_tv_showName.setText(orderDetail.getData().getKTVName());
		consume_detail_tv_address.setText(orderDetail.getData().getAddress());

		cancel = View.inflate(getApplicationContext(), R.layout.pop_register, null);
		pop_tv_text1 = (TextView) cancel.findViewById(R.id.pop_tv_text1);
		pop_tv_text2 = (TextView) cancel.findViewById(R.id.pop_tv_text2);

		yes = (Button) cancel.findViewById(R.id.pop_but_exit_login);
		point = (Button) cancel.findViewById(R.id.pop_but_forgert_pwd);

		int state = orderDetail.getData().getPayState();
		if (state == 0) {
			consume_but_cancel.setVisibility(View.GONE);
			consume_ll.setVisibility(View.VISIBLE);
			consume_tv_state.setText("未支付");

			yes.setText("否");
			point.setText("是");

			pop_tv_text1.setText("是否要取消该订单?");
		} else if (state == 1) {
			consume_ll.setVisibility(View.GONE);
			consume_but_cancel.setVisibility(View.VISIBLE);
			consume_but_cancel.setClickable(true);
			consume_tv_state.setText("已支付");

			yes.setText("是的");
			point.setText("点错");

			pop_tv_text1.setText("包厢已预留，真的要取消该订单吗?");
		} else if (state == 2) {
			if(isHistoryConsumeDetail){
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("已支付");
				consume_ll.setVisibility(View.GONE);
				consume_tv_state.setText("已支付");
			}else{
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("退款中");
				consume_ll.setVisibility(View.GONE);
				consume_tv_state.setText("已支付");
			}
		} else if (state == 3) {
			consume_but_cancel.setVisibility(View.VISIBLE);
			consume_but_cancel.setClickable(false);
			consume_but_cancel.setEnabled(false);
			consume_but_cancel.setText("已退款");
			consume_ll.setVisibility(View.GONE);
			consume_tv_state.setText("已退款");
		} else if (state == 4) {
			if(isHistoryConsumeDetail){
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("已取消");
				consume_ll.setVisibility(View.GONE);
				consume_tv_state.setText("已取消");
			}else{
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setEnabled(false);
				consume_but_cancel.setText("已取消");
				consume_ll.setVisibility(View.GONE);
				consume_tv_state.setText("未支付");
			}
			
		}
		consume_but_cancel.setOnClickListener(this);
		yes.setOnClickListener(this);
		point.setOnClickListener(this);
		detail_iv_exit.setOnClickListener(this);

		detail_tv_cancel.setOnClickListener(this);
		detail_tv_confirm.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.consume_but_cancel:
			if (orderDetail.getData().getPayState() == 1) {
				initView();
				showBoxType();
			}
			break;
		case R.id.pop_but_exit_login:
			// 退单页面
			if (orderDetail.getData().getPayState() == 1) {
				Intent intent = new Intent(getApplicationContext(), ChargeBackActivity.class);
				intent.putExtra("ReserveBoxId", orderDetail.getData().getReserveBoxId());// 订单号
				intent.putExtra("Price", orderDetail.getData().getPrice());// 订单号
				startActivity(intent);
				finish();
				consume_but_cancel.setVisibility(View.GONE);
				consume_ll.setVisibility(View.VISIBLE);
			}
			window.dismiss();
			// 缺少请求
			// window.dismiss();
			// consume_tv_state.setText("已取消");
			// consume_ll.setVisibility(View.GONE);
			// consume_but_cancel.setVisibility(View.VISIBLE);
			// consume_but_cancel.setText("已取消");
			// consume_but_cancel.setClickable(false);
			break;
		case R.id.pop_but_forgert_pwd:
			if (orderDetail.getData().getPayState() == 0) {
				consume_but_cancel.setText("已取消");
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_ll.setVisibility(View.GONE);
			}
			window.dismiss();
			break;
		case R.id.detail_iv_exit:
			finish();
			break;
		case R.id.detail_tv_cancel:
			showBoxType();
			break;
		case R.id.detail_tv_confirm:
			//Intent order = new Intent(getApplicationContext(), OrderFormActivity.class);
			//startActivity(order);
			break;
		}

	}

	/**
	 * 弹出取消包厢的popupwindow
	 */
	private void showBoxType() {
		int width = UICommonUtil.dip2px(getApplicationContext(), 300);
		int height = UICommonUtil.dip2px(getApplicationContext(), 145);

		window = new PopupWindow(cancel, width, height);

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

}