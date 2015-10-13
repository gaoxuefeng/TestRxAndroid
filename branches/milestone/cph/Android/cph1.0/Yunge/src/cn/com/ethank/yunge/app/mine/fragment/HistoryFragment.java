package cn.com.ethank.yunge.app.mine.fragment;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.activity.ConsumeDetailActivity;
import cn.com.ethank.yunge.app.home.bean.Order;
import cn.com.ethank.yunge.app.mine.activity.SupermarketDetailActivity;
import cn.com.ethank.yunge.app.mine.bean.AllOrderInfo;
import cn.com.ethank.yunge.app.mine.bean.DrinkOrderInfo;
import cn.com.ethank.yunge.app.mine.bean.AllOrderInfo.AllBoxInfo;
import cn.com.ethank.yunge.app.mine.fragment.ProcessFragment.MyAdapter;
import cn.com.ethank.yunge.app.mine.fragment.ProcessFragment.ViewHolder;
import cn.com.ethank.yunge.app.mine.fragment.ProcessFragment.ViewHolder1;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

public class HistoryFragment extends Fragment {

	private MyAdapter myAdapter;
	private ListView history_lv;
	private List<AllBoxInfo> allBoxInfos2 = new ArrayList<AllOrderInfo.AllBoxInfo>();
	private MyRefreshListView history_tab_mrlv;
	private LinearLayout historyView;

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		super.onCreateView(inflater, container, savedInstanceState);
		historyView = (LinearLayout) inflater.inflate(
				R.layout.activity_tab_history, container, false);
		history_tab_mrlv = (MyRefreshListView) historyView
				.findViewById(R.id.history_tab_mrlv);

		initData();

		history_lv = history_tab_mrlv.getRefreshableView();
		history_tab_mrlv
				.setMode(com.handmark.pulltorefresh.library.PullToRefreshBase.Mode.PULL_UP_TO_REFRESH);

