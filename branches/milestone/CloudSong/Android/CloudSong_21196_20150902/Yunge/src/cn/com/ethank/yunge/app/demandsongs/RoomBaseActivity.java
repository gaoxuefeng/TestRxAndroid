package cn.com.ethank.yunge.app.demandsongs;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;

public abstract class RoomBaseActivity extends BaseTitleActivity {

	private CloseRoomBroadCast closeRoomBroadCast;

	@Override
	public abstract void onNetworkConnectChanged(boolean isConnect);

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		closeRoomBroadCast = new CloseRoomBroadCast();
		IntentFilter intentFilter = new IntentFilter(Constants.EXITROOM_RECEIVED_ACTION);
		this.registerReceiver(closeRoomBroadCast, intentFilter);
	}

	class CloseRoomBroadCast extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			if (intent.getAction().equals(Constants.EXITROOM_RECEIVED_ACTION)) {
				try {
					finish();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		try {
			this.unregisterReceiver(closeRoomBroadCast);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
