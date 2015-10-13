package cn.com.ethank.yunge.app.startup;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.widget.ImageView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.room.request.RequestRoomInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.GetRoomInfoRequest;
import cn.com.ethank.yunge.app.util.RequestLoactionCity;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.jpush.android.api.JPushInterface;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.sys.SysInfo;
import com.umeng.analytics.MobclickAgent;

public class LoadingActivity extends BaseActivity {
	public static List<BoxDetail> myRooms = new ArrayList<BoxDetail>();
	private GetRoomInfoRequest getRoomInfoRequest;
	private ImageView bgiv_id, logoiv_id;
	private RequestLoactionCity requestLoactionCity;
	private boolean isFirstTimeStart = false;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_loading);
		getIsFirstTimeStart();
		bgiv_id = (ImageView) findViewById(R.id.bgiv_id);
		logoiv_id = (ImageView) findViewById(R.id.logoiv_id);

		if (Constants.getLoginState()) {
			if (Constants.isBinded()) {
				requestRoomInfo();
			} else {
				requestBoxList();
			}
		}
		// else {
		// }
		handler.sendEmptyMessageDelayed(-1, 1000);
		requestLocation();
	}

	private void requestLocation() {
		// 此处只是获取一遍,不管是否成功
		requestLoactionCity = new RequestLoactionCity();
		requestLoactionCity.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {

			}

			@Override
			public void onLoaderFail() {

			}
		});
	}

	private void requestRoomInfo() {

		HashMap<String, String> map = new HashMap<String, String>();

		map.put(SharePreferenceKeyUtil.reserveBoxId, Constants.getReserveBoxId());
		map.put(SharePreferenceKeyUtil.token, Constants.getToken());
		RequestRoomInfo requestRoomInfo = new RequestRoomInfo(getApplicationContext(), map, true);
		requestRoomInfo.start(new RequestCallBack() {
			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				BoxDetail boxDetail = (BoxDetail) map.get("data");
				if (boxDetail.getServiceDate() >= boxDetail.getRbEndTime()) {
					SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.boxInfo);
					SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.reserveBoxId);
					Constants.setBinded(false);
					requestBoxList();
				} else {
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo, JSONObject.toJSON(boxDetail).toString());
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, boxDetail.getReserveBoxId());
					Constants.setBinded(true);
					// handler.sendEmptyMessage(-1);
				}
			}

			@Override
			public void onLoaderFail() {
				// handler.sendEmptyMessageDelayed(-1, 500);
			}
		});
	}

	private void requestBoxList() {
		getRoomInfoRequest = new GetRoomInfoRequest(context);
		getRoomInfoRequest.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				String currentReserveBoxId = Constants.getReserveBoxId();
				if (myRooms.size() != 0) {
					if (!hasCurrentbox(currentReserveBoxId)) {
						// TODO
						Collections.sort(myRooms);
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, myRooms.get(0).getReserveBoxId());
					}
				}
				if (!Constants.isBinded()) {
					Constants.setBinded(true);
				}
				// handler.sendEmptyMessageDelayed(-1, 800);
			}

			private boolean hasCurrentbox(String currentReserveBoxId) {
				for (int i = 0; i < myRooms.size(); i++) {
					if (currentReserveBoxId.equals(myRooms.get(i).getReserveBoxId())) {
						return true;
					} else if (Constants.getScanBoxId().equals(myRooms.get(i).getReserveBoxId())) {
						return true;
					}
				}
				return false;
			}

			@Override
			public void onLoaderFail() {

				/*
				 * SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.
				 * reserveBoxId); if (Constants.isBinded()) {
				 * Constants.setBinded(false); }
				 */
				if (!TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.reserveBoxId))) {
					if (Constants.isBinded()) {
						Constants.setBinded(true);
					}
				} else if (!TextUtils.isEmpty(Constants.getScanBoxId())) {
					if (Constants.isBinded()) {
						Constants.setBinded(true);
					}
				} else {
					if (Constants.isBinded()) {
						Constants.setBinded(false);
					}
				}
				// handler.sendEmptyMessageDelayed(-1, 800);
			}
		});
	}

	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			finish();
			animhand.postAtTime(run2, 1000);
			overridePendingTransition(R.anim.fade, R.anim.mywave_scale);
			// logoiv_id.setVisibility(View.GONE);
			// CleanLogohand.postAtTime(CleanLogohandrun, 1500);
			// AlphaAnimation anim = new AlphaAnimation(1.0f, 0.0f);
			// anim.setDuration(400);
			// logoiv_id.setAnimation(anim);
			// logoiv_id.startAnimation(anim);
			// AnimationEndCallBack.setAnimationCallBack(anim, new
			// RefreshUiInterface() {
			// @Override
			// public void refreshUi(Object result) {
			// logoiv_id.setVisibility(View.GONE);
			// }
			// });

		};
	};

	Handler animhand = new Handler();
	Runnable run2 = new Runnable() {

		@Override
		public void run() {
			if (isFirstTimeStart) {
				Intent intent = new Intent(LoadingActivity.this, LoadingImagesActivity.class);
				startActivity(intent);
			} else {
				Intent intent = new Intent(LoadingActivity.this, MainTabActivity.class);
				startActivity(intent);
			}

		}
	};
	Handler CleanLogohand = new Handler();
	Runnable CleanLogohandrun = new Runnable() {

		@Override
		public void run() {
			logoiv_id.setVisibility(View.GONE);
			;
		}
	};

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	protected void onResume() {
		super.onResume();
		JPushInterface.onResume(this);
		MobclickAgent.onResume(this);
	}

	@Override
	protected void onPause() {
		super.onPause();
		JPushInterface.onPause(this);
		MobclickAgent.onPause(this);
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {

	}

	private void getIsFirstTimeStart() {
		int lastCode = SharePreferencesUtil.getIntData(SharePreferenceKeyUtil.lastTimeBuildCode);
		SysInfo sysInfo = CoyoteSystem.getCurrent().getSysInfo();
		int currentCode = sysInfo.getAppVersionCode();
		if (currentCode > lastCode) {
			isFirstTimeStart = true;
		}
	}
}