package com.coyotelib.app.ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.coyotelib.R;

public class BasicTitle extends RelativeLayout {
	public ImageButton mBtnBack;
	private ImageButton mBtnFunction;

	public TextView mTitleName;

	private ImageView mTitleImg;
	private LinearLayout mTitleBarContainer;
	public View v_basic_line;

	public BasicTitle(Context context, AttributeSet attrs) {
		super(context, attrs);
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		inflater.inflate(R.layout.titlelayout, this);

		mBtnBack = (ImageButton) findViewById(R.id.btn_back);
		mTitleName = (TextView) findViewById(R.id.function_name);
		mBtnFunction = (ImageButton) findViewById(R.id.title_function);
		mTitleImg = (ImageView) findViewById(R.id.title_img);
		v_basic_line = (View) findViewById(R.id.v_basic_line);

		mTitleBarContainer = (LinearLayout) findViewById(R.id.title_bar);

		mTitleBarContainer.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, dip2px(60)));
	}

	public int dip2px(float dipValue) {
		final float scale = getResources().getDisplayMetrics().density;
		return (int) (dipValue * scale + 0.5f);
	}

	public void setFragmentName(int resId) {
		mTitleName.setText(resId);
	}

	public void setTitle(String tiltle) {
		mTitleName.setText(tiltle);
	}

	public void setTitle(int res) {
		mTitleName.setText(res);
	}

	public void setBtnFunctionTextColor(String color) {
		mBtnFunction.setTextColor(color);
	}

	public void setBtnFunctionText(String rightText) {
		mBtnFunction.setText(rightText);
	}

	public void setBtnFunctionText(int res) {
		mBtnFunction.setText(getResources().getString(res));
	}

	public void setTitleImg(int res) {
		mTitleImg.setBackgroundResource(res);
		mTitleImg.setVisibility(View.VISIBLE);
	}

	public void setBtnFunctionImage(int resid) {
		if (resid == 0) {
			mBtnFunction.setIconBmp(null);
		} else
			mBtnFunction.setIconBmp(getResources().getDrawable(resid));
	}

	public void showBtnFunction() {
		mBtnFunction.setVisibility(View.VISIBLE);
	}

	public void showBtnFunction(boolean isVisible) {
		if (isVisible) {
			mBtnFunction.setVisibility(View.VISIBLE);
		} else {
			mBtnFunction.setVisibility(View.GONE);
		}

	}
	public void showBottomLine(boolean isVisible) {
		if (isVisible) {
			v_basic_line.setVisibility(View.VISIBLE);
		} else {
			v_basic_line.setVisibility(View.GONE);
		}
		
	}

	public void setOnBtnFunctionClickAction(OnClickListener l) {
		mBtnFunction.setOnClickListener(l);
	}

	public void setBtnBackImage(int resid) {
		if (resid == 0) {
			mBtnBack.setIconBmp(null);
		} else
			mBtnBack.setIconBmp(getResources().getDrawable(resid));
	}

	public void setBtnBackText(int stresid) {
		mBtnBack.setText(getResources().getString(stresid));
	}

	public void setBtnBackText(String string) {
		mBtnBack.setText(string);
	}

	public void setBtnBackTextColor(String color) {
		mBtnBack.setTextColor(color);
	}

	public void setOnBtnBackClickAction(OnClickListener l) {
		mBtnBack.setOnClickListener(l);
	}

	public void showBtnBack() {
		mBtnBack.setVisibility(VISIBLE);
	}

	public void showBtnBack(boolean isVisible) {
		if (isVisible) {
			mBtnBack.setVisibility(View.VISIBLE);
		} else {
			mBtnBack.setVisibility(View.GONE);
		}

	}

	public void setSecondaryType() {
		mBtnBack.setVisibility(View.VISIBLE);
		mBtnFunction.setVisibility(View.GONE);
	}

	public void setFunctionDrawable(int resID) {
		mBtnFunction.setImageResource(resID);
	}

	public void setBackgroundColor(int res) {
		mTitleBarContainer.setBackgroundColor(res);
	}

	public void setTitleColor(int colorRes) {
		mTitleName.setTextColor(colorRes);
	}

}
