package cn.com.ethank.yunge.app.discover.util;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.AbsListView;
import android.widget.GridView;

public class ScrollGridView extends GridView {

	ScrollViewRefrashUi scrollViewRefrashUi;

	public ScrollGridView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
		setScrollListener();
	}

	public ScrollGridView(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
		setScrollListener();
	}

	public ScrollGridView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		setScrollListener();
	}

	public void setScrollViewRefrashUi(ScrollViewRefrashUi scrollViewRefrashUi) {
		this.scrollViewRefrashUi = scrollViewRefrashUi;
	}

	int mGridViewFirstItem = 0;
	private int mLastY = 0;
	boolean mIsScrollIng = false;

	// listView中第一项的索引
	private int mListViewFirstItem = 0;
	// listView中第一项的在屏幕中的位置
	private int mScreenY = 0;
	// 是否向上滚动
	private boolean mIsScrollToUp = false;

	int lastVisibleItemPosition = 0;

	private void setScrollListener() {
		

		// this.setOnTouchListener(new OnTouchListener() {
		//
		// @Override
		// public boolean onTouch(View arg0, MotionEvent ev) {
		// // TODO Auto-generated method stub
		// final int action = ev.getAction();
		// switch (action & MotionEvent.ACTION_MASK) {
		// case MotionEvent.ACTION_MOVE:
		// if (mIsScrollIng) {
		// final int y = (int) ev.getY();
		// if (y > (mLastY + 10)) {// 向下
		// scrollViewRefrashUi.RefrashUiCallBack(false);
		// } else { // 向上
		// scrollViewRefrashUi.RefrashUiCallBack(true);
		// }
		// mLastY = y;
		// // mIsScrollIng = !mIsScrollIng;
		// }
		// // 判断是否上拉滑倒低端，如果上拉滑倒低端则将view设置为最小值
		// if (getLastVisiblePosition() == getCount() - 1) {
		// scrollViewRefrashUi.RefrashUiCallBack(true);
		// }
		//
		// // 判断是否滑倒顶端,如果到顶端则将view设置为最大值
		// if (getFirstVisiblePosition() == 0) {
		// scrollViewRefrashUi.RefrashUiCallBack(false);
		// }
		// break;
		// }
		// return false;
		// }
		// });

		this.setOnScrollListener(new OnScrollListener() {

			@Override
			public void onScrollStateChanged(AbsListView arg0, int arg1) {
				// TODO Auto-generated method stub
				// 正在滚动时回调，回调2-3次，手指没抛则回调2次。scrollState = 2的这次不回调
				// 回调顺序如下
				// 第1次：scrollState = SCROLL_STATE_TOUCH_SCROLL(1) 正在滚动
				// 第2次：scrollState = SCROLL_STATE_FLING(2)
				// 手指做了抛的动作（手指离开屏幕前，用力滑了一下）
				// 第3次：scrollState = SCROLL_STATE_IDLE(0) 停止滚动
				switch (arg1) {
				// 当不滚动时
				case OnScrollListener.SCROLL_STATE_IDLE:// 是当屏幕停止滚动时
					mIsScrollIng = false;
					// 判断滚动到底部
					// if (arg0.getLastVisiblePosition() == (arg0.getCount() -
					// 1)) {
					// toTopBtn.setVisibility(View.VISIBLE);
					// }
					// 判断滚动到顶部
					// if (arg0.getFirstVisiblePosition() == 0) {
					// toTopBtn.setVisibility(View.GONE);
					// }

					break;
				case OnScrollListener.SCROLL_STATE_TOUCH_SCROLL:// 滚动时
					mIsScrollIng = true;
					break;
				case OnScrollListener.SCROLL_STATE_FLING:// 是当用户由于之前划动屏幕并抬起手指，屏幕产生惯性滑动时
					mIsScrollIng = false;
					break;
				}
			}

			@Override
			public void onScroll(AbsListView absListView, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
				// TODO Auto-generated method stub
				// if (absListView.getChildCount() > 0) {
				boolean isScrollToUp = false;
				// View childAt = absListView.getChildAt(firstVisibleItem);
				// int[] location = new int[2];
				// if (childAt != null) {
				// childAt.getLocationOnScreen(location);
				// } else {
				// location[0] = absListView.getTop();
				// location[1] = absListView.getTop();
				// }
				// Log.d("onScroll", "firstVisibleItem= " + firstVisibleItem +
				// " , y=" + location[1]);
				//
				// if (firstVisibleItem != mListViewFirstItem) {
				// if (firstVisibleItem > mListViewFirstItem) {
				// Log.e("--->", "向上滑动");
				// isScrollToUp = true;
				// } else {
				// Log.e("--->", "向下滑动");
				// isScrollToUp = false;
				// }
				// mListViewFirstItem = firstVisibleItem;
				// mScreenY = location[1];
				// } else {
				// if (mScreenY > location[1]) {
				// Log.i("--->", "->向上滑动");
				// isScrollToUp = true;
				// } else if (mScreenY < location[1]) {
				// Log.i("--->", "->向下滑动");
				// isScrollToUp = false;
				// }
				// mScreenY = location[1];
				// }
				//
				// // if (mIsScrollToUp != isScrollToUp) {
				// scrollViewRefrashUi.RefrashUiCallBack(isScrollToUp);
				// // }
				// if (getLastVisiblePosition() == getCount() - 1) {
				// scrollViewRefrashUi.RefrashUiCallBack(isScrollToUp);
				// }
				// 判断是否滑倒顶端,如果到顶端则将view设置为最大值
				if (firstVisibleItem == 0) {
					scrollViewRefrashUi.RefrashUiCallBack(true);
				} else {
					scrollViewRefrashUi.RefrashUiCallBack(false);
				}

				// }

				// 当开始滑动且ListView底部的Y轴点超出屏幕最大范围时，显示或隐藏顶部按钮
				// if (mIsScrollIng) {
				// if (firstVisibleItem > lastVisibleItemPosition) {// 上滑
				// isScrollToUp = false;
				// } else if (firstVisibleItem < lastVisibleItemPosition) {// 下滑
				// isScrollToUp = true;
				// } else {
				// return;
				// }
				// lastVisibleItemPosition = firstVisibleItem;
				// scrollViewRefrashUi.RefrashUiCallBack(isScrollToUp);
				// }
			}
		});
	}

	@Override
	protected void onScrollChanged(int l, int t, int oldl, int oldt) {
		// TODO Auto-generated method stub
		super.onScrollChanged(l, t, oldl, oldt);
	}

	@Override
	public void setOnScrollListener(OnScrollListener l) {
		// TODO Auto-generated method stub
		super.setOnScrollListener(l);
	}

}
