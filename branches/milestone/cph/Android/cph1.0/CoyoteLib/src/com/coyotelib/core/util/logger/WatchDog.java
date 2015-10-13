package com.coyotelib.core.util.logger;

public final class WatchDog {
	private final static String TAG = "watch_dog";
	private static final Logger LOGGER = new Logger();
	private long mStartTime;

	public WatchDog() {
		mStartTime = System.currentTimeMillis();
	}

	public long passedTimeMillis() {
		return System.currentTimeMillis() - mStartTime;
	}

	public void reset() {
		mStartTime = System.currentTimeMillis();
	}

	public void report(String msg) {
		LOGGER.i(TAG, String.format("%s: [%d] millis", msg, passedTimeMillis()));
	}

	public void reportAndReset(String msg) {
		report(msg);
		reset();
	}
}
