package com.ethank.yunge.ui;

import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.ethank.yunge.R;

public abstract class BaseActivity extends Activity {

	private FrameLayout content_layout;
	private LayoutInflater mInflater;
	protected TextView tv_left;
	private TextView tv_right;
	private TextView tv_center;
	protected BaseActivity context;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		super.setContentView(R.layout.activity_base);
		context = this;
		setBaseView();
		initBaseView();
	}

	private void setBaseView() {
		content_layout = (FrameLayout) findViewById(R.id.content_layout);
		tv_left = (TextView) findViewById(R.id.tv_left);
		tv_right = (TextView) findViewById(R.id.tv_right);
		tv_center = (TextView) findViewById(R.id.tv_center);
	}

	@Override
	public void setContentView(int layoutResID) {
		if (mInflater == null) {
			mInflater = getLayoutInflater();
		}
		View view = mInflater.inflate(layoutResID, null);
		if (content_layout == null) {
			content_layout = (FrameLayout) findViewById(R.id.content_layout);
		}
		content_layout.addView(view, 0);
	}

	/**
	 * 抽象方法设置公共部分
	 */
	public abstract void initBaseView();

	/**
	 * 设置头部文字
	 * 
	 * @param center
	 */
	public void setCenterText(String center) {
		tv_center.setText(center);
	}

	public void setCenterText(int center) {
		tv_center.setText(center);
	}

	public void setLeftTvVisible(Boolean visible) {
		if (visible) {
			tv_left.setVisibility(View.VISIBLE);
		} else {
			tv_left.setVisibility(View.GONE);
		}

	}

	public void setRightTvVisible(Boolean visible) {
		if (visible) {
			tv_right.setVisibility(View.VISIBLE);
		} else {
			tv_right.setVisibility(View.GONE);
		}

	}

	@Override
	protected void onResume() {
		super.onResume();
	}

	@Override
	protected void onPause() {
		super.onPause();
	}
}