		history_tab_mrlv.setOnRefreshListener(new OnRefreshListener2() {
			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
			}

			@Override
			public void onPullUpToRefresh(final PullToRefreshBase refreshView) {
				// 上拉加载
				// initData();
				refreshView.postDelayed(new Runnable() {

					@Override
					public void run() {
						refreshView.onRefreshComplete();
					}
				}, 1);

			}
		});
		if (myAdapter == null) {
			myAdapter = new MyAdapter();
		}
		history_lv.setAdapter(myAdapter);
		history_lv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int position,
					long arg3) {
				
//				 Intent intent = new Intent(getActivity(),
//				 SupermarketDetailActivity.class); startActivity(intent);
//				 
				AllBoxInfo allBoxInfo = allBoxInfos2.get(position -1);
				if(allBoxInfo.getOrderType() == 0){
					getRoom(position - 1);
				}else{
					getDrink(position - 1);
				}
			}
		});
		return historyView;

	}

	/**
	 * 获取数据
	 */
	private void initData() {
		final Map<String, String> map = new HashMap<String, String>();
		map.put("action", "1");
		map.put("startIndex", "1");
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(
						Constants.hostUrlCloud + Constants.getOrders, map)
						.toString();
			}

			protected void onCompletion(String result, Throwable exception,
					boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					AllOrderInfo allOrderInfo = JSON.parseObject(result,
							AllOrderInfo.class);
					if (allOrderInfo.getCode() == 0) {
						if (allOrderInfo.getData().size() > 0) {
							for (int i = 0; i < allOrderInfo.getData().size(); i++) {
								// allBoxInfos2 = allOrderInfo.getData();
								allBoxInfos2.add(allOrderInfo.getData().get(i));
							}
						}
						myAdapter.notifyDataSetChanged();
						history_tab_mrlv.onRefreshComplete();

					} else {
						ToastUtil.show("没有");
					}
				} else {
					ToastUtil.show("联网失败");
				}
			};
		}.run();
	}

	class MyAdapter extends BaseAdapter {

		final int TYPE_0 = 0;
		final int TYPE_1 = 1;

		@Override
		public int getItemViewType(int position) {

			int type = position;

			if (allBoxInfos2.get(position).getOrderType() == 0) {
				type = 0;
			} else {
				type = 1;
			}

			if (type == 0) {
				return TYPE_0;
			} else if (type == 1) {
				return TYPE_1;
			}
			return TYPE_0;
		}

		@Override
		public int getViewTypeCount() {
			return 2;
		}

		@Override
		public int getCount() {
			// return 5;
			return allBoxInfos2.size();
		}

		@Override
		public Object getItem(int position) {
			return null;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder holder = null;
			ViewHolder1 holder1 = null;

			int type = 0;
			type = getItemViewType(position);

			if (convertView == null) {
				switch (type) {
				case TYPE_0:
					convertView = View.inflate(getActivity(),
							R.layout.item_consume, null);
					holder = new ViewHolder();
					holder.consume_tv_pay_state = (TextView) convertView
							.findViewById(R.id.consume_tv_pay_state);
					holder.tab_tv_day = (TextView) convertView
							.findViewById(R.id.tab_tv_day);
					holder.tab_tv_hours = (TextView) convertView
							.findViewById(R.id.tab_tv_hours);
					holder.tab_tv_name = (TextView) convertView
							.findViewById(R.id.tab_tv_name);

					convertView.setTag(holder);
					break;
				case TYPE_1:
					convertView = View.inflate(getActivity(),
							R.layout.item_drink, null);
					holder1 = new ViewHolder1();
					holder1.drink_tv_name = (TextView) convertView
							.findViewById(R.id.drink_tv_name);
					holder1.drink_tv_thing = (TextView) convertView
							.findViewById(R.id.drink_tv_thing);
					holder1.drink_tv_state = (TextView) convertView
							.findViewById(R.id.drink_tv_state);
					convertView.setTag(holder1);
					break;
				}

			} else {
				switch (type) {
				case TYPE_0:
					holder = (ViewHolder) convertView.getTag();
					break;
				case TYPE_1:
					holder1 = (ViewHolder1) convertView.getTag();
					break;
				}

			}

			switch (type) {
			case TYPE_0:

				SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd");
				String day = dateFormat.format(new Date(allBoxInfos2.get(
						position).getRbStartTime() * 1000L));

				SimpleDateFormat dateFormat2 = new SimpleDateFormat("E");
				String week = dateFormat2.format(new Date(allBoxInfos2.get(
						position).getRbStartTime() * 1000L));

				holder.tab_tv_day.setText(day + "(" + week + ")");

				SimpleDateFormat dateFormat1 = new SimpleDateFormat("HH:mm");
				String hour1 = dateFormat1.format(new Date(allBoxInfos2.get(
						position).getRbStartTime() * 1000L));
				String hour2 = dateFormat1.format(new Date(allBoxInfos2.get(
						position).getRbEndTime() * 1000L));

				holder.tab_tv_hours.setText(hour1 + "至" + hour2);

				String payState = "";

				holder.tab_tv_name.setText(allBoxInfos2.get(position)
						.getKTVName());
				if (allBoxInfos2.get(position).getPayState() == 0) {
					payState = "待支付";
				}
				holder.consume_tv_pay_state.setText(payState);
				break;
			case TYPE_1:

				String payState1 = "";
				holder1.drink_tv_name.setText(allBoxInfos2.get(position)
						.getKTVName());
				if (allBoxInfos2.get(position).getPayState() == 0) {
					payState1 = "待支付";
				} else {
					payState1 = "已支付";
				}
				holder1.drink_tv_state.setText(payState1);

				StringBuffer buffer = new StringBuffer();
				int size = allBoxInfos2.get(position).getGoodsList().size();

				for (int i = 0; i < size; i++) {
					if (i != size - 1) {
						buffer.append(allBoxInfos2.get(position).getGoodsList()
								.get(i).getgName()
								+ ",");
						allBoxInfos2.get(position).getKTVName();
					} else {
						buffer.append(allBoxInfos2.get(position).getGoodsList()
								.get(i).getgName());
					}
				}

				holder1.drink_tv_thing.setText(buffer);
				break;
			}

			return convertView;
		}

	}

	class ViewHolder {
		public TextView consume_tv_pay_state;
		public TextView tab_tv_name;
		public TextView tab_tv_day;
		public TextView tab_tv_hours;

	}

	class ViewHolder1 {
		public TextView drink_tv_name;
		public TextView drink_tv_thing;
		public TextView drink_tv_state;
	}

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
	}
	

	protected void getDrink(int position) {
		final String reserveBoxId = allBoxInfos2.get(position).getReserveGoodsId();
		if (TextUtils.isEmpty(Constants.getToken())) {
			ToastUtil.show("登录账号已过期，请重新登录");
			return;
		}
		final Map<String, String> map = new HashMap<String, String>();
		map.put("reserveGoodsId", reserveBoxId);
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.dingkDetail, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (result != null) {
					DrinkOrderInfo orderInfo = JSON.parseObject(result, DrinkOrderInfo.class);
					if (orderInfo.getCode() == 0) {
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.dringorderDetail, result);
						// --跳转到消费详情--
						Intent intent = new Intent(getActivity(), SupermarketDetailActivity.class);
						intent.putExtra("isHistorySuperDetail", true);
						intent.putExtra("reserveGoodsId", reserveBoxId);
						startActivity(intent);
					} else {
						ToastUtil.show("code!=0");
					}
				} else {
					ToastUtil.show("联网失败");
				}
			};
		}.run();
	}


	private void getRoom(int position) {
		String reserveBoxId = allBoxInfos2.get(position).getReserveBoxId();
		if (TextUtils.isEmpty(Constants.getToken())) {
			ToastUtil.show("登录账号已过期，请重新登录");
			return;
		}
		final Map<String, String> map = new HashMap<String, String>();
		map.put("reserveBoxId", reserveBoxId);
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.ktvorderDetail, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (result != null) {
					Order orderInfo = JSON.parseObject(result, Order.class);
					if (orderInfo.getCode() == 0) {
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.orderDetail, result);
						// --跳转到消费详情--
						Intent intent = new Intent(getActivity(), ConsumeDetailActivity.class);
						intent.putExtra("isHistoryConsumeDetail", true);
						startActivity(intent);
					} else {
						ToastUtil.show(orderInfo.getMessage());
					}
				} else {
					ToastUtil.show("联网失败");
				}
			};
		}.run();
	}
	
}
