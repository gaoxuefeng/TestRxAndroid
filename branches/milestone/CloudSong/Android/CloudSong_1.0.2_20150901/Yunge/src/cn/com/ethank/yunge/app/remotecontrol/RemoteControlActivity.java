package cn.com.ethank.yunge.app.remotecontrol;

import java.util.HashMap;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout.LayoutParams;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.RoomBaseActivity;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.remotecontrol.lightcontrol.LightPopUpWindows;
import cn.com.ethank.yunge.app.remotecontrol.requestnetwork.RequestBoxControl;
import cn.com.ethank.yunge.app.remotecontrol.sing.SingPopUpWindows;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.umeng.analytics.MobclickAgent;

public class RemoteControlActivity extends RoomBaseActivity implements OnClickListener {
	private ImageView iv_remote_btn_bg;
	private ImageView iv_remote_change_song;
	private ImageView iv_remote_mute;
	private ImageView iv_remote_pause;
	private ImageView iv_remote_resing;
	private ImageView iv_remote_singer;
	private ImageView iv_remote_mic_down;
	private ImageView iv_remote_mic_up;
	private ImageView iv_remote_tone_down;
	private ImageView iv_remote_tone_up;
	private ImageView iv_remote_accompany_down;
	private ImageView iv_remote_accompany_up;
	private ImageView iv_remote_light;
	private ImageView iv_remote_effect;
	private ImageView iv_remote_record;
	private ImageView iv_remote_service;
	private View pop_light_layout;
	private LightPopUpWindows myLightPopup;
	private View pop_sing_layout;
	private SingPopUpWindows mySingPopup;
	private TimeCount timeCount;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_remote_control);
		initTitle();
		initView();
		handler.sendEmptyMessageDelayed(-1, 1000);
	}

	private void initPopSingView() {
		if (pop_sing_layout == null || mySingPopup == null) {
			pop_sing_layout = getWindow().getLayoutInflater().inflate(R.layout.pop_sing_layout, null, false);// 弹出窗口包含的视图
			mySingPopup = new SingPopUpWindows(this, pop_sing_layout);
		}

	}

	private void initPopLightView() {
		//
		if (pop_light_layout == null || myLightPopup == null) {
			pop_light_layout = getWindow().getLayoutInflater().inflate(R.layout.pop_light_layout, null, false);// 弹出窗口包含的视图
			myLightPopup = new LightPopUpWindows(this, pop_light_layout);
		}

	}

	private void initTitle() {
		title.showBtnBack(false);
		title.showBtnFunction(true);
		title.setTitle("遥控");
		title.showBottomLine(false);
		title.setBtnFunctionImage(R.drawable.remote_close_btn);
		title.setOnClickListener(this);
	}

	private void initView() {
		// 上面5个按钮
		iv_remote_btn_bg = (ImageView) findViewById(R.id.iv_remote_btn_bg);
		// 切歌
		iv_remote_change_song = (ImageView) findViewById(R.id.iv_remote_change_song);
		iv_remote_change_song.setOnClickListener(this);
		// 静音
		iv_remote_mute = (ImageView) findViewById(R.id.iv_remote_mute);
		iv_remote_mute.setOnClickListener(this);
		// 暂停
		iv_remote_pause = (ImageView) findViewById(R.id.iv_remote_pause);
		iv_remote_pause.setOnClickListener(this);
		// 重唱
		iv_remote_resing = (ImageView) findViewById(R.id.iv_remote_resing);
		iv_remote_resing.setOnClickListener(this);
		// 原伴
		iv_remote_singer = (ImageView) findViewById(R.id.iv_remote_singer);
		iv_remote_singer.setOnClickListener(this);
		initViewWidthAndHeight();

		// 加减6个按钮
		// 麦克风
		iv_remote_mic_down = (ImageView) findViewById(R.id.iv_remote_mic_down);
		iv_remote_mic_down.setOnClickListener(this);
		iv_remote_mic_up = (ImageView) findViewById(R.id.iv_remote_mic_up);
		iv_remote_mic_up.setOnClickListener(this);
		// 升降调
		iv_remote_tone_down = (ImageView) findViewById(R.id.iv_remote_tone_down);
		iv_remote_tone_down.setOnClickListener(this);
		iv_remote_tone_up = (ImageView) findViewById(R.id.iv_remote_tone_up);
		iv_remote_tone_up.setOnClickListener(this);
		// 伴奏
		iv_remote_accompany_down = (ImageView) findViewById(R.id.iv_remote_accompany_down);
		iv_remote_accompany_down.setOnClickListener(this);
		iv_remote_accompany_up = (ImageView) findViewById(R.id.iv_remote_accompany_up);
		iv_remote_accompany_up.setOnClickListener(this);

		// 最下面4个按钮
		// 灯光
		iv_remote_light = (ImageView) findViewById(R.id.iv_remote_light);
		iv_remote_light.setOnClickListener(this);
		// 唱效
		iv_remote_effect = (ImageView) findViewById(R.id.iv_remote_effect);
		iv_remote_effect.setOnClickListener(this);
		// 录音
		iv_remote_record = (ImageView) findViewById(R.id.iv_remote_record);
		iv_remote_record.setOnClickListener(this);
		// 服务
		iv_remote_service = (ImageView) findViewById(R.id.iv_remote_service);
		iv_remote_service.setOnClickListener(this);
	}

	private void initViewWidthAndHeight() {
		setViewPosition(iv_remote_btn_bg, 720, 525, 0, 0);
		setViewPosition(iv_remote_change_song, 288, 288, 194, 186);
		setViewPosition(iv_remote_mute, 99, 99, 43, 230);
		setViewPosition(iv_remote_pause, 99, 99, 514, 230);
		setViewPosition(iv_remote_resing, 147, 147, 128, 26);// 重唱
		setViewPosition(iv_remote_singer, 147, 147, 382, 24);

	}

	private void setViewPosition(ImageView view, int designWidth, int designHeight, int maginLeft, int maginTop) {
		int screenWidth = UICommonUtil.getScreenWidthPixels(context);
		LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();
		layoutParams.width = (int) (0.5f + screenWidth * designWidth * 1f / 720);
		layoutParams.height = (int) (0.5f + screenWidth * designHeight * 1f / 720);
		layoutParams.leftMargin = (int) (0.5f + screenWidth * maginLeft * 1f / 640);
		layoutParams.topMargin = (int) (0.5f + screenWidth * maginTop * 1f / 640);
		view.setLayoutParams(layoutParams);
	}

	@Override
	public void onClick(View view) {
		if (!verifyIsLogin()) {
			return;
		}
		if (!Constants.isBinded()) {
			bindBox();
			ToastUtil.show("请先绑定房间");
			return;
		}
		switch (view.getId()) {
		case R.id.title_function:
			finish();
			break;
		// 5个控制按钮
		case R.id.iv_remote_change_song:
			ToastUtil.show("切歌");
			requestControl(ControlCode.change_song_code);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlNext");
			break;
		case R.id.iv_remote_mute:
			ToastUtil.show("静音");
			requestControl(ControlCode.mute_code);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlMute");
			break;
		case R.id.iv_remote_resing:
			ToastUtil.show("重唱");
			requestControl(ControlCode.play_again_code);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlReplay");
			break;
		case R.id.iv_remote_singer:
			ToastUtil.show("原/伴");
			requestControl(ControlCode.accompnaiment_all_code);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlHarmy");
			break;
		case R.id.iv_remote_pause:
			ToastUtil.show("播/停");
			requestControl(ControlCode.play_pause_code);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlPause");
			break;
		// 6个加减按钮
		case R.id.iv_remote_mic_down:
			ToastUtil.show("麦克风-");
			break;
		case R.id.iv_remote_mic_up:
			ToastUtil.show("麦克风+");
			break;
		case R.id.iv_remote_tone_down:
			ToastUtil.show("降调");
			break;
		case R.id.iv_remote_tone_up:
			ToastUtil.show("升调");
			break;
		case R.id.iv_remote_accompany_down:
			ToastUtil.show("伴奏-");
			requestControl(ControlCode.accompaniment_minus_code);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlVolDown");
			break;
		case R.id.iv_remote_accompany_up:
			ToastUtil.show("伴奏+");
			requestControl(ControlCode.accompaniment_plus_code);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlVolUp");
			break;
		// 4个最下面按钮
		case R.id.iv_remote_light:
			ToastUtil.show("灯光");
			if (myLightPopup != null && !myLightPopup.isShowing() && pop_light_layout != null) {
				myLightPopup.showAtLocation(rl_base_layout, Gravity.TOP, 0, 0);
			} else {
				initPopLightView();
				myLightPopup.showAtLocation(rl_base_layout, Gravity.TOP, 0, 0);
			}
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlLight");
			break;
		case R.id.iv_remote_effect:
			ToastUtil.show("唱效");
			if (mySingPopup != null && !mySingPopup.isShowing() && pop_sing_layout != null) {
				mySingPopup.showAtLocation(rl_base_layout, Gravity.TOP, 0, 0);
			} else {
				initPopSingView();
				mySingPopup.showAtLocation(rl_base_layout, Gravity.TOP, 0, 0);
			}
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlMusictype");
			break;
		case R.id.iv_remote_record:

			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlRecord");
			break;
		case R.id.iv_remote_service:
			int i = iv_remote_service.getBackground().getLevel();
			if (i == 0) {
				timeCount = new TimeCount(1000 * 60 * 10, 1000);
				iv_remote_service.getBackground().setLevel(1);
				MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControlServe");
			} else {
				ToastUtil.show("服务已呼叫");
			}
			break;
		default:
			super.onClick(view);
			break;
		}
	}

	private boolean verifyIsLogin() {
		if (Constants.getLoginState()) {
			// 已经登陆成功
			return true;
		} else {
			toLogin();
			return false;
		}
	}

	private void toLogin() {
		Intent intent = new Intent(context, LoginActivity.class);
		startActivityForResult(intent, Constants.LOGIN_REQUEST_CODE_RETURN);
	}

	private void bindBox() {
		Intent intent;
		ToastUtil.show("连接房间+");
		intent = new Intent(context, MipcaActivityCapture.class);
		startActivityForResult(intent, 10);
	}

	// 定义一个倒计时的内部类
	class TimeCount extends CountDownTimer {
		public TimeCount(long millisInFuture, long countDownInterval) {
			super(millisInFuture, countDownInterval);// 参数依次为总时长,和计时的时间间隔
		}

		@Override
		public void onFinish() {
			iv_remote_service.getBackground().setLevel(0);
			iv_remote_service.setClickable(true);
		}

		@Override
		public void onTick(long millisUntilFinished) {
			iv_remote_service.setClickable(false);
			iv_remote_service.getBackground().setLevel(1);
		}
	}

	/**
	 * 请求控制
	 * 
	 * @param controlType
	 */
	private void requestControl(String controlType) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("boxToken", ControlCode.getBoxToken());
		hashMap.put("controlType", controlType);
		final int controlId = Integer.parseInt(controlType);
		RequestBoxControl requestBoxControl = new RequestBoxControl(context, hashMap);
		requestBoxControl.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				controlToast(controlId, true);

			}

			@Override
			public void onLoaderFail() {
				controlToast(controlId, false);
			}
		});

	}

	private void controlToast(int controlId, boolean success) {
		switch (controlId) {
		case 101:// 切歌
			if (success) {
				ToastUtil.show("切歌成功");
			} else {
				ToastUtil.show("切歌失败");
			}
			break;
		case 102:// 原／伴唱
			if (success) {
				ToastUtil.show("原／伴唱切换成功");
			} else {
				ToastUtil.show("原／伴唱切换失败");
			}
			break;
		case 103:// 静音／取消静音
			if (success) {
				ToastUtil.show("静音／取消静音成功");
			} else {
				ToastUtil.show("静音／取消静音失败");
			}
			break;
		case 104:// 伴奏音＋
			if (success) {
				ToastUtil.show("伴奏音＋成功");
			} else {
				ToastUtil.show("伴奏音＋失败");
			}
			break;
		case 105:// 伴奏音 －
			if (success) {
				ToastUtil.show("伴奏音 －成功");
			} else {
				ToastUtil.show("伴奏音 －失败");
			}
			break;
		case 106:// 暂停：106继续播放
			if (success) {
				ToastUtil.show("暂停/播放切换成功");
			} else {
				ToastUtil.show("暂停/播放切换失败");
			}
			break;
		case 107:// 暂停：107重唱
			if (success) {
				ToastUtil.show("重唱切换成功");
			} else {
				ToastUtil.show("重唱切换失败");
			}
			break;

		default:
			break;
		}

	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		if (myLightPopup != null && myLightPopup.isShowing()) {
			myLightPopup.dismiss();
		}
		if (mySingPopup != null && mySingPopup.isShowing()) {
			mySingPopup.dismiss();
		}

	}

	@Override
	public void finish() {
		super.finish();
		overridePendingTransition(R.anim.without_anim_out, R.anim.anim_to_bottom);
	}

	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			initPopLightView();
			initPopSingView();

		};
	};

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}
}
