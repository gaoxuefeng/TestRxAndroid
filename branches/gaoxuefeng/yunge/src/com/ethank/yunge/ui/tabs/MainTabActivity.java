package com.ethank.yunge.ui.tabs;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.view.KeyEvent;
import android.widget.Toast;

import com.ethank.yunge.R;
import com.ethank.yunge.ui.BaseActivity;

public class MainTabActivity extends BaseActivity {
	public static boolean isexit = false;
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
	public void initBaseView() {
		setLeftTvVisible(false);
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		switch (keyCode) {
		case KeyEvent.KEYCODE_BACK:
			if (isexit == false) {
				Toast.makeText(this, R.string.finish_application, Toast.LENGTH_SHORT).show();
				isexit = true;
				handler.sendEmptyMessageDelayed(0, 2000);
				return true;
			} else {
				isexit = false;
				finish();
				return true;
			}

		default:
			return super.onKeyDown(keyCode, event);

		}

	}
}
