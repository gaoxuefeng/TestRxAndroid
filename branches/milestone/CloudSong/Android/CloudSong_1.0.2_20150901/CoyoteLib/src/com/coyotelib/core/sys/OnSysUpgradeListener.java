package com.coyotelib.core.sys;

public interface OnSysUpgradeListener {
	void onSysUpgraded(int currentBuild, int previousBuild);
}
