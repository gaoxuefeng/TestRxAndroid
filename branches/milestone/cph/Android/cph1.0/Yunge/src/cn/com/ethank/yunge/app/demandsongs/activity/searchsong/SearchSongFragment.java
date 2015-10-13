package cn.com.ethank.yunge.app.demandsongs.activity.searchsong;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.DemandSongOnlineAdapter;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestSearchSongByKeyTask;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.view.MyRefreshListView;
import cn.com.ethank.yunge.view.MyRefreshListView.TouchLisTener;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;

public class SearchSongFragment extends Fragment implements View.OnClickListener, TouchLisTener {
	private MyRefreshListView mrlv_search_song;
	private ListView lv_search_song;
	List<SongOnline> songOnLines = new ArrayList<SongOnline>();
	private DemandSongOnlineAdapter demandSongOnlineAdapter;
	private Context context;
	private EditText et_search_song;
	protected String currentKeyWords;
	private RequestSearchSongByKeyTask requestSearchSongByKeyList;

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		et_search_song = (EditText) getActivity().findViewById(R.id.et_search_song);
		initData();
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.layout_search_song, container, false);
		context = getActivity();
		initView(view);

		return view;
	}

	private void initData() {
		et_search_song.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {

			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {

			}

			@Override
			public void afterTextChanged(Editable s) {
				currentKeyWords = s.toString().trim();
				clearSongList();
				requestSongData(true);
			}
		});

	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void initView(View view) {

		/*
		 * Mode.BOTH：同时支持上拉下拉 Mode.PULL_FROM_START：只支持下拉Pulling Down
		 * Mode.PULL_FROM_END：只支持上拉Pulling Up
		 */

		mrlv_search_song = (MyRefreshListView) view.findViewById(R.id.mrlv_search_song);
		mrlv_search_song.setTouchLisTener(this);
		lv_search_song = mrlv_search_song.getRefreshableView();
		demandSongOnlineAdapter = new DemandSongOnlineAdapter(getActivity(), songOnLines);
		lv_search_song.setAdapter(demandSongOnlineAdapter);
		mrlv_search_song.setPullToRefreshOverScrollEnabled(false);
		mrlv_search_song.setMode(Mode.PULL_FROM_END);
		mrlv_search_song.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener2() {

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				try {
					requestSongData(false);

				} catch (Exception e) {
					e.printStackTrace();
					refreshView.onRefreshComplete();
				}

			}

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				Log.i("", "OnRefreshListener2 onPullDownToRefresh");
				refreshView.onRefreshComplete();
			}
		});

	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		default:
			break;
		}
	}

	/**
	 * 切换fragment
	 */
	public void setFragmentRefresh() {
		hideInpter();
	}

	// 请求数据
	private void requestSongData(final boolean isFirst) {
		String newKeyWords = et_search_song.getText().toString().trim();
		// 上拉加载
		if (newKeyWords == null) {
			clearSongList();
			mrlv_search_song.onRefreshComplete();
			return;
		}
		currentKeyWords = newKeyWords;
		if (newKeyWords.length() > 0) {
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("keyWord", currentKeyWords);
			hashMap.put("startIndex", songOnLines.size() + "");

			String url = Constants.REQUEST_SONG_URL_BY_KEY;
			requestSearchSongByKeyList = new RequestSearchSongByKeyTask(context, hashMap, url);
			requestSearchSongByKeyList.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					try {
						String newKeyWords = et_search_song.getText().toString().trim();
						if (!newKeyWords.equals(currentKeyWords)||newKeyWords.isEmpty()) {
							clearSongList();
							mrlv_search_song.onRefreshComplete();
							return;
						}
						if (map != null && map.containsKey("data")) {
							@SuppressWarnings("unchecked")
							List<SongOnline> mySongOnlines = (List<SongOnline>) map.get("data");
							if (mySongOnlines != null) {
								if (isFirst) {
									clearSongList();
								}
								songOnLines.addAll(mySongOnlines);
								demandSongOnlineAdapter.setList(songOnLines);
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}

					mrlv_search_song.onRefreshComplete();

				}

				@Override
				public void onLoaderFail() {
					mrlv_search_song.onRefreshComplete();

				}
			});
		} else {
			// ToastUtil.show("搜索词不能为空");
			mrlv_search_song.onRefreshComplete();
		}
	}

	private void clearSongList() {
		songOnLines.clear();
		demandSongOnlineAdapter.setList(songOnLines);

	}

	private boolean hideInpter() {
		try {
			InputMethodManager imm = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
			if (imm.isActive(et_search_song)) {
				imm.hideSoftInputFromWindow(et_search_song.getWindowToken(), 0);
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public boolean OnTouchLisTener() {
		return hideInpter();

	}
}
