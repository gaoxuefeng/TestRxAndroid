package cn.com.ethank.yunge.app.home.adapter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.activity.OrderFormActivity;
import cn.com.ethank.yunge.app.home.bean.BoxInfo.Data.Box;
import cn.com.ethank.yunge.app.home.bean.HomeInfo;
import cn.com.ethank.yunge.app.home.bean.OrderInfo;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;

public class BoxListAdapter extends BaseAdapter {

	Context context;
	private List<Box> boxInfos;
	HomeInfo homeInfo;
	TextView pre_detail_tv_day;
	TextView pre_detail_tv_duration;
	TextView pre_detail_tv_hour;

	public BoxListAdapter(Context context, List<Box> boxInfos, HomeInfo homeInfo, TextView pre_detail_tv_day, TextView pre_detail_tv_duration,
			TextView pre_detail_tv_hour) {
		this.context = context;
		this.boxInfos = boxInfos;
		this.homeInfo = homeInfo;
		this.pre_detail_tv_day = pre_detail_tv_day;
		this.pre_detail_tv_duration = pre_detail_tv_duration;
		this.pre_detail_tv_hour = pre_detail_tv_hour;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = View.inflate(context, R.layout.item_box_type, null);
			holder.item_tv_box_type = (TextView) convertView.findViewById(R.id.item_tv_box_type);
			holder.item_tv_box_count = (TextView) convertView.findViewById(R.id.item_tv_box_count);
			holder.item_tv_price = (TextView) convertView.findViewById(R.id.item_tv_price);
			holder.item_but_pre = (Button) convertView.findViewById(R.id.item_but_pre);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		holder.item_tv_box_type.setText(boxInfos.get(position).getBoxTypeName());
		holder.item_tv_box_count.setText(boxInfos.get(position).getBoxTypeChoice());
		holder.item_tv_price.setText("￥" + boxInfos.get(position).getPrice() + "");
		if (boxInfos.get(position).isBoxTypeState()) {
			holder.item_but_pre.setBackgroundResource(R.drawable.pre_shape);
			holder.item_but_pre.setTextColor(context.getResources().getColor(R.color.white));
			holder.item_but_pre.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					if (!Constants.getLoginState()) {
						Intent intent = new Intent(context, LoginActivity.class);
						context.startActivity(intent);
					} else {
						onPredete(boxInfos.get(position).getBoxTypeId(), boxInfos.get(position).getBoxTypeName());
					}
				}
			});

		} else {
			holder.item_but_pre.setBackgroundResource(R.drawable.pre_shape_gray);
			holder.item_but_pre.setTextColor(context.getResources().getColor(R.color.pre_yuding));
		}

		return convertView;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public int getCount() {
		return boxInfos.size();
	}

	/**
	 * 点击预订按钮，跳转到预订支付界面
	 * 
	 * @param name
	 * @param id
	 */
	private void onPredete(int id, String name) {

		/*if (!TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.preState))) {
			ToastUtil.show("请您10分钟之后再来预订");
			return;
		}*/

		final Map<String, String> map = new HashMap<String, String>();
		map.put("BLDKTVId", homeInfo.getBLDKTVId());
		SimpleDateFormat dateFormat = new SimpleDateFormat("MM月dd日");
		Date date = null;
		try {
			date = dateFormat.parse(pre_detail_tv_day.getText() + "");
			dateFormat = new SimpleDateFormat("MM-dd");
			String day = dateFormat.format(date);
			map.put("day", day);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		String duration = pre_detail_tv_duration.getText().toString();
		map.put("duration", duration.subSequence(1, duration.indexOf("小")) + "");
		String hour = pre_detail_tv_hour.getText().toString();
		map.put("hour", hour.substring(0, hour.indexOf("起")));
		map.put("boxTypeId", id + "");
		map.put("boxTypeName", name);
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.genorder, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					OrderInfo orderInfo = JSON.parseObject(result, OrderInfo.class);
					if(orderInfo != null){
						
						if (orderInfo.getCode() == 0) {
							SharePreferencesUtil.deleteData("orderInfo");
							SharePreferencesUtil.saveStringData("orderInfo", result);
							// --跳转到订单支付界面--
							Intent order = new Intent(context, OrderFormActivity.class);
							context.startActivity(order);
						} else {
							ToastUtil.show(orderInfo.getMessage());
						}
					}

				} else {
					ToastUtil.show(R.string.connectfailtoast);
				}
			};
		}.run();
	}

	class ViewHolder {
		public TextView item_tv_box_type;
		public TextView item_tv_box_count;
		public TextView item_tv_price;
		public Button item_but_pre;
	}
}
