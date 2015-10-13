package cn.com.ethank.yunge.app.home;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.GZIPOutputStream;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AbsListView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.home.activity.MerchantDetailActivity;
import cn.com.ethank.yunge.app.home.activity.WebMerchantDetailActivity;
import cn.com.ethank.yunge.app.home.adapter.HomeOrderAdapter;
import cn.com.ethank.yunge.app.home.bean.CityCircleBean;
import cn.com.ethank.yunge.app.home.bean.HomeInfo;
import cn.com.ethank.yunge.app.home.requestNetWork.MyAddressPopWindower;
import cn.com.ethank.yunge.app.home.requestNetWork.RequestCityCircledata;
import cn.com.ethank.yunge.app.home.requestNetWork.RequestKTVList;
import cn.com.ethank.yunge.app.search.SearchTabView;
import cn.com.ethank.yunge.app.search.SearchTabView.TabTextChangeListener;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseFragment;
import cn.com.ethank.yunge.app.ui.doublelist.DoubleListView;
import cn.com.ethank.yunge.app.ui.doublelist.MasterAdapter;
import cn.com.ethank.yunge.app.ui.doublelist.OrderByAdapter;
import cn.com.ethank.yunge.app.ui.doublelist.SubAdapter;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.VerifyStringType;
import cn.com.ethank.yunge.view.MyRefreshListView;
import cn.com.ethank.yunge.view.NetworkLayout;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.LocationClientOption.LocationMode;
import com.coyotelib.app.ui.widget.BasicTitle;
import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.network.OnNetworkChangedListener;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.lidroid.xutils.bitmap.PauseOnScrollListener;
import com.umeng.analytics.MobclickAgent;

