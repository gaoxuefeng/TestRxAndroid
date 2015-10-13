package cn.com.ethank.yunge.app.demandsongs;

import java.util.ArrayList;
import java.util.List;

import android.app.Fragment;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.childfragment.DemandFragment;
import cn.com.ethank.yunge.app.demandsongs.childfragment.DemandedFragment;
import cn.com.ethank.yunge.app.demandsongs.childfragment.HistorySongFragment;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestUnSingedSong;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.JsonCacheUtil;
import cn.com.ethank.yunge.view.MyFragmentPagerAdapter;

import com.alibaba.fastjson.JSONArray;
import com.umeng.analytics.MobclickAgent;

public class DemandSongsActivity extends BaseTitleActivity {
	private RadioGroup rg_fgsong_title;
	private ViewPager vp_fgcontent;
	private RadioButton rb_fgsong1;
	private DemandFragment demandFragment;
	private DemandedFragment demandedFragment;
	private HistorySongFragment histirySongFragment;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.fragment_song);
		initTitle();
		initView();
		initDemandedSongList();
		initData();
	}

	@SuppressWarnings("unchecked")
	private void initDemandedSongList() {
		// 先取出cache里面的,避免网络不好获取不及时

		if (Constants.demandedSongIdList == null || Constants.demandedSongIdList.size() == 0) {
			String cache = JsonCacheUtil.getCacheData(Constants.getReserveBoxId());
			if (cache != null && JSONArray.parse(cache) != null) {
				Constants.demandedSongIdList = (List<String>) JSONArray.parse(cache);
			} else {
				Constants.demandedSongIdList = new ArrayList<String>();
			}
		}
		// 获取网络的已点歌曲
		RequestUnSingedSong requestUnSingedSong = new RequestUnSingedSong(context);
		requestUnSingedSong.start(null);
	}

	private void initTitle() {
		// title.setBackgroundColor(Color.parseColor("#211C36"));
		title.showBtnBack(false);
		title.showBtnFunction(true);
		title.setTitle("点歌");
		title.setBtnFunctionImage(R.drawable.remote_close_btn);
		title.setOnClickListener(this);
		title.setOnBtnFunctionClickAction(this);
	}

	private void initView() {
		rg_fgsong_title = (RadioGroup) findViewById(R.id.rg_fgsong_title);
		rg_fgsong_title.check(R.id.rb_fgsong1);
		vp_fgcontent = (ViewPager) findViewById(R.id.vp_fgcontent);
		rb_fgsong1 = (RadioButton) findViewById(R.id.rb_fgsong1);
		vp_fgcontent.setOffscreenPageLimit(2);// 缓冲两页使fragment不被ViewPager摧毁
	}

	private void initData() {

		demandFragment = new DemandFragment();
		demandedFragment = new DemandedFragment();
		histirySongFragment = new HistorySongFragment();
		vp_fgcontent.setAdapter(new MyFragmentPagerAdapter(getFragmentManager()) {

			@Override
			public int getCount() {
				return 3;
			}

			@Override
			public Fragment getItem(int position) {
				if (position == 0) {
					return demandFragment;
				} else if (position == 1) {
					return demandedFragment;
				} else {
					return histirySongFragment;
				}
			}
		});

		rg_fgsong_title.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				switch (checkedId) {
				case R.id.rb_fgsong1:
					if (vp_fgcontent.getCurrentItem() != 0)
						vp_fgcontent.setCurrentItem(0);
					MobclickAgent.onEvent(BaseApplication.getInstance(), "RSRS");

					break;
				case R.id.rb_fgsong2:
					if (vp_fgcontent.getCurrentItem() != 1)
						vp_fgcontent.setCurrentItem(1);
					MobclickAgent.onEvent(BaseApplication.getInstance(), "RsList");
					break;
				case R.id.rb_fgsong3:
					if (vp_fgcontent.getCurrentItem() != 2)
						vp_fgcontent.setCurrentItem(2);
					MobclickAgent.onEvent(BaseApplication.getInstance(), "RsHistory");
					
					break;
				}
			}
		});
		vp_fgcontent.setOnPageChangeListener(new pageChangeListener());

	}

	private class pageChangeListener implements ViewPager.OnPageChangeListener {
		@Override
		public void onPageScrolled(int i, float v, int i2) {

		}

		@Override
		public void onPageSelected(int i) {
			if (i == 0) {
				rg_fgsong_title.check(R.id.rb_fgsong1);
				demandedFragment.OnFragmentChanged();

			} else if (i == 1) {
				rg_fgsong_title.check(R.id.rb_fgsong2);
				demandedFragment.OnFragmentResume();
			} else if (i == 2) {
				rg_fgsong_title.check(R.id.rb_fgsong3);
				demandedFragment.OnFragmentChanged();
			}

		}

		@Override
		public void onPageScrollStateChanged(int i) {

		}
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.btn_back:
			finish();
			break;
		case R.id.title_function:
			finish();
			break;

		default:
			super.onClick(view);
			break;
		}

	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		try {

			JsonCacheUtil.saveCacheData(Constants.getReserveBoxId(), JSONArray.toJSON(Constants.demandedSongIdList).toString());
			Constants.demandedSongIdList.clear();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void finish() {
		super.finish();
		overridePendingTransition(R.anim.without_anim_out, R.anim.anim_to_bottom);
	}
}
