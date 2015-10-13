package com.coyotelib.core.util.logger;

public interface ILogger {
	void i(String tag, String msg);

	void d(String tag, String msg);

	void d(String tag, String msg, Throwable t);

	void e(String tag, String msg);

	void e(String tag, String msg, final Throwable t);

	void w(String tag, String msg);
}
