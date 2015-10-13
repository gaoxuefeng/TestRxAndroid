package com.coyotelib.framework.sys;

import java.util.HashMap;
import java.util.Map;

import android.content.Context;

import com.coyotelib.core.sys.ICoyoteSystem;
import com.coyotelib.core.sys.SysInfo;

public final class CoyoteSystemImp implements ICoyoteSystem {
	private final Map<Class<?>, Object> mServiceDict = new HashMap<Class<?>, Object>();
	private final Context mAppContext;
	private final String mDataRootDirPath;
	private final SysInfo mSysInfo;

	public CoyoteSystemImp(Context appCtx, SysInfo mSysInfo) {
		mAppContext = appCtx;
		this.mSysInfo = mSysInfo;
		mDataRootDirPath = mAppContext.getFilesDir().getPath();
	}

	@Override
	public Context getAppContext() {
		return mAppContext;
	}

	@Override
	public Object getService(Class<?> serviceType) {
		return mServiceDict.get(serviceType);
	}

	public void addService(Class<?> serviceType, Object serviceImp) {
		if (!serviceType.isInstance(serviceImp)) {
			throw new IllegalArgumentException();
		}
		mServiceDict.put(serviceType, serviceImp);
	}

	@Override
	public SysInfo getSysInfo() {
		return mSysInfo;
	}

	@Override
	public String getDataRootDirectory() {
		return mDataRootDirPath;
	}
}

