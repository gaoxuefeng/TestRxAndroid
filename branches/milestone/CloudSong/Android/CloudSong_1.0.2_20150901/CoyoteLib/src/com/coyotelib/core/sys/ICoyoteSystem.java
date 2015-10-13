package com.coyotelib.core.sys;

import android.content.Context;

public interface ICoyoteSystem {
	Context getAppContext();

	String getDataRootDirectory();

	Object getService(Class<?> serviceType);
	void addService(Class<?> serviceType, Object serviceImp);

	SysInfo getSysInfo();
}
