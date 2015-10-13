package cn.com.ethank.yunge.app.net;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.framework.network.INetworkStatusService;

public class NetworkChangedReceiver extends BroadcastReceiver {

	public static final String netACTION = "android.net.conn.CONNECTIVITY_CHANGE";

	@Override
	public void onReceive(final Context context, Intent intent) {
		if (intent.getAction().equals(netACTION)) {
			boolean isBreak = intent.getBooleanExtra(
					ConnectivityManager.EXTRA_NO_CONNECTIVITY, false);
			if (!isBreak) {

				INetworkStatusService iNetworkStatusService = (INetworkStatusService) CoyoteSystem
						.getCurrent().getService(INetworkStatusService.class);
				iNetworkStatusService.notifyNetworkStatusChange(isBreak);
			}
		}
	}

}