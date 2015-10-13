package cn.com.ethank.yunge.app.search.city;

import java.util.ArrayList;
import java.util.LinkedHashMap;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

import com.coyotelib.app.ui.indexlist.HeadAdapter;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.sys.CoyoteSystem;

public class ChooseCityAdapter extends HeadAdapter {

	private ArrayList<CityListitem> mList = CityDataNew.getCitys();
	private ArrayList dataList;
	private LinkedHashMap<String, Integer> positionMap=new LinkedHashMap<String, Integer>();;

	public void setData(ArrayList<CityListitem> list) {
		mList = list;
		dataList = new ArrayList<Object>();
		dataList.add(mList.get(0));
		for (int i = 1; i < mList.size(); i++) {
			positionMap.put(mList.get(i).getCityTitle(), dataList.size());
			dataList.addAll(mList.get(i).getCityStingList());
		}
	}

	@Override
	public int getCount() {
		if (mList == null)
			return 0;
		int res = 0;
		for (int i = 0; i < mList.size(); i++) {
			res += mList.get(i).getCurrentPos();
		}
		return res;
	}

	@Override
	public Object getItem(int position) {
		if (mList == null)
			return null;
		int c = 0;
		for (int i = 0; i < mList.size(); i++) {
			CityListitem cli = mList.get(i);
			if (!cli.isHot()) {
				int currcitySize = mList.get(i).getCityStingList().size();
				if (position >= c && position < c + currcitySize) {
					return mList.get(i).getCityStingList().get(position - c);
				}
				c += currcitySize;
			} else {
				if (position == 0) {
					return cli;
				}
				c += 1;
			}

		}
		return null;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public void setGpsCity(String str) {
	}

	@Override
	public View getAmazingView(int position, View convertView, ViewGroup parent) {

		final View view = (convertView != null) ? convertView : LayoutInflater.from(parent.getContext()).inflate(R.layout.city_item, parent, false);

		Object thisItem = getItem(position);
		final LinearLayout hotCityContainer = (LinearLayout) view.findViewById(R.id.city_hot_city_container);
		final TextView header = (TextView) view.findViewById(R.id.header);
		final TextView name = (TextView) view.findViewById(R.id.city_name);
		if (thisItem instanceof CityListitem) {
			name.setVisibility(View.GONE);
			hotCityContainer.setVisibility(View.VISIBLE);
		} else {
			CityBean cityBean = (CityBean) thisItem;
			if (cityBean != null) {
				name.setVisibility(View.VISIBLE);
				hotCityContainer.setVisibility(View.GONE);
				final Context context = CoyoteSystem.getCurrent().getAppContext();
				name.setText(cityBean.getCityName());
				name.setPadding(UICommonUtil.dip2px(context, 16), UICommonUtil.dip2px(context, 16), UICommonUtil.dip2px(context, 16), UICommonUtil.dip2px(context, 16));
				if (positionMap.containsValue(position)) {
					header.setVisibility(View.VISIBLE);
					header.setText(cityBean.getCityTitle());

				} else {
					header.setVisibility(View.GONE);
				}
			}
		}
		return view;
	}

	// 右侧的字母索引
	@Override
	public int getPositionForSection(int section) {
		if (mList == null)
			return 0;
		if (section < 0)
			section = 0;
		if (section >= mList.size())
			section = mList.size() - 1;
		int c = 0;
		for (int i = 0; i < mList.size(); i++) {
			if (section == i) {
				return c;
			}
			CityListitem cli = mList.get(i);
			if (cli.isHot()) {
				c += 1;
			} else {
				c += mList.get(i).getCityStingList().size();
			}
		}
		return 0;

	}

	@Override
	public int getSectionForPosition(int position) {
		if (mList == null)
			return -1;
		int c = 0;
		for (int i = 0; i < mList.size(); i++) {

			CityListitem cli = mList.get(i);
			if (!cli.isHot()) {
				int currsize = mList.get(i).getCityStingList().size();
				if (position >= c && position < c + currsize) {
					return i;
				}

				c += currsize;
			} else {
				return 0;
			}

		}
		return -1;
	}

	@Override
	public String[] getSections() {
		if (mList == null)
			return null;
		String[] res = new String[mList.size()];
		for (int i = 0; i < mList.size(); i++) {
			res[i] = mList.get(i).getCityTitle();
		}
		return res;

	}

	@Override
	public void onScrollStateChanged(AbsListView view, int scrollState) {

	}

	@Override
	protected void bindSectionHeader(View view, int position, boolean displaySectionHeader) {
//		TextView lSectionTitle = (TextView) view.findViewById(R.id.header);
//		if (displaySectionHeader) {
//			lSectionTitle.setVisibility(View.VISIBLE);
//			lSectionTitle.setText(getSections()[getSectionForPosition(position)]);
//			lSectionTitle.setBackgroundColor(Color.parseColor("#FFFFFF"));
//			lSectionTitle.setTextColor(Color.parseColor("#000000"));
//		} else {
//			lSectionTitle.setVisibility(View.GONE);
//		}

	}

	@Override
	protected void onNextPageRequested(int page) {

	}

	@Override
	public void configurePinnedHeader(View header, int position, int alpha) {
		TextView lSectionHeader = (TextView) header;
		lSectionHeader.setText(getSections()[getSectionForPosition(position)]);
		header.setVisibility(View.VISIBLE);
	}

}
