package cn.com.ethank.yunge.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.Toast;

import com.handmark.pulltorefresh.library.PullToRefreshGridView;

public class MyRefreshGridView extends PullToRefreshGridView {

	protected Mode defaultMode;

	public MyRefreshGridView(Context context, com.handmark.pulltorefresh.library.PullToRefreshBase.Mode mode,
			com.handmark.pulltorefresh.library.PullToRefreshBase.AnimationStyle style) {
		super(context, mode, style);
		initView(context);
	}

	public MyRefreshGridView(Context context, com.handmark.pulltorefresh.library.PullToRefreshBase.Mode mode) {
		super(context, mode);
		initView(context);
	}

	public MyRefreshGridView(Context context, AttributeSet attrs) {
		super(context, attrs);
		initView(context);
	}

	public MyRefreshGridView(final Context context) {
		super(context);

		initView(context);
	}

	private void initView(final Context context) {
		setMode(Mode.MANUAL_REFRESH_ONLY);
		this.setPullToRefreshOverScrollEnabled(false);
		this.setPullToRefreshEnabled(false);

	}

	// 如果Mode为Both则调用这个方法
	public void refreshComplete() {
		super.onRefreshComplete();
		if (defaultMode != null) {
			setMode(defaultMode);
		}

	}
}
