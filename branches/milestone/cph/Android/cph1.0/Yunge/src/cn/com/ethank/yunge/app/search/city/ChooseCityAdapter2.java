package cn.com.ethank.yunge.app.search.city;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.SectionIndexer;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.requestNetWork.MyAddressPopWindower;
import cn.com.ethank.yunge.app.search.city.PinnedHeaderListView.PinnedHeaderAdapter;


public class ChooseCityAdapter2 extends BaseAdapter implements SectionIndexer, PinnedHeaderAdapter, OnScrollListener {
	private int mLocationPosition = -1;
	private LayoutInflater inflater;
	private ArrayList<Object> dataList;
	private LinkedHashMap<String, Integer> positionMap = new LinkedHashMap<String, Integer>();
	private Integer[] positionArray;
	private Context context;
	private View popView;
	private MyAddressPopWindower myAddressPopWindower;

	public ChooseCityAdapter2(Context context, View popView, MyAddressPopWindower myAddressPopWindower) {

		this.context = context;
		this.popView = popView;
		this.myAddressPopWindower = myAddressPopWindower;

		initData();
		inflater = LayoutInflater.from(context);
		positionArray = new Integer[positionMap.size()];
		positionMap.values().toArray(positionArray);
	}

	private void initData() {
		ArrayList<CityListitem> cityListitems = CityDataNew.getCitys();
		dataList = new ArrayList<Object>();
		dataList.add(cityListitems.get(0));
		for (int i = 1; i < cityListitems.size(); i++) {
			positionMap.put(cityListitems.get(i).getCityTitle(), dataList.size());
			dataList.addAll(cityListitems.get(i).getCityStingList());
		}
	}

	@Override
	public int getCount() {
		return dataList.size();
	}

	@Override
	public Object getItem(int position) {
		return dataList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@SuppressLint("InflateParams")
	@Override
	public View getView(int position, View view, ViewGroup parent) {
		if (view == null) {
			view = inflater.inflate(R.layout.city_item, null);
		}
		final LinearLayout hotCityContainer = (LinearLayout) view.findViewById(R.id.city_hot_city_container);
		final LinearLayout hot_city_cheat_view_container = (LinearLayout) view.findViewById(R.id.hot_city_cheat_view_container);
		final TextView header = (TextView) view.findViewById(R.id.header);
		final TextView name = (TextView) view.findViewById(R.id.city_name);
		if (position == 0) {
			name.setVisibility(View.GONE);
			hotCityContainer.setVisibility(View.VISIBLE);
			if (hot_city_cheat_view_container.getChildCount() != 0) {
				getViewChild(hot_city_cheat_view_container);

			}

		} else {
			CityBean cityBean = (CityBean) dataList.get(position);
			name.setVisibility(View.VISIBLE);
			hotCityContainer.setVisibility(View.GONE);
			name.setText(cityBean.getCityName());
		}
		if (positionMap.containsValue(position) || position == 0) {
			header.setVisibility(View.VISIBLE);
			if (position == 0) {
				CityListitem cityListitem = (CityListitem) dataList.get(0);
				header.setText(cityListitem.getCityTitle());
			} else {
				CityBean cityBean = (CityBean) dataList.get(position);
				header.setText(cityBean.getCityTitle());
			}

		} else {
			header.setVisibility(View.GONE);
		}

		return view;
	}

	@Override
	public void onScrollStateChanged(AbsListView view, int scrollState) {

	}

	@Override
	public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
		if (view instanceof PinnedHeaderListView) {
			// 设置顶部的显示
			((PinnedHeaderListView) view).configureHeaderView(firstVisibleItem);
		}
	}

	@Override
	public int getPinnedHeaderState(int firstPosition) {
		// 传进来的position是第一个position
		int realPosition = firstPosition;
		if (realPosition < 0 || (mLocationPosition != -1 && mLocationPosition == realPosition)) {
			return PINNED_HEADER_GONE;// 消失
		}
		mLocationPosition = -1;
		int section = getSectionForPosition(realPosition);// 获取到这个item首字母是哪个position
		int nextSectionPosition = getPositionForSection(section + 1);// 下一个要选择的首字母位置
		if (nextSectionPosition != -1 && realPosition == nextSectionPosition - 1) {
			return PINNED_HEADER_PUSHED_UP;// 推上去
		}
		return PINNED_HEADER_VISIBLE;// 显示
	}

	@Override
	public void configurePinnedHeader(View header, int firstPosition, int alpha) {
		// 根据第一个位置选择首字母
		int realPosition = firstPosition;
		String title;
		if (realPosition != 0) {
			title = ((CityBean) dataList.get(realPosition)).getCityTitle();
		} else {
			title = ((CityListitem) dataList.get(0)).getCityTitle();
		}

		try {
			((TextView) header.findViewById(R.id.header)).setText(title);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public Object[] getSections() {
		return positionMap.values().toArray();
	}

	@Override
	public int getPositionForSection(int section) {
		if (section < 0 || section >= positionMap.size()) {
			return -1;
		}

		return positionArray[section];
	}

	@Override
	public int getSectionForPosition(int position) {
		if (position < 0 || position >= getCount()) {
			return -1;
		}
		int index = Arrays.binarySearch(positionArray, position);
		return index >= 0 ? index : -index - 2;
	}

	void getViewChild(View view) {
		if (view instanceof ViewGroup) {
			for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
				View con_view = ((ViewGroup) view).getChildAt(i);
				if (con_view instanceof HotCityRow) {
					Log.i("", "");
					getViewChildTextView(con_view);
				} else if (con_view instanceof TextView) {
					Log.i("", "");
				} else {
					getViewChild(con_view);
				}

			}
		}

	}

	// 这儿的textView是需要点击的
	void getViewChildTextView(View view) {
		if (view instanceof ViewGroup) {
			for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
				View con_view = ((ViewGroup) view).getChildAt(i);
				if (con_view instanceof HotCityRow) {
					Log.i("", "");
				} else if (con_view instanceof TextView) {
					Log.i("", "");
					final String cityName = ((TextView) con_view).getText().toString();
					if (cityName != null && !cityName.isEmpty()) {
						if (context instanceof Activity) {
							con_view.setOnClickListener(new OnClickListener() {

								@Override
								public void onClick(View v) {
									popView.setTag(cityName);
									myAddressPopWindower.dismiss();
								}
							});

						}
						// getRunningActivityName();
					}
				} else {
					getViewChildTextView(con_view);
				}

			}
		}

	}

}
