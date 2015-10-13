package com.coyotelib.app.ui.indexlist;

import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ListAdapter;
import android.widget.ListView;

public class HeadListView extends ListView implements HeadAdapter.HasMorePagesListener {

	public static final String TAG = HeadListView.class.getSimpleName();

	View listFooter;

	boolean footerViewAttached = false;

	private View mHeaderView;
	private boolean mHeaderViewVisible;

	private int mHeaderViewWidth;
	private int mHeaderViewHeigth;

	private HeadAdapter adapter;

	public void setPinnedHeaderView(View view) {
		mHeaderView = view;

		if (mHeaderView != null) {
			setFadingEdgeLength(0);
		}
		requestLayout();
	}

	@Override
	public void noMorePages() {

	}

	@Override
	public void mayHaveMorePages() {

	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		if (mHeaderView != null) {
			measureChild(mHeaderView, widthMeasureSpec, heightMeasureSpec);
			mHeaderViewWidth = mHeaderView.getMeasuredWidth();
			mHeaderViewHeigth = mHeaderView.getMeasuredHeight();
		}
	}

	@Override
	protected void onLayout(boolean changed, int l, int t, int r, int b) {
		super.onLayout(changed, l, t, r, b);
		if (mHeaderView != null) {
			mHeaderView.layout(0, 0, mHeaderViewWidth, mHeaderViewHeigth);
			configureHeaderView(getFirstVisiblePosition());
		}
	}

	public void configureHeaderView(int position) {
		if (mHeaderView == null) {
			return;
		}

		int state = adapter.getPinnedHeaderState(position);
		switch (state) {
		case HeadAdapter.PINNED_HEADER_GONE:
			mHeaderViewVisible = false;
			break;

		case HeadAdapter.PINNED_HEADER_VISIBLE:
			adapter.configurePinnedHeader(mHeaderView, position, 255);
			if (mHeaderView.getTop() != 0) {
				mHeaderView.layout(0, 0, mHeaderViewWidth, mHeaderViewHeigth);
			}
			mHeaderViewVisible = true;
			break;
		case HeadAdapter.PINNED_HEADER_PUSHED_UP:
			View firstView = getChildAt(0);
			if (firstView != null) {
				int bottom = firstView.getBottom();
				int headerHeight = mHeaderView.getHeight();
				int y;
				int alpha;
				if (bottom < headerHeight) {
					y = (bottom - headerHeight);
					alpha = 255 * (headerHeight + y) / headerHeight;
				} else {
					y = 0;
					alpha = 255;
				}
				adapter.configurePinnedHeader(mHeaderView, position, alpha);
				if (mHeaderView.getTop() != y) {
					mHeaderView.layout(0, y, mHeaderViewWidth,
							mHeaderViewHeigth);
				}
			}
			break;
		}

	}

	@Override
	protected void dispatchDraw(Canvas canvas) {
		super.dispatchDraw(canvas);
		if (mHeaderViewVisible) {
			drawChild(canvas, mHeaderView, getDrawingTime());
		}
	}

	public HeadListView(Context context) {
		super(context);
	}

	public HeadListView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public HeadListView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public void setLoadingView(View listFooter) {
		this.listFooter = listFooter;
	}

	public View getLoadingView() {
		return listFooter;
	}

	@Override
	public void setAdapter(ListAdapter adapter) {
		if (!(adapter instanceof HeadAdapter)) {
			throw new IllegalArgumentException();
		}

		if (this.adapter != null) {
			this.adapter.setHasMorePagesListener(null);
			this.setOnScrollListener(null);
		}

		this.adapter = (HeadAdapter) adapter;

		((HeadAdapter) adapter).setHasMorePagesListener(this);
		this.setOnScrollListener((HeadAdapter) adapter);

		View dummy = new View(getContext());

		super.addFooterView(dummy);
		super.setAdapter(adapter);
		super.removeFooterView(dummy);
	}

	@Override
	public void setOnScrollListener(OnScrollListener l) {
		super.setOnScrollListener(l);
	}

}
