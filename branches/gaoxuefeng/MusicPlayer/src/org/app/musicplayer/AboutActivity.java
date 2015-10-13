package org.app.musicplayer;

import android.os.Bundle;
/**
 * 关于界面
 * @author 恋心
 *
 */
public class AboutActivity extends SettingActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.about);
		setTopTitle(getResources().getString(R.string.about_title));
	}

}
