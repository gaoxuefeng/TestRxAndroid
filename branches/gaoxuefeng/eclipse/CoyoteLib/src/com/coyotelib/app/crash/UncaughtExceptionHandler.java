package com.coyotelib.app.crash;

import android.content.Context;
import android.content.Intent;

import java.io.PrintWriter;
import java.io.StringWriter;

public class UncaughtExceptionHandler implements
		Thread.UncaughtExceptionHandler {

	private final Context mContext;

	public UncaughtExceptionHandler(Context context) {
		this.mContext = context;
	}

	@Override
	public void uncaughtException(Thread thread, Throwable ex) {
		final StringWriter stackTrace = new StringWriter();
		ex.printStackTrace(new PrintWriter(stackTrace));

		final String crashInfo = stackTrace.toString();
		Intent intent = new Intent(mContext, BugReportActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
				| Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra(BugReportActivity.STACKTRACE, crashInfo);
		mContext.startActivity(intent);
		System.exit(0);
	}

}
