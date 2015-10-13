package com.coyotelib.framework.network;

import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.network.OnNetworkChangedListener;

public interface INetworkStatusService {
	void addNetworkStatusChangeListener(OnNetworkChangedListener listener);

	void notifyNetworkStatusChange(boolean isBreak);

	INetworkStatus currentNetworkStatus();
}
