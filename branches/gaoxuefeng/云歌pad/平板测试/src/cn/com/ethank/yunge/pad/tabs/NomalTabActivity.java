package cn.com.ethank.yunge.pad.tabs;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Toast;

import cn.com.ethank.yunge.pad.BaseActivity;
import cn.com.ethank.yunge.pad.MainActivity;
import cn.com.ethank.yunge.pad.utils.ContentValues;
import cn.com.ethank.yunge.pad.utils.ToastUtil;

public class NomalTabActivity extends BaseActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		addActivity();
		ToastUtil.show(ContentValues.tabhost.getTabContentView().getChildCount() + "");
	}

	private void addActivity() {
		if (!ContentValues.activityStack.contains(this)) {
			ContentValues.activityStack.add(this);
		} else {
			ContentValues.activityStack.remove(this);
			ContentValues.activityStack.add(this);
		}

	}

	@Override
	public void initBaseView() {
		setTitleVisible(true);
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
				ViewGroup view = ContentValues.tabhost.getTabContentView();
				int count = view.getChildCount();
				view.removeViewAt(count - 1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		MainActivity.setCurrentTabByTag(MainActivity.getLastTabTag(), false);
		// ContentValues.tabhost.setCurrentTab(ContentValues.tabhost.getChildCount()
		// - 1);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		removeActivity();

	}

	@SuppressLint("NewApi")
	private void removeActivity() {
		if (ContentValues.activityStack.contains(this)) {
			ContentValues.activityStack.remove(this);
		}
	}
}
