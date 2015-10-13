package cn.com.ethank.yunge.pad.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.os.Bundle;
import android.widget.ListView;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.adapter.DemandSongOnlineAdapter;
import cn.com.ethank.yunge.pad.bean.SongOnline;
import cn.com.ethank.yunge.pad.requsetnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.pad.requsetnetwork.RequestSongList;
import cn.com.ethank.yunge.pad.tabs.NomalTabActivity;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class HotSongsActivity extends NomalTabActivity {
	private ListView lv_hot_songs;
	private ArrayList<SongOnline> musicBeanArrayList = new ArrayList<SongOnline>();
	private DemandSongOnlineAdapter songsAdapter;
	private MyRefreshListView mrlv_hot_songs;
	private RequestSongList requestSongList;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_hot_songs);
		initView();
		initData();

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initData() {
		mrlv_hot_songs.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				// 下拉
			};

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉
				requestDataByPage();
			}
		});
		songsAdapter = new DemandSongOnlineAdapter(this, musicBeanArrayList);
		lv_hot_songs.setAdapter(songsAdapter);

		requestDataByPage();

	}

	private void requestDataByPage() {
		// pageNum 第几页 number 从0开始
		// perPage 每页多少 number 可为null，默认50
		// token
		// type 歌手分类 string
		// userID

		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("startIndex", musicBeanArrayList.size() + "");
		hashMap.put("token", Constants.getToken());
		hashMap.put("type", "2");// 热榜
		String url = Constants.hostUrl.concat(Constants.REQUEST_NEWSONG_HOTSONG_LIST);
		requestSongList = new RequestSongList(this, hashMap, url);
		requestSongList.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					if (map != null && map.containsKey("data")) {
						List<SongOnline> mySongList = (List<SongOnline>) map.get("data");

						musicBeanArrayList.addAll(mySongList);
						songsAdapter.setList(musicBeanArrayList);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				mrlv_hot_songs.onRefreshComplete();
			}

			@Override
			public void onLoaderFail() {
				mrlv_hot_songs.onRefreshComplete();
			}
		});
	}

	private void initView() {
		setCenterText(R.string.title_top);
		mrlv_hot_songs = (MyRefreshListView) findViewById(R.id.mrlv_hot_songs);
		lv_hot_songs = mrlv_hot_songs.getRefreshableView();
		mrlv_hot_songs.setPullToRefreshOverScrollEnabled(false);
		mrlv_hot_songs.setMode(Mode.PULL_FROM_END);

	}

	private void clearSongerList() {

		musicBeanArrayList.clear();
		songsAdapter.setList(musicBeanArrayList);

	}

}
