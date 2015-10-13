package cn.com.ethank.yunge.app.demandsongs.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.RoomBaseActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.MusicStyleAdapter;
import cn.com.ethank.yunge.app.demandsongs.beans.MusicStyleBean;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestTypes;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;

/**
 * 分类列表
 * 
 * @author Gao Xuefeng
 * 
 */
public class TypeActivity extends RoomBaseActivity implements OnItemClickListener {
	ArrayList<MusicStyleBean> musicStyleList = new ArrayList<MusicStyleBean>();
	private ListView gv_music_style;
	private Context context;
	private MusicStyleAdapter musicStyleAdapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_type);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
		this.context = this;
		initView();
		initData();
	}

	private void initData() {
		initMusicStyles();

		musicStyleAdapter = new MusicStyleAdapter(context, musicStyleList);
		gv_music_style.setAdapter(musicStyleAdapter);

	}

	private void initView() {
		title.setTitle(R.string.title_type);
		title.setBtnBackText("点歌");
		gv_music_style = (ListView) findViewById(R.id.gv_music_style);
		gv_music_style.setOnItemClickListener(this);
	}

	private void initMusicStyles() {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("token", Constants.getToken());
		RequestTypes requestTypes = new RequestTypes(context, hashMap);
		requestTypes.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				if (map != null && map.containsKey("data")) {
					@SuppressWarnings("unchecked")
					List<MusicStyleBean> myMusicTypelist = (List<MusicStyleBean>) map.get("data");
					musicStyleList.addAll(myMusicTypelist);
					musicStyleAdapter.setList(musicStyleList);
				}
				// 完成
			}

			@Override
			public void onLoaderFail() {
				// 失败

			}
		});

	}

	private void toSongListActivity(MusicStyleBean musicStyleBean) {
		Intent intent = new Intent(context, SongListBySongTypeActivity.class);
		intent.putExtra("musicStyleBean", musicStyleBean);
		startActivity(intent);
	}

//	@Override
//	public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
//		switch (adapterView.getId()) {
//		case R.id.gv_music_style:
//			toSongListActivity(musicStyleList.get(i));
//			break;
//		}
//	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		toSongListActivity(musicStyleList.get(arg2));
	}
}
