package com.coyotelib.app.base;

import android.app.Activity;
import android.os.Bundle;

public class SkinChangableActivity extends Activity {

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setTheme(ThemeChangeHelper.getInst().getCurrentTheme());
	}
	
}
