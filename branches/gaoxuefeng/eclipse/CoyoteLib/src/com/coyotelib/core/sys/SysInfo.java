package com.coyotelib.core.sys;

public abstract class SysInfo {

	final public int getBuildNO() {
		String full = getFullVersionString();
		final int index = full.lastIndexOf('.');
		return index >= 0 ? Integer.parseInt(full.substring(index + 1)) : 0;
	}

	// xx.xx.xx: eg. 2.3.1.4567
	public abstract String getFullVersionString();

	// xx.xx.xx: eg. 2.3.1
	final public String getMainVersionString() {
		String full = getFullVersionString();
		int index = full.lastIndexOf('.');
		return full.substring(0, index).trim();
	}

	public abstract String getHID();

	public abstract String getProtocolVersion();

	public abstract String getChannelIDWithOrigin();

	public abstract String getChannelID();

	public abstract String getIMSI();

	public abstract String getPlatform();

	public abstract String getRomInfo();

	public abstract String getVersionDecor();
	
}
