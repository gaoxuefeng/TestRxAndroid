package cn.com.ethank.yunge.pad.tabs.fragment;

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
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.adapter.HistorySongAdapter;
import cn.com.ethank.yunge.pad.bean.SongOnlineDemanded;
import cn.com.ethank.yunge.pad.requsetnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.pad.requsetnetwork.RequestDemandedSongTask;
import cn.com.ethank.yunge.pad.utils.SharePreferencesUtil;
import cn.com.ethank.yunge.pad.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;



public class HistorySongFragment extends Fragment {
	// TODO: Rename parameter arguments, choose names that match
	// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
	private static final String ARG_PARAM1 = "param1";
	private static final String ARG_PARAM2 = "param2";

	// TODO: Rename and change types of parameters
	private String mParam1;
	private String mParam2;
	private Context context;
	private ListView lv_history_songs;
	private ArrayList<SongOnlineDemanded> musicBeanArrayList = new ArrayList<SongOnlineDemanded>();
	private HistorySongAdapter songsAdapter;
	private MyRefreshListView mrlv_history_songs;

	public static HistorySongFragment newInstance(String param1, String param2) {
		HistorySongFragment fragment = new HistorySongFragment();
		Bundle args = new Bundle();
		args.putString(ARG_PARAM1, param1);
		args.putString(ARG_PARAM2, param2);
		fragment.setArguments(args);
		return fragment;
	}

	public HistorySongFragment() {
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (getArguments() != null) {
			mParam1 = getArguments().getString(ARG_PARAM1);
			mParam2 = getArguments().getString(ARG_PARAM2);
		}
	}

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
		// musicBeanArrayList = MusicList.getMusicData(context);
		songsAdapter = new HistorySongAdapter(context, musicBeanArrayList);
		lv_history_songs.setAdapter(songsAdapter);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initView(View view) {
		mrlv_history_songs = (MyRefreshListView) view.findViewById(R.id.mrlv_history_songs);
		lv_history_songs = mrlv_history_songs.getRefreshableView();
		mrlv_history_songs.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				// 下拉刷新
				clearSongList();
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
//			if (!Constants.isBinded()) {
//				ToastUtil.show("请先绑定包厢");
//				mrlv_history_songs.refreshComplete();
//				return;
//			}

//			String token = Constants.getToken();
			String token = SharePreferencesUtil.getStringData("token");
			String roomNum = SharePreferencesUtil.getStringData("roomNum");
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("action", "1");// 已唱歌曲
			hashMap.put("startIndex", musicBeanArrayList.size() + "");
			hashMap.put("roomNum", roomNum);
			hashMap.put("token", token);
			// hashMap.put(key, value);
			RequestDemandedSongTask requestDemandedSongTask = new RequestDemandedSongTask(context, hashMap);
			requestDemandedSongTask.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					//
					try {
						if (map != null && map.containsKey("data")) {
							@SuppressWarnings("unchecked")
							List<SongOnlineDemanded> mySongList = (List<SongOnlineDemanded>) map.get("data");
							if (mySongList.size() == 0) {
								// 已经是最后一页
								mrlv_history_songs.refreshComplete();
							} else {
								musicBeanArrayList.addAll(mySongList);
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
