package com.coyotelib.framework.service;

import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.sys.CoyoteSystem;

public class PeriodicalTaskTimeKeeper {
	private long mPeriod;
	private long mWifiDelayTime;
	private String mTimeKeeperKey;
	private String mDeadLineKey;
	private boolean mRunInNonWifi;

	/**
	 * If WIFI connected recently, delay task execution time. Default is 12h
	 */
	public static final int DEFAULT_WIFI_DELAY_TIME = 12 * 60 * 60 * 1000;

	public PeriodicalTaskTimeKeeper(long period, String timeKeeperKey,
			long wifiDelayTime, boolean runInNonWifi) {
		mPeriod = period;
		mTimeKeeperKey = timeKeeperKey;
		mDeadLineKey = mTimeKeeperKey + "_deadline";
		mWifiDelayTime = wifiDelayTime;
		mRunInNonWifi = runInNonWifi;
	}

	public PeriodicalTaskTimeKeeper(long period, String timeKeeperKey) {
		this(period, timeKeeperKey, DEFAULT_WIFI_DELAY_TIME, true);
	}

	public PeriodicalTaskTimeKeeper(long period, String timeKeeperKey,
			boolean runInNonWifi) {
		this(period, timeKeeperKey, DEFAULT_WIFI_DELAY_TIME, runInNonWifi);
	}

	private ISettingService getSetting() {
		return (ISettingService) CoyoteSystem.getCurrent().getService(
				ISettingService.class);
	}

	public boolean isTimeDue(INetworkStatus ns) {
		final ISettingService svc = getSetting();
		final long timeNow = System.currentTimeMillis();
		long lastTime = svc.getLong(mTimeKeeperKey, 0);
		if (timeNow - lastTime < mPeriod)
			return false;
		long deadLine = svc.getLong(mDeadLineKey, 0);
		if (deadLine <= 0) {
			if (!ns.wifiAvailable()) {
				if (ns.wifiConnectedRecently()) {
					svc.setLong(mDeadLineKey, timeNow + mWifiDelayTime);
					return false;
				}
				return mRunInNonWifi;
			}
			return true;
		} else {
			return ns.wifiAvailable() || (timeNow - deadLine) >= 0;
		}
	}

	public void updateTimeKeeper(long time) {
		final ISettingService svc = getSetting();
		svc.setLong(mTimeKeeperKey, time);
		svc.setLong(mDeadLineKey, 0);
	}

	public void updateTimeKeeper() {
		updateTimeKeeper(System.currentTimeMillis());
	}
}
