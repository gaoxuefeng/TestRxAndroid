package cn.com.ethank.yunge.view;

import android.content.Context;
import android.util.AttributeSet;

import com.handmark.pulltorefresh.library.PullToRefreshGridView;

public class MyRefreshGridView extends PullToRefreshGridView {

	public MyRefreshGridView(Context context, Mode mode, AnimationStyle style) {
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
		this.setPullToRefreshOverScrollEnabled(false);

	}

}
