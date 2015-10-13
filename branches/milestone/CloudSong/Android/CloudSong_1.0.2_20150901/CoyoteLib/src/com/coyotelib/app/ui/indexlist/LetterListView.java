package com.coyotelib.app.ui.indexlist;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

import com.coyotelib.R;

public class LetterListView extends View {

	String[] b = { "热", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
			"L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
			"Y", "Z" };
	int choose = -1;
	Paint paint = new Paint();
	boolean showBkg = false;
	private OnTouchingLetterChangedListener onLetterChanged;

	private String mColor = "#8D2960";

	public interface OnTouchingLetterChangedListener {
		public void onTouchingLetterChanged(String s);
	}

	public LetterListView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public LetterListView(Context context, AttributeSet attrs) {
		super(context, attrs);
		TypedArray a = context.obtainStyledAttributes(attrs,
				R.styleable.SgLetterList);
		String letterColor = a.getString(R.styleable.SgLetterList_letterColor);
		if (!TextUtils.isEmpty(letterColor)) {
//			mColor = letterColor;
		}
		a.recycle();
	}

	public LetterListView(Context context) {
		super(context);
	}

	public void setColor(String color) {
		mColor = color;
	}

	private int getTextSize(int singleHeight) {
		if (singleHeight >= 30) {
			return 30;
		} else if (singleHeight >= 20 && singleHeight < 30) {
			return 20;
		} else {
			return 10;
		}
	}

	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		if (showBkg) {
			canvas.drawColor(Color.parseColor("#0A000000"));
		}

		int height = getHeight()-15;
		/*
		 * MaxHight = Math.max(MaxHight, height); height = MaxHight;
		 */
		int width = getWidth();
		int singleHeight = height / b.length;
		for (int i = 0; i < b.length; i++) {
			paint.setColor(Color.parseColor("#8D2960"));
			paint.setAntiAlias(true);
			paint.setTextSize(getTextSize(singleHeight));
			
			if (i == choose) {
				paint.setColor(Color.parseColor("#8D2960"));
				paint.setFakeBoldText(true);
			}
			float xPos = width / 2 - paint.measureText(b[i]) / 2;
			float yPos = singleHeight * i + singleHeight;
			canvas.drawText(b[i], xPos, yPos, paint);
			paint.reset();
		}
	}

	@Override
	public boolean dispatchTouchEvent(MotionEvent event) {
		final int action = event.getAction();
		final float y = event.getY();
		final int oldChoose = choose;
		final OnTouchingLetterChangedListener listener = onLetterChanged;
		final int c = (int) (y / getHeight() * b.length);

		switch (action) {
		case MotionEvent.ACTION_DOWN:
			showBkg = true;
			if (oldChoose != c && listener != null) {
				if (c > 0 && c < b.length) {
					listener.onTouchingLetterChanged(b[c]);
					choose = c;
					invalidate();
				}
			}

			break;
		case MotionEvent.ACTION_MOVE:
			if (oldChoose != c && listener != null) {
				if (c >= 0 && c < b.length) {
					listener.onTouchingLetterChanged(b[c]);
					choose = c;
					invalidate();
				}
			}
			break;
		case MotionEvent.ACTION_UP:
			showBkg = false;
			choose = -1;
			invalidate();
			break;
		}
		return true;
	}

	public void setOnTouchingLetterChangedListener(
			OnTouchingLetterChangedListener onTouchingLetterChangedListener) {
		this.onLetterChanged = onTouchingLetterChangedListener;
	}

	@Override
	protected void onSizeChanged(int w, int h, int oldw, int oldh) {
		super.onSizeChanged(w, h, oldw, oldh);
	}

	public void refresh() {
		this.requestLayout();
		this.invalidate();
	}

}
