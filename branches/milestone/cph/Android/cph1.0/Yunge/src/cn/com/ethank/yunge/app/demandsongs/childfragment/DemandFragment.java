package cn.com.ethank.yunge.app.demandsongs.childfragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.HotSongsActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.LanguageActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.NewSongsActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.SingTogetherActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.SingerTypeActvity;
import cn.com.ethank.yunge.app.demandsongs.activity.SongListActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.ThemeSongListActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.TypeActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.DemandSongOnlineAdapter;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.MainThemeAdapter;
import cn.com.ethank.yunge.app.demandsongs.activity.searchsong.SearchSongActivity;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.beans.maintheme.MainThemeBean;
import cn.com.ethank.yunge.app.demandsongs.beans.maintheme.ThemeChildBean;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestMainTheme;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestTop4SingTogetherSongList;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity.DemandClickCallBack;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.JsonCacheKeyUtil;
import cn.com.ethank.yunge.app.util.JsonCacheUtil;
import cn.com.ethank.yunge.view.MyGridView;
import cn.com.ethank.yunge.view.MyListView;

import com.umeng.analytics.MobclickAgent;

public class DemandFragment extends Fragment implements View.OnClickListener {

	private RadioGroup rg_fgsong_title;
	private RadioButton rb_fgsong1;
	private MyListView lv_top_song;
	// public static int cur_pos = -1;
	private TextView tv_search_song;
	private LinearLayout ll_singers;
	private LinearLayout ll_languages;
	private LinearLayout ll_types;
	private LinearLayout ll_new_songs;
	private LinearLayout ll_tops;
	private RelativeLayout rl_demand_hot;
	private LinearLayout ll_ktv_hot_song;
	private LinearLayout ll_ktv_new_song;
	private LinearLayout ll_ktv_hot_chorus;
	private LinearLayout ll_ktv_hot_demand;
	List<SongOnline> musicList = new ArrayList<SongOnline>();
	private RelativeLayout rl_search_song;
	private Activity context;
	private DemandSongOnlineAdapter topFourthSongAdapter;
	private RequestTop4SingTogetherSongList requestSongList;
	private MyGridView mgv_main_theme;
	private List<ThemeChildBean> musicThemeList = new ArrayList<ThemeChildBean>();
	private MainThemeAdapter mainThemeAdapter;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.fragment_demand, container, false);
		context = getActivity();
		initView(view);
		initListAndGridView();// 设置Adapter和点击事件
		initSingTogetherData();// 大家一起唱数据
		initRecommendData();// 推荐专题数据
		return view;
	}

	private void initListAndGridView() {
		// 大家都在唱
		@SuppressWarnings("unchecked")
		List<SongOnline> myList = (List<SongOnline>) JsonCacheUtil.getArrayList(JsonCacheKeyUtil.top4SingTogether, SongOnline.class);
		if (myList != null && myList.size() != 0) {
			musicList.clear();
			musicList.addAll(myList);
		}
		topFourthSongAdapter = new DemandSongOnlineAdapter(context, musicList, new DemandClickCallBack() {

			@Override
			public void onClickListener(View view, int position, Object viewHolder) {

			}
		});

		lv_top_song.setAdapter(topFourthSongAdapter);
		lv_top_song.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// 点击歌曲
			}
		});

		// 推荐专题

		// 取出缓存
		@SuppressWarnings("unchecked")
		List<ThemeChildBean> myThemeList = (List<ThemeChildBean>) JsonCacheUtil.getArrayList(JsonCacheKeyUtil.musicThemeList, ThemeChildBean.class);
		if (myThemeList != null && myThemeList.size() != 0) {
			musicThemeList.clear();
			musicThemeList.addAll(myThemeList);
		}
		// 设置adapter
		mainThemeAdapter = new MainThemeAdapter(context, musicThemeList);
		mgv_main_theme.setAdapter(mainThemeAdapter);
		mgv_main_theme.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent intent = new Intent();
				intent.setClass(getActivity(), ThemeSongListActivity.class);
				intent.putExtra("themeChildBean", musicThemeList.get(position));
				startActivity(intent);
			}
		});
	}

	private void initRecommendData() {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("token", Constants.getToken());
		hashMap.put("version", "0");// 推荐专题的版本号
		RequestMainTheme requestMainTheme = new RequestMainTheme(context, hashMap);
		requestMainTheme.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					if (map != null && map.containsKey("data") && map.get("data") instanceof MainThemeBean) {
						MainThemeBean mainThemeBean = (MainThemeBean) map.get("data");
						ArrayList<ThemeChildBean> myThemeChildBeans = mainThemeBean.getTheme();
						clearThemeList();
						musicThemeList.addAll(myThemeChildBeans);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			@Override
			public void onLoaderFail() {

			}
		});
	}

	protected void clearThemeList() {
		musicThemeList.clear();
		mainThemeAdapter.setList(musicThemeList);

	}

	private void initSingTogetherData() {
		// 大家一起唱
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("startIndex", "0");
		hashMap.put("flag", "0");
		hashMap.put("token", Constants.getToken());
		String url = Constants.REQUEST_SONG_SING_TOGETHER_URL;
		requestSongList = new RequestTop4SingTogetherSongList(context, hashMap, url);
		requestSongList.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				if (map != null && map.containsKey("data")) {
					@SuppressWarnings("unchecked")
					List<SongOnline> mySongList = (List<SongOnline>) map.get("data");
					if (musicList.size() != 0) {
						musicList.clear();
						topFourthSongAdapter.setList(musicList);
					}
					musicList.addAll(mySongList);

					topFourthSongAdapter.setList(musicList);
				}
			}

			@Override
			public void onLoaderFail() {

			}
		});
	}

	private void initView(View view) {
		// 4个列表
		lv_top_song = (MyListView) view.findViewById(R.id.lv_top_song);
		mgv_main_theme = (MyGridView) view.findViewById(R.id.mgv_main_theme);

		// 搜歌
		tv_search_song = (TextView) view.findViewById(R.id.tv_search_song);
		rl_search_song = (RelativeLayout) view.findViewById(R.id.rl_search_song);
		// tv_search_song.setOnClickListener(this);
		rl_search_song.setOnClickListener(this);
		// 跳到榜单
		ll_singers = (LinearLayout) view.findViewById(R.id.ll_singers);
		ll_singers.setOnClickListener(this);

		ll_languages = (LinearLayout) view.findViewById(R.id.ll_languages);
		ll_languages.setOnClickListener(this);

		ll_types = (LinearLayout) view.findViewById(R.id.ll_types);
		ll_types.setOnClickListener(this);

		ll_new_songs = (LinearLayout) view.findViewById(R.id.ll_new_songs);
		ll_new_songs.setOnClickListener(this);

		ll_tops = (LinearLayout) view.findViewById(R.id.ll_tops);
		ll_tops.setOnClickListener(this);

		// 大家都在唱
		rl_demand_hot = (RelativeLayout) view.findViewById(R.id.rl_demand_hot);
		rl_demand_hot.setOnClickListener(this);

		// 主题榜单
		ll_ktv_hot_song = (LinearLayout) view.findViewById(R.id.ll_ktv_hot_song);// ktv热榜
		ll_ktv_hot_song.setOnClickListener(this);

		ll_ktv_new_song = (LinearLayout) view.findViewById(R.id.ll_ktv_new_song);// ktv新歌
		ll_ktv_new_song.setOnClickListener(this);

		ll_ktv_hot_chorus = (LinearLayout) view.findViewById(R.id.ll_ktv_hot_chorus);// ktv合唱
		ll_ktv_hot_chorus.setOnClickListener(this);

		ll_ktv_hot_demand = (LinearLayout) view.findViewById(R.id.ll_ktv_hot_demand);// ktv必点
		ll_ktv_hot_demand.setOnClickListener(this);
	}

	@Override
	public void onClick(View view) {
		if (!Constants.isClickAble()) {
			return;
		} else {
			Constants.setUnClickAble();
		}
		Intent intent = new Intent();
		switch (view.getId()) {
		case R.id.ll_singers:// 歌星
			intent.setClass(getActivity(), SingerTypeActvity.class);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RsCateSinger");
			break;
		// case R.id.tv_search_song://搜歌
		case R.id.rl_search_song:// 搜歌
			intent.setClass(getActivity(), SearchSongActivity.class);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RsSearch");

			break;
		case R.id.ll_languages:// 语种
			intent.setClass(getActivity(), LanguageActivity.class);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RsCateLanguage");
			break;
		case R.id.ll_types:// 分类
			intent.setClass(getActivity(), TypeActivity.class);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RsCateCate");
			break;
		case R.id.ll_new_songs:// 新歌
			intent.setClass(getActivity(), NewSongsActivity.class);
			break;
		case R.id.ll_tops:// 热榜
			intent.setClass(getActivity(), HotSongsActivity.class);
			break;

		case R.id.rl_demand_hot:// 大家都在唱
			intent.setClass(getActivity(), SingTogetherActivity.class);
			intent.putExtra("className", "大家都在唱");
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RsAllSing");
			break;

		case R.id.ll_ktv_hot_song:// ktv热歌
			intent.setClass(getActivity(), SongListActivity.class);
			intent.putExtra("className", "KTV热歌榜");
			break;
		case R.id.ll_ktv_new_song:// ktv新歌
			intent.setClass(getActivity(), SongListActivity.class);
			intent.putExtra("className", "KTV新歌榜");
			break;
		case R.id.ll_ktv_hot_chorus:// ktv热门合唱
			intent.setClass(getActivity(), SongListActivity.class);
			intent.putExtra("className", "KTV热门合唱");
			break;
		case R.id.ll_ktv_hot_demand:// ktv必点
			intent.setClass(getActivity(), SongListActivity.class);
			intent.putExtra("className", "KTV必点歌曲榜");
			break;

		}

		if (intent.getComponent() != null) {
			startActivity(intent);
		}

	}
}
