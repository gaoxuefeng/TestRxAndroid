package cn.com.ethank.yunge.app.manoeuvre;

/**
 * 活动
 */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.homepager.ActivityWebWithTitleActivity;
import cn.com.ethank.yunge.app.homepager.adapter.AcyivityByTypeListAdapter;
import cn.com.ethank.yunge.app.manoeuvre.bean.TagsBean;
import cn.com.ethank.yunge.app.manoeuvre.request.RequestActivityCitys;
import cn.com.ethank.yunge.app.manoeuvre.request.RequestActivityTags;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.startup.BaseFragment;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.NetworkLayout;

import com.coyotelib.app.ui.widget.BasicTitle;
import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.network.OnNetworkChangedListener;
import com.viewpagerindicator.TabPageIndicator;

public class ManoeuvreFragment extends BaseFragment implements OnClickListener, OnNetworkChangedListener {
	private View view;
	private List<TagsBean> typeList = new ArrayList<TagsBean>();
	private List<String> cityList = new ArrayList<String>();
	private ViewPager vp_activity_type;
	private ActivityViewPagerAdapter activityViewPagerAdapter;
	private BasicTitle bt_title;
	private RequestActivityTags requestActivityTags;
	private View pop_select_city;
	private GridView gv_city_select;
	private PopupWindow myCityPopup;
	private CityListAdapter cityListAdapter;
	private View v_top_line;
	private TabPageIndicator tpi_indicator;
	private OnUpdaterManoeuvreListner onUpdaterManoeuvreListner;
	private NetworkLayout network_manoeu;
	private LinearLayout ll_normal;
	public static boolean isConnectNetManoueyvre = true;

	@SuppressLint("InflateParams")
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

		view = inflater.inflate(R.layout.fragment_manoeuvre, null, false);
		initView();
		initTitle();
		initTitleData("全国");// 默认是全国
		initCityPopView();
		// initCityPopData();
		network_manoeu = (NetworkLayout) view.findViewById(R.id.network_manoeu);

		if (NetStatusUtil.isNetConnect()) {
			network_manoeu.setVisibility(View.GONE);
			ll_normal.setVisibility(View.VISIBLE);
			// initTitleData("全国");// 默认是全国
			// initCityPopView();
			initCityPopData();
			isConnectNetManoueyvre = true;
		} else {
			network_manoeu.setVisibility(View.VISIBLE);
			ll_normal.setVisibility(View.GONE);
			// view = inflater.inflate(R.layout.activity_net, null, false);
			initNetView(network_manoeu);
			isConnectNetManoueyvre = false;
		}

