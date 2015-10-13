package cn.com.ethank.yunge.app.homepager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.graphics.Color;
import android.os.Bundle;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class HomePagerByTypeActivity extends BaseTitleActivity {
	private String type = "";
	private ArrayList<ActivityBean> activityByTypeList = new ArrayList<ActivityBean>();
	private ListView lv_activity_type;
	private AcyivityByTypeListAdapter acyivityByTypeListAdapter;
	private MyRefreshListView mrlv_activity_type;
	private RequestActivityByType requestActivityByType;

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
		if (type != null && type.equals("精品活动")) {
			hashMap.put("activityType", "2");
		} else if (type != null && type.equals("热门活动")) {
			hashMap.put("activityType", "1");
		} else {
			hashMap.put("activityType", "0");
		}
		hashMap.put("startIndex", activityByTypeList.size() + "");

		requestActivityByType = new RequestActivityByType(context, hashMap);
		requestActivityByType.start(new RequestCallBack() {

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
				mrlv_activity_type.refreshComplete();
			}

			@Override
			public void onLoaderFail() {
				mrlv_activity_type.refreshComplete();
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
		acyivityByTypeListAdapter = new AcyivityByTypeListAdapter(context, activityByTypeList);
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

	private void initTitle() {
		title.setBackgroundColor(Color.parseColor("#211C36"));
		title.showBtnFunction(false);
		title.showBottomLine(false);
		Bundle bundle = getIntent().getExtras();
		if (bundle != null && bundle.containsKey("type")) {
			type = bundle.getString("type");
		} else {
			type = "全国活动";
		}
		title.setTitle(type.toString());

	}
}
