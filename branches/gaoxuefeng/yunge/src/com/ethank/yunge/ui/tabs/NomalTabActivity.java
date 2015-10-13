package com.ethank.yunge.ui.tabs;

import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;

import com.ethank.yunge.ui.BaseActivity;
import com.ethank.yunge.ui.MainActivity;
import com.ethank.yunge.utils.ContentValues;

public class NomalTabActivity extends BaseActivity {

	@Override
	public void initBaseView() {
		tv_left.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				backToLastActivity();
			}
		});
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		switch (keyCode) {
		case KeyEvent.KEYCODE_BACK:
			backToLastActivity();
			return true;

		default:
			return super.onKeyDown(keyCode, event);

		}

	}

	private void backToLastActivity() {
		String currentTag = ContentValues.tabhost.getCurrentTabTag();
		try {

			if (currentTag.equals(MainActivity.getLastTabTag())) {
				MainActivity.tabSpecsList.remove(currentTag);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		MainActivity.setCurrentTabByTag(MainActivity.getLastTabTag(), false);
	}

}
