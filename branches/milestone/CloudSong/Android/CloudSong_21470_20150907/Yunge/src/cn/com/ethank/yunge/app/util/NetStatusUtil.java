package cn.com.ethank.yunge.app.util;

import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.framework.network.INetworkStatusService;

public class NetStatusUtil {

	private INetworkStatus netStatus;

	private static NetStatusUtil INST = new NetStatusUtil();

	private NetStatusUtil() {
		INetworkStatusService nss = (INetworkStatusService) CoyoteSystem.getCurrent().getService(INetworkStatusService.class);
		netStatus = nss.currentNetworkStatus();
	}

	public static NetStatusUtil getInst() {
		return INST;
	}

	public INetworkStatus getNetStatusManager() {
		return netStatus;
	}

	// 是否联网
	public static boolean isNetConnect() {
		return new NetStatusUtil().getNetStatusManager().isNetworkConnected();

	}
}
