package cn.com.ethank.yunge.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;

import com.handmark.pulltorefresh.library.PullToRefreshListView;

public class MyRefreshListView extends PullToRefreshListView {

	protected Mode defaultMode;
	private TouchLisTener touchListener;

	public MyRefreshListView(Context context, com.handmark.pulltorefresh.library.PullToRefreshBase.Mode mode,
			com.handmark.pulltorefresh.library.PullToRefreshBase.AnimationStyle style) {
		super(context, mode, style);
		initView(context);
	}

	public MyRefreshListView(Context context, com.handmark.pulltorefresh.library.PullToRefreshBase.Mode mode) {
		super(context, mode);
		initView(context);
	}

	public MyRefreshListView(Context context, AttributeSet attrs) {
		super(context, attrs);
		initView(context);
	}

	public MyRefreshListView(final Context context) {
		super(context);

		initView(context);
	}

	private void initView(final Context context) {
		setMode(Mode.MANUAL_REFRESH_ONLY);
		this.setPullToRefreshOverScrollEnabled(false);
		this.setPullToRefreshEnabled(false);

		this.setOnLastItemVisibleListener(new OnLastItemVisibleListener() {

			@Override
			public void onLastItemVisible() {
				if (!isRefreshing() && true && (getMode() == Mode.PULL_FROM_END || getMode() == Mode.PULL_UP_TO_REFRESH || getMode() == Mode.BOTH)) {
					defaultMode = getMode();

					if (getRefreshableView().getFirstVisiblePosition() == 0) {
						return;
					}
					setMode(Mode.PULL_FROM_END);
					setRefreshing(true);
				}
				return;
			}
		});

	}

	// 如果Mode为Both则调用这个方法
	public void refreshComplete() {
		super.onRefreshComplete();
		if (defaultMode != null) {
			setMode(defaultMode);
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
