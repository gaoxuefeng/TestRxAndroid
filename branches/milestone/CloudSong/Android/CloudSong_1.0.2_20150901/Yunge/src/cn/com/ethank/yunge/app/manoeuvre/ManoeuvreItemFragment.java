package cn.com.ethank.yunge.app.manoeuvre;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.homepager.ActivityWebWithTitleActivity;
import cn.com.ethank.yunge.app.homepager.adapter.AcyivityByTypeListAdapter;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.manoeuvre.request.RequestActivityByTag;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseFragment;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.lidroid.xutils.bitmap.PauseOnScrollListener;

public class ManoeuvreItemFragment extends BaseFragment {

	private View layout;
	private static String city = "";
	private String tag = "";
	private MyRefreshListView mrlv_activity_view_pager;
	private ListView lv_activity_view_pager;
	private List<ActivityBean> activityBeans = new ArrayList<ActivityBean>();
	private AcyivityByTypeListAdapter acyivityByTypeListAdapter;
	HashMap<String, List<ActivityBean>> hashMapData = new HashMap<String, List<ActivityBean>>();

	public ManoeuvreItemFragment() {
		if (city == null) {
			city = "";
		}
		if (tag == null) {
			tag = "";
		}
	}

	public ManoeuvreItemFragment(String city, String tag) {
		if (city != null) {
			ManoeuvreItemFragment.city = city;
		} else {
			ManoeuvreItemFragment.city = "";
		}
		if (tag != null) {
			this.tag = tag;
		} else {
			this.tag = "";
		}

	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		if (layout == null) {
			layout = inflater.inflate(R.layout.item_activity_view_pager, null);
			mrlv_activity_view_pager = (MyRefreshListView) layout.findViewById(R.id.mrlv_activity_view_pager);
			mrlv_activity_view_pager.setMode(Mode.BOTH);
			lv_activity_view_pager = mrlv_activity_view_pager.getRefreshableView();
			lv_activity_view_pager.setOnScrollListener(new PauseOnScrollListener(BaseApplication.bitmapUtils, false, true));
			acyivityByTypeListAdapter = new AcyivityByTypeListAdapter(getActivity(), activityBeans, new RefreshUiInterface() {

				@Override
				public void refreshUi(Object result) {
					// TODO Auto-generated method stub
					boolean isToLogin = (Boolean) result;
					if (isToLogin) {
						Intent intent = new Intent(getActivity(), LoginActivity.class);
						startActivityForResult(intent, 1);
					}
				}
			});
			lv_activity_view_pager.setAdapter(acyivityByTypeListAdapter);
		}

		mrlv_activity_view_pager.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				requestData(activityBeans, acyivityByTypeListAdapter, city, tag, true, mrlv_activity_view_pager);
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				requestData(activityBeans, acyivityByTypeListAdapter, city, tag, false, mrlv_activity_view_pager);
			}
		});
		if (layout.getTag() != null && layout.getTag().equals(city + tag)) {
			// 城市tag都没变
			acyivityByTypeListAdapter.notifyDataSetChanged();
		} else if (layout.getTag() != null && !layout.getTag().equals(city + tag)) {
			// tag或城市变了
			activityBeans.clear();
			if (hashMapData.containsKey(city + tag)) {
				activityBeans = hashMapData.get(city + tag);
			}
		} else {
			// 新建的
		}
		// 如果没有数据重新获取
		if (activityBeans.size() == 0) {
			requestData(activityBeans, acyivityByTypeListAdapter, city, tag, true, mrlv_activity_view_pager);
		} else {
			acyivityByTypeListAdapter.notifyDataSetChanged();
		}

		return layout;
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (Constants.getLoginState()) {
			Intent intent = new Intent(getActivity(), ActivityWebWithTitleActivity.class);
			intent.putExtra("activityBean", Constants.activityBeanitem);
			startActivity(intent);
		}
	}

	@Override
	public void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
	}

	@Override
	public void setBind(boolean isBind) {

	}

	@Override
	public void OnFragmentChanged() {

	}

	@Override
	public void OnFragmentResume() {

	}

	public void OnFragmentResume(String city, String tag) {
		try {
			if (layout != null) {
				layout.setTag(ManoeuvreItemFragment.city + this.tag);
			}

			if (city != null) {
				ManoeuvreItemFragment.city = city;
			} else {
				ManoeuvreItemFragment.city = "";
			}
			if (tag != null) {
				this.tag = tag;
			} else {
				this.tag = "";
			}
			clearActivityList();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void requestData(final List<ActivityBean> activityBeans, final AcyivityByTypeListAdapter acyivityByTypeListAdapter, final String city, final String tag, final boolean isFirstRequest,
			final MyRefreshListView mrlv_activity_view_pager) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		if (!city.equals("全国") && !city.isEmpty()) {
			hashMap.put("cityName", city);
		}
		if (!tag.equals("全部") && !tag.isEmpty()) {
			hashMap.put("tag", tag);
		}
		if (isFirstRequest) {
			hashMap.put("startIndex", 0 + "");
		} else {
			hashMap.put("startIndex", activityBeans.size() + "");
		}

		RequestActivityByTag requestActivityByTag = new RequestActivityByTag(getActivity(), hashMap);
		requestActivityByTag.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				if (!city.equals(ManoeuvreItemFragment.city)) {
					return;
				}
				if (map != null && map.containsKey("data") && map.get("data") != null) {
					@SuppressWarnings("unchecked")
					List<ActivityBean> beans = (List<ActivityBean>) map.get("data");
					if (isFirstRequest) {
						clearActivityList();

					}
					activityBeans.addAll(beans);
					hashMapData.put((city + tag), activityBeans);
					acyivityByTypeListAdapter.setList(activityBeans);

				}

				mrlv_activity_view_pager.onRefreshComplete();
			}

			@Override
			public void onLoaderFail() {
				if (mrlv_activity_view_pager != null)
					mrlv_activity_view_pager.onRefreshComplete();
			}
		});
		acyivityByTypeListAdapter.setList(activityBeans);

	}

	private void clearActivityList() {
		activityBeans.clear();
		acyivityByTypeListAdapter.setList(activityBeans);
	}
}
