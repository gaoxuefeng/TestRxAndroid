package com.coyotelib.core.threading;

import java.util.concurrent.Callable;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.concurrent.atomic.AtomicBoolean;

import android.os.Handler;
import android.os.Looper;

public abstract class BackgroundTask<V> implements Runnable, Future<V> {
	private static Handler mHandler = new Handler(Looper.getMainLooper());
	private final FutureTask<V> mComputation = new Computation();
	private AtomicBoolean isOnewayTask = new AtomicBoolean(false);

	private class Computation extends FutureTask<V> {
		public Computation() {
			super(new Callable<V>() {
				public V call() throws Exception {
					return BackgroundTask.this.doWork();
				}
			});
		}

		@Override
		protected final void done() {
			V value = null;
			Throwable thrown = null;
			boolean cancelled = false;
			try {
				value = get();
			} catch (ExecutionException e) {
				thrown = e.getCause();
			} catch (CancellationException e) {
				cancelled = true;
			} catch (InterruptedException consumed) {
				cancelled = true;
			}

			if (isOnewayTask())
				return;

			final V result = value;
			final Throwable error = thrown;
			final boolean isCancelled = cancelled;
			mHandler.post(new Runnable() {
				public void run() {
					onCompletion(result, error, isCancelled);
				}
			});
		}
	}

	protected void setProgress(final V current, final int progress, final int max) {
		if (isOnewayTask())
			return;
		mHandler.post(new Runnable() {
			public void run() {
				onProgress(current, progress, max);
			}
		});
	}

	public void setIsOnewayTask(boolean oneway) {
		isOnewayTask.set(oneway);
	}

	public boolean isOnewayTask() {
		return isOnewayTask.get();
	}

	/**
	 * Called in the background thread
	 * 
	 * @return
	 * @throws Exception
	 */
	abstract protected V doWork() throws Exception;

	/**
	 * Called in the event thread
	 * 
	 * @param result
	 * @param exception
	 * @param cancelled
	 */
	protected void onCompletion(V result, Throwable exception, boolean cancelled) {
	}

	protected void onProgress(V obj, int progress, int max) {
	}

	@Override
	public boolean cancel(boolean mayInterruptIfRunning) {
		return mComputation.cancel(mayInterruptIfRunning);
	}

	@Override
	public V get() throws InterruptedException, ExecutionException {
		return mComputation.get();
	}

	@Override
	public V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException {
		return mComputation.get(timeout, unit);
	}

	@Override
	public boolean isCancelled() {
		return mComputation.isCancelled();
	}

	@Override
	public boolean isDone() {
		return mComputation.isDone();
	}

	@Override
	public void run() {
		new Thread() {
			public void run() {
				mComputation.run();
			};
		}.start();

	}
}
