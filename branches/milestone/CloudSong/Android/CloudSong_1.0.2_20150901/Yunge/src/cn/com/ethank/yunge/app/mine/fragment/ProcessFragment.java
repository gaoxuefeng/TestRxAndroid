package cn.com.ethank.yunge.app.mine.fragment;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
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
import cn.com.ethank.yunge.app.mine.activity.SupermarketDetailActivity;
import cn.com.ethank.yunge.app.mine.bean.AllOrderInfo;
import cn.com.ethank.yunge.app.mine.bean.AllOrderInfo.AllBoxInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;


@SuppressLint("SimpleDateFormat")
public class ProcessFragment extends Fragment {

	private ListView tab_lv;
	private MyAdapter myAdapter;
	private LinearLayout processView;
	private MyRefreshListView tab_mrlv;
	private AllOrderInfo allOrderInfo;
	private List<AllBoxInfo> allBoxInfos = new ArrayList<AllOrderInfo.AllBoxInfo>();
	private boolean haveMore;
	private int size;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		processView = (LinearLayout) inflater.inflate(R.layout.activity_tab_process, container, false);
		tab_mrlv = (MyRefreshListView) processView.findViewById(R.id.tab_mrlv);

		return processView;

	}


	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public void onResume() {
		allBoxInfos.clear();
		size = allBoxInfos.size();
		size = 0;
		initData();
		
		tab_lv = tab_mrlv.getRefreshableView();
		tab_mrlv.setMode(com.handmark.pulltorefresh.library.PullToRefreshBase.Mode.PULL_UP_TO_REFRESH);
		tab_mrlv.setOnRefreshListener(new OnRefreshListener2() {
			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
			}

			@Override
			public void onPullUpToRefresh(final PullToRefreshBase refreshView) {
				// 上拉加载
				if(haveMore){
					initData();
					refreshView.postDelayed(new Runnable() {
						@Override
						public void run() {
							refreshView.onRefreshComplete();
						}
					}, 1);
					
				}else{
					refreshView.onRefreshComplete();
				}

			}
		});

		if (myAdapter == null) {
			myAdapter = new MyAdapter();
		}
		tab_lv.setAdapter(myAdapter);

		tab_lv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				
				AllBoxInfo allBoxInfo = allBoxInfos.get(position);
			
				if(allBoxInfo.getOrderType() == 0){
					getRoom(position);
				}else{
					getDrink(position);
				}

			}

		});
		
		super.onResume();
	}
	protected void getDrink(int position) {
		final String reserveBoxId = allBoxInfos.get(position).getReserveGoodsId();
		if (TextUtils.isEmpty(Constants.getToken())) {
			ToastUtil.show("登录账号已过期，请重新登录");
			return;
		}
		final Map<String, String> map = new HashMap<String, String>();
		map.put("reserveGoodsId", reserveBoxId);
		map.put("token", Constants.getToken());
		
		Intent intent = new Intent(getActivity(), SupermarketDetailActivity.class);
		intent.putExtra("reserveGoodsId", reserveBoxId);
		startActivity(intent);
	}


	private void getRoom(int position) {
		String reserveBoxId = allBoxInfos.get(position).getReserveBoxId();
		if (TextUtils.isEmpty(Constants.getToken())) {
			ToastUtil.show("登录账号已过期，请重新登录");
			return;
		}
		
		Intent intent = new Intent(getActivity(), ConsumeDetailActivity.class);
		intent.putExtra(SharePreferenceKeyUtil.reserveBoxId, reserveBoxId);
		startActivity(intent);
		
	}
	
	
	/**
	 * 获取数据
	 */
	private void initData() {
		final Map<String, String> map = new HashMap<String, String>();
		map.put("action", "0");
		map.put("startIndex", size+"");
		
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.getOrders, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					AllOrderInfo allOrderInfo = JSON.parseObject(result, AllOrderInfo.class);
					if(allOrderInfo != null){
						if (allOrderInfo.getCode() == 0) {
							if (allOrderInfo.getData().size() > 0) {
								haveMore = true;
								//allBoxInfos = allOrderInfo.getData();
								for (int i = 0; i < allOrderInfo.getData().size(); i++) {
									//TODO 看后台是否更改
									//allBoxInfos = allOrderInfo.getData();
									allBoxInfos.add(allOrderInfo.getData().get(i));
								}
								myAdapter.notifyDataSetChanged();
								size = allBoxInfos.size();
							}else{
								haveMore = false;
							}
							
							tab_mrlv.onRefreshComplete();
							
						} else {
							ToastUtil.show("没有更多数据了");
							haveMore = false;
							tab_mrlv.onRefreshComplete();
						}
					}else{
						haveMore = false;
						tab_mrlv.onRefreshComplete();	
					}
				} else {
					ToastUtil.show(R.string.connectfailtoast);
					haveMore = false;
					tab_mrlv.onRefreshComplete();
				}
				
			};
		}.run();
	}

	@SuppressLint("SimpleDateFormat")
	class MyAdapter extends BaseAdapter {

		final int TYPE_0 = 0;
		final int TYPE_1 = 1;
		

		@Override
		public int getItemViewType(int position) {
			
			int type = position;
			
			if(allBoxInfos.get(position).getOrderType() == 0){
				type = 0;
			}else{
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
			//return 5;
			return allBoxInfos.size();
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
					convertView = View.inflate(getActivity(), R.layout.item_consume, null);
					holder = new ViewHolder();
					holder.consume_tv_pay_state = (TextView) convertView.findViewById(R.id.consume_tv_pay_state);
					holder.tab_tv_day = (TextView) convertView.findViewById(R.id.tab_tv_day);
					holder.tab_tv_hours = (TextView) convertView.findViewById(R.id.tab_tv_hours);
					holder.tab_tv_name = (TextView) convertView.findViewById(R.id.tab_tv_name);

					convertView.setTag(holder);
					break;
				case TYPE_1:
					convertView = View.inflate(getActivity(), R.layout.item_drink, null);
					holder1 = new ViewHolder1();
					holder1.drink_tv_name = (TextView) convertView.findViewById(R.id.drink_tv_name);
					holder1.drink_tv_thing = (TextView) convertView.findViewById(R.id.drink_tv_thing);
					holder1.drink_tv_state = (TextView) convertView.findViewById(R.id.drink_tv_state);
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
				String day = dateFormat.format(new Date(allBoxInfos.get(position).getRbStartTime() * 1000L));

				SimpleDateFormat dateFormat2 = new SimpleDateFormat("E");
				String week = dateFormat2.format(new Date(allBoxInfos.get(position).getRbStartTime() * 1000L));

				holder.tab_tv_day.setText(day + "(" + week + ")");

				SimpleDateFormat dateFormat1 = new SimpleDateFormat("HH:mm");
				String hour1 = dateFormat1.format(new Date(allBoxInfos.get(position).getRbStartTime() * 1000L));
				String hour2 = dateFormat1.format(new Date(allBoxInfos.get(position).getRbEndTime() * 1000L));

				holder.tab_tv_hours.setText(hour1 + "至" + hour2);

				String payState = "";

				holder.tab_tv_name.setText(allBoxInfos.get(position).getKTVName());
				int payStateInt = allBoxInfos.get(position).getPayState();
				if (payStateInt == 0) {
					payState = "已支付";
				}else if(payStateInt == 1){
					payState = "已支付";
				}else if(payStateInt == 2){
					payState = "已支付";
				}else if(payStateInt == 3){
					payState = "已取消";
				}else if(payStateInt == 4){
					payState = "待支付";
				}else if(payStateInt == 5){
					payState ="退款中";
				}
				holder.consume_tv_pay_state.setText(payState);
				break;
			case TYPE_1:
				
				String payState1 = "";
				holder1.drink_tv_name.setText(allBoxInfos.get(position).getKTVName()+"");
				int payStateInt1 = allBoxInfos.get(position).getPayState();
				if (payStateInt1 == 1) {
					payState1 = "未支付";
				}else if(payStateInt1 == 2){
					payState1 = "已支付";
				}else if(payStateInt1 == 3){
					payState1 = "退款中";
				}else if(payStateInt1 == 4){
					payState1 = "已完成";
				}else if(payStateInt1 == 5){
					payState1 = "已取消";
				}
			
				holder1.drink_tv_state.setText(payState1+"");
				
				StringBuffer buffer = new StringBuffer();
				int size = allBoxInfos.get(position).getGoodsList().size();
				
				
				for(int i=0; i<size; i++){
					if(i != size-1){
						buffer.append(allBoxInfos.get(position).getGoodsList().get(i).getgName()+ ",");
						allBoxInfos.get(position).getKTVName();
					}else{
						buffer.append(allBoxInfos.get(position).getGoodsList().get(i).getgName());
					}
				}
				if(TextUtils.isEmpty(buffer)){
					holder1.drink_tv_thing.setText("");
				}else{
					holder1.drink_tv_thing.setText(buffer.toString());
				}
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
}
