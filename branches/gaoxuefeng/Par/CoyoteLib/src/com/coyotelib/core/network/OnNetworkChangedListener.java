package com.coyotelib.core.network;

public interface OnNetworkChangedListener {
	void onNetworkChanged(INetworkStatus status);
	public void onNetworkConnectChanged(boolean isConnect);
}
