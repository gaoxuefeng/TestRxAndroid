package com.ethank.yunge.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TabHost.TabSpec;
import android.widget.TextView;

import com.ethank.yunge.R;
import com.ethank.yunge.ui.tabs.NomalTabActivity;
import com.ethank.yunge.ui.utils.ContentValues;

public class SingleActivity extends NomalTabActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_single);
		TextView tv = (TextView) findViewById(R.id.tv);
		tv.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(context, TopActivity.class);
				TabSpec tabTop = ContentValues.tabhost.newTabSpec(ContentValues.tabTop).setIndicator(ContentValues.tabTop).setContent(intent);
				ContentValues.tabhost.addTab(tabTop);
				MainActivity.setCurrentTabByTag(ContentValues.tabTop, true);

			}
		});

	}

	@Override
	protected void onDestroy() {
		super.onDestroy();

	}
}
