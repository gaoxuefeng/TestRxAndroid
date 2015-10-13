package com.coyotelib.app.ui.util;

import android.app.Activity;
import android.content.Context;
import android.graphics.Rect;
import android.util.DisplayMetrics;

public class UICommonUtil {

	// pixs =
	public static int dip2px(Context context, float dipValue) {
		if (context != null) {
			final float scale = context.getResources().getDisplayMetrics().density;
			return (int) (dipValue * scale + 0.5f);
		}
		return (int) (1.5f * dipValue);

	}

	// dips=(pixs*160)/densityDpi
	public static int px2dip(Context context, float pxValue) {
		if (context != null) {
			final float scale = context.getResources().getDisplayMetrics().density;
			return (int) (pxValue / scale + 0.5f);
		}
		return (int) (pxValue / 1.5f);

	}

	public static int px2sp(Context context, float pxValue) {
		if (context != null) {
			final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
			return (int) (pxValue / fontScale + 0.5f);
		}
		return (int) (pxValue / 1.5f);
	}

	public static int sp2px(Context context, float spValue) {
		if (context != null) {
			final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
			return (int) (spValue * fontScale + 0.5f);
		}
		return (int) (1.5f * spValue);
	}

	public static int getScreenWidthPixels(Context context) {
		if (context != null) {
			DisplayMetrics dm = new DisplayMetrics();
			dm = context.getResources().getDisplayMetrics();
			return dm.widthPixels;
		}
		return 720;

	}

	public static int getScreenHeightPixels(Context context) {
		if (context != null) {
			DisplayMetrics dm = new DisplayMetrics();
			dm = context.getResources().getDisplayMetrics();
			return dm.heightPixels;
		}
		return 1080;
	}

	/**
	 * 获取状态栏高度
	 * 
	 * @param context
	 * @return
	 */
	public static int getScreenTopPixels(Activity context) {
		if (context != null) {
			Rect rect = new Rect();
			context.getWindow().getDecorView().getWindowVisibleDisplayFrame(rect);
			return rect.top;
		}
		return 70;

	}
}
