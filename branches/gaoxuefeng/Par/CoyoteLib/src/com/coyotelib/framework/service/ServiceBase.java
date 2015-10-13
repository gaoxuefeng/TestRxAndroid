package com.coyotelib.framework.service;

import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.framework.service.SvcInitializer.InitializationException;

public abstract class ServiceBase implements OnSvcInitializeListener {
	private SvcInitializer mSvcInitilizer;

	public ServiceBase() {
		mSvcInitilizer = new SvcInitializer(this, this);
	}

	/**
	 * nonLocked, should locked from caller Every public method should start
	 * with this method: eg. if(!this.checkInit()) return;
	 */
	protected boolean checkInit() {
		try {
			mSvcInitilizer.checkInit();
		} catch (InitializationException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	/**
	 * nonLocked, should locked from caller
	 */
	protected void setUnInited() {
		mSvcInitilizer.setUnInited();
	}

	/**
	 * nonLocked, should locked from caller
	 */
	protected void setInited() {
		mSvcInitilizer.setInited();
	}

	protected ISettingService getSetting() {
		return (ISettingService) CoyoteSystem.getCurrent().getService(
				ISettingService.class);
	}

	public void initAsync() {
		mSvcInitilizer.initAsync();
	}
}
