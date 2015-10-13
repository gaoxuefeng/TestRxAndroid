package com.coyotelib.core.broadcast;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;

public interface IBroadcastService {
	void registerReceiver(BroadcastReceiver receiver, IntentFilter filter);

	void unRegisterReceiver(BroadcastReceiver receiver);

	boolean sendBroadcast(Intent intent);
}
