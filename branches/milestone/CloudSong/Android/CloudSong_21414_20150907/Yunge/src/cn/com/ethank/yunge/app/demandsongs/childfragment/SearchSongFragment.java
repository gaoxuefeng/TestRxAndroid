package cn.com.ethank.yunge.app.demandsongs.childfragment;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.HotSongsActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.LanguageActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.NewSongsActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.SingerTypeActvity;
import cn.com.ethank.yunge.app.demandsongs.activity.SongListActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.TypeActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.searchsong.SearchSongActivity;
import cn.com.ethank.yunge.app.demandsongs.beans.MusicBean;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.view.MyListView;


public class SearchSongFragment extends Fragment implements View.OnClickListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;
    private RadioGroup rg_fgsong_title;
    private RadioButton rb_fgsong1;
    private MyListView lv_top_song;
    //	public static int cur_pos = -1;
    private SongsAdapter topFourthSongAdapter;
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
    ArrayList<MusicBean> musicList = new ArrayList<MusicBean>();
    private RelativeLayout rl_search_song;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment DemandFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static SearchSongFragment newInstance(String param1, String param2) {
        SearchSongFragment fragment = new SearchSongFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    public SearchSongFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_demand, container, false);
        initView(view);
        initData(view);

        return view;
    }

    private void initData(View view) {
        MusicBean musicBean = new MusicBean();
        musicBean.setTitle("小苹果");
        musicBean.setSinger("筷子兄弟");
        musicBean.setLanguage("国语");
        musicList.add(musicBean);


        musicBean = new MusicBean();
        musicBean.setTitle("可惜没有如果");
        musicBean.setSinger("林俊杰");
        musicBean.setLanguage("国语");
        musicList.add(musicBean);

        musicBean = new MusicBean();
        musicBean.setTitle("李白");
        musicBean.setSinger("李荣浩");
        musicBean.setLanguage("国语");
        musicList.add(musicBean);

        musicBean = new MusicBean();
        musicBean.setTitle("手写的从前");
        musicBean.setSinger("周杰伦");
        musicBean.setLanguage("国语");
        musicList.add(musicBean);
        topFourthSongAdapter.notifyDataSetChanged();
    }

    private void initView(View view) {
        //4个列表
        lv_top_song = (MyListView) view.findViewById(R.id.lv_top_song);
        topFourthSongAdapter = new SongsAdapter(getActivity(), musicList, new BaseTitleActivity.DemandClickCallBack() {
            @Override
            public void onClickListener(View view, int position, Object viewHolder) {

            }
        });
        lv_top_song.setAdapter(topFourthSongAdapter);
        lv_top_song.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

            }
        });
        //搜歌
        tv_search_song = (TextView) view.findViewById(R.id.tv_search_song);
        rl_search_song = (RelativeLayout) view.findViewById(R.id.rl_search_song);
        //        tv_search_song.setOnClickListener(this);
        rl_search_song.setOnClickListener(this);
        //跳到榜单
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

        //大家都在唱
        rl_demand_hot = (RelativeLayout) view.findViewById(R.id.rl_demand_hot);
        rl_demand_hot.setOnClickListener(this);

        //主题榜单
        ll_ktv_hot_song = (LinearLayout) view.findViewById(R.id.ll_ktv_hot_song);//ktv热榜
        ll_ktv_hot_song.setOnClickListener(this);

        ll_ktv_new_song = (LinearLayout) view.findViewById(R.id.ll_ktv_new_song);//ktv新歌
        ll_ktv_new_song.setOnClickListener(this);

        ll_ktv_hot_chorus = (LinearLayout) view.findViewById(R.id.ll_ktv_hot_chorus);//ktv合唱
        ll_ktv_hot_chorus.setOnClickListener(this);

        ll_ktv_hot_demand = (LinearLayout) view.findViewById(R.id.ll_ktv_hot_demand);//ktv必点
        ll_ktv_hot_demand.setOnClickListener(this);
    }


    @Override
    public void onClick(View view) {
        Intent intent = new Intent();
        switch (view.getId()) {
            case R.id.ll_singers://歌星
                intent.setClass(getActivity(), SingerTypeActvity.class);
                break;
//            case R.id.tv_search_song://搜歌
            case R.id.rl_search_song://搜歌
                intent.setClass(getActivity(), SearchSongActivity.class);
                break;
            case R.id.ll_languages://语种
                intent.setClass(getActivity(), LanguageActivity.class);
                break;
            case R.id.ll_types://分类
                intent.setClass(getActivity(), TypeActivity.class);
                break;
            case R.id.ll_new_songs://新歌
                intent.setClass(getActivity(), NewSongsActivity.class);
                break;
            case R.id.ll_tops://热榜
                intent.setClass(getActivity(), HotSongsActivity.class);
                break;

            case R.id.rl_demand_hot://大家都在唱
                intent.setClass(getActivity(), SongListActivity.class);
                intent.putExtra("className", "大家都在唱");
                break;

            case R.id.ll_ktv_hot_song://ktv热歌
                intent.setClass(getActivity(), SongListActivity.class);
                intent.putExtra("className", "KTV热歌榜");
                break;
            case R.id.ll_ktv_new_song://ktv新歌
                intent.setClass(getActivity(), SongListActivity.class);
                intent.putExtra("className", "KTV新歌榜");
                break;
            case R.id.ll_ktv_hot_chorus://ktv热门合唱
                intent.setClass(getActivity(), SongListActivity.class);
                intent.putExtra("className", "KTV热门合唱");
                break;
            case R.id.ll_ktv_hot_demand://ktv必点
                intent.setClass(getActivity(), SongListActivity.class);
                intent.putExtra("className", "KTV必点歌曲榜");
                break;

        }
        if (intent.getComponent() != null) {
            startActivity(intent);
        }

    }
}
