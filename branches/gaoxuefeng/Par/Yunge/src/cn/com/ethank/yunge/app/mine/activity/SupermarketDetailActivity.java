package cn.com.ethank.yunge.app.mine.activity;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import android.annotation.SuppressLint;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager.LayoutParams;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.utils.JZADScoreTextView;
import cn.com.ethank.yunge.app.mine.bean.DrinkOrderInfo;
import cn.com.ethank.yunge.app.mine.bean.DrinkOrderInfo.Data;
import cn.com.ethank.yunge.app.mine.bean.DrinkOrderInfo.Data.DrinkInfo;
import cn.com.ethank.yunge.app.mine.network.CancelOrderNetwork;
import cn.com.ethank.yunge.app.mine.network.GetDrinkNetwork;
import cn.com.ethank.yunge.app.mine.network.GetUserInfo.OnSuccess;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

public class SupermarketDetailActivity extends BaseActivity implements OnClickListener {

	@ViewInject(R.id.consume_lv_supermarket)
	private cn.com.ethank.yunge.view.MyListView consume_lv_supermarket;

	// 订单号
	@ViewInject(R.id.detail_tv_orderId)
	private TextView detail_tv_orderId;

	@ViewInject(R.id.detail_iv_exit)
	private ImageView detail_iv_exit;
	// 预约人
	@ViewInject(R.id.detail_tv_uname)
	private TextView detail_tv_uname;
	// 预约人电话
	@ViewInject(R.id.detail_tv_phoneNum)
	private TextView detail_tv_phoneNum;

	// 包厢号
	@ViewInject(R.id.detail_tv_theme)
	private TextView detail_tv_theme;

	// 下单时间
	@ViewInject(R.id.detail_tv_ordertime)
	private TextView detail_tv_ordertime;

	// 合计金额
	@ViewInject(R.id.tv_totalprice)
	private TextView tv_totalprice;

	// KTV名称
	@ViewInject(R.id.tv_ktvname)
	private TextView tv_ktvname;

	// KTV地址
	@ViewInject(R.id.tv_ktvaddress)
	private TextView tv_ktvaddress;

	// 右上角斜角
	@ViewInject(R.id.consume_tv_state)
	private JZADScoreTextView consume_tv_state;

	@ViewInject(R.id.consume_but_cancel)
	private Button consume_but_cancel;

	@ViewInject(R.id.consume_ll_drink)
	private LinearLayout consume_ll_drink;

	@ViewInject(R.id.drink_tv_cancel)
	private TextView drink_tv_cancel;

	@ViewInject(R.id.drink_tv_confirm)
	private TextView drink_tv_confirm;

	private MyAdapter adapter;

	private DrinkOrderInfo drinkOrderInfo;

	private List<DrinkInfo> goodsList;

	private Data data;

	private boolean isHistorySuperDetail;

	private SimpleDateFormat dateFormat;

	private View cancel;

	private TextView pop_tv_text1;

	private TextView pop_tv_text2;

	private Button yes;

	private Button point;

