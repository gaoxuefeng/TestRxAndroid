package cn.com.ethank.yunge.app.demandsongs.activity.searchsong;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
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
import cn.com.ethank.yunge.app.demandsongs.beans.SinglerOnLine;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestSinggerList;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.view.MyRefreshListView;
import cn.com.ethank.yunge.view.MyRefreshListView.TouchLisTener;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;


public class SearchSingerFragment extends Fragment implements View.OnClickListener, TouchLisTener {

	private String currentKeyWords = "";

	private MyRefreshListView mrlv_search_song;
	private ListView lv_search_song;
	List<SinglerOnLine> singlerOnLines = new ArrayList<SinglerOnLine>();
	private SingersOnlineAdapter singersOnlineAdapter;
	private Context context;
	private EditText et_search_song;

	private RequestSinggerList requestSongByKeyTask;

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
				clearSingerList();
				requestNetwork(true);
			}
		});
	}

	@SuppressLint("ClickableViewAccessibility")
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void initView(View view) {

		/*
		 * Mode.BOTH：同时支持上拉下拉 Mode.PULL_FROM_START：只支持下拉Pulling Down
		 * Mode.PULL_FROM_END：只支持上拉Pulling Up
		 */
		mrlv_search_song = (MyRefreshListView) view.findViewById(R.id.mrlv_search_song);
		mrlv_search_song.setTouchLisTener(this);
		lv_search_song = mrlv_search_song.getRefreshableView();
		singersOnlineAdapter = new SingersOnlineAdapter(getActivity(), singlerOnLines);
		lv_search_song.setAdapter(singersOnlineAdapter);
		mrlv_search_song.setPullToRefreshOverScrollEnabled(false);
		mrlv_search_song.setMode(Mode.PULL_FROM_END);
		
		mrlv_search_song.setOnRefreshListener(new OnRefreshListener2() {
			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				try {
					hideInpter();
					requestNetwork(false);
				} catch (Exception e) {
					e.printStackTrace();
				}
				if(mrlv_search_song!=null){
					mrlv_search_song.onRefreshComplete();
					
				}

			}

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				Log.i("", "OnRefreshListener2 onPullDownToRefresh");
				if(mrlv_search_song!=null){
					mrlv_search_song.onRefreshComplete();
					
				}
			}
		});

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
	public void onClick(View view) {
		switch (view.getId()) {

		default:
			break;
		}
	}

	/**
	 * 第一次请求
	 * 
	 * @param b
	 */
	private void requestNetwork(final boolean isFirst) {

		String newKeyWords = et_search_song.getText().toString().trim();
		currentKeyWords = newKeyWords;
		if (newKeyWords.length() == 0) {
			// ToastUtil.show("搜索词不能为空");
		} else {
			String url = Constants.REQUEST_SINGER_URL_BY_KEY;
			HashMap<String, String> hashMap = new HashMap<String, String>();
			if (isFirst) {
				clearSingerList();
			}
			hashMap.put("startIndex", singlerOnLines.size() + "");
			hashMap.put("keyWord", currentKeyWords);
			requestSongByKeyTask = new RequestSinggerList(context, hashMap, url);
			requestSongByKeyTask.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					try {
						String newKeyWords = et_search_song.getText().toString().trim();
						if (!newKeyWords.equals(currentKeyWords)) {
							mrlv_search_song.onRefreshComplete();
							return;
						}
						if (map != null && map.containsKey("data")) {
							List<SinglerOnLine> mySinglerList = (List<SinglerOnLine>) map.get("data");
							if (mySinglerList != null) {
								if (isFirst) {
									clearSingerList();
								}
								singlerOnLines.addAll(mySinglerList);
								singersOnlineAdapter.setList(singlerOnLines);
							}
						}
						mrlv_search_song.onRefreshComplete();
					} catch (Exception e) {
						e.printStackTrace();
					}

				}

				@Override
				public void onLoaderFail() {
					mrlv_search_song.onRefreshComplete();
				}
			});
		}

	}

	private void clearSingerList() {
		singlerOnLines.clear();
		singersOnlineAdapter.setList(singlerOnLines);
	}

	/**
	 * 切换fragment
	 */
	public void setFragmentRefresh() {
//		hideInpter();
	}

	@Override
	public boolean OnTouchLisTener() {
		return hideInpter();

	}

}
