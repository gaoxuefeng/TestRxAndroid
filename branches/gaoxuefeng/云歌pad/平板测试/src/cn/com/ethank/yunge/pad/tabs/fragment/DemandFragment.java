package cn.com.ethank.yunge.pad.tabs.fragment;

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
import android.widget.TabHost.TabSpec;
import android.widget.TextView;
import cn.com.ethank.yunge.pad.MainActivity;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.activity.HotSongsActivity;
import cn.com.ethank.yunge.pad.activity.LanguageActivity;
import cn.com.ethank.yunge.pad.activity.NewSongsActivity;
import cn.com.ethank.yunge.pad.activity.SearchSongActivity;
import cn.com.ethank.yunge.pad.activity.SingTogetherActivity;
import cn.com.ethank.yunge.pad.activity.SingerTypeActvity;
import cn.com.ethank.yunge.pad.activity.SongListActivity;
import cn.com.ethank.yunge.pad.activity.ThemeSongListActivity;
import cn.com.ethank.yunge.pad.activity.TypeActivity;
import cn.com.ethank.yunge.pad.adapter.DemandSongOnlineTogetherAdapter;
import cn.com.ethank.yunge.pad.adapter.MainThemeAdapter;
import cn.com.ethank.yunge.pad.bean.SongOnline;
import cn.com.ethank.yunge.pad.bean.mainthemebean.MainThemeBean;
import cn.com.ethank.yunge.pad.bean.mainthemebean.ThemeChildBean;
import cn.com.ethank.yunge.pad.requsetnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.pad.requsetnetwork.RequestMainTheme;
import cn.com.ethank.yunge.pad.requsetnetwork.RequestSongList;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.utils.ContentValues;
import cn.com.ethank.yunge.pad.view.MyGridView;
import cn.com.ethank.yunge.pad.view.MyListView;

import com.coyotelib.app.ui.util.UICommonUtil;

public class DemandFragment extends Fragment implements View.OnClickListener {

	private RadioGroup rg_fgsong_title;
	private RadioButton rb_fgsong1;
	private MyListView lv_top_song;
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
	ArrayList<SongOnline> musicList = new ArrayList<SongOnline>();
	private RelativeLayout rl_search_song;
	private DemandSongOnlineTogetherAdapter topFourthSongAdapter;
	private RequestSongList requestSongList;
	private MyGridView mgv_main_theme;
	private List<ThemeChildBean> musicThemeList = new ArrayList<ThemeChildBean>();
	private MainThemeAdapter mainThemeAdapter;
	private Activity context;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.fragment_demand, container, false);
		context = getActivity();
		initView(view);
		initListAndGridView();// 设置Adapter和点击事件
		initSingTogetherData(view);// 大家一起唱数据
		initRecommendData(view);// 推荐专题数据

		return view;
	}

	private void initListAndGridView() {
		// 大家都在唱
		topFourthSongAdapter = new DemandSongOnlineTogetherAdapter(context, musicList);

		lv_top_song.setAdapter(topFourthSongAdapter);
		lv_top_song.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// 点击歌曲
			}
		});

		// 推荐专题
		mainThemeAdapter = new MainThemeAdapter(context, musicThemeList);
		mgv_main_theme.setAdapter(mainThemeAdapter);
		mgv_main_theme.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent intent = new Intent();
				intent.setClass(getActivity(), ThemeSongListActivity.class);
				intent.putExtra("themeChildBean", musicThemeList.get(position));
				String tabTag = intent.hashCode() + "";
				TabSpec tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
				ContentValues.tabhost.addTab(tabSpec);
				MainActivity.setCurrentTabByTag(tabTag, true);
			}
		});
	}

	private void initRecommendData(View view) {
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

	private void initSingTogetherData(View view) {
		// 大家一起唱
		HashMap<String, String> hashMap = new HashMap<String, String>();
		UICommonUtil.dip2px(getActivity(), 1);
		hashMap.put("startIndex", "0");
		hashMap.put("flag", "0");
		String url = Constants.getBetterHost().concat(Constants.REQUEST_SONG_SING_TOGETHER_URL);
		requestSongList = new RequestSongList(context, hashMap, url);
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
		Intent intent = new Intent();
		String tabTag = "";
		TabSpec tabSpec;
		switch (view.getId()) {

		case R.id.ll_singers:// 歌星

			intent.setClass(getActivity(), SingerTypeActvity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			break;
		case R.id.rl_search_song:// 搜歌
			intent.setClass(getActivity(), SearchSongActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			break;
		case R.id.ll_languages:// 语种
			intent.setClass(getActivity(), LanguageActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			break;
		case R.id.ll_types:// 分类
			intent.setClass(getActivity(), TypeActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			break;
		case R.id.ll_new_songs:// 新歌
			intent.setClass(getActivity(), NewSongsActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			break;
		case R.id.ll_tops:// 热榜
			intent.setClass(getActivity(), HotSongsActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			break;

		case R.id.rl_demand_hot:// 大家都在唱
			intent.setClass(getActivity(), SingTogetherActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			intent.putExtra("className", "大家都在唱");
			break;

		case R.id.ll_ktv_hot_song:// ktv热歌
			intent.setClass(getActivity(), SongListActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			intent.putExtra("className", "KTV热歌榜");
			break;
		case R.id.ll_ktv_new_song:// ktv新歌
			intent.setClass(getActivity(), SongListActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			intent.putExtra("className", "KTV新歌榜");
			break;
		case R.id.ll_ktv_hot_chorus:// ktv热门合唱
			intent.setClass(getActivity(), SongListActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			intent.putExtra("className", "KTV热门合唱");
			break;
		case R.id.ll_ktv_hot_demand:// ktv必点
			intent.setClass(getActivity(), SongListActivity.class);
			tabTag = intent.hashCode() + "";
			tabSpec = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
			ContentValues.tabhost.addTab(tabSpec);
			intent.putExtra("className", "KTV必点歌曲榜");
			break;

		}
		if (intent.getComponent() != null) {
			MainActivity.setCurrentTabByTag(tabTag, true);
		}

	}
}
