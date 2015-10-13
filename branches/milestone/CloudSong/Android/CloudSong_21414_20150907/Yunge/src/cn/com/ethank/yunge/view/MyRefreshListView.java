/*******************************************************************************
 * Copyright 2011, 2012 Chris Banes.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/
package cn.com.ethank.yunge.view;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ListView;
import cn.com.ethank.yunge.R;

import com.handmark.pulltorefresh.library.OverscrollHelper;
import com.handmark.pulltorefresh.library.PullToRefreshAdapterViewBase;
import com.handmark.pulltorefresh.library.internal.EmptyViewMethodAccessor;

public class MyRefreshListView extends PullToRefreshAdapterViewBase<ListView> {

	private TouchLisTener touchListener;

	public MyRefreshListView(Context context) {
		super(context);
		setPullToRefreshOverScrollEnabled(false);
	}

	public MyRefreshListView(Context context, AttributeSet attrs) {
		super(context, attrs);
		setPullToRefreshOverScrollEnabled(false);
	}

	public MyRefreshListView(Context context, Mode mode) {
		super(context, mode);
		setPullToRefreshOverScrollEnabled(false);
	}

	public MyRefreshListView(Context context, Mode mode, AnimationStyle style) {
		super(context, mode, style);
		setPullToRefreshOverScrollEnabled(false);
	}

	@Override
	public final Orientation getPullToRefreshScrollDirection() {
		return Orientation.VERTICAL;
	}

	@Override
	protected final ListView createRefreshableView(Context context, AttributeSet attrs) {
		final ListView lv;
		if (VERSION.SDK_INT >= VERSION_CODES.GINGERBREAD) {
			lv = new InternalListViewSDK9(context, attrs);
		} else {
			lv = new InternalListView(context, attrs);
		}

		// Use Generated ID (from res/values/ids.xml)
		lv.setId(R.id.listView);
		return lv;
	}

	class InternalListView extends ListView implements EmptyViewMethodAccessor {

		public InternalListView(Context context, AttributeSet attrs) {
			super(context, attrs);
		}

		@Override
		public void setEmptyView(View emptyView) {
			MyRefreshListView.this.setEmptyView(emptyView);
		}

		@Override
		public void setEmptyViewInternal(View emptyView) {
			super.setEmptyView(emptyView);
		}
	}

	@TargetApi(9)
	final class InternalListViewSDK9 extends InternalListView {

		public InternalListViewSDK9(Context context, AttributeSet attrs) {
			super(context, attrs);
		}

		@Override
		protected boolean overScrollBy(int deltaX, int deltaY, int scrollX, int scrollY, int scrollRangeX, int scrollRangeY, int maxOverScrollX,
				int maxOverScrollY, boolean isTouchEvent) {

			final boolean returnValue = super.overScrollBy(deltaX, deltaY, scrollX, scrollY, scrollRangeX, scrollRangeY, maxOverScrollX,
					maxOverScrollY, isTouchEvent);

			// Does all of the hard work...
			OverscrollHelper.overScrollBy(MyRefreshListView.this, deltaX, scrollX, deltaY, scrollY, isTouchEvent);

			return returnValue;
		}
	}

	public void refreshComplete() {
		try {
			this.onRefreshComplete();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public boolean dispatchTouchEvent(MotionEvent ev) {

		if (touchListener != null) {
			touchListener.OnTouchLisTener();
		}
		return super.dispatchTouchEvent(ev);

	}

	public interface TouchLisTener {
		boolean OnTouchLisTener();
	}

	public void setTouchLisTener(TouchLisTener touchListener) {
		this.touchListener = touchListener;
	}
}
