package cn.com.ethank.yunge.app.demandsongs.childfragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.BaseFragment;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.DemandedSongAdapter;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnlineDemanded;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestDemandedSongTask;
import cn.com.ethank.yunge.app.jpush.YungeJPushType;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity.DemandClickCallBack;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

/**
 * 已点歌曲,不支持分页加载
 * 
 * @author Gao Xuefeng
 * 
 */
public class DemandedFragment extends BaseFragment {

	private MyRefreshListView mrlv_demanded_songs;
	private ListView lv_demanded_songs;
	private Context context;
	private List<SongOnlineDemanded> musicBeanArrayList = new ArrayList<SongOnlineDemanded>();
	private DemandedSongAdapter songsAdapter;
	private SongChangeReceive songChangeReceive;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		context = getActivity();
		View view = inflater.inflate(R.layout.fragment_demanded, container, false);
		initView(view);
		initData(view);
		getNetData(true);

		return view;
	}

	private void getNetData(final boolean isFirstRequest) {
		try {
			if (!Constants.isBinded()) {
				if (isVisible())
					// ToastUtil.show("请先绑定房间");
					mrlv_demanded_songs.refreshComplete();
				return;
			}

			String token = Constants.getToken();
			String reserveBoxId = Constants.getReserveBoxId();
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("action", "0");// 已点歌曲
			hashMap.put("startIndex", "0");
			hashMap.put("reserveBoxId", reserveBoxId);
			hashMap.put("token", token);
			RequestDemandedSongTask requestDemandedSongTask = new RequestDemandedSongTask(context, hashMap);
			requestDemandedSongTask.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					//
					try {
						if (map != null && map.containsKey("data")) {
							@SuppressWarnings("unchecked")
							List<SongOnlineDemanded> mySongList = (List<SongOnlineDemanded>) map.get("data");
							if (mySongList != null) {
								musicBeanArrayList = mySongList;
								songsAdapter.setList(musicBeanArrayList);
							}

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					mrlv_demanded_songs.refreshComplete();
				}

				@Override
				public void onLoaderFail() {
					mrlv_demanded_songs.refreshComplete();
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void initData(View view) {
		songsAdapter = new DemandedSongAdapter(getActivity(), musicBeanArrayList, new DemandClickCallBack() {

			@Override
			public void onClickListener(View view, int position, Object viewHolder) {

			}
		});
		lv_demanded_songs.setAdapter(songsAdapter);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initView(View view) {
		mrlv_demanded_songs = (MyRefreshListView) view.findViewById(R.id.mrlv_demanded_songs);
		lv_demanded_songs = mrlv_demanded_songs.getRefreshableView();
		mrlv_demanded_songs.setPullToRefreshOverScrollEnabled(false);
		mrlv_demanded_songs.setMode(Mode.PULL_FROM_START);

		mrlv_demanded_songs.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				// 下拉刷新
				getNetData(true);
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				getNetData(false);
			}
		});
	}

	protected void clearSongList() {
		musicBeanArrayList.clear();
		songsAdapter.setList(musicBeanArrayList);

	}

	@Override
	public void setBind(boolean isBind) {
		// TODO Auto-generated method stub

	}

	@Override
	public void OnFragmentResume() {
		// 切到这个页面
		// 刷新一次列表
		try {
			if (!Constants.isBinded()) {
				clearSongList();

			} else {
				getNetData(true);
			}
			// 注册接收广播
			registBroadCastReceive();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void OnFragmentChanged() {
		// 离开这个页面

	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		unRegistBroadCastReceive();
	}

	private void registBroadCastReceive() {
		try {

			songChangeReceive = new SongChangeReceive();
			IntentFilter filter = new IntentFilter();
			filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
			filter.addAction(YungeJPushType.getAction(YungeJPushType.changeSong));
			context.registerReceiver(songChangeReceive, filter);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void unRegistBroadCastReceive() {
		try {
			if (songChangeReceive != null) {
				context.unregisterReceiver(songChangeReceive);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	class SongChangeReceive extends BroadcastReceiver {

		@SuppressLint("NewApi")
		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			try {
				if (action.equals(YungeJPushType.getAction(YungeJPushType.changeSong)) && Constants.isBinded()) {
					getNetData(true);
					ToastUtil.show("自动刷新已点列表");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}
}
