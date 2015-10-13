package cn.com.ethank.yunge.app.startup;

import java.util.List;

import android.annotation.SuppressLint;
import android.app.Fragment;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.RadioButton;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.BaseFragment;
import cn.com.ethank.yunge.app.discover.DiscoverFragment;
import cn.com.ethank.yunge.app.home.MerchantDetailFragment;
import cn.com.ethank.yunge.app.home.PredeteFragment;
import cn.com.ethank.yunge.app.homepager.HomePagerFragment;
import cn.com.ethank.yunge.app.manoeuvre.ManoeuvreFragment;
import cn.com.ethank.yunge.app.mine.MineFragment;
import cn.com.ethank.yunge.app.room.RoomFragment;
import cn.com.ethank.yunge.app.util.AppManager;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.JsonCacheKeyUtil;
import cn.com.ethank.yunge.app.util.JsonCacheUtil;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyFragmentPagerAdapter;
import cn.com.ethank.yunge.view.MyRadioGroup;
import cn.com.ethank.yunge.view.MyRadioGroup.OnCheckedChangeListener;

import com.alibaba.fastjson.JSONArray;
import com.handmark.pulltorefresh.library.PullConstants;
import com.umeng.analytics.AnalyticsConfig;
import com.umeng.analytics.MobclickAgent;
import com.umeng.update.UmengUpdateAgent;
import com.umeng.update.UmengUpdateListener;
import com.umeng.update.UpdateResponse;
import com.umeng.update.UpdateStatus;

public class MainTabActivity extends BaseActivity {

