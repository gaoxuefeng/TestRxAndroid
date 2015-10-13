package cn.com.ethank.yunge.view;

import cn.com.ethank.yunge.R;
import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

public class NetworkLayout extends LinearLayout {

	public View tv_refresh;

	public NetworkLayout(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
		initLayout(context);
	}

	private void initLayout(Context context) {
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = inflater.inflate(R.layout.layout_network, this);
//		tv_refresh=view.findViewById(R.id.tv_refresh);
//		view.setVisibility(View.GONE);
	}

	public NetworkLayout(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}

	public NetworkLayout(Context context) {
		this(context, null);
	}

}
