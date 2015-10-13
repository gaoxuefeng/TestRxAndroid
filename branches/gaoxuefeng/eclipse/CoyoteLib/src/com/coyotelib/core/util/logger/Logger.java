package com.coyotelib.core.util.logger;

import android.util.Log;

public final class Logger implements ILogger {
	private boolean mDebug;

	public Logger(boolean debug) {
		mDebug = debug;
	}

	@Override
	public void i(String tag, String msg) {
		Log.i(tag, msg);
	}

	@Override
	public void d(String tag, String msg) {
		if (mDebug) {
			Log.d(tag, msg);
		}
	}

	@Override
	public void d(String tag, String msg, Throwable t) {
		if (mDebug) {
			Log.d(tag, msg, t);
		}
	}

	@Override
	public void e(String tag, String msg) {
		if (mDebug) {
			Log.e(tag, msg);
		}
	}

	@Override
	public void e(String tag, String msg, Throwable t) {
		if (mDebug) {
			Log.e(tag, msg, t);
		}
	}

	@Override
	public void w(String tag, String msg) {
		if (mDebug) {
			Log.w(tag, msg);
		}
	}
}
