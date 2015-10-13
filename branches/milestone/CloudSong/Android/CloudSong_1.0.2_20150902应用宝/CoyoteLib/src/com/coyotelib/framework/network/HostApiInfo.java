package com.coyotelib.framework.network;

public class HostApiInfo {
	private String mHost;
	private String mAPI;

	public HostApiInfo(String host, String api) {
		mHost = host;
		mAPI = api;
	}

	public String getHost() {
		return mHost;
	}

	public String getAPI() {
		return mAPI;
	}

	@Override
	public String toString() {
		return "http://" + mHost + "/" + mAPI;
	}
}
