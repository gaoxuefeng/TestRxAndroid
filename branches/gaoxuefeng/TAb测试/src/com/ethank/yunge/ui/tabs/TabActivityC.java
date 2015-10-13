package com.ethank.yunge.ui.tabs;

import com.ethank.yunge.R;
import com.ethank.yunge.R.layout;
import com.ethank.yunge.R.string;
import com.ethank.yunge.ui.BaseActivity;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

public class TabActivityC extends MainTabActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_tab_activity_c);
	}

	@Override
	public void initBaseView() {
		super.initBaseView();
		setCenterText(R.string.title_activity_tab_activity_c);
		
	}
}
