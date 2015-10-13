package com.coyotelib.core.sys;

import android.content.Context;

public interface ICoyoteSystem {
	Context getAppContext();

	String getDataRootDirectory();

	SysInfo getSysInfo();

	Object getService(Class<?> serviceType);
}
