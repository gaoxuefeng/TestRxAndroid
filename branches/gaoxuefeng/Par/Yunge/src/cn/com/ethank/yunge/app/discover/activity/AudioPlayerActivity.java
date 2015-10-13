package cn.com.ethank.yunge.app.discover.activity;

import in.srain.cube.Cube;
import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnKeyListener;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnPreparedListener;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.LayoutParams;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.AbsListView;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.DipToPx;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.discover.bean.MusicBroadInfo;
import cn.com.ethank.yunge.app.discover.bean.MusicBroadInfo.PraiseAvatarUrl;
import cn.com.ethank.yunge.app.discover.service.AudioPlayerPraiseRequest;
import cn.com.ethank.yunge.app.discover.service.GetMusicBoradRequest;
import cn.com.ethank.yunge.app.discover.util.DisCoverConstantUtils;
import cn.com.ethank.yunge.app.discover.util.ShareFriendUtils;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.imageloader.MyImageLoader;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.mine.fragment.CustomDialogNewData;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.DeviceUtil;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.XCRoundImageViewByXfermode;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.sso.UMSsoHandler;

public class AudioPlayerActivity extends BaseActivity implements OnClickListener {
	private SeekBar sb_aduio_progress;
	private ImageView iv_isplay, iv_share, iv_praise, iv_zhen;
	private CubeImageView iv_useicon;
	private TextView tv_usename, titlename_id, tv_usedes, tv_praise_num, tv_changetime, tv_alltime;
	private LinearLayout ll_add_ima, layout_isplay;
	// private boolean isPrise = false;// 是否点赞了,true代表没点过；false表示点过了
	private LinkedHashMap<Integer, View> hashMap = new LinkedHashMap<Integer, View>();
	private RotateAnimation rl_recordRotate;
	private Animation zhenEndRotateAnimation, zhenStartRotateAnimation;
	private int zhenState = 0;// 0停止 ,1播放,2动画播放,3动画暂停
	// ViewPager当前页面的位置
	private int pagePosition;
	// 上面针动画结束
	// 首先在您的Activity中添加如下成员变量
	private final UMSocialService mController = UMServiceFactory.getUMSocialService("com.umeng.share");
	private RotateAnimation rl_recordRotate_stop;
	private ShareFriendUtils shareFriendUtils;

	private static final int PLAYERRANDOM = 0;// 随机播放
	private static final int PLAYERONLYONE = 1;// 单曲循环播放
	private static final int PLAYERALL = 2;// 顺序播放

	private String mediaTime = "";
	private int mediaDuration = 0;
	private int progressChange = 0;
	private String musicFileName = "";

	private String sdCardpath = null;
	// 获取的播放器界面数据
	private MusicBroadInfo musicBean = null;
	// 发现界面点击的item的属性
	private DiscoverInfo audioPlayer = null;

	private String temp;

	private boolean isloginBack = false;
	private ImageLoader imageLoader;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// 从savedInstanceState中恢复数据, 如果没有数据需要恢复savedInstanceState为null
		if (savedInstanceState != null) {
			temp = savedInstanceState.getString("temp");
		}
		super.setContentView(R.layout.activity_audio_player);
		BaseApplication.getInstance().cacheActivityList.add(this);
		imageLoader = ImageLoaderUtil.CreatImageLoader(context, R.drawable.mine_defaultavatar, true);
		// 无网络3秒后退出
		if (!DeviceUtil.isMobileConnected(this)) {
			LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			final CustomDialogNewData dialog = new CustomDialogNewData(context, R.style.Dialog);
			dialog.setCanceledOnTouchOutside(false);// 设置点击屏幕Dialog不消失
			View layout = inflater.inflate(R.layout.dialog_nonetwork, null);
			dialog.addContentView(layout, new AbsListView.LayoutParams(AbsListView.LayoutParams.WRAP_CONTENT, AbsListView.LayoutParams.WRAP_CONTENT));
			dialog.setContentView(layout);

			// 重写此方法主要是为了屏蔽back退出dialog,和重写的dispatchKeyEvent方法同时使用才见效
			dialog.setOnKeyListener(new OnKeyListener() {

				@Override
				public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
					return true;
				}
			});
			dialog.show();

