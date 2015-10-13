package cn.com.ethank.yunge.app.demandsongs.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.DemandSongOnlineAdapter;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestSongList;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class NewSongsActivity extends BaseTitleActivity implements OnClickListener {
	ArrayList<SongOnline> musicBeanArrayList = new ArrayList<SongOnline>();
	private MyRefreshListView mrlv_new_songs;
	private ListView lv_new_songs;
	private DemandSongOnlineAdapter songsAdapter;
	private RequestSongList requestSongList;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_new_songs);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
		initView();
		initData();
	}

	private void initData() {

		songsAdapter = new DemandSongOnlineAdapter(context, musicBeanArrayList, new DemandClickCallBack() {
			@Override
			public void onClickListener(View view, int position, Object viewHolder) {

			}
		});
		lv_new_songs.setAdapter(songsAdapter);
		requestDataByPage();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initView() {
		title.setTitle(R.string.title_new_song);
		title.setBtnBackText("点歌");
		mrlv_new_songs = (MyRefreshListView) findViewById(R.id.mrlv_new_songs);

		lv_new_songs = mrlv_new_songs.getRefreshableView();
		mrlv_new_songs.setPullToRefreshOverScrollEnabled(false);
		mrlv_new_songs.setMode(Mode.PULL_FROM_END);

		mrlv_new_songs.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {

			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				requestDataByPage();
			}

		});
	}

	protected void requestDataByPage() {
		// pageNum 第几页 number 从0开始
		// perPage 每页多少 number 可为null，默认50
		// token
		// type 歌手分类 string
		// userID

		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("startIndex", musicBeanArrayList.size() + "");
		hashMap.put("token", Constants.getToken());
		hashMap.put("type", "1");
		String url = Constants.REQUEST_NEWSONG_HOTSONG_LIST;
		requestSongList = new RequestSongList(context, hashMap, url);
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
				mrlv_new_songs.onRefreshComplete();
			}

			@Override
			public void onLoaderFail() {
				mrlv_new_songs.onRefreshComplete();
			}
		});
	}

	protected void clearSongerList() {
		if (musicBeanArrayList.size() == 0) {
			musicBeanArrayList.clear();
			songsAdapter.setList(musicBeanArrayList);
		}

	}

	@Override
	public void onClick(View view) {

		switch (view.getId()) {

		default:
			super.onClick(view);
			break;
		}
	}
}
