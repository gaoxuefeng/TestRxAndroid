package cn.com.ethank.yunge.app.demandsongs.activity.searchsong;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.View;
import android.widget.Button;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.ScreenInfo;
import cn.com.ethank.yunge.view.MyViewPager;

import com.coyotelib.app.ui.widget.BasicTitle;

public class SearchSongActivity extends FragmentActivity implements View.OnClickListener {

	private MyViewPager vp_search_song_content;
	private SearchSingerFragment searchSingerFragment;
	private SearchSongFragment searchSongFragment;

	private RadioGroup rg_search_song;

	private BasicTitle title;

	// private static EditText et_search_song;

	private Button bt_dismiss;
	private CloseRoomBroadCast closeRoomBroadCast;

	// private static InputMethodManager imm;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_search_song);

		initView();
		initListener();
		initFragmentTab();
		registExitRoom();
	}

	private void registExitRoom() {
		closeRoomBroadCast = new CloseRoomBroadCast();
		IntentFilter intentFilter = new IntentFilter(Constants.EXITROOM_RECEIVED_ACTION);
		this.registerReceiver(closeRoomBroadCast, intentFilter);

	}

	private void initFragmentTab() {
		String action = getIntent().getAction();
		if (action != null && action.equals(Constants.SINGER_ACTION)) {
			rg_search_song.check(R.id.rb_search_song2);
		}
	}

	private void initView() {
		title = (BasicTitle) findViewById(R.id.title);
		title.setTitle("搜歌");
		title.showBtnBack();
		title.setBtnBackImage(R.drawable.icon_back);
		title.setOnBtnBackClickAction(this);
		rg_search_song = (RadioGroup) findViewById(R.id.rg_search_song);
		vp_search_song_content = (MyViewPager) findViewById(R.id.vp_search_song_content);
		// et_search_song = (EditText) findViewById(R.id.et_search_song);
		bt_dismiss = (Button) findViewById(R.id.bt_dismiss);
		bt_dismiss.setOnClickListener(this);
		// imm = (InputMethodManager)
		// context.getSystemService(Context.INPUT_METHOD_SERVICE);
		ScreenInfo info = new ScreenInfo(this);
		info.getScaledDensity();
	}

	private void initListener() {

		searchSingerFragment = new SearchSingerFragment();
		searchSongFragment = new SearchSongFragment();
		vp_search_song_content.setAdapter(new FragmentPagerAdapter(getSupportFragmentManager()) {

			@Override
			public int getCount() {
				return 2;
			}

			@Override
			public Fragment getItem(int position) {
				if (position == 0) {
					return searchSongFragment;
				} else if (position == 1) {
					return searchSingerFragment;
				}
				return searchSongFragment;
			}
		});
		rg_search_song.setOnCheckedChangeListener(new OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				switch (checkedId) {
				case R.id.rb_search_song1:
					if (vp_search_song_content.getCurrentItem() != 0) {
						vp_search_song_content.setCurrentItem(0);
						searchSongFragment.setFragmentRefresh();
					}

					break;
				case R.id.rb_search_song2:
					if (vp_search_song_content.getCurrentItem() != 1) {
						vp_search_song_content.setCurrentItem(1);
						searchSingerFragment.setFragmentRefresh();
					}
					break;

				default:
					break;
				}
			}
		});
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_back:
		case R.id.bt_dismiss:
			finish();
			break;

		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		try {
			this.unregisterReceiver(closeRoomBroadCast);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	class CloseRoomBroadCast extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			if (intent.getAction().equals(Constants.EXITROOM_RECEIVED_ACTION)) {
				try {
					finish();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

	}
}
