package com.coyotelib.core.threading;

import java.util.concurrent.Future;

public interface IThreadingService {
	void runForegroundTask(Runnable r, long delay);

	void cancelForegroundTask(Runnable r);

	Future<?> runBackgroundTask(Runnable r);

	void cancelBackgroundTask(Runnable r, Future<?> future);

}
