package com.coyotelib.framework.service;

import com.coyotelib.framework.network.HostApiInfo;

public class NetworkTaskInfo {
	private HostApiInfo mHostApi;
	private long mPeriodMillis;
	private String mTimeKeeperKey;
	private int mNotificationID;
	private int mNotificationIconRID;

	public NetworkTaskInfo(HostApiInfo hostApi, String timeKeeperKey,
			long periodMillis) {
		this(hostApi, timeKeeperKey, periodMillis, 0, 0);
	}

	public NetworkTaskInfo(HostApiInfo hostApi, String timeKeeperKey,
			long periodMillis, int notificationID, int notificationIconRID) {
		mHostApi = hostApi;
		mTimeKeeperKey = timeKeeperKey;
		mPeriodMillis = periodMillis;
		mNotificationID = notificationID;
		mNotificationIconRID = notificationIconRID;
	}

	public HostApiInfo getHostApi() {
		return mHostApi;
	}

	public String getTimeKeeperKey() {
		return mTimeKeeperKey;
	}

	public long getPeriodMillis() {
		return mPeriodMillis;
	}

	public int getNotificationID() {
		return mNotificationID;
	}

	public int getNotificationIconRID() {
		return mNotificationIconRID;
	}
}
