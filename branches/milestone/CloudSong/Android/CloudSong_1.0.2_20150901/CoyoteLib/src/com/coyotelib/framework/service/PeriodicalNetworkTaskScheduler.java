package com.coyotelib.framework.service;

import java.util.concurrent.Callable;

import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.IThreadingService;

/**
 * Scheduler for periodical network related task. It guarantees only one task
 * execution at any time. It will run the task when period is due It will delay
 * the task when WIFI is not available currently but user has WIFI connected
 * recently
 */
public class PeriodicalNetworkTaskScheduler extends SingletonTaskScheduler {
	private PeriodicalTaskTimeKeeper mTimeKeeper;
	private boolean mUpdateTimeWhenFail;

	/**
	 * Scheduler constructor
	 * 
	 * @param task
	 *            : return true if you want to update the time keeper(latest run
	 *            time)
	 * @param period
	 *            : task period
	 * @param timeKeeperKey
	 *            : key for time keeper
	 * @param mGoodNetworkTypes
	 */
	public PeriodicalNetworkTaskScheduler(Callable<Boolean> task, long period,
			String timeKeeperKey) {
		this(task, period, timeKeeperKey, false,
				PeriodicalTaskTimeKeeper.DEFAULT_WIFI_DELAY_TIME, true);
	}

	public PeriodicalNetworkTaskScheduler(Callable<Boolean> task, long period,
			String timeKeeperKey, boolean updateTimeWhenFail,
			long wifiDelayTime, boolean runInNonWifi) {
		super(task);
		mTimeKeeper = new PeriodicalTaskTimeKeeper(period, timeKeeperKey,
				wifiDelayTime, runInNonWifi);
		mUpdateTimeWhenFail = updateTimeWhenFail;
	}

	private boolean runNoLock() {
		boolean shouldRecordTime = true;
		try {
			shouldRecordTime = (Boolean) this.runTaskUnsafe();
		} catch (Exception e) {
			e.printStackTrace();
			if (!mUpdateTimeWhenFail) {
				shouldRecordTime = false;
			}
		} finally {
			if (shouldRecordTime) {
				mTimeKeeper.updateTimeKeeper();
			}
			this.exitRunningState();
		}
		return shouldRecordTime;
	}

	private boolean checkIfShouldRun(INetworkStatus ns) {
		if (!this.enterRunningState()) {
			return false;
		}
		// If task is not due, reset mIsRunning flag
		if (!mTimeKeeper.isTimeDue(ns)) {
			this.exitRunningState();
			return false;
		}
		return true;
	}

	public void run(INetworkStatus ns) {
		if (!checkIfShouldRun(ns))
			return;

		// mIsRunning flag is set; safe to run task
		runNoLock();
	}

	public void runAsync(INetworkStatus ns) {
		if (!checkIfShouldRun(ns))
			return;

		IThreadingService svc = (IThreadingService) CoyoteSystem.getCurrent()
				.getService(IThreadingService.class);
		svc.runBackgroundTask(new Runnable() {
			@Override
			public void run() {
				runNoLock();
			}
		});
	}
}
