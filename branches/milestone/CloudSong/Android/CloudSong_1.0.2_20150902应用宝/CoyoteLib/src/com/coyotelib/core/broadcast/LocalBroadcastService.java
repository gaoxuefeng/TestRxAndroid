package com.coyotelib.core.broadcast;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v4.content.LocalBroadcastManager;

public final class LocalBroadcastService implements IBroadcastService {
	private LocalBroadcastManager mBroadCastMgnr;;

	public LocalBroadcastService(Context ctx) {
		mBroadCastMgnr = LocalBroadcastManager.getInstance(ctx);
	}

	@Override
	public void registerReceiver(BroadcastReceiver receiver, IntentFilter filter) {
		mBroadCastMgnr.registerReceiver(receiver, filter);
	}

	@Override
	public void unRegisterReceiver(BroadcastReceiver receiver) {
		mBroadCastMgnr.unregisterReceiver(receiver);
	}

	@Override
	public boolean sendBroadcast(Intent intent) {
		return mBroadCastMgnr.sendBroadcast(intent);
	}

}
