package com.coyotelib.app.ui.widget;

import java.lang.reflect.Method;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Build;
import android.util.AttributeSet;
import android.view.View;
import android.webkit.WebView;

/**
 * Created by chenjishi on 14-1-11.
 */
public class HAWebView extends WebView {
	private Method mCavansIsHAAcced;
	private Method mViewSetLayerType;
	private boolean mSupportAccApi;

	public HAWebView(Context context, AttributeSet attrs) {
		super(context, attrs);
		try {
			mCavansIsHAAcced = Canvas.class.getMethod("isHardwareAccelerated");
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			mViewSetLayerType = View.class.getMethod("setLayerType", int.class,
					Paint.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mSupportAccApi = Build.VERSION.SDK_INT >= 11
				&& mCavansIsHAAcced != null && mViewSetLayerType != null;
	}

	@Override
	protected void onDraw(Canvas canvas) {
		try {
			if (mSupportAccApi && (Boolean) mCavansIsHAAcced.invoke(canvas)) {
				mViewSetLayerType.invoke(this, 1, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		super.onDraw(canvas);
	}
}
