package cn.com.ethank.yunge.app.demandsongs.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.RoomBaseActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.searchsong.SearchSongActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.searchsong.SingersOnlineAdapter;
import cn.com.ethank.yunge.app.demandsongs.beans.SingerTypeBean;
import cn.com.ethank.yunge.app.demandsongs.beans.SinglerOnLine;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestSinggerList;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.lidroid.xutils.bitmap.PauseOnScrollListener;

public class SinglerListActivity extends RoomBaseActivity implements OnClickListener {

	private MyRefreshListView mrlv_singers;
	private ListView lv_singers;
	private SingersOnlineAdapter singersOnlineAdapter;
	private List<SinglerOnLine> singlerList = new ArrayList<SinglerOnLine>();
	private RequestSinggerList requestSinggerList;
	private SingerTypeBean singerTypeBean;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_singler_list);
		BaseApplication.getInstance().cacheActivityList.add(this);

		initView();
		getDataByPage();
		setListen();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void setListen() {
		mrlv_singers.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				try {
					getDataByPage();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {

			}
		});

	}

	private void initView() {
		title.showBtnFunction();
		title.setOnBtnFunctionClickAction(this);
		Bundle bundle = getIntent().getExtras();
		getIntent().getAction();
		if (bundle.containsKey("singerTypeBean")) {
			singerTypeBean = (SingerTypeBean) bundle.getSerializable("singerTypeBean");
			if (singerTypeBean == null) {
				// 纠错,默认显示全部歌星
				singerTypeBean = new SingerTypeBean();
				singerTypeBean.setSingerTypeName("全部歌星");
				singerTypeBean.setSingerTypeId(0);
			}
			title.setTitle(singerTypeBean.getSingerTypeName());
			title.setBtnBackText("歌星");
		}
		mrlv_singers = (MyRefreshListView) findViewById(R.id.mrlv_singers);
		mrlv_singers.setPullToRefreshOverScrollEnabled(false);
		mrlv_singers.setPullToRefreshEnabled(false);
		mrlv_singers.setMode(Mode.PULL_UP_TO_REFRESH);

		lv_singers = mrlv_singers.getRefreshableView();
		// 设置滑动时不加载图片
		lv_singers.setOnScrollListener(new PauseOnScrollListener(BaseApplication.bitmapUtils, false, true));
		singersOnlineAdapter = new SingersOnlineAdapter(context, singlerList);
		lv_singers.setAdapter(singersOnlineAdapter);
	}

	private void getDataByPage() {
		// pageNum 第几页 number 从0开始
		// perPage 每页多少 number 可为null，默认50
		// token
		// type 歌手分类 string
		// userID
		HashMap<String, String> hashMap = new HashMap<String, String>();
		String url = "";
		if (singerTypeBean.getSingerTypeId() == 0) {

			url = Constants.REQUEST_SINGER_URL;
			hashMap.put("startIndex", singlerList.size() + "");
			hashMap.put("token", Constants.getToken());
		} else {
			url = Constants.REQUEST_SINGER_BY_TYPE_URL;
			hashMap.put("startIndex", singlerList.size() + "");
			hashMap.put("token", Constants.getToken());
			hashMap.put("type", singerTypeBean.getSingerTypeId() + "");
		}

		requestSinggerList = new RequestSinggerList(context, hashMap, url);
		requestSinggerList.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					if (map != null && map.containsKey("data")) {
						List<SinglerOnLine> mySinglerList = (List<SinglerOnLine>) map.get("data");

						singlerList.addAll(mySinglerList);
						singersOnlineAdapter.setList(singlerList);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (mrlv_singers != null) {
					mrlv_singers.onRefreshComplete();
				}

			}

			@Override
			public void onLoaderFail() {
				if (mrlv_singers != null) {
					mrlv_singers.onRefreshComplete();
				}
			}
		});
	}

	protected void clearList() {
		singlerList.clear();
		singersOnlineAdapter.setList(singlerList);
	}

	@Override
	public void onClick(View view) {

		switch (view.getId()) {
		case R.id.title_function:
			Intent intent = new Intent(this, SearchSongActivity.class);
			intent.setAction(Constants.SINGER_ACTION);
			startActivity(intent);
			break;

		default:
			super.onClick(view);
			break;
		}

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
