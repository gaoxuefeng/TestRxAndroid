package cn.com.ethank.yunge.app.manoeuvre;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
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
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.GridView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.BaseFragment;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.homepager.LandscapeTitleAdapter;
import cn.com.ethank.yunge.app.manoeuvre.bean.TagsBean;
import cn.com.ethank.yunge.app.manoeuvre.request.RequestActivityCitys;
import cn.com.ethank.yunge.app.manoeuvre.request.RequestActivityTags;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.HorizontalListView;

import com.coyotelib.app.ui.widget.BasicTitle;

public class ManoeuvreFragment extends BaseFragment implements OnClickListener {
	private View view;
	private HorizontalListView hlv_activity_tags;
	private List<TagsBean> typeList = new ArrayList<TagsBean>();
	private List<String> cityList = new ArrayList<String>();
	private LandscapeTitleAdapter landscapeTitleAdapter;
	private ViewPager vp_activity_type;
	private ActivityViewPagerAdapter activityViewPagerAdapter;
	private BasicTitle bt_title;
	private RequestActivityTags requestActivityTags;
	private View pop_select_city;
	private GridView gv_city_select;
	private PopupWindow myCityPopup;
	private CityListAdapter cityListAdapter;
	private View v_top_line;

	@SuppressLint("InflateParams")
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

		view = inflater.inflate(R.layout.fragment_manoeuvre, null, false);
		initView();
		initTitle();
		initTitleData("全国");// 默认是全国
		initCityPopView();
		initCityPopData();

		return view;
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
					cityListAdapter.setList(cityList);
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
		bt_title.setBackgroundColor(Color.parseColor("#211B34"));
		bt_title.showBtnFunction(false);
		bt_title.setTitleColor(Color.parseColor("#B5B7BF"));
		bt_title.mBtnBack.mTvView.getBackground().setLevel(0);
		bt_title.setOnBtnBackClickAction(new OnClickListener() {

			@Override
			public void onClick(View view) {
				if (myCityPopup == null) {
					initCityPopData();
				}
				if (myCityPopup.isShowing()) {
					myCityPopup.dismiss();
				} else {
					myCityPopup.showAsDropDown(v_top_line);
					bt_title.mBtnBack.mTvView.getBackground().setLevel(1);
				}

			}
		});
	}

	private void initView() {
		v_top_line = view.findViewById(R.id.v_top_line);
		hlv_activity_tags = (HorizontalListView) view.findViewById(R.id.hlv_activity_tags);
		bt_title = (BasicTitle) view.findViewById(R.id.bt_title);
		vp_activity_type = (ViewPager) view.findViewById(R.id.vp_activity_type);
		vp_activity_type.setOnPageChangeListener(new OnPageChangeListener() {

			@Override
			public void onPageSelected(int position) {
				try {
					if (landscapeTitleAdapter != null && landscapeTitleAdapter.getCount() > position) {
						landscapeTitleAdapter.setSelectPosition(position);
						hlv_activity_tags.setSelection(position);
						activityViewPagerAdapter.notifyItemDataSetChanged(position);
					}
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
		hlv_activity_tags.setOnItemSelectedListener(new OnItemSelectedListener() {

			@Override
			public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
				if (position < activityViewPagerAdapter.getCount()) {
					hlv_activity_tags.setSelection(position);
					vp_activity_type.setCurrentItem(position);
				}

			}

			@Override
			public void onNothingSelected(AdapterView<?> parent) {

			}
		});
		landscapeTitleAdapter = new LandscapeTitleAdapter(getActivity(), typeList);
		hlv_activity_tags.setAdapter(landscapeTitleAdapter);
		hlv_activity_tags.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				landscapeTitleAdapter.setSelectPosition(position);
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
		activityViewPagerAdapter = new ActivityViewPagerAdapter(getActivity(), typeList, currentCity);
		vp_activity_type.setAdapter(activityViewPagerAdapter);

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
						landscapeTitleAdapter.setList(typeList);
						initViewPager(currentCity);
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
		landscapeTitleAdapter.setList(typeList);

	}

	@Override
	public void setBind(boolean isBind) {

	}

	@Override
	public void OnFragmentResume() {
		if (!NetStatusUtil.isNetConnect()) {
			ToastUtil.show("当前网络出现异常,请稍后再试");
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
}
