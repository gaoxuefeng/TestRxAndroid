package com.coyotelib.framework.network;

import com.coyotelib.core.network.HttpService;
import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.util.coding.AbstractCoding;
import com.coyotelib.core.util.coding.PlainCoding;

public class DefaultHttpService extends HttpService {
	private AbstractCoding mDefaultCoding = new PlainCoding();

	public DefaultHttpService(AbstractCoding defaultCoding, ISettingService settingService) {
        super(settingService);
		this.mDefaultCoding = defaultCoding;
	}

	@Override
	protected AbstractCoding defaultCoding() {
		return mDefaultCoding;
	}
}
