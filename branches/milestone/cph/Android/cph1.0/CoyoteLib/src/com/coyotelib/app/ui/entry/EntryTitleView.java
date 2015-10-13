package com.coyotelib.app.ui.entry;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.coyotelib.R;

public class EntryTitleView extends LinearLayout {

	private TextView mTitle;
	
	public EntryTitleView(Context context) {
		this(context, null);
	}
	
	public EntryTitleView(Context context, AttributeSet attrs) {
		super(context, attrs);
		inflate(context, R.layout.entry_title_layout, this);
		mTitle = (TextView) findViewById(R.id.setting_title);
        setSoundEffectsEnabled(false);
	}

	
	public void setTitle(String titleTx) {
		mTitle.setText(titleTx);
	}
	
	public void setTitle(int titleRes) {
		mTitle.setText(titleRes);
	}

}
