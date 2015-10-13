package cn.com.ethank.yunge.app.remotecontrol;

import java.io.IOException;
import java.util.Map;
import java.util.Vector;

import android.graphics.Bitmap;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.os.Bundle;
import android.os.Handler;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestConnectBanding;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.mining.app.zxing.camera.CameraManager;
import cn.com.mining.app.zxing.decoding.CaptureActivityHandler;
import cn.com.mining.app.zxing.decoding.InactivityTimer;
import cn.com.mining.app.zxing.view.ViewfinderView;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.Result;

/**
 * 扫描二维码
 * 
 * @author Gao Xuefeng
 * 
 */
public class MipcaActivityCapture extends BaseActivity implements Callback, OnClickListener {

	private CaptureActivityHandler handler;
	private ViewfinderView viewfinderView;
	private boolean hasSurface;
	private Vector<BarcodeFormat> decodeFormats;
	private String characterSet;
	private InactivityTimer inactivityTimer;
	private boolean playBeep;
	private boolean vibrate;
	private CheckBox cb_cameralight;
	private CameraManager cameraManager;
	private ImageView iv_back;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_capture);
		CameraManager.init(this);
		cameraManager = CameraManager.get();
		viewfinderView = (ViewfinderView) findViewById(R.id.viewfinder_view);
		iv_back = (ImageView) findViewById(R.id.iv_back);
		iv_back.setOnClickListener(this);
		cb_cameralight = (CheckBox) findViewById(R.id.cb_cameralight);
		if (!cameraManager.getSupportLight()) {
			// cb_cameralight.setVisibility(View.GONE);
		}
		hasSurface = false;
		inactivityTimer = new InactivityTimer(this);
		cb_cameralight.setOnCheckedChangeListener(new OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				try {
					if (!isChecked) {
						cameraManager.openLight();
					} else {
						cameraManager.offLight();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
		});
	}

	@Override
	public void onResume() {
		super.onResume();

		SurfaceView surfaceView;
		surfaceView = (SurfaceView) findViewById(R.id.preview_view);
		SurfaceHolder surfaceHolder = surfaceView.getHolder();
		if (hasSurface) {
			initCamera(surfaceHolder);
		} else {
			surfaceHolder.addCallback(this);
			surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
		}
		decodeFormats = null;
		characterSet = null;

		playBeep = true;
		AudioManager audioService = (AudioManager) getSystemService(AUDIO_SERVICE);
		if (audioService.getRingerMode() != AudioManager.RINGER_MODE_NORMAL) {
			playBeep = false;
		}
		vibrate = true;

	}

	@Override
	public void onPause() {
		super.onPause();
		if (handler != null) {
			handler.quitSynchronously();
			handler = null;
		}
		CameraManager.get().closeDriver();
	}

	@Override
	public void onDestroy() {
		inactivityTimer.shutdown();
		super.onDestroy();
		ProgressDialogUtils.dismiss();
	}

	public void handleDecode(Result result, Bitmap barcode) {
		inactivityTimer.onActivity();
		String resultString = result.getText();
		if (resultString.equals("")) {
			ToastUtil.show("请扫描指定的二维码!");
			finish();
		} else {
			// 扫码成功,连接房间
			if (resultString != null && resultString.split("\\|").length == 3) {
				ProgressDialogUtils.show(this);
				final String[] roomData = resultString.split("\\|");
				RequestConnectBanding connectBanding = new RequestConnectBanding(this, resultString);

				connectBanding.start(new RequestCallBack() {

					@Override
					public void onLoaderFinish(Map<String, ?> map) {
						// 绑定房间完成

					}

					@Override
					public void onLoaderFail() {
						SharePreferencesUtil.saveBooleanData(SharePreferenceKeyUtil.isBinded, false);
						// ToastUtil.show("连接房间失败");
						finish();
					}
				});
			} else {
				ToastUtil.show("请扫描指定的二维码");
				finish();
			}

		}
		finish();
	}

	private void initCamera(SurfaceHolder surfaceHolder) {
		try {
			CameraManager.get().openDriver(surfaceHolder);
		} catch (IOException ioe) {
			return;
		} catch (RuntimeException e) {
			return;
		}
		if (handler == null) {
			handler = new CaptureActivityHandler(this, decodeFormats, characterSet);
		}
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {

	}

	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		if (!hasSurface) {
			hasSurface = true;
			initCamera(holder);
		}

	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		hasSurface = false;

	}

	public ViewfinderView getViewfinderView() {
		return viewfinderView;
	}

	public Handler getHandler() {
		return handler;
	}

	public void drawViewfinder() {
		viewfinderView.drawViewfinder();

	}

	private static final long VIBRATE_DURATION = 200L;

	/**
	 * When the beep has finished playing, rewind to queue up another one.
	 */
	private final OnCompletionListener beepListener = new OnCompletionListener() {
		public void onCompletion(MediaPlayer mediaPlayer) {
			mediaPlayer.seekTo(0);
		}
	};

	public boolean onKeyDown(int keyCode, android.view.KeyEvent event) {
		if (keyCode == android.view.KeyEvent.KEYCODE_BACK) {
			finish();
		}
		return true;
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.iv_back:
			finish();
			break;

		default:
			break;
		}

	};

}