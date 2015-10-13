package cn.com.ethank.yunge.app.util;

import java.util.concurrent.Future;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.IThreadingService;

/**
 * @author hanqw
 * @since 2013-10-12 上午8:24:15
 */
public final class ThreadingService {

	private static final ThreadingService INST = new ThreadingService();
	private IThreadingService mThreadingService;

	private ThreadingService() {
		mThreadingService = (IThreadingService) CoyoteSystem.getCurrent()
				.getService(IThreadingService.class);
	}

	public static ThreadingService getInst() {
		return INST;
	}

	public void runForegroundTask(Runnable r, long delay) {
		mThreadingService.runForegroundTask(r, delay);
	}

	public void runForegroundTask(Runnable r) {
		mThreadingService.runForegroundTask(r, 0);
	}

	public void cancelForegroundTask(Runnable r) {
		mThreadingService.cancelForegroundTask(r);
	}

	public Future<?> runBackgroundTask(Runnable r) {
		mThreadingService.runBackgroundTask(r);
		return null;
	}

	public void cancelBackgroundTask(Runnable r, Future<?> future) {
		mThreadingService.cancelBackgroundTask(r, future);
	}
}
