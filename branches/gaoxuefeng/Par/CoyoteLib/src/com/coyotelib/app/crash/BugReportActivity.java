package com.coyotelib.app.crash;

import android.app.Activity;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.widget.Button;
import android.widget.TextView;

import com.coyotelib.R;

public class BugReportActivity extends Activity {

	public static final String STACKTRACE = "demo.stacktrace";

	private Button mBtnRestart;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.bug_report_view);

		final String stackTrace = getIntent().getStringExtra(STACKTRACE);
		final TextView reportTextView = (TextView) findViewById(R.id.report_text);
		reportTextView.setMovementMethod(ScrollingMovementMethod.getInstance());
		reportTextView.setClickable(false);
		reportTextView.setLongClickable(false);

		// TODO 特定情况下隐藏掉
		reportTextView.append(stackTrace);
	}
}
