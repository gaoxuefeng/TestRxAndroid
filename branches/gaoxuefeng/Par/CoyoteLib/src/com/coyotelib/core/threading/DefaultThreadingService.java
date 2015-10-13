package com.coyotelib.core.threading;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import android.os.Handler;
import android.os.Looper;

public class DefaultThreadingService implements IThreadingService {
	private static final Handler H = new Handler(Looper.getMainLooper());
	protected ExecutorService mExecutor;

	public DefaultThreadingService() {
		mExecutor = Executors.newCachedThreadPool();
	}

	@Override
	public void runForegroundTask(Runnable r, long delay) {
		H.postDelayed(r, delay);
	}

	@Override
	public void cancelForegroundTask(Runnable r) {
		H.removeCallbacks(r);
	}

	@Override
	public Future<?> runBackgroundTask(Runnable r) {
		return mExecutor.submit(r);
	}

	@Override
	public void cancelBackgroundTask(Runnable r, Future<?> future) {
		if (r != null) {
			if (Future.class.isInstance(r))
				((Future<?>) r).cancel(true);
		}
		if (future != null) {
			future.cancel(true);
		}
	}
}