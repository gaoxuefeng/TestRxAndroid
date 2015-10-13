package com.coyotelib.app.ui.widget;

import com.coyotelib.R;

import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

public class ImageButton extends FrameLayout {

	public ImageView mImgView;
	public TextView mTvView;

	public ImageButton(Context context, AttributeSet attrs) {
		super(context, attrs);
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		inflater.inflate(R.layout.image_btn_layout, this);

		mImgView = (ImageView) findViewById(R.id.img_view);
		mTvView = (TextView) findViewById(R.id.tv_view);

		TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.imgbtn);
		Drawable drawable = a.getDrawable(R.styleable.imgbtn_img);
		if (drawable != null) {
			mImgView.setImageDrawable(drawable);
		}

		a.recycle();
	}

	public void setIconBmp(Drawable drawable) {
		if (drawable != null) {
			mImgView.setImageDrawable(drawable);
		}else{
			mImgView.setAlpha(0f);
		}
	}

	public void setText(String string) {
		if (string != null) {
			mTvView.setText(string);
		} else {
			mTvView.setText("");
		}
	}

	public void setTextColor(String color) {
		if (color != null) {
			mTvView.setTextColor(Color.parseColor(color));
		}
	}

	public void setImageResource(int resId) {
		mImgView.setImageResource(resId);

	}

}
