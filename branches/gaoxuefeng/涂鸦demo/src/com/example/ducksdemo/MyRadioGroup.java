/*
 * 
 * Copyright (C) 2006 The Android Open Source Project
 * 
 * 
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * 
 * you may not use this file except in compliance with the License.
 * 
 * You may obtain a copy of the License at
 * 
 * 
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * 
 * 
 * Unless required by applicable law or agreed to in writing, software
 * 
 * distributed under the License is distributed on an "AS IS" BASIS,
 * 
 * WITHOUT WARRANTIES OR CONDITI OF ANY KIND, either express or implied.
 * 
 * See the License for the specific language governing permissions and
 * 
 * limitations under the License.
 */
package com.example.ducksdemo;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.RadioButton;

public class MyRadioGroup extends LinearLayout {
	// holds the checked id; the ion is empty by default
	private int mCheckedId = -1;
	// tracks children radio buttons checked state
	private CompoundButton.OnCheckedChangeListener mChildOnCheckedChangeListener;
	// when true, mOnCheckedChangeListener discards events
	private boolean mProtectFromCheckedChange = false;
	private OnCheckedChangeListener mOnCheckedChangeListener;
	private PassThroughHierarchyChangeListener mPassThroughListener;

	public MyRadioGroup(Context context) {
		super(context);
		setOrientation(LinearLayout.VERTICAL);
		init();
	}

	public MyRadioGroup(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}

	private void init() {
		mChildOnCheckedChangeListener = new CheckedStateTracker();
		mPassThroughListener = new PassThroughHierarchyChangeListener();
		super.setOnHierarchyChangeListener(mPassThroughListener);
	}

	@Override
	public void setOnHierarchyChangeListener(OnHierarchyChangeListener listener) {
		// the user listener is delegated to our pass-through listener
		mPassThroughListener.mOnHierarchyChangeListener = listener;
	}

	@Override
	protected void onFinishInflate() {
		if (mCheckedId != -1) {
			mProtectFromCheckedChange = true;
			setCheckedStateForView(mCheckedId, true);
			mProtectFromCheckedChange = false;
			setCheckedId(mCheckedId);
		}
	}

