//package cn.com.ethank.yunge.app.search;
//
//import java.util.ArrayList;
//
//import android.content.Intent;
//import android.os.Bundle;
//import android.util.Pair;
//import android.view.View;
//import android.widget.AdapterView;
//import android.widget.LinearLayout;
//import cn.com.ethank.yunge.R;
//import cn.com.ethank.yunge.app.search.city.ChooseCityActivity;
//import cn.com.ethank.yunge.app.startup.BaseActivity;
//import cn.com.ethank.yunge.app.startup.BaseApplication;
//import cn.com.ethank.yunge.app.ui.doublelist.DoubleListView;
//import cn.com.ethank.yunge.app.ui.doublelist.MasterAdapter;
//import cn.com.ethank.yunge.app.ui.doublelist.SubAdapter;
//import cn.com.ethank.yunge.app.util.ToastUtil;
//
//import com.coyotelib.app.ui.widget.BasicTitle;
//
//public class OrderListActivity extends BaseActivity {
//
//	private BasicTitle title;
//	private SearchTabView tabCity;
//	private SearchTabView tabNearby;
//	private SearchTabView tabOrder;
//
//	private LinearLayout cityContainer;
//
//	private ArrayList<Pair<String, String[]>> nearbyList;
//	private DoubleListView masterList;
//	private DoubleListView subList;
//
//	private MasterAdapter masterAdapter;
//	private SubAdapter mSubAdapter;
//
//	@Override
//	protected void onCreate(Bundle savedInstanceState) {
//		super.onCreate(savedInstanceState);
//		setContentView(R.layout.activity_order_list);
//		BaseApplication.getInstance().cacheActivityList.add(this);
//		title = (BasicTitle) findViewById(R.id.title);
//		title.setTitle(R.string.ktv_order_title);
//		cityContainer = (LinearLayout) findViewById(R.id.listContainer);
//		masterList = (DoubleListView) findViewById(R.id.masterlistView);
//		subList = (DoubleListView) findViewById(R.id.subListView);
//		masterAdapter = new MasterAdapter(this);
//		mSubAdapter = new SubAdapter(this);
//		initTab();
//		initTextCityData();
//		masterAdapter.setData(nearbyList);
//		masterList.setAdapter(masterAdapter);
//
//		subList.setAdapter(mSubAdapter);
//		subList.setAdapter(mSubAdapter);
//
//		masterList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//			@Override
//			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//				Pair<String, String[]> item = masterAdapter.getItem(position);
//				mSubAdapter.setData(item.second);
//				mSubAdapter.notifyDataSetChanged();
//			}
//		});
//
//	}
//
//	private static final String[] nearBy = new String[] { "附近（智能范围）", "500米", "1000米", "2000米", "5000米" };
//
//	private static final String[] hotdistrict = new String[] { "全部商区", "三里屯", "回龙观", "国贸", "望京", "朝外大街", "亮马桥/三元桥", "大望路" };
//
//	private static final String[] testDistrict1 = new String[] { "商圈测试1", "三里屯", "回龙观", "国贸", "望京", "朝外大街", "亮马桥/三元桥", "大望路" };
//
//	private static final String[] testDistrict2 = new String[] { "商圈测试2", "三里屯", "回龙观", "国贸", "望京", "朝外大街", "亮马桥/三元桥", "大望路" };
//
//	private static final String[] testDistrict3 = new String[] { "商圈测试3", "三里屯", "回龙观", "国贸", "望京", "朝外大街", "亮马桥/三元桥", "大望路" };
//
//	private static final String[] testDistrict4 = new String[] { "商圈测试4", "三里屯", "回龙观", "国贸", "望京", "朝外大街", "亮马桥/三元桥", "大望路" };
//
//	private void initTextCityData() {
//		nearbyList = new ArrayList<Pair<String, String[]>>();
//		nearbyList.add(new Pair<String, String[]>("附近", nearBy));
//		nearbyList.add(new Pair<String, String[]>("全城热门商区", hotdistrict));
//		nearbyList.add(new Pair<String, String[]>("朝阳区", testDistrict1));
//		nearbyList.add(new Pair<String, String[]>("昌平区", testDistrict2));
//		nearbyList.add(new Pair<String, String[]>("海淀区", testDistrict3));
//		nearbyList.add(new Pair<String, String[]>("东城区", testDistrict4));
//
//	}
//
//	private void initTab() {
//
//		tabCity = (SearchTabView) findViewById(R.id.tab_choose_tx);
//		tabCity.setTabName(R.string.tab_name_city);
//		tabCity.setOnClickListener(cityClicked);
//		tabNearby = (SearchTabView) findViewById(R.id.tab_nearby);
//		tabNearby.setTabName(R.string.tab_nearby);
//		tabNearby.setOnClickListener(nearByClicked);
//		tabOrder = (SearchTabView) findViewById(R.id.tab_order);
//		tabOrder.setTabName(R.string.tab_first);
//		tabOrder.setOnClickListener(orderClicked);
//	}
//
//	private View.OnClickListener cityClicked = new View.OnClickListener() {
//		@Override
//		public void onClick(View v) {
//			Intent intent = new Intent(OrderListActivity.this, ChooseCityActivity.class);
//			startActivity(intent);
//		}
//	};
//
//	private View.OnClickListener nearByClicked = new View.OnClickListener() {
//		@Override
//		public void onClick(View v) {
//			changeNearbyStatus();
//		}
//	};
//
//	private View.OnClickListener orderClicked = new View.OnClickListener() {
//		@Override
//		public void onClick(View v) {
//			ToastUtil.show("this is test");
//		}
//	};
//
//	private void changeNearbyStatus() {
//		if (cityContainer.getVisibility() == View.GONE) {
//			cityContainer.setVisibility(View.VISIBLE);
//			masterList.performItemClick(masterList, 0, 0);
//		} else {
//			cityContainer.setVisibility(View.GONE);
//		}
//	}
//}
