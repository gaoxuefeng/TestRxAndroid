package cn.com.ethank.yunge.app.demandsongs.childfragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.DemandSongOnlineAdapter;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestDemandedHistory;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class HistorySongFragment extends Fragment {

	private Context context;
	private ListView lv_history_songs;
	private List<SongOnline> musicBeanArrayList = new ArrayList<SongOnline>();
	private DemandSongOnlineAdapter songsAdapter;
	private MyRefreshListView mrlv_history_songs;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		context = getActivity();
		View view = inflater.inflate(R.layout.fragment_histiry_song, container, false);
		initView(view);
		initData(view);
		getNetData();
		return view;
	}

	private void initData(View view) {
		songsAdapter = new DemandSongOnlineAdapter(getActivity(), musicBeanArrayList, new BaseTitleActivity.DemandClickCallBack() {
			@Override
			public void onClickListener(View view, int position, Object viewHolder) {

			}
		});
		lv_history_songs.setAdapter(songsAdapter);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initView(View view) {
		mrlv_history_songs = (MyRefreshListView) view.findViewById(R.id.mrlv_history_songs);
		mrlv_history_songs.setMode(com.handmark.pulltorefresh.library.PullToRefreshBase.Mode.PULL_FROM_START);
		lv_history_songs = mrlv_history_songs.getRefreshableView();
		mrlv_history_songs.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				// 下拉刷新

				getNetData();
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				getNetData();

			}
		});
	}

	protected void clearSongList() {
		musicBeanArrayList.clear();
		songsAdapter.setList(musicBeanArrayList);

	}

	private void getNetData() {
		try {

			String token = Constants.getToken();
			String reserveBoxId = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.reserveBoxId);
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("startIndex", "0");
			hashMap.put("token", token);
			// hashMap.put(key, value);
			RequestDemandedHistory requestDemandedSongHistory = new RequestDemandedHistory(context, hashMap);
			requestDemandedSongHistory.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					//
					try {
						if (map != null && map.containsKey("data")) {
							@SuppressWarnings("unchecked")
							List<SongOnline> mySongList = (List<SongOnline>) map.get("data");
							if (mySongList != null) {
								// 已经是最后一页
								mrlv_history_songs.refreshComplete();
								musicBeanArrayList = mySongList;
								songsAdapter.setList(musicBeanArrayList);
							}

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					mrlv_history_songs.refreshComplete();
				}

				@Override
				public void onLoaderFail() {
					mrlv_history_songs.refreshComplete();
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
