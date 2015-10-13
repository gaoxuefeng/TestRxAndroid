//package cn.com.ethank.yunge.app.remotecontrol;
//
//import java.io.File;
//import java.util.HashMap;
//import java.util.Map;
//
//import android.app.Activity;
//import android.app.Fragment;
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.content.IntentFilter;
//import android.net.Uri;
//import android.os.Bundle;
//import android.os.CountDownTimer;
//import android.view.Gravity;
//import android.view.LayoutInflater;
//import android.view.MotionEvent;
//import android.view.View;
//import android.view.View.OnClickListener;
//import android.view.View.OnLongClickListener;
//import android.view.View.OnTouchListener;
//import android.view.ViewGroup;
//import android.widget.Button;
//import android.widget.ImageView;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//import cn.com.ethank.yunge.R;
//import cn.com.ethank.yunge.app.catering.activity.MenuActivity;
//import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
//import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
//import cn.com.ethank.yunge.app.remotecontrol.interactcontrl.InteractPopUpWindows;
//import cn.com.ethank.yunge.app.remotecontrol.interactcontrl.SendPictureActivity;
//import cn.com.ethank.yunge.app.remotecontrol.lightcontrol.LightPopUpWindows;
//import cn.com.ethank.yunge.app.remotecontrol.requestnetwork.RequestBoxControl;
//import cn.com.ethank.yunge.app.remotecontrol.sing.SingPopUpWindows;
//import cn.com.ethank.yunge.app.util.Constants;
//import cn.com.ethank.yunge.app.util.SDCardPathUtil;
//import cn.com.ethank.yunge.app.util.ToastUtil;
//
//public class ControlFragment extends Fragment implements OnClickListener, OnTouchListener, OnLongClickListener {
//
//	private ImageView iv_contron_hd;
//	private ImageView iv_contron_cd;
//	private ImageView iv_contron_cx;
//	private ImageView iv_contron_dg;
//	private ImageView iv_contron_fw;
//	private Activity context;
//	// 切歌
//	private Button bt_change_song;
//	// 重唱
//	private TextView tv_sing_again;
//	private TextView tv_mute;
//	private TextView tv_play_pause;
//	private TextView tv_accompnaiment_all;
//	private Button bt_microphone_minus;
//	private Button bt_microphone_plus;
//	private Button bt_falling_tone;
//	private Button bt_rising_tone;
//	private Button bt_accompaniment_minus;
//	private Button bt_accompaniment_plus;
//	private RelativeLayout rl_connect_room;
//	private String hintUnBinded = "还没绑定房间,点此立即绑定吧";
//	private String hintBinded = "已经绑定房间,长按断开";
//	private TextView tv_connect_room;
//	private LightPopUpWindows myLightPopup;
//	private View pop_light_layout;
//	private RelativeLayout rl_control;
//	private View pop_sing_layout;
//	private SingPopUpWindows mySingPopup;
//	private Intent intent;
//	private ViewGroup activity_interact;
//	private InteractPopUpWindows interactPopUpWindows;
//	private final int IMAGE_CAPTURE = 500;
//	/**
//	 * 表示选择的是相册--1
//	 */
//	private final int IMAGE_MEDIA = 501;
//	private TimeCount timeCount;
//
//	@Override
//	public void onResume() {
//		super.onResume();
//		try {
//			if (Constants.isBinded()) {
//				tv_connect_room.setText(hintBinded);
//			} else {
//				tv_connect_room.setText(hintUnBinded);
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
//
//	@Override
//	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
//		System.gc();
//		View view = inflater.inflate(R.layout.fragment_control_new, container, false);
//		context = getActivity();
//		initView(view);
//		initPopLightView();
//		initPopSingView();
//		initInteractView();
//		registerBinderReceive();
//		return view;
//	}
//
//	/**
//	 * 注册广播
//	 */
//	private void registerBinderReceive() {
//		BindAndUnBindReceive bindAndUnBindReceive = new BindAndUnBindReceive();
//		IntentFilter filter = new IntentFilter();
//		filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
//		filter.addAction(Constants.UNBIND_RECEIVED_ACTION);
//		getActivity().registerReceiver(bindAndUnBindReceive, filter);
//	}
//
//	private void initInteractView() {
//		activity_interact = (ViewGroup) getActivity().getWindow().getLayoutInflater().inflate(R.layout.activity_interact, null, false);// 弹出窗口包含的视图
//		interactPopUpWindows = new InteractPopUpWindows(getActivity(), activity_interact, ControlFragment.this);
//	}
//
//	@Override
//	public void onStart() {
//		super.onStart();
//	}
//
//	/**
//	  灯光效果切换页面
//	 */
//	private void initPopLightView() {
//		pop_light_layout = getActivity().getWindow().getLayoutInflater().inflate(R.layout.pop_light_layout, null, false);// 弹出窗口包含的视图
//		myLightPopup = new LightPopUpWindows(getActivity(), pop_light_layout);
//
//	}
//
//	/**
//	 * 唱效切换
//	 */
//	private void initPopSingView() {
//		pop_sing_layout = getActivity().getWindow().getLayoutInflater().inflate(R.layout.pop_sing_layout, null, false);// 弹出窗口包含的视图
//		mySingPopup = new SingPopUpWindows(getActivity(), pop_sing_layout);
//
//	}
//
//	private void initView(View view) {
//
//		rl_control = (RelativeLayout) view.findViewById(R.id.rl_control);
//		// 五个圆圈按钮
//		// 互动
//		iv_contron_hd = (ImageView) view.findViewById(R.id.iv_contron_hd);
//		// 餐点
//		iv_contron_cd = (ImageView) view.findViewById(R.id.iv_contron_cd);
//		// 唱效
//		iv_contron_cx = (ImageView) view.findViewById(R.id.iv_contron_cx);
//		// 灯光
//		iv_contron_dg = (ImageView) view.findViewById(R.id.iv_contron_dg);
//		// 服务
//		iv_contron_fw = (ImageView) view.findViewById(R.id.iv_contron_fw);
//
//		iv_contron_hd.setOnClickListener(this);
//		iv_contron_cd.setOnClickListener(this);
//		iv_contron_cx.setOnClickListener(this);
//		iv_contron_dg.setOnClickListener(this);
//		iv_contron_fw.setOnClickListener(this);
//
//		// iv_contron_hd.setOnTouchListener(this);
//		// iv_contron_cd.setOnTouchListener(this);
//		// 切歌
//		bt_change_song = (Button) view.findViewById(R.id.bt_change_song);
//		bt_change_song.setOnClickListener(this);
//
//		// 静音,重唱,播停,原伴
//		tv_sing_again = (TextView) view.findViewById(R.id.tv_sing_again);
//		tv_mute = (TextView) view.findViewById(R.id.tv_mute);
//		tv_play_pause = (TextView) view.findViewById(R.id.tv_play_pause);
//		tv_accompnaiment_all = (TextView) view.findViewById(R.id.tv_accompnaiment_all);
//
//		tv_sing_again.setOnClickListener(this);
//		tv_mute.setOnClickListener(this);
//		tv_play_pause.setOnClickListener(this);
//		tv_accompnaiment_all.setOnClickListener(this);
//
//		// 麦克风+,-. 降调,升调,伴奏+,伴奏-
//		bt_microphone_minus = (Button) view.findViewById(R.id.bt_microphone_minus);
//		bt_microphone_plus = (Button) view.findViewById(R.id.bt_microphone_plus);
//		bt_microphone_minus.setOnClickListener(this);
//		bt_microphone_plus.setOnClickListener(this);
//
//		bt_falling_tone = (Button) view.findViewById(R.id.bt_falling_tone);
//		bt_rising_tone = (Button) view.findViewById(R.id.bt_rising_tone);
//		bt_falling_tone.setOnClickListener(this);
//		bt_rising_tone.setOnClickListener(this);
//
//		bt_accompaniment_minus = (Button) view.findViewById(R.id.bt_accompaniment_minus);
//		bt_accompaniment_plus = (Button) view.findViewById(R.id.bt_accompaniment_plus);
//		bt_accompaniment_minus.setOnClickListener(this);
//		bt_accompaniment_plus.setOnClickListener(this);
//		// 连接房间
//		rl_connect_room = (RelativeLayout) view.findViewById(R.id.rl_connect_room);
//		rl_connect_room.setOnClickListener(this);
//		rl_connect_room.setOnLongClickListener(this);
//		tv_connect_room = (TextView) view.findViewById(R.id.tv_connect_room);
//		if (Constants.isBinded()) {
//			tv_connect_room.setText(hintBinded);
//		} else {
//			tv_connect_room.setText(hintUnBinded);
//		}
//	}
//
//	
//
//	@Override
//	public void onAttach(Activity activity) {
//		super.onAttach(activity);
//	
//	}
//
//	@Override
//	public void onDetach() {
//		super.onDetach();
//	}
//
//	public interface OnFragmentInteractionListener {
//		public void onFragmentInteraction(Uri uri);
//	}
//
//	@Override
//	public void onClick(View view) {
//		if(!Constants.isClickAble()){
//			return;
//		}else {
//			Constants.setUnClickAble();
//		}
//		
//		if (!verifyIsLogin()) {
//			return;
//		}
//		if (!Constants.isBinded()) {
//			bindBox();
//			ToastUtil.show("请先绑定房间");
//			return;
//		}
//		switch (view.getId()) {
//		case R.id.iv_contron_hd:
//			ToastUtil.show("互动");
//			if (interactPopUpWindows != null) {
//				interactPopUpWindows.showAtLocation(rl_control, Gravity.TOP, 0, 0);
//			}
//
//			break;
//		case R.id.iv_contron_cd:
//			ToastUtil.show("餐点");
//			iv_contron_cd.getWidth();
//			iv_contron_cd.getHeight();
//
//			intent = new Intent(getActivity(), MenuActivity.class);
//			startActivity(intent);
//			break;
//		case R.id.iv_contron_cx:
//			ToastUtil.show("唱效");
//			if (mySingPopup != null && !mySingPopup.isShowing() && pop_sing_layout != null) {
//				mySingPopup.showAtLocation(rl_control, Gravity.TOP, 0, 0);
//			} else {
//				initPopSingView();
//				mySingPopup.showAtLocation(rl_control, Gravity.TOP, 0, 0);
//			}
//			break;
//		case R.id.iv_contron_dg:
//			ToastUtil.show("灯光");
//			if (myLightPopup != null && !myLightPopup.isShowing() && pop_light_layout != null) {
//				myLightPopup.showAtLocation(rl_control, Gravity.TOP, 0, 0);
//			} else {
//				initPopLightView();
//				myLightPopup.showAtLocation(rl_control, Gravity.TOP, 0, 0);
//			}
//			break;
//		case R.id.iv_contron_fw:
//
//			int i = iv_contron_fw.getBackground().getLevel();
//			if (i == 0) {
//				timeCount = new TimeCount(1000 * 60 * 10, 1000);
//				iv_contron_fw.getBackground().setLevel(1);
//			} else {
//				ToastUtil.show("服务已呼叫");
//				// iv_contron_fw.getBackground().setLevel(0);
//			}
//			break;
//		// 切歌
//		case R.id.bt_change_song:// 101
//			ToastUtil.show("切歌");
//			requestControl(ControlCode.change_song_code);
//			break;
//
//		// 静音,重唱,播停,原伴
//		case R.id.tv_sing_again:
//			ToastUtil.show("重唱");
//			requestControl(ControlCode.play_again_code);
//			break;
//		case R.id.tv_mute:
//			ToastUtil.show("静音");
//			requestControl(ControlCode.mute_code);
//			break;
//		case R.id.tv_play_pause:
//			ToastUtil.show("播/停");
//			requestControl(ControlCode.play_pause_code);
//			break;
//		case R.id.tv_accompnaiment_all:
//			ToastUtil.show("原/伴");
//			requestControl(ControlCode.accompnaiment_all_code);
//			break;
//		// // 麦克风+,-. 降调,升调,伴奏+,伴奏-
//		case R.id.bt_microphone_minus:
//			ToastUtil.show("麦克风-");
//			break;
//		case R.id.bt_microphone_plus:
//			ToastUtil.show("麦克风+");
//			break;
//		case R.id.bt_falling_tone:
//			ToastUtil.show("降调");
//			break;
//		case R.id.bt_rising_tone:
//			ToastUtil.show("升调");
//			break;
//		case R.id.bt_accompaniment_minus:
//			ToastUtil.show("伴奏-");
//			requestControl(ControlCode.accompaniment_minus_code);
//			break;
//		case R.id.bt_accompaniment_plus:
//			ToastUtil.show("伴奏+");
//			requestControl(ControlCode.accompaniment_plus_code);
//			break;
//		case R.id.rl_connect_room:
//			if (Constants.isBinded()) {
//				ToastUtil.show("已经连接房间,长按断开连接");
//			} else {
//				bindBox();
//			}
//
//			break;
//		default:
//			break;
//		}
//
//	}
//
//	/**
//	 * 请求控制
//	 * 
//	 * @param controlType
//	 */
//	private void requestControl(String controlType) {
//		HashMap<String, String> hashMap = new HashMap<String, String>();
//		hashMap.put("boxToken", ControlCode.getBoxToken());
//		hashMap.put("controlType", controlType);
//		final int controlId = Integer.parseInt(controlType);
//		RequestBoxControl requestBoxControl = new RequestBoxControl(context, hashMap);
//		requestBoxControl.start(new RequestCallBack() {
//
//			@Override
//			public void onLoaderFinish(Map<String, ?> map) {
//				controlToast(controlId, true);
//
//			}
//
//			@Override
//			public void onLoaderFail() {
//				controlToast(controlId, false);
//			}
//		});
//
//	}
//
//	private void controlToast(int controlId, boolean success) {
//		switch (controlId) {
//		case 101:// 切歌
//			if (success) {
//				ToastUtil.show("切歌成功");
//			} else {
//				ToastUtil.show("切歌失败");
//			}
//			break;
//		case 102:// 原／伴唱
//			if (success) {
//				ToastUtil.show("原／伴唱切换成功");
//			} else {
//				ToastUtil.show("原／伴唱切换失败");
//			}
//			break;
//		case 103:// 静音／取消静音
//			if (success) {
//				ToastUtil.show("静音／取消静音成功");
//			} else {
//				ToastUtil.show("静音／取消静音失败");
//			}
//			break;
//		case 104:// 伴奏音＋
//			if (success) {
//				ToastUtil.show("伴奏音＋成功");
//			} else {
//				ToastUtil.show("伴奏音＋失败");
//			}
//			break;
//		case 105:// 伴奏音 －
//			if (success) {
//				ToastUtil.show("伴奏音 －成功");
//			} else {
//				ToastUtil.show("伴奏音 －失败");
//			}
//			break;
//		case 106:// 暂停：106继续播放
//			if (success) {
//				ToastUtil.show("暂停/播放切换成功");
//			} else {
//				ToastUtil.show("暂停/播放切换失败");
//			}
//			break;
//		case 107:// 暂停：107重唱
//			if (success) {
//				ToastUtil.show("重唱切换成功");
//			} else {
//				ToastUtil.show("重唱切换失败");
//			}
//			break;
//
//		default:
//			break;
//		}
//	}
//
//	private void bindBox() {
//		Intent intent;
//		ToastUtil.show("连接房间+");
//		intent = new Intent(context, MipcaActivityCapture.class);
//		startActivityForResult(intent, 10);
//	}
//
//	private boolean verifyIsLogin() {
//		if (Constants.getLoginState()) {
//			// 已经登陆成功
//			return true;
//		} else {
//			toLogin();
//			return false;
//		}
//	}
//
//	private void toLogin() {
//		Intent intent = new Intent(context, LoginActivity.class);
//		startActivityForResult(intent, Constants.LOGIN_REQUEST_CODE_RETURN);
//	}
//
//	@Override
//	public boolean onTouch(View v, MotionEvent event) {
//		switch (v.getId()) {
//		case R.id.iv_contron_hd:
//
//			break;
//
//		default:
//			break;
//		}
//		return false;
//	};
//
//	@Override
//	public boolean onLongClick(View v) {
//		switch (v.getId()) {
//		case R.id.rl_connect_room:
//			if (!Constants.getLoginState()) {
//				toLogin();
//				return true;
//			}
//			if (Constants.isBinded()) {
//				Constants.setBinded(false);
//				ToastUtil.show("已经断开房间");
//				tv_connect_room.setText(hintUnBinded);
//			} else {
//				bindBox();
//			}
//			return true;
//		default:
//			break;
//		}
//		return false;
//	}
//
//	@Override
//	public void onActivityResult(int requestCode, int resultCode, Intent data) {
//		super.onActivityResult(requestCode, resultCode, data);
//		switch (requestCode) {
//		case 10:
//			// 这儿code不知道为什么==0
//			if (Constants.isBinded()) {
//				tv_connect_room.setText(hintBinded);
//			} else {
//				tv_connect_room.setText(hintUnBinded);
//			}
//			break;
//		case IMAGE_CAPTURE:
//			if (resultCode == -1) {
//				ToastUtil.show("拍照成功");
//				String pictureRootFile = SDCardPathUtil.getImagePath();
//				File picFile = new File(pictureRootFile, "temppic.jpg");
//				Intent intent = new Intent(context, SendPictureActivity.class);
//				intent.putExtra("imagePath", picFile.getPath());
//				startActivity(intent);
//
//			}
//			break;
//		case IMAGE_MEDIA:
//			if (resultCode == -1) {
//				if (data.getData() == null) {
//				} else {
//					// 获得图片的uri
//					Uri uri = data.getData();
//					if (uri != null) {
//
//						String imagePath = SDCardPathUtil.getImageAbsolutePath(getActivity(), uri);
//						ToastUtil.show("选择照片成功");
//						if (imagePath == null || imagePath.isEmpty()) {
//							return;
//						}
//						Intent intent = new Intent(context, SendPictureActivity.class);
//						intent.putExtra("imagePath", imagePath);
//						startActivity(intent);
//					}
//
//				}
//				break;
//
//			}
//		}
//	}
//
//	 //定义一个倒计时的内部类 
//	class TimeCount extends CountDownTimer {
//		public TimeCount(long millisInFuture, long countDownInterval) {
//			super(millisInFuture, countDownInterval);// 参数依次为总时长,和计时的时间间隔
//		}
//
//		@Override
//		public void onFinish() {
//			iv_contron_fw.getBackground().setLevel(0);
//			iv_contron_fw.setClickable(true);
//		}
//
//		@Override
//		public void onTick(long millisUntilFinished) {
//			iv_contron_fw.setClickable(false);
//			iv_contron_fw.getBackground().setLevel(1);
//		}
//	}
//
//	class BindAndUnBindReceive extends BroadcastReceiver {
//
//		@Override
//		public void onReceive(Context context, Intent intent) {
//			try {
//				if (intent.getAction().equals(Constants.UNBIND_RECEIVED_ACTION)) {
//
//					// 解绑房间
//					if (Constants.isBinded()) {
//						tv_connect_room.setText(hintBinded);
//					} else {
//						tv_connect_room.setText(hintUnBinded);
//					}
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//
//		}
//
//	}
//}
