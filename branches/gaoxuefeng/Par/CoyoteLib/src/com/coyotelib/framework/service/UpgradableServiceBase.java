package com.coyotelib.framework.service;

import com.coyotelib.core.sys.OnSysUpgradeListener;
import com.coyotelib.framework.service.SvcUpgrader.UpgradeException;

public abstract class UpgradableServiceBase extends ServiceBase implements
		OnSvcUpgradeListener, OnSysUpgradeListener {

	private SvcUpgrader mSvcUpgrader;

	public UpgradableServiceBase() {
		super();
		mSvcUpgrader = new SvcUpgrader(this, this);
	}

	/**
	 * nonLocked, should locked from caller Every public method should start
	 * with this method: eg. if(!this.checkInitOrUpGrade()) return;
	 */
	protected boolean checkInitAndUpgrade() {
		return checkUpgrade() && checkInit();
	}

	/**
	 * nonLocked, should locked from caller
	 */
	protected boolean checkUpgrade() {
		try {
			mSvcUpgrader.checkUpgrade();
		} catch (UpgradeException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	// Override should always call super.onInitialize()!
	@Override
	public void onInitialize() {
		try {
			mSvcUpgrader.checkUpgrade();
		} catch (UpgradeException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onSysUpgraded(int currentBuild, int previousBuild) {
		mSvcUpgrader.upgrade(currentBuild, previousBuild);
	}
}
