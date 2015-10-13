package cn.com.ethank.yunge.app.util;

import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

public class KeyboardUtils {
	public static void hide(Context c, View focusedView) {
		InputMethodManager inputMethodManager = (InputMethodManager) c
				.getSystemService(Context.INPUT_METHOD_SERVICE);
		inputMethodManager.hideSoftInputFromWindow(
				focusedView.getWindowToken(), 0);
	}

	public static boolean isShown(Context c) {
		return ((InputMethodManager) c
				.getSystemService(Context.INPUT_METHOD_SERVICE)).isActive();
	}

	public static void show(Context c, View focusedView) {
		((InputMethodManager) c.getSystemService(Context.INPUT_METHOD_SERVICE))
				.showSoftInput(focusedView, InputMethodManager.SHOW_FORCED);
	}
}
