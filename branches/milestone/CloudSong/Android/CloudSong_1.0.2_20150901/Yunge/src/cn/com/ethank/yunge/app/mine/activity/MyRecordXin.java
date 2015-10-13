package cn.com.ethank.yunge.app.mine.activity;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.view.ViewPager.LayoutParams;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.discover.util.ShareFriendUtils;
import cn.com.ethank.yunge.app.mine.adapter.MyRecordAdapter;
import cn.com.ethank.yunge.app.mine.bean.RecordInfoXin;
import cn.com.ethank.yunge.app.mine.bean.RecordXin;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.sso.UMSsoHandler;

@SuppressLint("SimpleDateFormat")
public class MyRecordXin extends BaseActivity implements OnClickListener {
	List<RecordXin> records = new ArrayList<RecordXin>();
	private ListView lv_record;
	private MyRecordAdapter recordAdapter;
	protected String tag = "MyRecordXin";
	private MyRefreshListView mrlv_record;
	private MediaPlayer player;
	private TextView tv_record_changetime;
	private TextView tv_record_alltime;
	private SeekBar sb_record_progress;
	private ImageView iv_pause;
	private boolean recordOver;
	// 首先在您的Activity中添加如下成员变量
	final UMSocialService mController = UMServiceFactory.getUMSocialService("com.umeng.share");

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_record_xin);

		shareFriendUtils = new ShareFriendUtils(this, mController);

		initView();
		initData();
		getNetData(true);
	}

	private void getNetData(final boolean isFristRequest) {
		try {

			if (isFristRequest) {
				clearRecordList();
			}
			String token = Constants.getToken();
			final HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("startIndex", records.size() + "");
			// hashMap.put("token", token);//为了得到数据暂时把token写死方便测试
			hashMap.put("token", token);
			new BackgroundTask<String>() {

				@Override
				protected String doWork() throws Exception {
					return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.myRecord, hashMap).toString();
				}

				@Override
				protected void onCompletion(String result, Throwable exception, boolean cancelled) {
					super.onCompletion(result, exception, cancelled);
					if (result != null) {
						RecordInfoXin recordInfoXin = JSON.parseObject(result, RecordInfoXin.class);

						if (recordInfoXin != null) {

							if (recordInfoXin.getCode() == 0) {
								if (recordInfoXin.getData().size() == 0) {
									Log.e(tag, "没有更多数据了");
									mrlv_record.onRefreshComplete();
								} else {
									if (isFristRequest) {
										clearRecordList();
									}
									for (int i = 0; i < recordInfoXin.getData().size(); i++) {
										records.add(recordInfoXin.getData().get(i));
										recordAdapter.setList(records);
									}
								}
							}
							mrlv_record.onRefreshComplete();
						}
					} else {
						ToastUtil.show(R.string.connectfailtoast);
					}

				}
			}.run();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void clearRecordList() {
		records.clear();
		recordAdapter.setList(records);

	}

	private void initData() {

		recordAdapter = new MyRecordAdapter(this, records, new OnRecordListner() {

			@Override
			public void playRecord(String recordUrl) {
				ToastUtil.show("点击播放了。。。。。。。");
				Log.e(tag, "点击播放了。。。。。。。" + recordUrl);
				playMusic(recordUrl);
			}

			@Override
			public void share() {

				showPopupWindow();
				// TODO后续再添加内容
				// shareFriendUtils.startShare();
			}
		});
		lv_record.setAdapter(recordAdapter);
		// 添加假数据
		// RecordXin record = new RecordXin();
		// record.setDuration("03:00");
		// record.setMusicName("哈哈");
		// record.setRecordTime("07-15");
		// record.setRecordUrl("http://202.204.208.83/gangqin/download/music/02/03/02/Track08.mp3");
		// records.add(record);
		// recordAdapter.setList(records);

	}

	protected void playMusic(String recordUrl) {

		iv_pause.setBackgroundResource(R.drawable.mine_tage_control_play);

		if (null != player) {
			player.release();
			player = null;
		}

		player = new MediaPlayer();
		try {
			player.reset();

			// File file = new File(sdCardpath + File.separator +
			// musicFileName);
			player.setAudioStreamType(AudioManager.STREAM_MUSIC);
			player.setDataSource(recordUrl);
			player.prepare();
			player.start();

			// if (file.exists()) {
			// player.setAudioStreamType(AudioManager.STREAM_MUSIC);
			// player.setDataSource(file.getAbsolutePath());
			// player.prepare();
			// player.start();
			// }
		} catch (Exception e1) {
			e1.printStackTrace();
		}

		mediaDuration = player.getDuration();

		mediaTime = new SimpleDateFormat("mm:ss").format(mediaDuration);
		tv_record_changetime.setText("00:00");
		tv_record_alltime.setText(mediaTime);

		sb_record_progress.setMax(player.getDuration());// 设置进度条

		sb_record_progress.setOnSeekBarChangeListener(new SeekBarChangeListener());

		player.setOnPreparedListener(new OnPreparedListener() {

			@Override
			public void onPrepared(MediaPlayer arg0) {
				handler.post(updateThread);
			}
		});
		player.setOnCompletionListener(new OnCompletionListener() {

			@Override
			public void onCompletion(MediaPlayer mp) {
				iv_pause.setBackgroundResource(R.drawable.mine_tage_control);
				recordOver = true;
			}
		});
	}

	Handler handler = new Handler();
	Runnable updateThread = new Runnable() {
		public void run() {
			// 获得歌曲现在播放位置并设置成播放进度条的值
			if (player != null) {
				String progresstime = new SimpleDateFormat("mm:ss").format(player.getCurrentPosition());

				sb_record_progress.setProgress(player.getCurrentPosition());
				tv_record_changetime.setText("" + progresstime);
				tv_record_alltime.setText(mediaTime);

				if (progresstime.equals(mediaTime)) {
					return;
				}
				// 每次延迟100毫秒再启动线程
				handler.postDelayed(updateThread, 100);
			}
		}
	};
	private int progressChange;
	private String mediaTime;
	private RelativeLayout rl_pause;
	private int mediaDuration;
	private View contentView;
	private LinearLayout ll_bottom;
	private PopupWindow window;
	private ShareFriendUtils shareFriendUtils;

	public class SeekBarChangeListener implements OnSeekBarChangeListener {

		@Override
		public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
			switch (seekBar.getId()) {
			case R.id.sb_record_progress:
				if (fromUser) {
					progressChange = progress;
					String progresstime = new SimpleDateFormat("mm:ss").format(progressChange);
					tv_record_changetime.setText(progresstime);
					tv_record_alltime.setText(mediaTime);
					player.seekTo(progressChange);
				}
				break;

			default:
				break;
			}

		}

		@Override
		public void onStartTrackingTouch(SeekBar seekBar) {

		}

		@Override
		public void onStopTrackingTouch(SeekBar seekBar) {

		}

	}

	private void initView() {
		// 分享的布局
		contentView = View.inflate(getApplicationContext(), R.layout.layout_share, null);
		ll_bottom = (LinearLayout) findViewById(R.id.ll_bottom);
		TextView head_tv_left = (TextView) findViewById(R.id.head_tv_left);
		TextView head_tv_title = (TextView) findViewById(R.id.head_tv_title);
		tv_record_changetime = (TextView) findViewById(R.id.tv_record_changetime);
		tv_record_alltime = (TextView) findViewById(R.id.tv_record_alltime);
		sb_record_progress = (SeekBar) findViewById(R.id.sb_record_progress);
		iv_pause = (ImageView) findViewById(R.id.iv_pause);
		rl_pause = (RelativeLayout) findViewById(R.id.rl_pause);

		head_tv_left.setText("返回");
		head_tv_title.setText("我的录音");
		mrlv_record = (MyRefreshListView) findViewById(R.id.mrfg_discover);
		lv_record = mrlv_record.getRefreshableView();
		mrlv_record.setMode(Mode.BOTH);
		mrlv_record.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				// 下拉刷新
				clearRecordList();
				getNetData(true);
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				getNetData(false);
			}
		});
		rl_pause.setOnClickListener(this);
		head_tv_left.setOnClickListener(this);
		LinearLayout ll_share = (LinearLayout) contentView.findViewById(R.id.ll_share);
		// LinearLayout ll_share1 = (LinearLayout)
		// contentView.findViewById(R.id.ll_share1);
		// ImageView iv_QQ_xin = (ImageView)
		// contentView.findViewById(R.id.iv_QQ_xin);
		// ImageView iv_sina_xin = (ImageView)
		// contentView.findViewById(R.id.iv_sina_xin);
		// iv_QQ_xin.setOnClickListener(this);
		// iv_sina_xin.setOnClickListener(this);

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
		// View wechat_view = contentView.findViewById(R.id.wechat_view);
		// View friend_circle_view =
		// contentView.findViewById(R.id.friend_circle_view);
		// View QQ_view = contentView.findViewById(R.id.QQ_view);
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
			// ll_share.setVisibility(View.VISIBLE);
			// ll_share1.setVisibility(View.GONE);
			ll_wechat.setVisibility(View.VISIBLE);
			ll_friend_cricle.setVisibility(View.VISIBLE);
			// wechat_view.setVisibility(View.VISIBLE);
			// friend_circle_view.setVisibility(View.VISIBLE);

		} else {
			// ll_share.setVisibility(View.GONE);
			// ll_share1.setVisibility(View.VISIBLE);
			ll_wechat.setVisibility(View.GONE);
			ll_friend_cricle.setVisibility(View.GONE);
			// wechat_view.setVisibility(View.GONE);
			// friend_circle_view.setVisibility(View.GONE);
		}
		// QQ
		if (isAvilible(this, "com.tencent.mobileqq")) {
			ll_QQ.setVisibility(View.VISIBLE);
			// QQ_view.setVisibility(View.VISIBLE);
		} else {
			ll_QQ.setVisibility(View.GONE);
			// QQ_view.setVisibility(View.GONE);
		}

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.rl_pause:
			// 播放暂停
			if (player != null) {
				if (player.isPlaying()) {
					player.pause();
					iv_pause.setBackgroundResource(R.drawable.mine_tage_control);
				} else {

					if (recordOver) {
						player.start();
						iv_pause.setBackgroundResource(R.drawable.mine_tage_control_play);
						handler.post(updateThread);
					} else {
						player.start();
						iv_pause.setBackgroundResource(R.drawable.mine_tage_control_play);
					}
				}
			}

			break;
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.tv_cancle:
			// 取消
			window.dismiss();
			break;
		case R.id.iv_wechat:
			// 微信分享
			shareFriendUtils.shareWx();
			break;
		case R.id.iv_friend_cricle:
			// 朋友圈分享
			shareFriendUtils.shareWxFriends();
			break;
		case R.id.iv_QQ:
			// qq分享
			shareFriendUtils.shareQQ();
			break;
		case R.id.iv_sina:
			// 新浪分享
			shareFriendUtils.shareSina();
			break;
		// case R.id.iv_QQ_xin:
		// // qq分享
		// shareFriendUtils.shareQQ();
		// break;
		// case R.id.iv_sina_xin:
		// // 新浪分享
		// shareFriendUtils.shareSina();
		// break;

		default:
			break;
		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		try {
			if (player != null) {
				player.release();
				player = null;
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	private void showPopupWindow() {
		if (contentView == null) {
			contentView = View.inflate(getApplicationContext(), R.layout.layout_share, null);
		}
		contentView.setBackgroundResource(R.color.BLACK);
		window = new PopupWindow(contentView, LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

		// 参数1 爹是谁 挂载的对象 参数2
		int[] location = new int[2]; // 现在数据里面没有值
		// 获取到每个条目view对象的具体位置
		ll_bottom.getLocationInWindow(location);// 往数组里面写入 x和y两个值
		int x = location[0];
		int y = location[1];

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(true);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(ll_bottom, Gravity.LEFT | Gravity.BOTTOM, 0, 0);// 在代码中出现的单位
		// window. showAsDropDown(this.findViewById(R.id.rl_bottom), 0, 0);
		TranslateAnimation translate = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f,
				Animation.RELATIVE_TO_PARENT, 1.0f, Animation.RELATIVE_TO_SELF, 0f);
		translate.setDuration(250);
		translate.setFillAfter(true);
		contentView.startAnimation(translate);
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
		tv_cancle.setOnClickListener(this);
		iv_wechat.setOnClickListener(this);
		iv_friend_cricle.setOnClickListener(this);
		iv_QQ.setOnClickListener(this);
		iv_sina.setOnClickListener(this);
	}

	// 友盟分享回掉代码
	// 6.1 配置SSO授权回调
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		/** 使用SSO授权必须添加如下代码 */
		UMSsoHandler ssoHandler = mController.getConfig().getSsoHandler(requestCode);
		if (ssoHandler != null) {
			ssoHandler.authorizeCallBack(requestCode, resultCode, data);
		}
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