	private PopupWindow window;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_supermarket_detail);

		ViewUtils.inject(this);
		cancel = View.inflate(getApplicationContext(), R.layout.pop_utils, null);
		pop_tv_text1 = (TextView) cancel.findViewById(R.id.pop_tv_text1);
		pop_tv_text2 = (TextView) cancel.findViewById(R.id.pop_tv_text2);
		pop_tv_text2.setVisibility(View.GONE);

		yes = (Button) cancel.findViewById(R.id.pop_but_left);
		point = (Button) cancel.findViewById(R.id.pop_but_right);
		yes.setOnClickListener(this);
		point.setOnClickListener(this);

		drink_tv_cancel.setOnClickListener(this);
		drink_tv_confirm.setOnClickListener(this);

		detail_iv_exit.setOnClickListener(this);

		getData();

	}

	private void getData() {
		try {
			OnSuccess onSuccess = new OnSuccess() {
				@Override
				public void success() {
					isHistorySuperDetail = getIntent().getBooleanExtra("isHistorySuperDetail", false);
					String str = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.dringorderDetail);
					if (str != null) {
						drinkOrderInfo = JSONObject.parseObject(str, DrinkOrderInfo.class);
					}
					if (drinkOrderInfo.getCode() == 0) {
						data = drinkOrderInfo.getData();
						if (data != null) {
							goodsList = data.getGoodsList();
						}
					}

					initView();
					initData();
				}
			};
			final Map<String, String> map = new HashMap<String, String>();
			map.put("reserveGoodsId", getIntent().getStringExtra("reserveGoodsId"));
			map.put("token", Constants.getToken());
			new GetDrinkNetwork(map, onSuccess).run();

		} catch (Exception e) {
		}

	}

	@SuppressLint("SimpleDateFormat")
	private void initData() {
		detail_tv_orderId.setText(getIntent().getStringExtra("reserveGoodsId"));
		detail_tv_uname.setText(data.getUseName());
		detail_tv_phoneNum.setText(data.getPhoneNum());

		dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String day = dateFormat.format(new Date(data.getOrderTime() * 1000L));

		dateFormat = new SimpleDateFormat("HH:mm");
		String week = dateFormat.format(new Date(data.getOrderTime() * 1000L));

		detail_tv_ordertime.setText(day + "     " + week);// 订单时间
		tv_totalprice.setText(data.getSumPrice());
		tv_ktvname.setText("门店：" + data.getKTVName());
		tv_ktvaddress.setText("地址：" + data.getAddress());
		switch (data.getPayState()) {
		case 1:
			if (isHistorySuperDetail) {

				consume_tv_state.setText("已取消");
				consume_but_cancel.setText("已取消");
				consume_but_cancel.setClickable(false);
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_ll_drink.setVisibility(View.GONE);
			} else {

				consume_tv_state.setText("未支付");
				consume_but_cancel.setVisibility(View.GONE);
				consume_ll_drink.setVisibility(View.VISIBLE);
				drink_tv_cancel.setText("取消预订");
				drink_tv_confirm.setText("完成支付");

				pop_tv_text1.setText("是否取消该订单？");
				yes.setText("否");
				point.setText("是");
			}

			break;
		case 2:
			if (isHistorySuperDetail) {

				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_ll_drink.setVisibility(View.GONE);
				consume_but_cancel.setClickable(false);
				consume_tv_state.setText("已消费");
				consume_but_cancel.setText("已消费");
			} else {

				consume_tv_state.setText("已支付");
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_ll_drink.setVisibility(View.GONE);
				consume_but_cancel.setText("取消订单");
				consume_but_cancel.setClickable(true);
				consume_but_cancel.setEnabled(true);
				pop_tv_text1.setText("酒水已下单，是否要取消该订单？");
				yes.setText("是的");
				point.setText("点错");
			}

			break;
		case 3:
			if (isHistorySuperDetail) {

				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_ll_drink.setVisibility(View.GONE);
				consume_but_cancel.setClickable(false);
				consume_tv_state.setText("已取消");
				consume_but_cancel.setText("已取消");
			} else {
				consume_tv_state.setText("退款中");
				consume_but_cancel.setText("退款中");
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(true);
				consume_but_cancel.setEnabled(true);
				consume_ll_drink.setVisibility(View.GONE);
			}
			break;
		case 4:
			if (isHistorySuperDetail) {
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_ll_drink.setVisibility(View.GONE);
				consume_but_cancel.setClickable(false);
				consume_tv_state.setText("已消费");
				consume_but_cancel.setText("已消费");
			} else {
				consume_tv_state.setText("已完成");
				consume_but_cancel.setText("已完成");
				consume_but_cancel.setClickable(true);
				consume_but_cancel.setEnabled(true);
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_ll_drink.setVisibility(View.GONE);
			}
			break;
		case 5:
			if (isHistorySuperDetail) {
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_ll_drink.setVisibility(View.GONE);
				consume_but_cancel.setClickable(false);
				consume_tv_state.setText("已取消");
				consume_but_cancel.setText("已取消");
			} else {
				consume_tv_state.setText("已取消");
				consume_but_cancel.setText("已取消");
				consume_but_cancel.setVisibility(View.VISIBLE);
				consume_but_cancel.setClickable(true);
				consume_but_cancel.setEnabled(true);
				consume_ll_drink.setVisibility(View.GONE);
			}
			break;
		default:
			break;
		}

	}

	private void initView() {

		detail_tv_orderId.setFocusable(true);
		detail_tv_orderId.setFocusableInTouchMode(true);
		detail_tv_orderId.requestFocus();

		if (adapter == null) {
			adapter = new MyAdapter();
		}

		consume_lv_supermarket.setAdapter(adapter);
	}

	class MyAdapter extends BaseAdapter {
		@Override
		public int getCount() {
			return goodsList.size();
		}

		@Override
		public Object getItem(int position) {
			return goodsList.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			DrinkInfo drinkInfo = goodsList.get(position);
			ViewHolder holder = null;
			if (convertView == null) {
				convertView = View.inflate(getApplicationContext(), R.layout.item_merchand, null);
				holder = new ViewHolder();
				holder.merchand_tv_name = (TextView) convertView.findViewById(R.id.merchand_tv_name);
				holder.merchand_tv_num = (TextView) convertView.findViewById(R.id.merchand_tv_num);
				holder.merchand_tv_price = (TextView) convertView.findViewById(R.id.merchand_tv_price);
				holder.merchand_tv_allPrice = (TextView) convertView.findViewById(R.id.merchand_tv_allPrice);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			holder.merchand_tv_name.setText(drinkInfo.getGname());
			holder.merchand_tv_num.setText(drinkInfo.getNum() + "/" + drinkInfo.getGprice());
			holder.merchand_tv_price.setText(drinkInfo.getGprice() + "");
			holder.merchand_tv_allPrice.setText("￥" + drinkInfo.getNum() * drinkInfo.getGprice());
			return convertView;
		}

	}

	/**
	 * 弹出取消包厢的popupwindow
	 */
	private void showBoxType() {
		int width = UICommonUtil.dip2px(getApplicationContext(), 300);

		window = new PopupWindow(cancel, width, LayoutParams.WRAP_CONTENT);
		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(detail_iv_exit, Gravity.CENTER, 0, 0);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.detail_iv_exit:
			finish();
			break;
		case R.id.drink_tv_cancel:
			if (data.getPayState() == 1) {
				showBoxType();
			}
			break;
		case R.id.drink_tv_confirm:
			break;
		case R.id.pop_but_left:

			break;
		case R.id.pop_but_right:
			if (data.getPayState() == 1) {
				Map<String, String> map = new HashMap<String, String>();
				map.put(SharePreferenceKeyUtil.reserveBoxId, getIntent().getStringExtra("reserveGoodsId"));
				map.put(SharePreferenceKeyUtil.token, Constants.getToken());
				OnSuccess success = new OnSuccess() {
					@Override
					public void success() {
						consume_but_cancel.setVisibility(View.VISIBLE);
						consume_ll_drink.setVisibility(View.GONE);
						consume_but_cancel.setText("已取消");
						consume_tv_state.setText("已取消");
					}
				};
				new CancelOrderNetwork(map, success, window).run();
			} else {

				window.dismiss();

			}
			break;
		}

	}

	class ViewHolder {
		public TextView merchand_tv_name;
		public TextView merchand_tv_num;
		public TextView merchand_tv_price;
		public TextView merchand_tv_allPrice;

	}

	private String getOrderTime(int time) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd  HH:mm");
		return format.format(time);
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