			Handler hand = new Handler();
			hand.postDelayed(new Runnable() {
				@Override
				public void run() {
					AudioPlayerActivity.this.finish();
				}
			}, 3000);
			return;
		}
		initData();
	}

	private void initData() {
		shareFriendUtils = new ShareFriendUtils(this, mController);
		try {
			if (DisCoverConstantUtils.disCoverList == null || DisCoverConstantUtils.disCoverList.isEmpty()) {
				DisCoverConstantUtils.disCoverList = JSON.parseArray(SharePreferencesUtil.getStringData("list"), DiscoverInfo.class);
				DisCoverConstantUtils.disCoverIndex = (Integer) SharePreferencesUtil.getIntData("id");
			}
			audioPlayer = DisCoverConstantUtils.disCoverList.get(DisCoverConstantUtils.disCoverIndex);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (audioPlayer == null) {
			return;
		}
		initView();
		getData_Method();
	}

	// 重写此方法主要是为了屏蔽back退出dialog
	@Override
	public boolean dispatchKeyEvent(KeyEvent event) {
		switch (event.getKeyCode()) {
		case KeyEvent.KEYCODE_BACK:
			break;
		default:
			break;
		}
		return super.dispatchKeyEvent(event);
	}

	private void initView() {
		ll_parent = (LinearLayout) findViewById(R.id.ll_parent);// 根部线性布局
		tv_song = (TextView) findViewById(R.id.tv_song);// 左上角点歌
		titlename_id = (TextView) findViewById(R.id.titlename_id);
		sb_aduio_progress = (SeekBar) findViewById(R.id.sb_aduio_progress);// seekbar进度条
		iv_play_mode = (ImageView) findViewById(R.id.iv_play_mode);// 播放模式
		layout_isplay = (LinearLayout) findViewById(R.id.layout_isplay);// 暂停开始
		iv_isplay = (ImageView) findViewById(R.id.iv_isplay);
		iv_useicon = (CubeImageView) findViewById(R.id.iv_useicon);// 用户头像
		tv_usename = (TextView) findViewById(R.id.tv_usename);// 用户名字
		tv_usedes = (TextView) findViewById(R.id.tv_usedes);// 用户签名
		iv_share = (ImageView) findViewById(R.id.iv_share);// 分享
		iv_praise = (ImageView) findViewById(R.id.iv_praise);// 点赞
		tv_praise_num = (TextView) findViewById(R.id.tv_praise_num);// 点赞的数量
		ll_add_ima = (LinearLayout) findViewById(R.id.ll_add_ima);// 添加点赞的头像
		tv_changetime = (TextView) findViewById(R.id.tv_changetime);// 变化的时间
		tv_alltime = (TextView) findViewById(R.id.tv_alltime);// 总时间
		iv_zhen = (ImageView) findViewById(R.id.iv_zhen);// 播放音乐针
		viewapager = (ViewPager) findViewById(R.id.viewapager);// 中间的viewpager

		// 图片
		imageUrlList = new ArrayList<String>();
		imageUrlList.add("http://192.168.1.74/1.png");
		// 分享的布局
		contentView = View.inflate(getApplicationContext(), R.layout.layout_share, null);
		viewapager.setOnPageChangeListener(new MyPageChangeListener());
		viewapager.setAdapter(new MyPager());

		tv_song.setOnClickListener(this);
		iv_praise.setOnClickListener(this);
		iv_share.setOnClickListener(this);
		iv_play_mode.setOnClickListener(this);
		startOrStopMusicListener(layout_isplay);
	}

	private void getData_Method() {
		ProgressDialogUtils.show(this);

		// 重写此方法主要是为了屏蔽back退出dialog,和重写的dispatchKeyEvent方法同时使用才见效
		ProgressDialogUtils.mProgressDialog.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
				return true;
			}
		});

		Map<String, String> map = new HashMap<String, String>();
		map.put("discoveryId", String.valueOf(audioPlayer.getDiscoverId()));
		if (Constants.getLoginState()) {
			map.put("token", SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token));
		}
		new GetMusicBoradRequest(map, new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				try {
					if (result == null) {
						musicBean = new MusicBroadInfo();
						musicBean.setAvatarUrl(audioPlayer.getAvatarUrl());
						musicBean.setSongName(audioPlayer.getMusicName());
						musicBean.setPraiseCount(audioPlayer.getPraiseCount());
						musicBean.setUserName(audioPlayer.getUserNickName());
					} else {
						musicBean = (MusicBroadInfo) result;
					}
					setviewData();
					getMusicData_Method();
				} catch (Exception e) {
				} finally {
					ProgressDialogUtils.dismiss();
				}
			}

		}).requestData();
	}

	private void setviewData() {
		try {
			String musicName = musicBean.getSongName();
			String userName = musicBean.getUserName();
			String desc = musicBean.getSignature();
			int num = musicBean.getPraiseCount();

			try {
				iv_useicon.loadImage(imageLoader, musicBean.getAvatarUrl());
			} catch (Exception e) {
			}
			titlename_id.setText(musicName);
			tv_usename.setText(userName);
			tv_praise_num.setText(String.valueOf(num));
			tv_usedes.setText(desc);
			if (musicBean.isPraised()) {
				iv_praise.getBackground().setLevel(1);
			} else {
				iv_praise.getBackground().setLevel(0);
			}

			List<PraiseAvatarUrl> list = musicBean.getPraiseAvatarUrls();
			if (list != null) {
				List<String> urls = new ArrayList<String>();
				for (int i = 0; i < list.size(); i++) {
					urls.add(list.get(i).getPraiseAvatarUrl());
				}
				addUserList(urls);
			}
		} catch (Exception e) {
		}
	}

	// 获取音乐资源
	private void getMusicData_Method() {
		playMusic();
		initAnimation();
	}

	private void playMusic() {
		if (null != DisCoverConstantUtils.player) {
			DisCoverConstantUtils.player.release();
			DisCoverConstantUtils.player = null;
		}
		DisCoverConstantUtils.player = new MediaPlayer();
		try {
			DisCoverConstantUtils.player.reset();
			DisCoverConstantUtils.player.setAudioStreamType(AudioManager.STREAM_MUSIC);
			DisCoverConstantUtils.player.setDataSource(audioPlayer.getMusicUrl());
			DisCoverConstantUtils.player.prepare();
			DisCoverConstantUtils.player.start();
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		mediaDuration = DisCoverConstantUtils.player.getDuration();

		// 测试说歌曲播放到总时间的前2s左右停止，所以就提前2秒结束
		mediaTime = new SimpleDateFormat("mm:ss").format(mediaDuration);
		tv_alltime.setText("/" + mediaTime);
		sb_aduio_progress.setMax(DisCoverConstantUtils.player.getDuration());// 设置进度条
		sb_aduio_progress.setOnSeekBarChangeListener(new SeekBarChangeListener());
		DisCoverConstantUtils.player.setOnPreparedListener(new OnPreparedListener() {

			@Override
			public void onPrepared(MediaPlayer arg0) {
				handler.post(updateThread);
			}
		});
	}

	@Override
	protected void onStop() {
		super.onStop();
		if (DisCoverConstantUtils.player != null && DisCoverConstantUtils.player.isPlaying()) {
			DisCoverConstantUtils.player.pause();
		}
	}

	@Override
	protected void onResume() {
		super.onResume();
		temp = "xing";
		System.out.println("onResume: temp = " + temp);
		// 切换屏幕方向会导致activity的摧毁和重建
		if (getRequestedOrientation() == ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
			System.out.println("屏幕切换");
		}
	}

	// 将数据保存到outState对象中, 该对象会在重建activity时传递给onCreate方法
	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		outState.putString("temp", temp);
	}

	@Override
	protected void onRestart() {
		super.onRestart();
		if (imageUrlList == null || imageUrlList.isEmpty()) {
			initData();
		}
		if (DisCoverConstantUtils.player != null && !DisCoverConstantUtils.player.isPlaying() && !isPaues) {
			DisCoverConstantUtils.player.start();
		}
	}

	/**
	 * 实现监听Seekbar的类
	 */
	private class SeekBarChangeListener implements OnSeekBarChangeListener {

		@Override
		public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
			switch (seekBar.getId()) {
			case R.id.sb_aduio_progress:
				if (fromUser) {
					progressChange = progress;

					String progresstime = new SimpleDateFormat("mm:ss").format(progressChange);
					tv_changetime.setText("" + progresstime);
					tv_alltime.setText("/" + mediaTime);
				}
				break;
			}
		}

		@Override
		public void onStartTrackingTouch(SeekBar arg0) {
			// TODO Auto-generated method stub
		}

		@Override
		public void onStopTrackingTouch(SeekBar arg0) {
			DisCoverConstantUtils.player.seekTo(progressChange);
		}
	}

	Handler handler = new Handler();
	Runnable updateThread = new Runnable() {
		public void run() {
			// 获得歌曲现在播放位置并设置成播放进度条的值
			if (DisCoverConstantUtils.player != null) {
				String progresstime = new SimpleDateFormat("mm:ss").format(DisCoverConstantUtils.player.getCurrentPosition() + 1000);

				sb_aduio_progress.setProgress(DisCoverConstantUtils.player.getCurrentPosition() + 1000);
				tv_changetime.setText("" + progresstime);

				if (progresstime.equals(mediaTime)) {
					DisCoverConstantUtils.player.seekTo(0);
				}
				if (!DeviceUtil.isMobileConnected(AudioPlayerActivity.this)) {
					playerModelChange_Method();
				} else {
					// 每次延迟100毫秒再启动线程
					handler.postDelayed(updateThread, 100);
				}
			}
		}
	};

	private void startOrStopMusicListener(View view) {
		view.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View arg0, MotionEvent arg1) {
				switch (arg1.getAction()) {
				case MotionEvent.ACTION_DOWN:
					if (!DeviceUtil.isMobileConnected(AudioPlayerActivity.this)) {
						ToastUtil.show(R.string.connectfailtoast);
					} else {
						handler.postDelayed(updateThread, 100);
						playerModelChange_Method();
					}
					break;
				default:
					break;
				}
				return false;
			}
		});
	}

	private void playerModelChange_Method() {
		// 暂停
		if (!isPaues) {
			iv_isplay.setBackgroundResource(R.drawable.player_play);
			// 清除动画
			if (hashMap != null) {
				View view = hashMap.get(pagePosition);
				ViewHoder hoder = (ViewHoder) view.getTag();
				hoder.rl_record.clearAnimation();
			}
			if (zhenEndRotateAnimation != null) {
				iv_zhen.startAnimation(zhenEndRotateAnimation);
			}

			if (DisCoverConstantUtils.player != null && DisCoverConstantUtils.player.isPlaying()) {
				DisCoverConstantUtils.player.pause();
			}
		} else {
			iv_isplay.setBackgroundResource(R.drawable.player_pause);
			if (zhenStartRotateAnimation != null) {
				iv_zhen.startAnimation(zhenStartRotateAnimation);
			}
			if (DisCoverConstantUtils.player != null && !DisCoverConstantUtils.player.isPlaying()) {
				DisCoverConstantUtils.player.start();
			}
		}
		isPaues = !isPaues;
	}

	private void addUserList(List<String> urls) {
		ll_add_ima.removeAllViews();
		int sum = urls.size();
		if (sum > 5) {
			sum = 5;
		}
		for (int i = 0; i < sum; i++) {
			CubeImageView view = new CubeImageView(this);
			view.setImageResource(R.drawable.mine_defaultavatar);
			view.setLayoutParams(new AbsListView.LayoutParams(DipToPx.dip2px(this, 30), DipToPx.dip2px(this, 30)));
			if (sum > 0) {
				view.loadImage(imageLoader, urls.get(i).toString());
			} else {
				view.setImageDrawable(getResources().getDrawable(R.drawable.mine_defaultavatar));
			}
			ll_add_ima.addView(view, 0);

			XCRoundImageViewByXfermode v = new XCRoundImageViewByXfermode(this);
			v.setLayoutParams(new AbsListView.LayoutParams(DipToPx.dip2px(this, 10), DipToPx.dip2px(this, 10)));
			v.setBackgroundResource(R.color.transparent);
			ll_add_ima.addView(v, 0);
		}
	}

	/**
	 * 初始化动画
	 */
	private void initAnimation() {
		// 针开始的动画
		zhenStartRotateAnimation = new RotateAnimation(0, 35, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 53f / 168);
		zhenStartRotateAnimation.setDuration(1000);
		zhenStartRotateAnimation.setFillAfter(true);
		iv_zhen.startAnimation(zhenStartRotateAnimation);

		// 针结束的动画
		zhenEndRotateAnimation = new RotateAnimation(35, 0, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 53f / 168);
		zhenEndRotateAnimation.setDuration(1000);
		zhenEndRotateAnimation.setFillAfter(true);
		// 中间唱片的旋转动画
		rl_recordRotate = new RotateAnimation(0, 360, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
		rl_recordRotate.setDuration(4000);
		rl_recordRotate.setRepeatCount(-1);
		rl_recordRotate_stop = new RotateAnimation(0, 0, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
		rl_recordRotate_stop.setDuration(0);
		rl_recordRotate_stop.setRepeatCount(-1);

		LinearInterpolator lir = new LinearInterpolator();
		rl_recordRotate.setInterpolator(lir);
		// 针的旋转动画设置监听
		zhenStartRotateAnimation.setAnimationListener(new ZhenAnimationListener());
		zhenEndRotateAnimation.setAnimationListener(new AnimationListener() {

			@Override
			public void onAnimationStart(Animation animation) {
				zhenState = 3;
				if (hashMap.containsKey(pagePosition) && hashMap.get(pagePosition) != null) {
					View view = hashMap.get(pagePosition);
					ViewHoder hoder = (ViewHoder) view.getTag();
					hoder.rl_record.clearAnimation();
				}
			}

			@Override
			public void onAnimationRepeat(Animation animation) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onAnimationEnd(Animation animation) {
				zhenState = 0;
			}
		});
	}

	/**
	 * 
	 * @author ping 开始播放
	 * 
	 */
	class ZhenAnimationListener implements AnimationListener {

		@Override
		public void onAnimationStart(Animation animation) {
			zhenState = 2;// 开始播放动画
		}

		@Override
		public void onAnimationEnd(Animation animation) {
			zhenState = 1;
			if (hashMap.containsKey(pagePosition)) {
				View view = hashMap.get(pagePosition);
				ViewHoder hoder = (ViewHoder) view.getTag();
				hoder.rl_record.startAnimation(rl_recordRotate);
			}
			// 当动画结束后节奏唱片旋转动画
			// rl_record.startAnimation(rl_recordRotate);
		}

		@Override
		public void onAnimationRepeat(Animation animation) {

		}
	}

	private LinearLayout ll_parent;
	private PopupWindow window;
	private ImageView iv_play_mode;
	private View contentView;
	private TextView tv_song;
	private ViewPager viewapager;
	private List<String> imageUrlList;

	/**
	 * 点击事件
	 * 
	 * @param v
	 */
	boolean isPaues = false;

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.tv_song:
			// 点歌推出界面
			finish();
			break;
		case R.id.iv_praise:
			iv_praise.setEnabled(false);
			if (Constants.getLoginState()) {
				PraseSend_Method();
			} else {
				isloginBack = true;
				Intent intent = new Intent(this, LoginActivity.class);
				startActivityForResult(intent, PLAYERALL);
				if (DisCoverConstantUtils.player != null && DisCoverConstantUtils.player.isPlaying()) {
					DisCoverConstantUtils.player.pause();
				}
			}
			break;
		case R.id.iv_play_mode:
			// 目前只要一种播放方式
			// 播放模式
			switch (DisCoverConstantUtils.playModel) {
			case PLAYERRANDOM:
				DisCoverConstantUtils.playModel = PLAYERONLYONE;
				break;
			case PLAYERONLYONE:
				DisCoverConstantUtils.playModel = PLAYERALL;
				break;
			case PLAYERALL:
				DisCoverConstantUtils.playModel = PLAYERRANDOM;
				break;
			default:
				break;
			}
			updatePlayModeBg();
			break;
		case R.id.iv_share:
			iv_share.setEnabled(false);
			// 分享
			showPopupWindow();
			shareFriendUtils.setDiscoverInfo(audioPlayer);
			shareFriendUtils.startShare();
			break;
		case R.id.tv_cancle:
			// 取消
			dismiessWindow();
			break;
		case R.id.iv_wechat:
			// 微信分享
			shareFriendUtils.shareWx();
			dismiessWindow();
			break;
		case R.id.iv_friend_cricle:
			// 朋友圈分享
			shareFriendUtils.shareWxFriends();
			dismiessWindow();
			break;
		case R.id.iv_QQ:
			// qq分享
			shareFriendUtils.shareQQ();
			dismiessWindow();
			break;
		case R.id.iv_sina:
			// 新浪分享
			shareFriendUtils.shareSina();
			dismiessWindow();
			break;
		default:
			break;
		}
	}

	private void dismiessWindow() {
		if (window != null && window.isShowing()) {
			window.dismiss();
		}
	}

	/**
	 * 更换播放背景图片
	 */
	private void updatePlayModeBg() {
		switch (DisCoverConstantUtils.playModel) {
		case PLAYERRANDOM:
			ToastUtil.show("随机播放");
			iv_play_mode.setBackgroundResource(R.drawable.player_random_icon);
			break;
		case PLAYERONLYONE:
			ToastUtil.show("单曲循环");
			iv_play_mode.setBackgroundResource(R.drawable.player_cycle_one);
			break;
		case PLAYERALL:
			ToastUtil.show("顺序播放");
			iv_play_mode.setBackgroundResource(R.drawable.player_cycle);
			break;
		}
	}

	private void showPopupWindow() {
		if (contentView != null) {
			contentView = View.inflate(getApplicationContext(), R.layout.layout_share, null);
			contentView.setBackgroundResource(R.drawable.player_share_1_bg);
		}
		window = new PopupWindow(contentView, LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

		// 参数1 爹是谁 挂载的对象 参数2
		int[] location = new int[2]; // 现在数据里面没有值
		// 获取到每个条目view对象的具体位置
		ll_parent.getLocationInWindow(location);// 往数组里面写入 x和y两个值
		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(true);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(ll_parent, Gravity.LEFT | Gravity.BOTTOM, 0, 0);// 在代码中出现的单位
		TranslateAnimation translate = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f,
				Animation.RELATIVE_TO_PARENT, 1.0f, Animation.RELATIVE_TO_SELF, 0f);
		translate.setDuration(250);
		translate.setFillAfter(true);
		contentView.startAnimation(translate);
		LinearLayout ll_share = (LinearLayout) contentView.findViewById(R.id.ll_share);

		// 取消
		TextView tv_cancle = (TextView) contentView.findViewById(R.id.tv_cancle);
		// 微信
		ImageView iv_wechat = (ImageView) contentView.findViewById(R.id.iv_wechat);
		// 朋友圈
		ImageView iv_friend_cricle = (ImageView) contentView.findViewById(R.id.iv_friend_cricle);
		// QQ
		ImageView iv_QQ = (ImageView) contentView.findViewById(R.id.iv_QQ);
		// 新浪
		ImageView iv_sina = (ImageView) contentView.findViewById(R.id.iv_sina);
		LinearLayout ll_wechat = (LinearLayout) contentView.findViewById(R.id.ll_wechat);
		LinearLayout ll_friend_cricle = (LinearLayout) contentView.findViewById(R.id.ll_friend_cricle);
		LinearLayout ll_QQ = (LinearLayout) contentView.findViewById(R.id.ll_QQ);

		tv_cancle.setOnClickListener(this);
		iv_wechat.setOnClickListener(this);
		iv_friend_cricle.setOnClickListener(this);
		iv_QQ.setOnClickListener(this);
		iv_sina.setOnClickListener(this);
		// 微信
		if (isAvilible(this, "com.tencent.mm")) {
			ll_wechat.setVisibility(View.VISIBLE);
			ll_friend_cricle.setVisibility(View.VISIBLE);
		} else {
			ll_wechat.setVisibility(View.GONE);
			ll_friend_cricle.setVisibility(View.GONE);
		}
		// QQ
		if (isAvilible(this, "com.tencent.mobileqq")) {
			ll_QQ.setVisibility(View.VISIBLE);
		} else {
			ll_QQ.setVisibility(View.GONE);
		}

		window.setOnDismissListener(new OnDismissListener() {

			@Override
			public void onDismiss() {
				iv_share.setEnabled(true);
			}
		});
	}

	// 友盟分享回掉代码
	// 6.1 配置SSO授权回调
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == PLAYERALL) {
			iv_praise.setEnabled(true);
			if (DisCoverConstantUtils.player != null && !DisCoverConstantUtils.player.isPlaying() && !isPaues) {
				DisCoverConstantUtils.player.start();
			}
			reViewPrise();
		} else {
			/** 使用SSO授权必须添加如下代码 */
			UMSsoHandler ssoHandler = mController.getConfig().getSsoHandler(requestCode);
			if (ssoHandler != null) {
				ssoHandler.authorizeCallBack(requestCode, resultCode, data);
			}
		}
	}

	// 登陆成功后刷新点赞相关的数量，头像列表，是否点过赞的数据
	private void reViewPrise() {
		Map<String, String> map = new HashMap<String, String>();
		map.put("discoveryId", String.valueOf(audioPlayer.getDiscoverId()));
		if (Constants.getLoginState()) {
			map.put("token", SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token));
		}
		new GetMusicBoradRequest(map, new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				try {
					if (result == null) {
						musicBean = new MusicBroadInfo();
						musicBean.setPraiseCount(audioPlayer.getPraiseCount());
					} else {
						musicBean = (MusicBroadInfo) result;
					}
					tv_praise_num.setText(String.valueOf(musicBean.getPraiseCount()));
					if (musicBean.isPraised()) {
						iv_praise.getBackground().setLevel(1);
					} else {
						iv_praise.getBackground().setLevel(0);
					}
					List<PraiseAvatarUrl> list = musicBean.getPraiseAvatarUrls();
					if (list != null) {
						List<String> urls = new ArrayList<String>();
						for (int i = 0; i < list.size(); i++) {
							urls.add(list.get(i).getPraiseAvatarUrl());
						}
						addUserList(urls);
					}
				} catch (Exception e) {
				}
			}
		}).requestData();
	}

	class MyPager extends PagerAdapter {

		@Override
		public int getCount() {
			// return Integer.MAX_VALUE;
			return imageUrlList.size();
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;
		}

		@Override
		public Object instantiateItem(ViewGroup container, int position) {
			ViewHoder viewHoder = new ViewHoder();
			View view = View.inflate(getApplicationContext(), R.layout.layout_player_center, null);
			viewHoder.rl_record = (RelativeLayout) view.findViewById(R.id.rl_record);
			view.setTag(viewHoder);

			container.addView(view);
			hashMap.put(position / imageUrlList.size(), view);
			return view;
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			container.removeView((View) object);
		}
	}

	// viewpager改变的页面监听
	class MyPageChangeListener implements OnPageChangeListener {

		@Override
		public void onPageScrollStateChanged(int position) {
		}

		@Override
		public void onPageScrolled(int position, float arg1, int arg2) {
		}

		@Override
		public void onPageSelected(int position) {
		}
	}

	class ViewHoder {
		public RelativeLayout rl_record;
		public ImageView iv_user_icon;
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		try {
			if (DisCoverConstantUtils.player != null) {
				DisCoverConstantUtils.player.stop();
				DisCoverConstantUtils.player.release();
				DisCoverConstantUtils.player = null;
			}
			// 将本次下载的音乐删除
			// deleteCacheMusic();
		} catch (Exception e) {
		}
	}

	// private void readFileFromAssets() {
	// musicFileName = audioPlayer.getMusicName();
	// new LoadMusicRequest(sdCardpath, musicFileName,
	// audioPlayer.getMusicUrl(), new RefreshUiInterface() {
	// @Override
	// public void refreshUi(Object result) {
	// // 这里表示的是在一些网络不稳定情况下用户请求到半截退出界面后，线程请求完毕后会接着走，所以判断全部变量如果是空的话就不走了
	// // if (null != DisCoverConstantUtils.player) {
	// // boolean isSec = (Boolean) result;
	// // if (isSec) {
	// // playMusic();
	// // initAnimation();
	// // }
	// // }
	// }
	// }).loadData();
	// }

	// 点赞
	private void PraseSend_Method() {
		Map<String, String> map = new HashMap<String, String>();
		map.put("discoveryId", String.valueOf(audioPlayer.getDiscoverId()));
		map.put("token", SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token));
		new AudioPlayerPraiseRequest(new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				iv_praise.setEnabled(true);
				// hasPraised true:点赞；false：取消赞
				if (result != null) {
					JSONObject obj = (JSONObject) result;
					try {
						JSONArray jarry = JSON.parseArray(obj.getString("praiseAvatarUrls"));
						if (jarry.size() > 0 && !jarry.isEmpty()) {
							List<String> list = new ArrayList<String>();
							for (int i = 0; i < jarry.size(); i++) {
								list.add(jarry.get(i).toString());
							}
							addUserList(list);
						} else {
							ll_add_ima.removeAllViews();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					if (obj.getBooleanValue("hasPraised")) {
						iv_praise.getBackground().setLevel(1);
					} else {
						iv_praise.getBackground().setLevel(0);
					}
					// 点赞的数量
					String text = obj.getString("praiseCount");
					int prisenum = Integer.parseInt(text);
					tv_praise_num.setText(prisenum++ + "");
				} else {
					ToastUtil.show(R.string.connectfailtoast);
				}
			}
		}, map).requestData();
	}

	private boolean isAvilible(Context context, String packageName) {
		PackageManager packageManager = context.getPackageManager();
		List<ApplicationInfo> packageInfos = packageManager.getInstalledApplications(0);
		List<String> packnames = new ArrayList<String>();
		if (packageInfos != null) {

			for (int i = 0; i < packageInfos.size(); i++) {
				packnames.add(packageInfos.get(i).packageName);
			}
		}
		return packnames.contains(packageName);
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}

}