@SuppressLint({ "InflateParams", "ValidFragment" })
public class PredeteFragment extends BaseFragment implements
		View.OnClickListener, OnNetworkChangedListener {
	public static final int CHANGE_CITY = 10;
	public static boolean isConnectNetPredete = true;

	private BasicTitle title;
	private LinearLayout cityContainer;
	private List<CityCircleBean> nearbyList = new ArrayList<CityCircleBean>();
	private DoubleListView dlv_masterList;
	private DoubleListView subList;
	private MasterAdapter masterAdapter;
	private Context context;
	private SubAdapter mSubAdapter;
	private SearchTabView tabCity;
	private SearchTabView tabNearby;
	private SearchTabView tabOrder;
	private ListView lv_order_list;
	private LocationClient mLocationClient;
	private MyLocationListener mMyLocationListener;
	private String locationCity = "";
	private View popView;
	private PopupWindow myNearByPopup;
	private LinearLayout ll_tabs;
	private View popCityView;
	private MyAddressPopWindower myCityPopup;
	private View popOrderLayout;
	private DoubleListView dlv_pop_order_by;
	// 请求网络的当前页
	List<HomeInfo> homeInfos = new MyArrayList();
	private PopupWindow myOrderByPopup;
	private OrderByAdapter orderByAdapter;
	private boolean tabNearbyIsopen;
	private boolean tabOrderIsopen;
	private int clickedOrderPuplePosition;
	public static HomeInfo currentHomeInfo;
	private RequestCityCircledata requestCityCircledata;

	public PredeteFragment() {

	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		context = getActivity();

		contentView = inflater.inflate(R.layout.activity_order_list, container,
				false);
		// initView(contentView);
		initTitle(contentView);
		initTab(contentView);
		initPopCity(contentView);
		initPopNearBy(contentView);// ffff
		initOrderByPop(contentView);
		setNetWork();

		return contentView;
	}

	private void setNetWork() {
		network = (NetworkLayout) contentView.findViewById(R.id.network);
		mrlv_order_list = (MyRefreshListView) contentView
				.findViewById(R.id.mrlv_order_list);
		if (NetStatusUtil.isNetConnect()) {
			mrlv_order_list.setVisibility(View.VISIBLE);
			network.setVisibility(View.GONE);
			initView(contentView);
			initAdapter();
			getLocationPosition();// 获取定位
			setTabChangeListener();
			requestCircledata(tabCity.getTabName());// 初始化
			netWorkUnConnect();
			isConnectNetPredete = true;
		} else {

			mrlv_order_list.setVisibility(View.GONE);
			network.setVisibility(View.VISIBLE);
			initNetView(network);
			isConnectNetPredete = false;
		}
	}

	private void initNetView(View view2) {
		TextView tv_refresh = (TextView) view2.findViewById(R.id.tv_refresh);
		tv_refresh.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// ToastUtil.show("点击刷新");
				onPredete.OnUpdatePredete();
			}
		});
	}

	public interface OnPredeteListner {
		void OnUpdatePredete();
	}

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		onPredete = (OnPredeteListner) activity;
	}

	private void netWorkUnConnect() {
		if (!NetStatusUtil.isNetConnect() && homeInfos.size() == 0) {

		}

	}

	protected void requestCircledata(String city) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("cityName", city);
		requestCityCircledata = new RequestCityCircledata(context, hashMap);
		requestCityCircledata.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				if (map != null && map.containsKey("data")
						&& map.get("data") != null) {
					List<CityCircleBean> circleBeans = (List<CityCircleBean>) map
							.get("data");
					clearNearByList();
					nearbyList.addAll(circleBeans);
					masterAdapter.setData(nearbyList);
					if (nearbyList.size() > 0
							&& nearbyList.get(0).getCircleName().size() > 0) {
						mSubAdapter.setData(nearbyList.get(0));
						String tabName = (String) mSubAdapter.getItem(0);
						tabNearby.setTabName(tabName);
					} else {
						if (homeInfos.size() == 0) {
							requestHomeInfoNetwork(true);
						}
					}
				}
			}

			@Override
			public void onLoaderFail() {
				clearNearByList();
			}
		});
	}

	protected void clearNearByList() {
		nearbyList.clear();
		masterAdapter.setData(nearbyList);
		mSubAdapter.setData(new CityCircleBean());
		tabNearby.setTabName("全城");
	}

	private void setTabChangeListener() {
		tabCity.SetOnTabTextChangeListener(new TabTextChangeListener() {

			@Override
			public void requestNetWork(String cityName) {

			}

			@Override
			public void changeBottomTab(String cityName) {
				clearHomeInfo();
				if (cityName != null && !cityName.isEmpty()) {
					SharePreferencesUtil.saveStringData(
							SharePreferenceKeyUtil.currentCity, cityName);
				}

				requestCircledata(cityName);// 获取商圈
			}
		});
		tabNearby.SetOnTabTextChangeListener(new TabTextChangeListener() {

			@Override
			public void requestNetWork(String nearbyName) {

				requestHomeInfoNetwork(true);

			}

			@Override
			public void changeBottomTab(String nearbyName) {

			}
		});
		tabOrder.SetOnTabTextChangeListener(new TabTextChangeListener() {

			@Override
			public void requestNetWork(String orderName) {
				requestHomeInfoNetwork(true);
			}

			@Override
			public void changeBottomTab(String orderName) {

			}
		});
	}

	/**
	 * 排序方法
	 * 
	 * @param contentView
	 */
	@SuppressLint("InflateParams")
	private void initOrderByPop(View contentView) {
		initTextOrderByData();
		tabOrder.setTabName(orderbyList.get(0));// 默认是智能排序
		popOrderLayout = getActivity().getWindow().getLayoutInflater()
				.inflate(R.layout.pop_select_order_by, null, true);// 弹出窗口包含的视图
		popOrderLayout.setOnClickListener(this);

		dlv_pop_order_by = (DoubleListView) popOrderLayout
				.findViewById(R.id.dlv_pop_order_by);
		myOrderByPopup = new PopupWindow(popOrderLayout,
				LayoutParams.WRAP_CONTENT, LayoutParams.MATCH_PARENT, true);
		// myNearByPopup.setAnimationStyle(R.style.PopupAnimation);
		myOrderByPopup.setOutsideTouchable(true);
		myOrderByPopup.setBackgroundDrawable(new ColorDrawable(0x00000000));
		orderByAdapter = new OrderByAdapter(context, orderbyList);
		myOrderByPopup.setWidth(LayoutParams.MATCH_PARENT);

		myOrderByPopup.setOnDismissListener(new OnDismissListener() {

			@Override
			public void onDismiss() {
				if (tabOrderIsopen) {
					tabOrderIsopen = false;
					tabOrder.changeTvDrawableDown();
				}
			}
		});

		dlv_pop_order_by.setAdapter(orderByAdapter);
		dlv_pop_order_by.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				// 记录已经点击的位置
				clickedOrderPuplePosition = position;
				tabOrder.setTabName(orderbyList.get(position));
				if (myOrderByPopup != null) {
					myOrderByPopup.dismiss();
				}
			}
		});

	}

	private void popOrderLayoutClick() {
		if (myOrderByPopup != null) {
			myOrderByPopup.dismiss();
		}
	}

	private void initPopCity(View contentView) {
		popCityView = getActivity().getWindow().getLayoutInflater()
				.inflate(R.layout.choose_city_layout, null, true);// 弹出窗口包含的视图
		myCityPopup = new MyAddressPopWindower(context, popCityView,
				LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, true);
		myCityPopup
				.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING);
		myCityPopup.setOnDismissListener(new OnDismissListener() {

			@Override
			public void onDismiss() {
				tabCity.changeTvDrawableDown();
				try {
					String city = popCityView.getTag().toString();
					if (city != null && !city.isEmpty()
							&& !city.equals(tabCity.getTabName())) {
						if (tabNearby.getTabName().equals("全城")) {
							tabCity.setTabName(city);
							requestHomeInfoNetwork(true);
							return;
						}
						tabCity.setTabName(city);
					}

				} catch (Exception e) {
					e.printStackTrace();
				}
				//
				tabCity.changeTvDrawableDown();

			}
		});
	}

	private void initPopNearBy(View contentView) {
		popView = getActivity().getWindow().getLayoutInflater()
				.inflate(R.layout.pop_select_naerby, null, true);// 弹出窗口包含的视图

		cityContainer = (LinearLayout) popView.findViewById(R.id.listContainer);
		cityContainer.setOnClickListener(this);
		dlv_masterList = (DoubleListView) popView
				.findViewById(R.id.masterlistView);
		subList = (DoubleListView) popView.findViewById(R.id.subListView);
		myNearByPopup = new PopupWindow(popView, LayoutParams.WRAP_CONTENT,
				LayoutParams.MATCH_PARENT, true);
		// myNearByPopup.setAnimationStyle(R.style.PopupAnimation);
		myNearByPopup.setOutsideTouchable(true);
		myNearByPopup.setBackgroundDrawable(new ColorDrawable(0x00000000));
		myNearByPopup.setWidth(LayoutParams.MATCH_PARENT);
		myNearByPopup.setOnDismissListener(new OnDismissListener() {

			@Override
			public void onDismiss() {
				if (tabNearbyIsopen) {
					tabNearbyIsopen = false;
					tabNearby.changeTvDrawableDown();
				}
			}
		});
		popView.setOnClickListener(this);
	}

	private void dismissNeayByPop() {
		if (myNearByPopup.isShowing()) {
			myNearByPopup.dismiss();
			if (tabNearbyIsopen) {
				tabNearby.changeTvDrawableDown();
			}
		}
	}

	/**
	 * 数据压缩
	 * 
	 * @param is
	 * @param os
	 * @throws Exception
	 */
	private static int BUFFER = 1024;

	public static void compress(InputStream is, OutputStream os)
			throws Exception {

		GZIPOutputStream gos = new GZIPOutputStream(os);

		int count;
		byte data[] = new byte[BUFFER];
		while ((count = is.read(data, 0, BUFFER)) != -1) {
			gos.write(data, 0, count);
		}

		gos.finish();

		gos.flush();
		gos.close();
	}

	private void initAdapter() {
		// 商圈1
		masterAdapter = new MasterAdapter(context, nearbyList);
		dlv_masterList.setAdapter(masterAdapter);
		// 商圈2
		mSubAdapter = new SubAdapter(context, new ArrayList<String>());
		subList.setAdapter(mSubAdapter);
		homeOrderAdapter = new HomeOrderAdapter(getActivity(), homeInfos);
		lv_order_list.setAdapter(homeOrderAdapter);

		lv_order_list.setSelector(new ColorDrawable(Color.TRANSPARENT));
		// 中间预订的listView
		lv_order_list.setAdapter(homeOrderAdapter);

		dlv_masterList
				.setOnItemClickListener(new AdapterView.OnItemClickListener() {
					@Override
					public void onItemClick(AdapterView<?> parent, View view,
							int position, long id) {
						masterAdapter.setSelectedPosition(position);
						mSubAdapter.setData(nearbyList.get(position));
						mSubAdapter.notifyDataSetChanged();
					}
				});
		dlv_masterList.setOnScrollListener(new OnScrollListener() {

			@Override
			public void onScrollStateChanged(AbsListView view, int scrollState) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onScroll(AbsListView view, int firstVisibleItem,
					int visibleItemCount, int totalItemCount) {
				int lastItem = firstVisibleItem + visibleItemCount;
				if (lastItem == totalItemCount) {
					dlv_masterList.setSelection(dlv_masterList.getBottom());
				}
			}

		});

		subList.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				String tabName = (String) mSubAdapter.getItem(position);
				if (tabName.equals("全区") || tabName.equals("全县")) {
					tabName = mSubAdapter.getMastTabName(position);

				}
				mSubAdapter.setSelectData(tabName);
				tabNearby.setTabName(tabName);
				changeNearbyStatus();
			}
		});

		lv_order_list.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				// 这儿的position是相对于下拉刷新的position加上了title,所以这儿获取的id才是真正的位置
				// 设置短时间内不可点击
				if (!Constants.isClickAble()) {
					return;
				} else {
					Constants.setUnClickAble();
				}
				if (id < homeInfos.size()) {
					HomeInfo homeInfo = homeInfos.get((int) id);
					if (homeInfo.isLocalData()) {

						// Intent intent = new Intent(getActivity(),
						// MainTabActivity.class);
						// intent.setType(MainTabActivity.);
						// intent.putExtra("homeInfo", homeInfo);
						// startActivity(intent);
						// TODO 跳转到详情
						currentHomeInfo = homeInfo;
						Intent intent = new Intent(getActivity(),
								MerchantDetailActivity.class);
						startActivity(intent);
						// setMainTabPosition(5);
					} else {
						Intent intent = new Intent(getActivity(),
								WebMerchantDetailActivity.class);
						intent.putExtra("homeInfo", homeInfo);
						intent.putExtra("intent_url", homeInfo.getShopUrl());
						startActivity(intent);

					}

					MobclickAgent.onEvent(BaseApplication.getInstance(),
							"ReserveListItem");
				}
			}
		});
	}

	private void initTab(View view) {
		// 城市
		tabCity = (SearchTabView) view.findViewById(R.id.tab_choose_tx);
		String currentDefaultCity = SharePreferencesUtil.getStringData(
				SharePreferenceKeyUtil.currentCity, "北京");
		locationCity = currentDefaultCity;
		tabCity.setTabName(currentDefaultCity);
		tabCity.setOnClickListener(this);
		// 附近
		tabNearby = (SearchTabView) view.findViewById(R.id.tab_nearby);
		tabNearby.setTabName(R.string.tab_nearby);
		tabNearby.setOnClickListener(this);
		// 智能排序
		tabOrder = (SearchTabView) view.findViewById(R.id.tab_order);
		tabOrder.setTabName(R.string.tab_first);
		tabOrder.setOnClickListener(this);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void initView(View view) {
		// initTitle(view);
		// home页面的ListView

		// if(NetStatusUtil.isNetConnect()){
		// mrlv_order_list.setVisibility(View.VISIBLE);
		// network.setVisibility(View.GONE);
		// }else{
		//
		// }
		// mrlv_order_list = (MyRefreshListView) contentView
		// .findViewById(R.id.mrlv_order_list);
		mrlv_order_list.setPullToRefreshOverScrollEnabled(false);
		mrlv_order_list.setMode(Mode.PULL_FROM_END);
		lv_order_list = mrlv_order_list.getRefreshableView();
		lv_order_list.setOnScrollListener(new PauseOnScrollListener(
				BaseApplication.bitmapUtils, true, true));
		mrlv_order_list.setOnRefreshListener(new OnRefreshListener2() {
			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				requestHomeInfoNetwork(false);

			}

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				if (mrlv_order_list != null) {
					mrlv_order_list.onRefreshComplete();
				}

			}
		});

	}

	private void initTitle(View view) {
		ll_tabs = (LinearLayout) view.findViewById(R.id.ll_tabs);
		title = (BasicTitle) view.findViewById(R.id.title);
		title.setBackgroundColor(Color.parseColor("#241938"));
		title.setTitleColor(Color.parseColor("#FFFFFF"));
		title.showBtnFunction(false);
		title.showBtnBack(false);
		title.setTitle(R.string.tab_first);
	}

	/**
	 * 请求网络
	 * 
	 * @return
	 */
	private void requestHomeInfoNetwork(final boolean isFirstTime) {
		if (isFirstTime) {
			clearHomeInfo();
		}

		requestHomeInfoNetwork(isFirstTime, locationCity, Constants.latitude
				+ "", Constants.longitude + "");

	}

	/**
	 * 请求网络
	 * 
	 * @return
	 */
	private void requestHomeInfoNetwork(final boolean isFirstTime, String city,
			String latitude, String longitude) {
		if (isFirstTime) {
			clearHomeInfo();
		}

		HashMap<String, String> hashMap = new HashMap<String, String>();
		// 每次请求10条数据
		// 商圈名称
		if (tabNearby != null && !tabNearby.getTabName().equals("附近")
				&& !tabNearby.getTabName().equals("附近（智能范围）")
				&& !tabNearby.equals("全部商圈")) {
			if (tabNearby.getTabName().endsWith("米")) {
				String mTab = tabNearby.getTabName().trim().replaceAll("米", "");
				if (VerifyStringType.isNumeric(mTab)) {
					hashMap.put("range", tabNearby.getTabName());
				}
			} else {
				if (!tabNearby.getTabName().equals("全城")) {
					hashMap.put("businessName", tabNearby.getTabName());
				}
			}

		}

		// 城市名
		if (tabCity != null && tabCity.getTabName() != null) {
			hashMap.put("cityName", tabCity.getTabName());
		}

		// 经纬度
		hashMap.put("lat", latitude);
		hashMap.put("lng", longitude);
		// 智能呢个排序
		hashMap.put("orderType", orderByAdapter.getSelectPosition() + "");
		// 500米
		hashMap.put("startIndex", homeInfos.size() + "");
		hashMap.put("token", Constants.getToken());
		// hashMap.put("type", value);

		RequestKTVList requestKTVList = new RequestKTVList(context, hashMap);
		requestKTVList.start(new RequestCallBack() {

			@SuppressWarnings("unchecked")
			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				if (map != null && map.containsKey("data")) {
					try {
						List<HomeInfo> infos = (List<HomeInfo>) map.get("data");
						if (isFirstTime) {
							clearHomeInfo();
						}
						if (infos != null) {
							for (int i = 0; i < infos.size(); i++) {
								if (!homeInfos.contains(infos.get(i))) {
									homeInfos.add(infos.get(i));
								}
							}
						}
						homeOrderAdapter.setList(homeInfos);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				mrlv_order_list.onRefreshComplete();
				ProgressDialogUtils.dismiss();
			}

			@Override
			public void onLoaderFail() {
				mrlv_order_list.onRefreshComplete();
				ProgressDialogUtils.dismiss();
			}
		});
	}

	protected void clearHomeInfo() {
		homeInfos.clear();
		if (homeOrderAdapter != null) {
			homeOrderAdapter.setList(homeInfos);
		}

	}

	private void getLocationPosition() {
		mLocationClient = new LocationClient(context);
		LocationClientOption option = new LocationClientOption();
		option.setLocationMode(LocationMode.Hight_Accuracy);// 设置定位模式
		option.setCoorType("gcj02");// 返回的定位结果是百度经纬度，默认值gcj02
		option.setScanSpan(10000);// 设置发起定位请求的间隔时间为5000ms
		option.setIsNeedAddress(true);// 返回的定位结果包含地址信息
		mLocationClient.setLocOption(option);
		mMyLocationListener = new MyLocationListener();
		mLocationClient.registerLocationListener(mMyLocationListener);
		mLocationClient.start();
		mLocationClient.requestLocation();
	}

	@Override
	public void onDetach() {
		super.onDetach();
	}

	@Override
	public void onClick(View v) {
		if (!Constants.isClickAble()) {
			return;
		} else {
			Constants.setUnClickAble();
		}
		switch (v.getId()) {
		case R.id.listContainer:

			break;
		case R.id.tab_choose_tx:
			tabcityClickListener();
			break;
		case R.layout.pop_select_order_by:
			popOrderLayoutClick();
			break;
		case R.layout.pop_select_naerby:
			dismissNeayByPop();
			break;
		case R.id.tab_nearby:
			changeNearbyStatus();
			break;
		case R.id.tab_order:
			tabOrderClickListener();
			break;
		default:
			break;
		}
	}

	public interface OnFragmentInteractionListener {
		public void onFragmentInteraction(Uri uri);
	}

	private void tabcityClickListener() {
		if (popCityView != null && tabCity != null) {
			popCityView.setTag(tabCity.getTabName().toString());
			myCityPopup.showAsDropDown(ll_tabs);
			tabCity.changeTvDrawableUp();
		}

		// Intent intent = new Intent(context, ChooseCityActivity.class);
		// startActivityForResult(intent, CHANGE_CITY);
	}

	private void tabOrderClickListener() {
		if (myOrderByPopup != null) {
			myOrderByPopup.showAsDropDown(ll_tabs);
		}
		if (!tabOrderIsopen) {
			tabOrder.changeTvDrawableUp();
			tabOrderIsopen = true;
		} else {
			tabOrderIsopen = false;
			if (tabOrder != null) {
				tabOrder.changeTvDrawableDown();
			}
		}
		// 每次点击景区更新位置
		if (orderByAdapter != null) {
			orderByAdapter.setSelectPosition(clickedOrderPuplePosition);
		}

	}

	private void changeNearbyStatus() {
		if (myNearByPopup == null || nearbyList.size() == 0) {
			ToastUtil.show("还没有商圈数据");
			return;
		} else {
			if (mSubAdapter != null) {
				mSubAdapter.setSelectData(tabNearby.getTabName());
			}

			if (myNearByPopup.isShowing()) {
				myNearByPopup.dismiss();
				if (tabNearbyIsopen) {
					tabNearby.changeTvDrawableUp();
					tabNearbyIsopen = false;
				}
			} else {
				myNearByPopup.update();
				myNearByPopup.showAsDropDown(ll_tabs);
				if (nearbyList.size() != 0
						&& nearbyList.get(0).getCircleName().size() != 0) {
					// dlv_masterList.performItemClick(dlv_masterList, 0, 0);
				}

				if (!tabNearbyIsopen) {
					tabNearby.changeTvDrawableUp();
					tabNearbyIsopen = true;
				}
			}

		}

	}

	private HomeOrderAdapter homeOrderAdapter;
	private MyRefreshListView mrlv_order_list;
	private ArrayList<String> orderbyList;

	private OnPredeteListner onPredete;

	private View contentView;

	private NetworkLayout network;

	/**
	 * 实现实位回调监听
	 */
	public class MyLocationListener implements BDLocationListener {

		@Override
		public void onReceiveLocation(BDLocation location) {
			try {
				mLocationClient.unRegisterLocationListener(this);
				mLocationClient.stop();
			} catch (Exception e) {
				e.printStackTrace();
			}

			String locationStr = "";
			String province = location.getProvince();// 省
			String city = location.getCity();// 城市
			String district = location.getDistrict();// 区,县
			String street = location.getStreet();// 街道
			// float radius = location.getRadius();
			location.getAddrStr();
			if (city != null && city.contains("市")) {
				city = city.replaceAll("市", "");
				Constants.locationCity = city;
			} else {
				if (city == null) {
					city = "北京";
				}
			}

			// 经纬度
			Constants.latitude = location.getLatitude();
			Constants.longitude = location.getLongitude();
			if (!locationCity.equals(city)) {
				locationCity = city;
				tabCity.setTabName(city);
				ToastUtil.show("正在切换到定位城市" + city);
			} else {
				// ToastUtil.show("当前定位城市为" + city);
			}
		}

	}

	public void changeCity() {

	};

	private void initTextOrderByData() {
		orderbyList = new ArrayList<String>();
		orderbyList.add("智能排序");
		orderbyList.add("离我最近");
		orderbyList.add("人气最高");
		orderbyList.add("全网最低");

	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		switch (resultCode) {
		case CHANGE_CITY:
			String myCityName = data.getAction();
			if (tabCity.getTabName().endsWith(myCityName)) {
				return;
			} else {
				tabCity.setTabName(myCityName);
			}
			break;

		default:
			break;
		}
	}

	@Override
	public void setBind(boolean isBind) {
		// TODO Auto-generated method stub

	}

	@Override
	public void OnFragmentResume() {
		try {
			if (homeInfos != null && homeInfos.size() == 0) {
				requestHomeInfoNetwork(true);
			}
			if (!NetStatusUtil.isNetConnect()) {
				ToastUtil.show(R.string.connectfailtoast);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void OnFragmentChanged() {
		if (myCityPopup != null && myCityPopup.isShowing()) {
			myCityPopup.dismiss();
		}
		if (myNearByPopup != null && myNearByPopup.isShowing()) {
			myNearByPopup.dismiss();
		}
		if (myOrderByPopup != null && myOrderByPopup.isShowing()) {
			myOrderByPopup.dismiss();
		}
	}

	void setMainTabPosition(int position) {
		Intent intent = new Intent();
		intent.setAction(Constants.CHANGE_VIEWPAGERPOSITION);
		intent.putExtra("position", position);
		getActivity().sendBroadcast(intent);
	}

	@Override
	public void onNetworkChanged(INetworkStatus status) {

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {

	}
}
