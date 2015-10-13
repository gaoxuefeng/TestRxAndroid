package com.coyotelib.framework.network;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;

import com.coyotelib.core.network.INetworkStatus;

final class NetworkStatusImp implements INetworkStatus {

	private ConnectivityManager mConnManager;
	private boolean mWifiConnectedRecently;
	private boolean mIsTelCom;

	public NetworkStatusImp(Context context, boolean wifiConnectedRecently,
			boolean isTelcom) {

		Object o = context.getSystemService(Context.CONNECTIVITY_SERVICE);
		mConnManager = null == o ? null : (ConnectivityManager) o;

		mWifiConnectedRecently = wifiConnectedRecently;
		mIsTelCom = isTelcom;
	}

	@Override
	public boolean wifiAvailable() {
		try {
			if (null == mConnManager)
				return false;
			NetworkInfo ni = mConnManager
					.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
			return ni != null ? ni.getState() == State.CONNECTED : false;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}

	}

	@Override
	public boolean wwanAvailable() {
		try {
			if (null == mConnManager)
				return false;
			NetworkInfo ni = mConnManager
					.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
			return ni != null ? ni.getState() == State.CONNECTED : false;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public boolean isNetworkConnected() {
		try {
			if (null == mConnManager)
				return false;
			NetworkInfo networkInfo = mConnManager.getActiveNetworkInfo();
			return networkInfo != null && networkInfo.isConnected();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public boolean wifiConnectedRecently() {
		return mWifiConnectedRecently;
	}

	public void setWIFIConnectedRecently(boolean val) {
		mWifiConnectedRecently = val;
	}

	@Override
	public boolean isNetworkAvailableWhenCall() {
		if (isNetworkConnected()) {
			if (wifiAvailable())
				return true;
			// 电信不能同时打电话上网。
			return !mIsTelCom;
		}
		return false;
	}
}
