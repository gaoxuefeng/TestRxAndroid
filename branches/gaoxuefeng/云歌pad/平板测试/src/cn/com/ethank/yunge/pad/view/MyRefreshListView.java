package cn.com.ethank.yunge.pad.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.Toast;

import com.handmark.pulltorefresh.library.PullToRefreshListView;

public class MyRefreshListView extends PullToRefreshListView {

	protected Mode defaultMode;

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
					Toast.makeText(context, "End of List!", Toast.LENGTH_SHORT).show();
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
}