	@Override
	public void addView(View child, int index, ViewGroup.LayoutParams params) {
		if (child instanceof RadioButton) {
			final RadioButton button = (RadioButton) child;
			if (button.isChecked()) {
				mProtectFromCheckedChange = true;
				if (mCheckedId != -1) {
					setCheckedStateForView(mCheckedId, false);
				}
				mProtectFromCheckedChange = false;
				setCheckedId(button.getId());
			}
		} else if (child instanceof ViewGroup) {
			final RadioButton button = findRadioButton((ViewGroup) child);
			if (button.isChecked()) {

				mProtectFromCheckedChange = true;
				if (mCheckedId != -1) {
					setCheckedStateForView(mCheckedId, false);

				}
				mProtectFromCheckedChange = false;
				setCheckedId(button.getId());
			}
			child.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					try {
						button.setChecked(true);
					} catch (Exception e) {
						e.printStackTrace();
					}
					
				}
			});

		}
		super.addView(child, index, params);
	}

	/** 查找radioButton控件 */
	public RadioButton findRadioButton(ViewGroup group) {
		RadioButton resBtn = null;
		int len = group.getChildCount();
		for (int i = 0; i < len; i++) {
			if (group.getChildAt(i) instanceof RadioButton) {
				resBtn = (RadioButton) group.getChildAt(i);
			} else if (group.getChildAt(i) instanceof ViewGroup) {
				findRadioButton((ViewGroup) group.getChildAt(i));
			}
		}
		return resBtn;
	}

	/**
	 * 
	 * <p>
	 * 
	 * Sets the ion to the radio button whose identifier is passed in
	 * 
	 * parameter. Using -1 as the ion identifier clears the ion;
	 * 
	 * such an operation is equivalent to invoking {@link ＃clearCheck()}.
	 * 
	 * </p>
	 * 
	 * 
	 * 
	 * @param id
	 * 
	 *            the unique id of the radio button to in this group
	 * 
	 * 
	 * 
	 * @see ＃getCheckedRadioButtonId()
	 * 
	 * @see ＃clearCheck()
	 */
	public void check(int id) {
		// don""t even bother
		if (id != -1 && id == mCheckedId) {
			return;
		}
		if (mCheckedId != -1) {
			setCheckedStateForView(mCheckedId, false);
		}
		if (id != -1) {
			setCheckedStateForView(id, true);
		}
		setCheckedId(id);
	}

	private void setCheckedId(int id) {
		mCheckedId = id;
		if (mOnCheckedChangeListener != null) {
			mOnCheckedChangeListener.onCheckedChanged(this, mCheckedId);
		}
	}

	private void setCheckedStateForView(int viewId, boolean checked) {
		View checkedView = findViewById(viewId);
		if (checkedView != null && checkedView instanceof RadioButton) {
			((RadioButton) checkedView).setChecked(checked);
		}
	}

	/**
	 * 
	 * <p>
	 * 
	 * Returns the identifier of the ed radio button in this group. Upon
	 * 
	 * empty ion, the returned value is -1.
	 * 
	 * </p>
	 * 
	 * 
	 * 
	 * @return the unique id of the ed radio button in this group
	 * 
	 * 
	 * 
	 * @see ＃check(int)
	 * 
	 * @see ＃clearCheck()
	 */
	public int getCheckedRadioButtonId() {
		return mCheckedId;
	}

	/**
	 * 
	 * <p>
	 * 
	 * Clears the ion. When the ion is cleared, no radio button in
	 * 
	 * this group is ed and {@link ＃getCheckedRadioButtonId()} returns
	 * 
	 * null.
	 * 
	 * </p>
	 * 
	 * 
	 * 
	 * @see ＃check(int)
	 * 
	 * @see ＃getCheckedRadioButtonId()
	 */
	public void clearCheck() {
		check(-1);
	}

	/**
	 * 
	 * <p>
	 * 
	 * Register a callback to be invoked when the checked radio button changes
	 * 
	 * in this group.
	 * 
	 * </p>
	 * 
	 * 
	 * 
	 * @param listener
	 * 
	 *            the callback to call on checked state change
	 */
	public void setOnCheckedChangeListener(OnCheckedChangeListener listener) {
		mOnCheckedChangeListener = listener;
	}

	/**
	 * 
	 * {@inheritDoc}
	 */
	@Override
	public LayoutParams generateLayoutParams(AttributeSet attrs) {
		return new MyRadioGroup.LayoutParams(getContext(), attrs);
	}

	/**
	 * 
	 * {@inheritDoc}
	 */
	@Override
	protected boolean checkLayoutParams(ViewGroup.LayoutParams p) {
		return p instanceof MyRadioGroup.LayoutParams;
	}

	@Override
	protected LinearLayout.LayoutParams generateDefaultLayoutParams() {
		return new LayoutParams(android.view.ViewGroup.LayoutParams.WRAP_CONTENT, android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
	}

	/**
	 * 
	 * <p>
	 * 
	 * This set of layout parameters defaults the width and the height of the
	 * 
	 * children to {@link ＃WRAP_CONTENT} when they are not specified in the XML
	 * 
	 * file. Otherwise, this class ussed the value read the XML file.
	 * 
	 * </p>
	 * 
	 * 
	 * 
	 * <p>
	 * 
	 * See {@link android.R.styleable＃LinearLayout_Layout LinearLayout
	 * 
	 * Attributes} for a list of all child view attributes that this class
	 * 
	 * supports.
	 * 
	 * </p>
	 * 
	 * 
	 */
	public static class LayoutParams extends LinearLayout.LayoutParams {
		/**
		 * 
		 * {@inheritDoc}
		 */
		public LayoutParams(Context c, AttributeSet attrs) {
			super(c, attrs);
		}

		/**
		 * 
		 * {@inheritDoc}
		 */
		public LayoutParams(int w, int h) {
			super(w, h);
		}

		/**
		 * 
		 * {@inheritDoc}
		 */
		public LayoutParams(int w, int h, float initWeight) {
			super(w, h, initWeight);
		}

		/**
		 * 
		 * {@inheritDoc}
		 */
		public LayoutParams(ViewGroup.LayoutParams p) {
			super(p);
		}

		/**
		 * 
		 * {@inheritDoc}
		 */
		public LayoutParams(MarginLayoutParams source) {
			super(source);
		}

		/**
		 * 
		 * <p>
		 * 
		 * Fixes the child""s width to
		 * 
		 * {@link android.view.ViewGroup.LayoutParams＃WRAP_CONTENT} and the
		 * 
		 * child""s height to
		 * 
		 * {@link android.view.ViewGroup.LayoutParams＃WRAP_CONTENT} when not
		 * 
		 * specified in the XML file.
		 * 
		 * </p>
		 * 
		 * 
		 * 
		 * @param a
		 * 
		 *            the styled attributes set
		 * 
		 * @param widthAttr
		 * 
		 *            the width attribute to fetch
		 * 
		 * @param heightAttr
		 * 
		 *            the height attribute to fetch
		 */
		@Override
		protected void setBaseAttributes(TypedArray a, int widthAttr, int heightAttr) {
			if (a.hasValue(widthAttr)) {
				width = a.getLayoutDimension(widthAttr, "layout_width");
			} else {
				width = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
			}
			if (a.hasValue(heightAttr)) {
				height = a.getLayoutDimension(heightAttr, "layout_height");
			} else {
				height = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
			}
		}
	}

	/**
	 * 
	 * <p>
	 * 
	 * Interface definition for a callback to be invoked when the checked radio
	 * 
	 * button changed in this group.
	 * 
	 * </p>
	 */
	public interface OnCheckedChangeListener {
		/**
		 * 
		 * <p>
		 * 
		 * Called when the checked radio button has changed. When the ion
		 * 
		 * is cleared, checkedId is -1.
		 * 
		 * </p>
		 * 
		 * 
		 * 
		 * @param group
		 * 
		 *            the group in which the checked radio button has changed
		 * 
		 * @param checkedId
		 * 
		 *            the unique identifier of the newly checked radio button
		 */
		public void onCheckedChanged(MyRadioGroup group, int checkedId);
	}

	private class CheckedStateTracker implements CompoundButton.OnCheckedChangeListener {
		@Override
		public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
			// prevents infinite recursion
			if (mProtectFromCheckedChange) {
				return;
			}
			mProtectFromCheckedChange = true;
			if (mCheckedId != -1) {
				setCheckedStateForView(mCheckedId, false);
			}
			mProtectFromCheckedChange = false;
			int id = buttonView.getId();
			setCheckedId(id);
		}
	}

	/**
	 * 
	 * <p>
	 * 
	 * A pass-through listener acts upon the events and dispatches them to
	 * 
	 * another listener. This allows the table layout to set its own internal
	 * 
	 * hierarchy change listener without preventing the user to setup his.
	 * 
	 * </p>
	 */
	private class PassThroughHierarchyChangeListener implements ViewGroup.OnHierarchyChangeListener {
		private ViewGroup.OnHierarchyChangeListener mOnHierarchyChangeListener;

		@Override
		public void onChildViewAdded(View parent, View child) {
			if (parent == MyRadioGroup.this && child instanceof RadioButton) {
				int id = child.getId();
				// generates an id if it""s missing
				if (id == View.NO_ID) {
					id = child.hashCode();
					child.setId(id);
				}
				((RadioButton) child).setOnCheckedChangeListener(mChildOnCheckedChangeListener);
			} else if (parent == MyRadioGroup.this && child instanceof ViewGroup) {
				RadioButton btn = findRadioButton((ViewGroup) child);
				int id = btn.getId();
				// generates an id if it""s missing
				if (id == View.NO_ID) {
					id = btn.hashCode();
					btn.setId(id);
				}
				btn.setOnCheckedChangeListener(mChildOnCheckedChangeListener);
			}
			if (mOnHierarchyChangeListener != null) {
				mOnHierarchyChangeListener.onChildViewAdded(parent, child);
			}
		}

		@Override
		public void onChildViewRemoved(View parent, View child) {
			if (parent == MyRadioGroup.this && child instanceof RadioButton) {
				((RadioButton) child).setOnCheckedChangeListener(null);
			} else if (parent == MyRadioGroup.this && child instanceof ViewGroup) {
				findRadioButton((ViewGroup) child).setOnCheckedChangeListener(null);
			}
			if (mOnHierarchyChangeListener != null) {
				mOnHierarchyChangeListener.onChildViewRemoved(parent, child);
			}
		}
	}

	

}
