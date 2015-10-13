package com.coyotelib.app.base;

import android.annotation.SuppressLint;
import android.app.Activity;

import com.coyotelib.R;
import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.sys.CoyoteSystem;

public class ThemeChangeHelper {

	private static ThemeChangeHelper INST = new ThemeChangeHelper();

	private ThemeChangeHelper() {

	}

	public static ThemeChangeHelper getInst() {
		return INST;
	}

	private ISettingService setting = (ISettingService) CoyoteSystem.getCurrent().getService(ISettingService.class);

	private static final String KEY_THEME = "key_theme";
	public static final int DEFUALT_THEME = R.style.themeTest1;

	public int getCurrentTheme() {
		return setting.getInt(KEY_THEME, DEFUALT_THEME);
	}

	public void setCurrentTheme(int themeID) {
		setting.setInt(KEY_THEME, themeID);
	}

	public void changeTheme(int themeID, Activity activityContext) {
		setCurrentTheme(themeID);
		activityContext.recreate();
	}
}
