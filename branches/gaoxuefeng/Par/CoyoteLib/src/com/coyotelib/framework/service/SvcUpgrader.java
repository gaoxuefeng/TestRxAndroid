package com.coyotelib.framework.service;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.IThreadingService;

class SvcUpgrader {
	private OnSvcUpgradeListener mUpgradeListener;
	private Object mSyncObject;
	private boolean mIsUpgrading;
	private boolean mUpgradeHasError;
	private Exception mUpgradeError;

	public SvcUpgrader(OnSvcUpgradeListener listener, Object syncObj) {
		mUpgradeListener = listener;
		mSyncObject = syncObj;
	}

	private void checkUpgradeError() throws UpgradeException {
		if (mUpgradeHasError) {
			throw new UpgradeException(String.format("%s init error", this
					.getClass().toString()), mUpgradeError);
		}
	}

	private void doUpgradeNonLock(int current, int previous) {
		try {
			mUpgradeListener.onSvcUpgrade(current, previous);
			mUpgradeHasError = false;
		} catch (Exception e) {
			mUpgradeHasError = true;
			mUpgradeError = e;
		}
	}

	public static class UpgradeException extends Exception {
		private static final long serialVersionUID = 1L;

		public UpgradeException(String msg, Throwable e) {
			super(msg, e);
		}
	}

	/**
	 * nonLocked, should locked from caller
	 */
	public void checkUpgrade() throws UpgradeException {
		checkUpgradeError();
		if (!mIsUpgrading)
			return;
		while (mIsUpgrading && !mUpgradeHasError) {
			try {
				mSyncObject.wait();
			} catch (InterruptedException e) {
			}
		}
		checkUpgradeError();
	}

	public void upgrade(int current, int previous) {
		synchronized (mSyncObject) {
			if (mIsUpgrading)
				return;
			mIsUpgrading = true;
			doUpgradeNonLock(current, previous);
			mIsUpgrading = false;
		}
	}

	public void upgradeAsync(final int current, final int previous) {
		synchronized (mSyncObject) {
			if (mIsUpgrading)
				return;

			IThreadingService svc = (IThreadingService) CoyoteSystem
					.getCurrent().getService(IThreadingService.class);
			mIsUpgrading = true;
			svc.runBackgroundTask(new Runnable() {
				@Override
				public void run() {
					synchronized (mSyncObject) {
						doUpgradeNonLock(current, previous);
						mIsUpgrading = false;
						mSyncObject.notifyAll();
					}
				}
			});
		}
	}
}
