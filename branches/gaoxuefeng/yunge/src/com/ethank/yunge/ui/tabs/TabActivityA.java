package com.ethank.yunge.ui.tabs;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TabHost.TabSpec;

import com.ethank.yunge.R;
import com.ethank.yunge.ui.MainActivity;
import com.ethank.yunge.ui.SingleActivity;
import com.ethank.yunge.utils.ContentValues;

public class TabActivityA extends MainTabActivity implements OnClickListener {

	private ImageView iv_single;
	private ImageView iv_local;
	private ImageView iv_top;
	private ImageView iv_type;
	private ImageView iv_comment;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_tab_activity_a);
		setView();
	}

	private void setView() {
		iv_single = (ImageView) findViewById(R.id.iv_single);
		iv_local = (ImageView) findViewById(R.id.iv_local);
		iv_top = (ImageView) findViewById(R.id.iv_top);
		iv_type = (ImageView) findViewById(R.id.iv_type);
		iv_comment = (ImageView) findViewById(R.id.iv_comment);
		iv_single.setOnClickListener(this);
		iv_local.setOnClickListener(this);
		iv_top.setOnClickListener(this);
		iv_type.setOnClickListener(this);
		iv_comment.setOnClickListener(this);

	}

	@Override
	public void initBaseView() {
		super.initBaseView();
		setCenterText(R.string.title_activity_tab_activity_a);

	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.iv_single:
			Intent intent = new Intent(context, SingleActivity.class);
			TabSpec tabSpecSingle = ContentValues.tabhost.newTabSpec(ContentValues.tabSingler).setIndicator(ContentValues.tabSingler).setContent(intent);
			ContentValues.tabhost.addTab(tabSpecSingle);
			MainActivity.setCurrentTabByTag(ContentValues.tabSingler, true);
			break;
		case R.id.iv_local:

			break;
		case R.id.iv_top:

			break;
		case R.id.iv_type:

			break;
		case R.id.iv_comment:

			break;

		default:
			break;
		}
	}
	@Override
	protected void onRestart() {
		// TODO Auto-generated method stub
		super.onRestart();
	}
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}
	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
	}
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
	}
}
