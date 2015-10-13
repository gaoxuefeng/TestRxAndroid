package com.coyotelib.framework.service;

interface OnSvcUpgradeListener {
	void onSvcUpgrade(int currentBuild, int previousBuild);
}
