package com.coyotelib.core.network;

public interface OnNetworkChangedListener {
	void onNetworkChanged(INetworkStatus status);
	void onNetworkConnectChanged(boolean isConnect);
}
