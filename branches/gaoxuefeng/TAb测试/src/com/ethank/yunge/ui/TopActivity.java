package com.ethank.yunge.ui;

import android.os.Bundle;

import com.ethank.yunge.R;
import com.ethank.yunge.ui.tabs.NomalTabActivity;

public class TopActivity extends NomalTabActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_top);
	}
}
