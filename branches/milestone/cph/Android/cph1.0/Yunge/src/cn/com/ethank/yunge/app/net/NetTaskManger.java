package cn.com.ethank.yunge.app.net;

import java.util.ArrayList;

import cn.com.ethank.yunge.BuildConfig;

import com.coyotelib.core.util.TimeUtil;
import com.coyotelib.framework.network.HostApiInfo;
import com.coyotelib.framework.service.NetworkTaskInfo;

public class NetTaskManger {
	
	private static final boolean isDebug = BuildConfig.DEBUG;
	public static final String HOST_NORMAL = "ethank.com.cn";
	public static final String HOST_TEST = "192.168.1.223:8080";
	
	public final int Statistic;
	
	private ArrayList<NetworkTaskInfo> mTaskInfoList = new ArrayList<NetworkTaskInfo>();
	
	public NetworkTaskInfo getInfo(int key) {
		return mTaskInfoList.get(key);
	}

	private static NetTaskManger INST = new NetTaskManger();

	public static NetTaskManger getInst() {
		return INST;
	}
	
	private int addTaskInfo_Api(String[] apis, String timeKeeperKey) {
		return addTaskInfo(new String[] { HOST_NORMAL,
				HOST_TEST }, apis, timeKeeperKey, new int[] {
				TimeUtil.ONE_DAY_MILLIS, TimeUtil.TEN_SECOND_MILLIS });
	}
	
	/**
	 * hosts[0]: official host hosts[1]: test host
	 */
	private int addTaskInfo(String[] hosts, String[] apis,
			String timeKeeperKey, int[] updateIntervalMillises) {
		String host = isDebug ? hosts[1] : hosts[0];
		String api = isDebug ? apis[1] : apis[0];
		int updateIntervalMillis = isDebug ? updateIntervalMillises[1]
				: updateIntervalMillises[0];
		mTaskInfoList.add(new NetworkTaskInfo(new HostApiInfo(host, api),
				timeKeeperKey, updateIntervalMillis));
		return mTaskInfoList.size() - 1;
	}
	
	private NetTaskManger() {
		Statistic = addTaskInfo(new String[] {
				"192.168.1.223:8010",
				"192.168.1.223:8010"
		}, new String[] {
				"blank.gif",
				"blank.gif"
		}, "ETHANK_STATISTIC",  new int[] {
				TimeUtil.ONE_DAY_MILLIS, TimeUtil.TEN_SECOND_MILLIS });
		
		
	}
	

}
