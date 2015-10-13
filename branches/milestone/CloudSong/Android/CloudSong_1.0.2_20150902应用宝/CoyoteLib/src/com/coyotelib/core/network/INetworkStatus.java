package com.coyotelib.core.network;

public interface INetworkStatus {
	boolean wifiAvailable();

	boolean wwanAvailable();

	boolean isNetworkConnected();

	boolean wifiConnectedRecently();

	boolean isNetworkAvailableWhenCall();
}
