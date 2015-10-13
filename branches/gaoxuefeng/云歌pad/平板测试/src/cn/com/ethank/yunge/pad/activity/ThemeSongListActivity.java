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
import cn.com.ethank.yunge.pad.bean.mainthemebean.ThemeChildBean;
import cn.com.ethank.yunge.pad.requsetnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.pad.requsetnetwork.RequestSongList;
import cn.com.ethank.yunge.pad.tabs.NomalTabActivity;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class ThemeSongListActivity extends NomalTabActivity {
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
		String url = Constants.getBetterHost().concat(Constants.REQUEST_UI_THEME_SONG_LIST);
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

		songsAdapter = new DemandSongOnlineAdapter(context, musicBeanArrayList);
		lv_songs.setAdapter(songsAdapter);
	}

	private void initView() {
		Bundle bundle = getIntent().getExtras();
		if (bundle.containsKey("themeChildBean")) {
			themeChildBean = (ThemeChildBean) bundle.getSerializable("themeChildBean");
			if (themeChildBean != null) {
				setCenterText(themeChildBean.getListTypeName());
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

}
