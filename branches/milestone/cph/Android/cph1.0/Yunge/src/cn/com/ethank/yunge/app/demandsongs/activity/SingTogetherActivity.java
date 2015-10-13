package cn.com.ethank.yunge.app.demandsongs.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.os.Bundle;
import android.view.View;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.DemandSongOnlineAdapter;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.DemandSongOnlineAdapter.ViewHolder;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestSongList;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class SingTogetherActivity extends BaseTitleActivity {

	private ListView lv_sing_together;
	private ArrayList<SongOnline> musicBeanArrayList = new ArrayList<SongOnline>();
	private DemandSongOnlineAdapter songsAdapter;
	private MyRefreshListView mrlv_sing_together;
	private RequestSongList requestSongList;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_sing_together);
		BaseApplication.getInstance().cacheActivityList.add(this);

		initView();
		initData();

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initData() {
		mrlv_sing_together.setOnRefreshListener(new OnRefreshListener2() {

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
		songsAdapter = new DemandSongOnlineAdapter(context, musicBeanArrayList, new DemandClickCallBack() {

			@Override
			public void onClickListener(View view, int position, Object viewHolder) {
				if (viewHolder instanceof DemandSongOnlineAdapter.ViewHolder) {
					ViewHolder holder = (ViewHolder) viewHolder;
					// ToastUtil.show("点一首:" +
					// holder.tv_music_name.getText().toString());
				}
			}

		});
		lv_sing_together.setAdapter(songsAdapter);

		requestDataByPage();

	}

	private void requestDataByPage() {
		// pageNum 第几页 number 从0开始
		// perPage 每页多少 number 可为null，默认50
		// token
		// type 歌手分类 string
		// userID

		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("startIndex", musicBeanArrayList.size() + 4 + "");
		hashMap.put("token", Constants.getToken());
		hashMap.put("flag", "1");
		String url = Constants.REQUEST_SONG_SING_TOGETHER_URL;
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
				mrlv_sing_together.onRefreshComplete();
			}

			@Override
			public void onLoaderFail() {
				mrlv_sing_together.onRefreshComplete();
			}
		});
	}

	private void initView() {
		title.setTitle("大家都在唱");
		title.setBtnBackText("点歌");
		title.showBtnFunction();
		mrlv_sing_together = (MyRefreshListView) findViewById(R.id.mrlv_sing_together);
		lv_sing_together = mrlv_sing_together.getRefreshableView();
		mrlv_sing_together.setPullToRefreshOverScrollEnabled(false);
		mrlv_sing_together.setMode(Mode.PULL_FROM_END);

	}

	private void clearSongerList() {

		musicBeanArrayList.clear();
		songsAdapter.setList(musicBeanArrayList);

	}

}
