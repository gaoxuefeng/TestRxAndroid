package cn.com.ethank.yunge.view;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.FrameLayout;
import cn.com.ethank.yunge.app.util.DisplayUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

public class ResizeLayout extends FrameLayout {

	private OnkeyboardShowListener mChangedListener;
	private boolean misKeyboardshow = false;
	private int keyboardHeight = DisplayUtil.px2dip(Config.DEFAULT_KEYBOARD_HIGHT);
	private final int THRESHOLD = 100;

	/**
	 * @param context
	 * @param attrs
	 */
	public ResizeLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public static interface OnkeyboardShowListener {
		public void onKeyboardShow();

		public void onKeyboardHide();

		public void onKeyboardHideOver();

		public void onKeyboardShowOver();

		public void onKeyboardShowStart();
	}

	@Override
	protected void onSizeChanged(int w, int h, int oldw, int oldh) {
		super.onSizeChanged(w, h, oldw, oldh);
		if (oldh - h > THRESHOLD) { // 键盘弹出了
			misKeyboardshow = true;
			keyboardHeight = oldh - h;
			SharePreferencesUtil.saveIntData(Config.KEYBOARD_HIGHT, keyboardHeight);
			if (mChangedListener != null) {
				mChangedListener.onKeyboardShow();
			}
		} else if (h < oldh && misKeyboardshow) { // 键盘变高了
			if (keyboardHeight == DisplayUtil.px2dip(Config.DEFAULT_KEYBOARD_HIGHT)) {
				// SharePreferencesUtil.getIntValue(Config.KEYBOARD_HIGHT,
				// DisplayUtil.px2dip(Config.DEFAULT_KEYBOARD_HIGHT));
			}
			if (keyboardHeight != DisplayUtil.px2dip(Config.DEFAULT_KEYBOARD_HIGHT)) {
				keyboardHeight += oldh - h;
				SharePreferencesUtil.saveIntData(Config.KEYBOARD_HIGHT, keyboardHeight);
			}
			if (mChangedListener != null) {
				mChangedListener.onKeyboardShow();
			}
		} else if (h - oldh > THRESHOLD) { // 键盘隐藏了
			misKeyboardshow = false;
			if (mChangedListener != null) {
				mChangedListener.onKeyboardHide();
			}
		} else if (h > oldh && misKeyboardshow) { // 键盘收缩了
			if (keyboardHeight == DisplayUtil.px2dip(Config.DEFAULT_KEYBOARD_HIGHT)) {
				// SharePreferencesUtil.getIntValue(Config.KEYBOARD_HIGHT,
				// DisplayUtil.px2dip(Config.DEFAULT_KEYBOARD_HIGHT));
			}
			if (keyboardHeight != DisplayUtil.px2dip(Config.DEFAULT_KEYBOARD_HIGHT)) {
				keyboardHeight -= h - oldh;
				SharePreferencesUtil.saveIntData(Config.KEYBOARD_HIGHT, keyboardHeight);
			}
			if (mChangedListener != null) {
				mChangedListener.onKeyboardShow();
			}
		}
		Log.i("NCS", "keyboard height:" + keyboardHeight);
	}

	@SuppressLint("WrongCall")
	@Override
	protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
		Log.i("NES", "是否改变:" + changed + ";是否隐藏:" + misKeyboardshow);
		if (mChangedListener != null && misKeyboardshow) {
			mChangedListener.onKeyboardShowStart();
		}

		super.onLayout(changed, left, top, right, bottom);
		Log.i("NCS", "top:" + top + "--bottom:" + bottom);
		if (mChangedListener != null && misKeyboardshow) {
			mChangedListener.onKeyboardShowOver();
			if (changed) {
				invalidate();
			}

		}
		if (mChangedListener != null && !misKeyboardshow) {
			mChangedListener.onKeyboardHideOver();
		}

	}

	public boolean isKeyboardShowing() {
		return misKeyboardshow;
	}

	public void setOnKeyboardShowListener(OnkeyboardShowListener listener) {
		mChangedListener = listener;
	}

}