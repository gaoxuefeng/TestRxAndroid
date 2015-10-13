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
import cn.com.ethank.yunge.pad.adapter.DemandedSongAdapter;
import cn.com.ethank.yunge.pad.adapter.DemandedSongAdapter.OnTopOnclickListner;
import cn.com.ethank.yunge.pad.bean.SongOnlineDemanded;
import cn.com.ethank.yunge.pad.requsetnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.pad.requsetnetwork.RequestDemandedSongTask;
import cn.com.ethank.yunge.pad.utils.SharePreferencesUtil;
import cn.com.ethank.yunge.pad.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

/**
 * 已点歌曲
 * 
 * @author Gao Xuefeng
 * 
 */
public class DemandedFragment extends Fragment {
	private static final String ARG_PARAM1 = "param1";
	private static final String ARG_PARAM2 = "param2";
	private String tag = "DemandedFragment";

	// TODO: Rename and change types of parameters
	private String mParam1;
	private String mParam2;
	private MyRefreshListView mrlv_demanded_songs;
	private ListView lv_demanded_songs;
	private Context context;
	private ArrayList<SongOnlineDemanded> musicBeanArrayList = new ArrayList<SongOnlineDemanded>();
	private DemandedSongAdapter songsAdapter;

	public static DemandedFragment newInstance(String param1, String param2) {
		DemandedFragment fragment = new DemandedFragment();
		Bundle args = new Bundle();
		args.putString(ARG_PARAM1, param1);
		args.putString(ARG_PARAM2, param2);
		fragment.setArguments(args);
		return fragment;
	}

	public DemandedFragment() {
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
		View view = inflater.inflate(R.layout.fragment_demanded, container, false);
		initView(view);
		initData(view);
		getNetData(true);

		return view;
	}

	private void getNetData(final boolean isFirstRequest) {
		try {
			if (isFirstRequest) {
				clearSongList();
			}

			String token = SharePreferencesUtil.getStringData("token");
			String roomNum = SharePreferencesUtil.getStringData("roomNum");
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("action", "0");// 已点歌曲
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
								mrlv_demanded_songs.refreshComplete();
							} else {
								if (isFirstRequest) {
									clearSongList();
								}
								musicBeanArrayList.addAll(mySongList);
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
		songsAdapter = new DemandedSongAdapter(context, musicBeanArrayList);

		lv_demanded_songs.setAdapter(songsAdapter);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initView(View view) {
		mrlv_demanded_songs = (MyRefreshListView) view.findViewById(R.id.mrlv_demanded_songs);
		lv_demanded_songs = mrlv_demanded_songs.getRefreshableView();
		mrlv_demanded_songs.setPullToRefreshOverScrollEnabled(false);
		mrlv_demanded_songs.setMode(Mode.BOTH);

		mrlv_demanded_songs.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				// 下拉刷新
				clearSongList();
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

	/**
	 * 刷新数据
	 */
	public void OnRefresh() {
		getNetData(true);

	}

}
