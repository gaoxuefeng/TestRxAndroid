package cn.com.ethank.yunge.app.manoeuvre;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.homepager.adapter.AcyivityByTypeListAdapter;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.manoeuvre.bean.TagsBean;
import cn.com.ethank.yunge.app.manoeuvre.request.RequestActivityByTag;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class ActivityViewPagerAdapter extends PagerAdapter {

	private Context context;
	private List<TagsBean> typeList;
	private ArrayList<View> viewList = new ArrayList<View>();
	private String currentCity;
	RefreshUiInterface refreshUiInterface;

	public ActivityViewPagerAdapter(Context context, List<TagsBean> typeList, String currentCity, RefreshUiInterface refreshUiInterface) {
		this.context = context;
		this.typeList = typeList;
		this.currentCity = currentCity;
		this.refreshUiInterface = refreshUiInterface;
		initViewList();
	}

	public ActivityViewPagerAdapter(Context context, List<TagsBean> typeList) {
		this.context = context;
		this.typeList = typeList;
		this.currentCity = "全国";
		initViewList();
	}

	private void initViewList() {
		for (int i = 0; i < typeList.size(); i++) {
			View view = LayoutInflater.from(context).inflate(R.layout.item_activity_view_pager, null);
			viewList.add(view);
		}
	}

	@Override
	public CharSequence getPageTitle(int position) {
		if (typeList.size() > position && position > 0) {
			return typeList.get(position).getTagName();
		} else {
			return "全部";
		}

	}

	@Override
	public int getCount() {
		return viewList.size();
	}

	@Override
	public boolean isViewFromObject(View arg0, Object arg1) {
		return arg0 == arg1;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public Object instantiateItem(View container, final int position) {
		View view = viewList.get(position);

		final MyRefreshListView mrlv_activity_view_pager = (MyRefreshListView) view.findViewById(R.id.mrlv_activity_view_pager);
		mrlv_activity_view_pager.setMode(Mode.BOTH);
		ListView lv_activity_view_pager = mrlv_activity_view_pager.getRefreshableView();

		final ArrayList<ActivityBean> activityBeans = new ArrayList<ActivityBean>();
		final AcyivityByTypeListAdapter acyivityByTypeListAdapter = new AcyivityByTypeListAdapter(context, activityBeans, new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				// TODO Auto-generated method stub
				refreshUiInterface.refreshUi(result);
			}
		});
		lv_activity_view_pager.setAdapter(acyivityByTypeListAdapter);
		view.setTag(acyivityByTypeListAdapter);

		requestData(activityBeans, acyivityByTypeListAdapter, typeList.get(position), true, mrlv_activity_view_pager);
		mrlv_activity_view_pager.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				// 下拉刷新
				try {
					TagsBean tagBean;
					if (typeList.size() > position) {
						tagBean = typeList.get(position);
					} else {
						tagBean = new TagsBean();
					}
					requestData(activityBeans, acyivityByTypeListAdapter, tagBean, true, mrlv_activity_view_pager);
				} catch (Exception e) {
					e.printStackTrace();
				}

			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				requestData(activityBeans, acyivityByTypeListAdapter, typeList.get(position), false, mrlv_activity_view_pager);
			}
		});
		((ViewPager) container).addView(view);
		return view;
	}

	private void requestData(final List<ActivityBean> activityBeans, final AcyivityByTypeListAdapter acyivityByTypeListAdapter, TagsBean tagsBean, final boolean isFirstRequest,
			final MyRefreshListView mrlv_activity_view_pager) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		if (!currentCity.equals("全国") && !currentCity.isEmpty()) {
			hashMap.put("cityName", currentCity);
		}
		if (!tagsBean.getTagName().equals("全部")) {
			hashMap.put("tag", tagsBean.getTagName());
		}
		if (isFirstRequest) {
			hashMap.put("startIndex", 0 + "");
		} else {
			hashMap.put("startIndex", activityBeans.size() + "");
		}

		RequestActivityByTag requestActivityByTag = new RequestActivityByTag(context, hashMap);
		requestActivityByTag.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				if (map != null && map.containsKey("data") && map.get("data") != null) {
					List<ActivityBean> beans = (List<ActivityBean>) map.get("data");
					if (isFirstRequest) {
						activityBeans.clear();
						acyivityByTypeListAdapter.setList(activityBeans);

					}
					activityBeans.addAll(beans);
					acyivityByTypeListAdapter.setList(activityBeans);
				}
				mrlv_activity_view_pager.onRefreshComplete();
			}

			@Override
			public void onLoaderFail() {
				mrlv_activity_view_pager.onRefreshComplete();
			}
		});
		acyivityByTypeListAdapter.setList(activityBeans);
	}

	@Override
	public void destroyItem(ViewGroup container, int position, Object object) {
		((ViewPager) container).removeView(viewList.get(position));
	}

	public void notifyItemDataSetChanged(int position) {
		try {
			if (viewList.size() > position) {
				AcyivityByTypeListAdapter acyivityByTypeListAdapter = (AcyivityByTypeListAdapter) viewList.get(position).getTag();
				if (acyivityByTypeListAdapter != null) {
					acyivityByTypeListAdapter.notifyDataSetChanged();
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
