package com.coyotelib.framework.service;

import java.util.concurrent.Callable;
import java.util.concurrent.atomic.AtomicBoolean;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.IThreadingService;

/**
 * Scheduler guarantees only one task execution at any time
 */
public class SingletonTaskScheduler {
	private Callable<Boolean> mTask;
	private AtomicBoolean mIsRunning = new AtomicBoolean(false);

	public SingletonTaskScheduler(Callable<Boolean> task) {
		mTask = task;
	}

	protected boolean enterRunningState() {
		// CAS mIsRunning flag
		return mIsRunning.compareAndSet(false, true);
	}

	protected void exitRunningState() {
		mIsRunning.set(false);
	}

	public Object run() {
		if (!enterRunningState())
			return null;
		return runTask();
	}

	public void runAsync() {
		if (!enterRunningState())
			return;

		IThreadingService svc = (IThreadingService) CoyoteSystem.getCurrent()
				.getService(IThreadingService.class);
		svc.runBackgroundTask(new Runnable() {
			@Override
			public void run() {
				runTask();
			}
		});
	}

	protected Boolean runTaskUnsafe() throws Exception {
		return mTask.call();
	}

	private Boolean runTask() {
		try {
			return runTaskUnsafe();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			exitRunningState();
		}
	}

}
