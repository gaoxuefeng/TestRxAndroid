package com.example.lightdemo;

/*
 * Copyright 2013 Csaba Szugyiczki
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * 
 * @author Szugyi Custom ImageView for the CircleLayout class. Makes it possible
 *         for the image to have an angle, position and a name. Angle is used
 *         for the positioning in the circle menu.
 */
public class CircleImageView2 extends ImageView {

	private float angle = 0;
	private int position = 0;
	private String name;

	public float getAngle() {
		return angle;
	}

	public void setAngle(float angle) {
		this.angle = angle;
		float dAngle = Math.abs(angle - 270) < 2 ? 2 : Math.abs(angle - 270);
		try {
			if (dAngle < 45) {
				float alpha = 510 / dAngle;
				this.getBackground().setAlpha((int) alpha);
			} else {
				this.getBackground().setAlpha((int) 0f);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public int getPosition() {
		return position;
	}

	public void setPosition(int position) {
		this.position = position;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @param context
	 */
	public CircleImageView2(Context context) {
		this(context, null);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	public CircleImageView2(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}

	/**
	 * @param context
	 * @param attrs
	 * @param defStyle
	 */
	public CircleImageView2(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
//		if (attrs != null) {
//			TypedArray a = getContext().obtainStyledAttributes(attrs, R.styleable.CircleImageView);
//			setScaleType(ScaleType.CENTER_CROP);
//			name = a.getString(R.styleable.CircleImageView_name);
//		}
	}

}
