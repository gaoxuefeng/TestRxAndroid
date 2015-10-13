package com.coyotelib.framework.network;

import com.coyotelib.core.network.HttpService;
import com.coyotelib.core.util.coding.AbstractCoding;
import com.coyotelib.core.util.coding.PlainCoding;
import com.coyotelib.core.util.coding.UrlCoding;

public class DefaultHttpService extends HttpService {
	private AbstractCoding mDefaultCoding = new UrlCoding();// 默认的应改为utf-8的

	// private AbstractCoding mDefaultCoding = new PlainCoding();

	public DefaultHttpService() {
		// this.mDefaultCoding = defaultCoding;
	}

	@Override
	protected AbstractCoding defaultCoding() {
		return mDefaultCoding;
	}
}
