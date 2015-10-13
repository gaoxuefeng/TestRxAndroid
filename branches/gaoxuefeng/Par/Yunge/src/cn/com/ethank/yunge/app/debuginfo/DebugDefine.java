package cn.com.ethank.yunge.app.debuginfo;

public class DebugDefine {
	public static boolean beDebug = getV("isDebug");

	private static boolean getV(String name) {
		boolean v = DebugSwitch.getSwitchValue(name);
		return v;
	}
}