	private boolean isExit = false;
	public static String TAB_HOME = "tab_home";
	public static String TAB_ACTIVITY = "tab_activity";
	public static String TAB_RESERVE = "tab_reserve";
	public static String TAB_DISCOVER = "tab_discover";
	public static String TAB_MINE = "tab_mine";
	public static boolean isForeground = false;
	private PredeteFragment predeteFragment;
	// private DemandSongsFragment demandSongsFragment;
	// private ControlFragment controlFragment;
	private DiscoverFragment discoverFragment;
	private MineFragment mineFragment;
	private ViewPager vp_fragment;
	private MyRadioGroup mrg_bottom_bar;
	private MerchantDetailFragment merchantDetailFragment;
	private HomePagerFragment homePagerFragment;
	private ManoeuvreFragment manoeuvreFragment;
	private RoomFragment roomFragment;
	private RadioButton rb_reserve;
	private MyFragmentPagerAdapter fragmentPagerAdapter;

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		try {
			AppManager.getAppManager().finishOtherActivity(this);
			String type = intent.getType();
			if (type != null) {
				if (type.equals(TAB_HOME)) {
					mrg_bottom_bar.getChildAt(0).performClick();
				} else if (type.equals(TAB_RESERVE)) {
					mrg_bottom_bar.getChildAt(1).performClick();
					if (Constants.isBinded()) {
						vp_fragment.setCurrentItem(6, false);
					} else {
						vp_fragment.setCurrentItem(1, false);
					}
				} else if (type.equals(TAB_ACTIVITY)) {
					mrg_bottom_bar.getChildAt(2).performClick();
				} else if (type.equals(TAB_DISCOVER)) {
					mrg_bottom_bar.getChildAt(3).performClick();
				} else if (type.equals(TAB_MINE)) {
					mrg_bottom_bar.getChildAt(4).performClick();
				} else {
					mrg_bottom_bar.getChildAt(0).performClick();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main_tab);
		BaseApplication.getInstance().cacheActivityList.add(this);
		initUmen();// 启动友盟
		initTab();// 初始化Tab
		getPrisedList();
		initFragment();
		registChangeViewPagerPositionRecaive();
		initJpush();
		checkUpdate();
		registBindAndUnBindBroadCast();
	}

	private void getPrisedList() {
		try {
			@SuppressWarnings("unchecked")
			List<String> activityPraisedList = (List<String>) JsonCacheUtil.getArrayList(JsonCacheKeyUtil.activityPraisedList, String.class);
			if (activityPraisedList != null) {
				Constants.actitityPraisedList = activityPraisedList;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 注册广播
	 */
	private void registBindAndUnBindBroadCast() {

		BindAndUnBindReceive bindAndUnBindReceive = new BindAndUnBindReceive();
		IntentFilter filter = new IntentFilter();
		filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
		filter.addAction(Constants.UNBIND_RECEIVED_ACTION);
		filter.addAction(Constants.BIND_RECEIVED_ACTION);
		this.registerReceiver(bindAndUnBindReceive, filter);

	}

	private void checkUpdate() {
		SharePreferencesUtil.saveBooleanData(SharePreferenceKeyUtil.hasUpdate, false);
		UmengUpdateAgent.setUpdateListener(new UmengUpdateListener() {

			@Override
			public void onUpdateReturned(int updateStatus, UpdateResponse arg1) {
				if (updateStatus == UpdateStatus.Yes) {
					SharePreferencesUtil.saveBooleanData(SharePreferenceKeyUtil.hasUpdate, true);
				}
			}
		});
		UmengUpdateAgent.setUpdateOnlyWifi(true);
		UmengUpdateAgent.update(this);
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	private void initFragment() {
		homePagerFragment = new HomePagerFragment();
		predeteFragment = new PredeteFragment();
		manoeuvreFragment = new ManoeuvreFragment();
		roomFragment = new RoomFragment();

		// demandSongsFragment = new DemandSongsFragment();
		// controlFragment = new ControlFragment();
		discoverFragment = new DiscoverFragment();
		mineFragment = new MineFragment();
		merchantDetailFragment = new MerchantDetailFragment();

		initPagerAdapter();
		vp_fragment.setAdapter(fragmentPagerAdapter);
		vp_fragment.setOnPageChangeListener(new OnPageChangeListener() {

			@Override
			public void onPageSelected(int position) {
				if (position == 3) {
					PullConstants.isGoneHeader = true;
				} else {
					PullConstants.isGoneHeader = false;
				}

				homePagerFragment.OnFragmentChanged();
				predeteFragment.OnFragmentChanged();
				manoeuvreFragment.OnFragmentChanged();
				roomFragment.OnFragmentChanged();
				discoverFragment.OnFragmentChanged();
				mineFragment.OnFragmentChanged();
				merchantDetailFragment.OnFragmentChanged();

				if (position < 5) {
					mrg_bottom_bar.setPositionChecked(position);
				} else {
					if (position == 5 || position == 6) {
						// 预定跟房间都是选第2个,position为第一个
						mrg_bottom_bar.setPositionChecked(1);// 显示预定
					}
				}
				BaseFragment baseFragment = (BaseFragment) fragmentPagerAdapter.getItem(position);
				baseFragment.OnFragmentResume();
			}

			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {

			}

			@Override
			public void onPageScrollStateChanged(int arg0) {

			}
		});
		mrg_bottom_bar.setPositionChecked(0);// 首次进入选首页
	}

	private void initPagerAdapter() {
		fragmentPagerAdapter = new MyFragmentPagerAdapter(getFragmentManager()) {

			@Override
			public int getCount() {
				return 7;
			}

			@Override
			public Fragment getItem(int position) {
				switch (position) {
				case 0:
					return homePagerFragment;
				case 1:
					return predeteFragment;
				case 2:
					return manoeuvreFragment;
				case 3:
					return discoverFragment;
				case 4:
					return mineFragment;
				case 5:
					// 商家详情
					return merchantDetailFragment;
				case 6:
					// 房间
					return roomFragment;
				}
				return homePagerFragment;

			}
		};

	}

	private void initJpush() {
		JpushMessageReceiver jpushMessageReceiver = new JpushMessageReceiver();
		IntentFilter filter = new IntentFilter();
		filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
		filter.addAction(Constants.MESSAGE_RECEIVED_ACTION);
		registerReceiver(jpushMessageReceiver, filter);

	}

	private void initUmen() {
		MobclickAgent.updateOnlineConfig(this);// 友盟统计
		AnalyticsConfig.enableEncrypt(true);// 统计信息加密
		MobclickAgent.setDebugMode(true);// 设置为debug模式,快速
	}

	private void initTab() {

		vp_fragment = (ViewPager) findViewById(R.id.vp_fragment);
		vp_fragment.setOffscreenPageLimit(7);
		mrg_bottom_bar = (MyRadioGroup) findViewById(R.id.mrg_bottom_bar);
		rb_reserve = (RadioButton) findViewById(R.id.rb_reserve);
		if (Constants.isBinded()) {
			rb_reserve.setBackgroundResource(R.drawable.tabbar_room);
		} else {
			rb_reserve.setBackgroundResource(R.drawable.tabbar_reserve);
		}
		mrg_bottom_bar.setOnCheckedChangeListener(new OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(MyRadioGroup group, int checkedId) {
				// if (!Constants.isClickAble()) {
				// group.setPositionChecked(vp_fragment.getCurrentItem());
				// return;
				// } else {
				// Constants.setUnClickAble();
				// }
				switch (checkedId) {
				case R.id.rb_homepager:
					// 首页
					MobclickAgent.onEvent(BaseApplication.getInstance(), "TabHome");
					vp_fragment.setCurrentItem(0, false);
					break;

				case R.id.rb_reserve:
					// 预定
					if (Constants.isBinded()) {
						vp_fragment.setCurrentItem(6, false);// 房间
					} else {
						vp_fragment.setCurrentItem(1, false);
					}
					MobclickAgent.onEvent(BaseApplication.getInstance(), "TabReserve");
					break;

				case R.id.rb_manoeuvre:
					// 活动
					vp_fragment.setCurrentItem(2, false);
					MobclickAgent.onEvent(BaseApplication.getInstance(), "TabActivity");
					break;

				case R.id.rb_discover:
					vp_fragment.setCurrentItem(3, false);
					MobclickAgent.onEvent(BaseApplication.getInstance(), "TabDiscovery");
					break;

				case R.id.rb_mine:
					vp_fragment.setCurrentItem(4, false);
					MobclickAgent.onEvent(BaseApplication.getInstance(), "TabMine");
					break;

				default:
					break;
				}

			}
		});
		// 设置预定和房间按钮的点击事件
		setSecondRadioButtonClickListener();
	}

	private void setSecondRadioButtonClickListener() {
		((ViewGroup) mrg_bottom_bar.getChildAt(1)).getChildAt(0).setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				if (vp_fragment.getCurrentItem() == 5) {
					vp_fragment.setCurrentItem(1, false);
				}
				return false;
			}
		});

		mrg_bottom_bar.getChildAt(1).setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				if (vp_fragment.getCurrentItem() == 5) {
					vp_fragment.setCurrentItem(1, false);
				}
				return false;
			}
		});
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		switch (keyCode) {
		case KeyEvent.KEYCODE_BACK:
			if (vp_fragment.getCurrentItem() == 5) {
				vp_fragment.setCurrentItem(1, false);
				return true;
			}
			if (isExit) {
				BaseApplication.getInstance().exit();
				return false;
			} else {
				isExit = true;
				ToastUtil.show("再按一次退出应用", false);
				handler.sendEmptyMessageDelayed(1, 2000);
				return true;
			}

		default:
			break;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	protected void onResume() {
		super.onResume();
		isForeground = true;

	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {

		switch (requestCode) {
		case Constants.LOGIN_REQUEST_CODE_TOMAIN:
			// 跳转到指定页面
			return;

		}

		super.onActivityResult(requestCode, resultCode, data);
	}

	@Override
	protected void onPause() {
		super.onPause();

	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		isForeground = false;
		savePraisedCache();
	}

	private void savePraisedCache() {
		JsonCacheUtil.saveCacheData(JsonCacheKeyUtil.activityPraisedList, JSONArray.toJSON(Constants.actitityPraisedList).toString());
		Constants.actitityPraisedList.clear();
	}

	@SuppressLint("HandlerLeak")
	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 1:
				isExit = false;
				break;

			default:
				break;
			}
		};
	};

	class BindAndUnBindReceive extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			try {
				if (intent.getAction().equals(Constants.UNBIND_RECEIVED_ACTION)) {
					// 解绑
					rb_reserve.setBackgroundResource(R.drawable.tabbar_reserve);

					ToastUtil.show("解绑成功");
					homePagerFragment.setBind(false);
					if (rb_reserve.isChecked()) {
						vp_fragment.setCurrentItem(1, false);
					}

				} else if (intent.getAction().equals(Constants.BIND_RECEIVED_ACTION) && Constants.isBinded()) {
					// 绑定
					rb_reserve.setBackgroundResource(R.drawable.tabbar_room);
					homePagerFragment.setBind(true);
					ToastUtil.show("绑定成功");
					if (rb_reserve.isChecked()) {
						vp_fragment.setCurrentItem(6, false);
					}

				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

	}

	public void registChangeViewPagerPositionRecaive() {
		ChangePositionReceive changePositionReceive = new ChangePositionReceive();
		IntentFilter intentFilter = new IntentFilter(Constants.CHANGE_VIEWPAGERPOSITION);
		this.registerReceiver(changePositionReceive, intentFilter);
	}

	class ChangePositionReceive extends BroadcastReceiver {

		@SuppressLint("NewApi")
		@Override
		public void onReceive(Context context, Intent intent) {
			try {
				if (intent.getAction().equals(Constants.CHANGE_VIEWPAGERPOSITION)) {

					if (MainTabActivity.this != null) {
						if (vp_fragment != null) {
							int position = intent.getIntExtra("position", vp_fragment.getCurrentItem());
							if (vp_fragment.getChildCount() > position) {
								vp_fragment.setCurrentItem(position, false);
							}
						}

					}

				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}
}
