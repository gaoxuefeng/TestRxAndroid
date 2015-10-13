package com.coyotelib.framework.network;

import java.util.ArrayList;
import java.util.concurrent.Callable;

import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.network.OnNetworkChangedListener;
import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.framework.service.SingletonTaskScheduler;

public class DefaultNetworkStatusService implements INetworkStatusService {
	private static final long DEFAULT_WIFI_RECENT_INTERVAL = 7 * 24 * 60 * 60
			* 1000; // 7 days
	private static final String LAST_CONNECT_WIFI_STAMP = "last_connect_wifi_time";
	private long mWifiRecentInterval;
	private ArrayList<OnNetworkChangedListener> mListeners = new ArrayList<OnNetworkChangedListener>();
	private SingletonTaskScheduler mSingletonTaskScheduler;
	private boolean mIsTelcom;

	public DefaultNetworkStatusService(boolean isTelcom) {
		this(DEFAULT_WIFI_RECENT_INTERVAL, isTelcom);
	}

	public DefaultNetworkStatusService(long wifiRecentIntervalMillis,
			boolean isTelcom) {
		mWifiRecentInterval = wifiRecentIntervalMillis;
		mIsTelcom = isTelcom;
	}

	@Override
	public void addNetworkStatusChangeListener(OnNetworkChangedListener listener) {
		mListeners.add(listener);
	}

	private ISettingService getSetting() {
		return (ISettingService) CoyoteSystem.getCurrent().getService(
				ISettingService.class);
	}

	private NetworkStatusImp createCurrentNetworkStatus() {
		ISettingService setting = (ISettingService) CoyoteSystem.getCurrent()
				.getService(ISettingService.class);
		final long lastWifiTime = setting.getLong(LAST_CONNECT_WIFI_STAMP, 0);
		return new NetworkStatusImp(
				CoyoteSystem.getCurrent().getAppContext(),
				System.currentTimeMillis() - lastWifiTime < mWifiRecentInterval,
				mIsTelcom);
	}

	@Override
	public void notifyNetworkStatusChange(boolean isBreak) {
		if (isBreak)
			return;
		if (mSingletonTaskScheduler == null) {
			mSingletonTaskScheduler = new SingletonTaskScheduler(
					new Callable<Boolean>() {

						@Override
						public Boolean call() throws Exception {
							NetworkStatusImp ns = createCurrentNetworkStatus();
							if (ns.wifiAvailable()) {
								getSetting().setLong(LAST_CONNECT_WIFI_STAMP,
										System.currentTimeMillis());
							}
							for (OnNetworkChangedListener listener : mListeners) {
								listener.onNetworkChanged(ns);
							}
							return true;
						}
					});
		}
		mSingletonTaskScheduler.run();
	}

	@Override
	public INetworkStatus currentNetworkStatus() {
		return createCurrentNetworkStatus();
	}

}
