package cn.com.ethank.yunge.app.demandsongs.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.DemandSongOnlineAdapter;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.beans.maintheme.ThemeChildBean;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestSongList;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class ThemeSongListActivity extends BaseTitleActivity {

	private MyRefreshListView mrlv_songs;
	private ListView lv_songs;
	private ArrayList<SongOnline> musicBeanArrayList = new ArrayList<SongOnline>();
	private DemandSongOnlineAdapter songsAdapter;
	private RequestSongList requestSongList;
	private ThemeChildBean themeChildBean;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_theme__song_list);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
		initView();
		initData();
		requestData();
		setListener();

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void setListener() {
		mrlv_songs.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {

			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				requestData();
			}
		});
	}

	private void requestData() {
		// pageNum 第几页 number 从0开始
		// perPage 每页多少 number 可为null，默认50
		// token
		// type 歌手分类 string
		// userID

		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("startIndex", musicBeanArrayList.size() + "");
		hashMap.put("token", Constants.getToken());
		hashMap.put("themeId", themeChildBean.getThemeId());
		String url = Constants.REQUEST_UI_THEME_SONG_LIST;
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
				mrlv_songs.onRefreshComplete();
			}

			@Override
			public void onLoaderFail() {
				mrlv_songs.onRefreshComplete();
			}
		});
	}

	protected void clearList() {
		musicBeanArrayList.clear();
		songsAdapter.notifyDataSetChanged();

	}

	private void initData() {

		songsAdapter = new DemandSongOnlineAdapter(context, musicBeanArrayList, demandClickCallBack);
		lv_songs.setAdapter(songsAdapter);
	}

	private void initView() {
		title.showBtnFunction();
		title.setOnBtnFunctionClickAction(this);
		Bundle bundle = getIntent().getExtras();
		if (bundle.containsKey("themeChildBean")) {
			themeChildBean = (ThemeChildBean) bundle.getSerializable("themeChildBean");
			if (themeChildBean != null) {
				title.setTitle(themeChildBean.getListTypeName());
				title.setBtnBackText("点歌");
			} else {
				themeChildBean = new ThemeChildBean();
			}
		}

		mrlv_songs = (MyRefreshListView) findViewById(R.id.mrlv_songs);
		mrlv_songs.setPullToRefreshOverScrollEnabled(false);
		mrlv_songs.setPullToRefreshEnabled(false);
		mrlv_songs.setMode(Mode.PULL_FROM_END);
		lv_songs = mrlv_songs.getRefreshableView();
	}

	protected DemandClickCallBack demandClickCallBack = new DemandClickCallBack() {
		@Override
		public void onClickListener(View view, int position, Object viewholder) {

			Log.i("position", "position");
		}
	};

}
