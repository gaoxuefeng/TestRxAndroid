package cn.com.ethank.yunge.app.mine.activity;

import java.text.SimpleDateFormat;
import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.utils.JZADScoreTextView;
import cn.com.ethank.yunge.app.mine.bean.DrinkOrderInfo;
import cn.com.ethank.yunge.app.mine.bean.DrinkOrderInfo.Data;
import cn.com.ethank.yunge.app.mine.bean.DrinkOrderInfo.Data.DrinkInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

public class SupermarketDetailActivity extends BaseActivity implements
		OnClickListener {

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

	private MyAdapter adapter;

	private DrinkOrderInfo drinkOrderInfo;

	private List<DrinkInfo> goodsList;

	private Data data;

	private boolean isHistorySuperDetail;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_supermarket_detail);

		getData();
		initView();
		initData();
	}

	private void getData() {
		try {
			isHistorySuperDetail = getIntent().getBooleanExtra("isHistorySuperDetail", false);
			String str = SharePreferencesUtil
					.getStringData(SharePreferenceKeyUtil.dringorderDetail);
			if (str != null) {
				drinkOrderInfo = JSONObject.parseObject(str, DrinkOrderInfo.class);
			}
			if (drinkOrderInfo.getCode() == 0) {
				data = drinkOrderInfo.getData();
				if(data != null){
					goodsList = data.getGoodsList();
				}
			}
		} catch (Exception e) {
		}
		
	}

	private void initData() {
		detail_tv_orderId.setText("");
		detail_tv_uname.setText(data.getUseName());
		detail_tv_phoneNum.setText(data.getPhoneNum());
		detail_tv_theme.setText("");
		detail_tv_ordertime.setText(getOrderTime(data.getOrderTime()));//订单时间
		tv_totalprice.setText(data.getSumPrice());
		tv_ktvname.setText(data.getKTVName());
		tv_ktvaddress.setText(data.getAddress());
		switch (data.getPayState()) {
		case 0:
			consume_tv_state.setText("未支付");
			break;

		default:
			break;
		}
		
	}

	private void initView() {
		ViewUtils.inject(this);

		detail_tv_orderId.setFocusable(true);
		detail_tv_orderId.setFocusableInTouchMode(true);
		detail_tv_orderId.requestFocus();

		detail_iv_exit.setOnClickListener(this);

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
				convertView = View.inflate(getApplicationContext(),
						R.layout.item_merchand, null);
				holder = new ViewHolder();
				holder.merchand_tv_name = (TextView) convertView
						.findViewById(R.id.merchand_tv_name);
				holder.merchand_tv_num = (TextView) convertView
						.findViewById(R.id.merchand_tv_num);
				holder.merchand_tv_price = (TextView) convertView
						.findViewById(R.id.merchand_tv_price);
				holder.merchand_tv_allPrice = (TextView) convertView
						.findViewById(R.id.merchand_tv_allPrice);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			holder.merchand_tv_name.setText(drinkInfo.getGname());
			holder.merchand_tv_num.setText(drinkInfo.getNum() + "/");
			holder.merchand_tv_price.setText(drinkInfo.getGprice() + "");
			holder.merchand_tv_allPrice.setText("￥"+drinkInfo.getNum()
					* drinkInfo.getGprice());
			return convertView;
		}

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.detail_iv_exit:
			finish();
			break;

		}

	}

	class ViewHolder {
		public TextView merchand_tv_name;
		public TextView merchand_tv_num;
		public TextView merchand_tv_price;
		public TextView merchand_tv_allPrice;

	}
	private String getOrderTime(int time){
		SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd  HH:mm");
		return format.format(time);
	}
}
