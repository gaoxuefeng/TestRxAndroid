package com.coyotelib.framework.service;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.IThreadingService;

public class SvcInitializer {
	private boolean mInited;
	private boolean mIsIniting;
	private boolean mInitHasError;
	private Exception mInitError;
	private OnSvcInitializeListener mInitListener;
	private Object mSyncObject;

	public SvcInitializer(OnSvcInitializeListener listener, Object syncObj) {
		mInitListener = listener;
		mSyncObject = syncObj;
	}

	public static class InitializationException extends Exception {
		private static final long serialVersionUID = 1L;

		public InitializationException(String msg, Throwable e) {
			super(msg, e);
		}
	}

	private void checkInitError() throws InitializationException {
		if (mInitHasError) {
			throw new InitializationException(String.format(
					"initializer error: [%s]", mSyncObject.getClass()
							.toString()), mInitError);
		}
	}

	/**
	 * nonLocked, should locked from caller
	 */
	public void setInited() {
		mInited = true;
		mInitHasError = false;
		mInitError = null;
	}

	/**
	 * nonLocked, should locked from caller
	 */
	public void setUnInited() {
		if (!mInited)
			return;
		mInited = false;
		mInitHasError = false;
		mInitError = null;
		mInitListener.onClearInitedState();
	}

	public void reInitAsync() {
		setUnInited();
		this.initAsync();
	}

	private void doInitNonLock() {
		try {
			mInitListener.onInitialize();
			mInitHasError = false;
			mInited = true;
		} catch (Exception e) {
			mInitHasError = true;
			mInitError = e;
			mInited = false;
		}
	}

	/**
	 * nonLocked, should locked from caller
	 */
	public void checkInit() throws InitializationException {
		checkInitError();
		if (mInited)
			return;
		if (mIsIniting) {
			while (!mInited && !mInitHasError) {
				try {
					mSyncObject.wait();
				} catch (InterruptedException e) {
				}
			}
		} else {
			mIsIniting = true;
			doInitNonLock();
			mIsIniting = false;
		}
		checkInitError();
	}

	public void initAsync() {
		IThreadingService svc = (IThreadingService) CoyoteSystem.getCurrent()
				.getService(IThreadingService.class);
		svc.runBackgroundTask(new Runnable() {
			@Override
			public void run() {
				synchronized (mSyncObject) {
					if (mInited)
						return;
					if (mIsIniting)
						return;

					mIsIniting = true;
					doInitNonLock();
					mIsIniting = false;
					mSyncObject.notifyAll();
				}
			}
		});
	}
}