		return view;
	}

	private void initNetView(View view2) {
		TextView tv_refresh = (TextView) view2.findViewById(R.id.tv_refresh);
		tv_refresh.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// ToastUtil.show("点击刷新");
				onUpdaterManoeuvreListner.OnUpdateManoeuvre();
			}
		});
	}

	public interface OnUpdaterManoeuvreListner {
		void OnUpdateManoeuvre();
	}

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		onUpdaterManoeuvreListner = (OnUpdaterManoeuvreListner) activity;
	}

	@SuppressLint("InflateParams")
	private void initCityPopView() {
		pop_select_city = LayoutInflater.from(getActivity()).inflate(R.layout.pop_select_city, null);
		gv_city_select = (GridView) pop_select_city.findViewById(R.id.gv_city_select);
		myCityPopup = new PopupWindow(pop_select_city, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, true);
		myCityPopup.setOutsideTouchable(true);
		myCityPopup.setBackgroundDrawable(new ColorDrawable(0x00000000));
		myCityPopup.setWidth(LayoutParams.MATCH_PARENT);
		myCityPopup.setHeight(android.app.ActionBar.LayoutParams.MATCH_PARENT);
		cityListAdapter = new CityListAdapter(getActivity(), cityList);
		gv_city_select.setAdapter(cityListAdapter);
		myCityPopup.setOnDismissListener(new OnDismissListener() {

			@Override
			public void onDismiss() {
				bt_title.mBtnBack.mTvView.getBackground().setLevel(0);
			}
		});
		gv_city_select.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				if (!bt_title.mBtnBack.mTvView.getText().equals(cityList.get(position))) {
					bt_title.setBtnBackText(cityList.get(position));
					// 请求tag和初始化ViewPager
					initTitleData(cityList.get(position));// 请求Tag数据
				}
				myCityPopup.dismiss();
			}
		});
		pop_select_city.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				myCityPopup.dismiss();
			}
		});
	}

	private void initCityPopData() {

		RequestActivityCitys requestActivityCitys = new RequestActivityCitys(getActivity());
		requestActivityCitys.start(new RequestCallBack() {

			@SuppressWarnings("unchecked")
			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					if (map != null && map.containsKey("data") && map.get("data") != null) {
						cityList = (List<String>) map.get("data");
						if (!cityList.contains("全国")) {
							cityList.add(0, "全国");
						}
						cityListAdapter.setList(cityList);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			@Override
			public void onLoaderFail() {
				if (cityList.size() == 0) {
					cityList.add("全国");
					if (cityListAdapter != null) {
						cityListAdapter.setList(cityList);
					}

				}
			}
		});
	}

	private void initTitle() {
		bt_title.mBtnBack.mTvView.setBackgroundResource(R.drawable.activity_arrow_btn);
		bt_title.mBtnBack.mTvView.setPadding(0, 0, 30, 0);
		bt_title.mBtnBack.mTvView.setGravity(Gravity.CENTER_VERTICAL);

		bt_title.showBtnBack();
		bt_title.setBtnBackImage(0);
		bt_title.setTitle("潮趴汇活动");
		bt_title.setBtnBackTextColor("#FFFFFF");
		bt_title.setBtnBackText("全国");
		bt_title.setOnBtnBackClickAction(this);
		bt_title.setBackgroundColor(Color.parseColor("#241938"));
		bt_title.showBtnFunction(false);
		bt_title.setTitleColor(Color.parseColor("#FFFFFF"));
		bt_title.mBtnBack.mTvView.getBackground().setLevel(0);
		bt_title.setOnBtnBackClickAction(new OnClickListener() {

			@Override
			public void onClick(View view) {
				if (NetStatusUtil.isNetConnect()) {
					if (myCityPopup == null) {
						initCityPopData();
					}
					if (myCityPopup.isShowing()) {
						myCityPopup.dismiss();
					} else {
						myCityPopup.showAsDropDown(v_top_line);
						bt_title.mBtnBack.mTvView.getBackground().setLevel(1);
					}
				} else {
					if (myCityPopup != null && myCityPopup.isShowing()) {
						myCityPopup.dismiss();
					}
					ToastUtil.show("网络连接失败,请稍后尝试");
				}
			}
		});
	}

	private void initView() {
		network_manoeu = (NetworkLayout) view.findViewById(R.id.network_manoeu);
		ll_normal = (LinearLayout) view.findViewById(R.id.ll_normal);
		tpi_indicator = (TabPageIndicator) view.findViewById(R.id.tpi_indicator);
		v_top_line = view.findViewById(R.id.v_top_line);
		bt_title = (BasicTitle) view.findViewById(R.id.bt_title);
		vp_activity_type = (ViewPager) view.findViewById(R.id.vp_activity_type);

		vp_activity_type.setOnPageChangeListener(new OnPageChangeListener() {

			@Override
			public void onPageSelected(int position) {
				try {

					activityViewPagerAdapter.notifyItemDataSetChanged(position);

				} catch (Exception e) {
					e.printStackTrace();
				}

			}

			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {

			}

			@Override
			public void onPageScrollStateChanged(int arg0) {

			}
		});

		initViewPager("全国");

	}

	/**
	 * 创建VIewPager,并初始化ViewPager中的数据
	 * 
	 * @param currentCity
	 */
	private void initViewPager(String currentCity) {
		activityViewPagerAdapter = new ActivityViewPagerAdapter(getActivity(), typeList, currentCity, new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				boolean isToLogin = (Boolean) result;
				if (isToLogin) {
					Intent intent = new Intent(getActivity(), LoginActivity.class);
					startActivityForResult(intent, 1);
				}
			}
		});
		vp_activity_type.setAdapter(activityViewPagerAdapter);
		tpi_indicator.setViewPager(vp_activity_type);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == 1 && Constants.getLoginState()) {
			Intent intent = new Intent(getActivity(), ActivityWebWithTitleActivity.class);
			intent.putExtra("activityBean", Constants.activityBeanitem);
			startActivity(intent);
		}
	}

	/**
	 * 根据城市名获取tag
	 * 
	 * @param currentCity
	 */
	private void initTitleData(final String currentCity) {
		HashMap<String, String> hashMap = new HashMap<String, String>();

		if (!currentCity.equals("全国") && currentCity != null) {
			hashMap.put("cityName", currentCity);
		}

		requestActivityTags = new RequestActivityTags(getActivity(), hashMap);
		requestActivityTags.start(new RequestCallBack() {

			@SuppressWarnings("unchecked")
			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					if (map != null && map.containsKey("data") && map.get("data") != null) {
						List<TagsBean> tagsBeans = (List<TagsBean>) map.get("data");
						clearTypeList();
						typeList = tagsBeans;
						initViewPager(currentCity);
						tpi_indicator.setViewPager(vp_activity_type, 0);
						tpi_indicator.notifyDataSetChanged();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

			}

			@Override
			public void onLoaderFail() {
				// 没有标签数据
			}
		});

	}

	protected void clearTypeList() {
		typeList.clear();

	}

	@Override
	public void setBind(boolean isBind) {

	}

	@Override
	public void OnFragmentResume() {
		if (!NetStatusUtil.isNetConnect()) {
			ToastUtil.show(R.string.connectfailtoast);
		}
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.btn_back:
			// 选择城市

			break;
		case R.id.title_function:
			// 不操作
			break;
		default:
			break;
		}
	}

	@Override
	public void OnFragmentChanged() {
		try {
			if (cityList != null && cityList.size() <= 1) {
				initCityPopData();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void onNetworkChanged(INetworkStatus status) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}
}
