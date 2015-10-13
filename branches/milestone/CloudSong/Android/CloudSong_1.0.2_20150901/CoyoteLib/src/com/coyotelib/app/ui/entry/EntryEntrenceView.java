package com.coyotelib.app.ui.entry;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.coyotelib.R;

public class EntryEntrenceView extends LinearLayout {

	private ImageView mFunctionIcon;
	private TextView mFunctionName;
	private ImageView mNewSign;
	private View mBottomLine;
	
	public EntryEntrenceView(Context context) {
		this(context, null);
	}
	
	public EntryEntrenceView(Context context, AttributeSet attrs) {
		super(context, attrs);
		inflate(context, R.layout.entry_entrence_view, this);
		mFunctionIcon = (ImageView) findViewById(R.id.function_icon);
		mFunctionName = (TextView) findViewById(R.id.function_title);
		mNewSign = (ImageView) findViewById(R.id.new_sign);
		mBottomLine = findViewById(R.id.bottom_line);
	}
	
	public void hideBottomLine() {
		mBottomLine.setVisibility(View.GONE);
	}
	
	public void setIcon(int res) {
		mFunctionIcon.setBackgroundResource(res);
	}
	
	public void setTitle(String title) {
		mFunctionName.setText(title);
	}
	
	public void setTitle(int res) {
		mFunctionName.setText(res);
	}
	
	public void showNew(boolean shouldShowNew) {
		if(shouldShowNew) {
			mNewSign.setVisibility(View.VISIBLE);
		} else {
			mNewSign.setVisibility(View.GONE);
		}
	}
}
