package com.coyotelib.app.ui.indexlist;

import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.BaseAdapter;
import android.widget.SectionIndexer;

public abstract class HeadAdapter extends BaseAdapter implements
		SectionIndexer, OnScrollListener {

	public static final String TAG = HeadAdapter.class.getCanonicalName();

	public HeadAdapter() {
		super();
	}

	public interface HasMorePagesListener {
		void noMorePages();

		void mayHaveMorePages();
	}

	int page = 1;
	int initialPage = 1;
	boolean automaticNextPageLoading = false;

	HasMorePagesListener hasMorePagesListener;

	void setHasMorePagesListener(HasMorePagesListener listener) {
		hasMorePagesListener = listener;
	}

	public static final int PINNED_HEADER_GONE = 0;

	public static final int PINNED_HEADER_VISIBLE = 1;

	public static final int PINNED_HEADER_PUSHED_UP = 2;

	public int getPinnedHeaderState(int position) {
		if (position < 0 || getCount() == 0) {
			return PINNED_HEADER_GONE;
		}

		int section = getSectionForPosition(position);
		int nextSectionPosition = getPositionForSection(section + 1);

		if (nextSectionPosition != -1 && position == nextSectionPosition - 1) {
			return PINNED_HEADER_PUSHED_UP;
		}

		return PINNED_HEADER_VISIBLE;
	}

	public void setInitialPage(int initialPage) {
		this.initialPage = initialPage;
	}

	public void resetPage() {
		this.page = this.initialPage;
	}

	public void nextPage() {
		this.page++;
	}

	public void onScroll(AbsListView view, int firstVisibleItem,
			int visibleItemCount, int totalItemCount) {
		if (view instanceof HeadListView) {
			((HeadListView) view).configureHeaderView(firstVisibleItem);
		}
	}

	public View getView(int position, View convertView, ViewGroup parent) {
		View res = getAmazingView(position, convertView, parent);

		if (position == getCount() - 1 && automaticNextPageLoading) {
			onNextPageRequested(page + 1);
		}

		final int section = getSectionForPosition(position);
		boolean displaySectionHeaders = (getPositionForSection(section) == position);

		bindSectionHeader(res, position, displaySectionHeaders);

		return res;
	}

	public void notifyNoMorePages() {
		automaticNextPageLoading = false;
		if (hasMorePagesListener != null) {
			hasMorePagesListener.noMorePages();
		}
	}

	public void notifyMayHaveMorePages() {
		automaticNextPageLoading = true;
		if (hasMorePagesListener != null)
			hasMorePagesListener.mayHaveMorePages();
	}

	protected abstract void bindSectionHeader(View view, int position,
			boolean displaySectionHeader);

	protected abstract void onNextPageRequested(int page);

	public abstract View getAmazingView(int position, View convertView,
			ViewGroup parent);

	public abstract void configurePinnedHeader(View header, int position,
			int alpha);

}
