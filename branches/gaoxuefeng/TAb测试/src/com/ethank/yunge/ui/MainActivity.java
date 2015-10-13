package com.ethank.yunge.ui;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.TabHost.TabSpec;

import com.ethank.yunge.R;
import com.ethank.yunge.ui.tabs.TabActivityA;
import com.ethank.yunge.ui.tabs.TabActivityB;
import com.ethank.yunge.ui.tabs.TabActivityC;
import com.ethank.yunge.ui.tabs.TabActivityD;
import com.ethank.yunge.ui.utils.ContentValues;

public class MainActivity extends TabActivity implements OnCheckedChangeListener, OnClickListener {

	private RadioGroup tab_group;
	private TabSpec tabSpecA;
	private TabSpec tabSpecB;
	private TabSpec tabSpecC;
	private TabSpec tabSpecD;
	public static boolean isexit = false;
	public static ArrayList<String> tabSpecsList = new ArrayList<String>();
	@SuppressLint("HandlerLeak")
	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 0:
				isexit = false;
				break;
			case 1:

				break;
			default:
				break;
			}

		};
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		setView();
	}

	@SuppressWarnings("deprecation")
	private void setView() {
		ContentValues.tabhost = getTabHost();
		tab_group = (RadioGroup) findViewById(R.id.tab_group);
		Intent tabActivityA = new Intent(this, TabActivityA.class);
		Intent tabActivityB = new Intent(this, TabActivityB.class);
		Intent tabActivityC = new Intent(this, TabActivityC.class);
		Intent tabActivityD = new Intent(this, TabActivityD.class);
		tabSpecA = ContentValues.tabhost.newTabSpec(ContentValues.tabA).setIndicator(ContentValues.tabA).setContent(tabActivityA);
		tabSpecB = ContentValues.tabhost.newTabSpec(ContentValues.tabB).setIndicator(ContentValues.tabB).setContent(tabActivityB);
		tabSpecC = ContentValues.tabhost.newTabSpec(ContentValues.tabC).setIndicator(ContentValues.tabC).setContent(tabActivityC);
		tabSpecD = ContentValues.tabhost.newTabSpec(ContentValues.tabD).setIndicator(ContentValues.tabD).setContent(tabActivityD);
		ContentValues.tabhost.addTab(tabSpecA);
		ContentValues.tabhost.addTab(tabSpecB);
		ContentValues.tabhost.addTab(tabSpecC);
		ContentValues.tabhost.addTab(tabSpecD);
		setCurrentTabByTag(ContentValues.tabA, true);
		// tab_group.setOnCheckedChangeListener(this);
		for (int i = 0; i < tab_group.getChildCount(); i++) {
			RadioButton radioButton = (RadioButton) tab_group.getChildAt(i);
			radioButton.setOnClickListener(this);
		}
	}

	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {

		RadioButton checked = (RadioButton) findViewById(checkedId);
		// lastChecked.setChecked(false);
		checked.setChecked(true);
		switch (checkedId) {
		case R.id.rb_taba:
			setCurrentTabByTag(ContentValues.tabA, true);

			break;
		case R.id.rb_tabb:
			setCurrentTabByTag(ContentValues.tabB, true);
			break;
		case R.id.rb_tabc:
			setCurrentTabByTag(ContentValues.tabC, true);

			break;
		case R.id.rb_tabd:
			setCurrentTabByTag(ContentValues.tabD, true);
			break;

		default:
			break;
		}
	}

	public static String getLastTabTag() {
		if (tabSpecsList.size() != 0) {
			return tabSpecsList.get(tabSpecsList.size() - 1);
		} else {
			return ContentValues.tabA;
		}

	}

	/**
	 * 
	 * @param tag需要跳转的tag
	 * @param isNewTag
	 *            是否是新的tag,新的是要跳转到的true,旧的是点击返回的false
	 */
	public static void setCurrentTabByTag(String tag, boolean isNewTag) {
		if (tag.equals(ContentValues.tabhost.getCurrentTabTag())) {
			return;
		}
		if (tag.equals(ContentValues.tabA) || tag.equals(ContentValues.tabB) || tag.equals(ContentValues.tabC) || tag.equals(ContentValues.tabD)) {
			tabSpecsList.clear();
			tabSpecsList.add(tag);
			ContentValues.tabhost.setCurrentTabByTag(tag);
		} else if (isNewTag) {
			tabSpecsList.add(tag);
			ContentValues.tabhost.setCurrentTabByTag(tag);
		} else if (!isNewTag) {
			ContentValues.tabhost.setCurrentTabByTag(tag);
		}

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.rb_taba:
			setCurrentTabByTag(ContentValues.tabA, true);

			break;
		case R.id.rb_tabb:
			setCurrentTabByTag(ContentValues.tabB, true);
			break;
		case R.id.rb_tabc:
			setCurrentTabByTag(ContentValues.tabC, true);

			break;
		case R.id.rb_tabd:
			setCurrentTabByTag(ContentValues.tabD, true);
			break;
		default:
			break;
		}

	}
}
