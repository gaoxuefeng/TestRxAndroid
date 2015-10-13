package cn.com.ethank.yunge.app.homepager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.homepager.adapter.AcyivityByTypeListAdapter;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.homepager.bean.ActivityTypeBean;
import cn.com.ethank.yunge.app.homepager.request.RequestActivityByType;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.lidroid.xutils.bitmap.PauseOnScrollListener;

public class HomePagerByTypeActivity extends BaseTitleActivity {
	private ArrayList<ActivityBean> activityByTypeList = new ArrayList<ActivityBean>();
	private ListView lv_activity_type;
	private AcyivityByTypeListAdapter acyivityByTypeListAdapter;
	private MyRefreshListView mrlv_activity_type;
	private RequestActivityByType requestActivityByType;
	private ActivityTypeBean activityTypeBean;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home_pager_by_type);
		initTitle();
		initView();
		initActivityData(true);
	}

	private void initActivityData(final boolean isFirst) {
		if (isFirst) {
			clearActivityList();
		}
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("startIndex", activityByTypeList.size() + "");
		hashMap.put("cityName", Constants.locationCity + "");
		hashMap.put("activityType", activityTypeBean.getActivityType() + "");
		requestActivityByType = new RequestActivityByType(context, hashMap, activityTypeBean.getRequestUrl());
		requestActivityByType.start(new RequestCallBack() {

			@SuppressWarnings("unchecked")
			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					if (map != null && map.containsKey("data") && map.get("data") != null) {
						if (isFirst) {
							clearActivityList();
						}
						List<ActivityBean> activityBeans = (List<ActivityBean>) map.get("data");
						activityByTypeList.addAll(activityBeans);
						acyivityByTypeListAdapter.setList(activityByTypeList);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (mrlv_activity_type != null) {
					mrlv_activity_type.onRefreshComplete();
				}
			}

			@Override
			public void onLoaderFail() {
				if (mrlv_activity_type != null) {
					mrlv_activity_type.onRefreshComplete();
				}

			}
		});
	}

	private void clearActivityList() {
		activityByTypeList.clear();
		acyivityByTypeListAdapter.setList(activityByTypeList);

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initView() {
		mrlv_activity_type = (MyRefreshListView) findViewById(R.id.mrlv_activity_type);
		mrlv_activity_type.setMode(Mode.PULL_FROM_END);
		mrlv_activity_type.setPullToRefreshOverScrollEnabled(false);
		lv_activity_type = mrlv_activity_type.getRefreshableView();
		lv_activity_type.setOnScrollListener(new PauseOnScrollListener(BaseApplication.bitmapUtils, false, true));
		acyivityByTypeListAdapter = new AcyivityByTypeListAdapter(context, activityByTypeList, new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				// TODO Auto-generated method stub
				boolean isToLogin = (Boolean) result;
				if (isToLogin) {
					Intent intent = new Intent(HomePagerByTypeActivity.this, LoginActivity.class);
					startActivityForResult(intent, 1);
				}
			}
		});
		lv_activity_type.setAdapter(acyivityByTypeListAdapter);
		mrlv_activity_type.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				mrlv_activity_type.onRefreshComplete();
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				initActivityData(false);
			}
		});
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (Constants.getLoginState()) {
			Intent intent = new Intent(HomePagerByTypeActivity.this, ActivityWebWithTitleActivity.class);
			intent.putExtra("activityBean", Constants.activityBeanitem);
			startActivity(intent);
		}
	}

	private void initTitle() {
		title.showBtnFunction(false);
		title.showBottomLine(false);
		Bundle bundle = getIntent().getExtras();
		if (bundle != null && bundle.containsKey("activityTypeBean")) {
			activityTypeBean = (ActivityTypeBean) bundle.getSerializable("activityTypeBean");
		} else {
			activityTypeBean = new ActivityTypeBean();
		}
		title.setTitle(activityTypeBean.getName());

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}
}
