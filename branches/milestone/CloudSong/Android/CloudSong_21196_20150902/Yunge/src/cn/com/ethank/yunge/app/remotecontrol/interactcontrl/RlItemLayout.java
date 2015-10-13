package cn.com.ethank.yunge.app.remotecontrol.interactcontrl;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import cn.com.ethank.yunge.R;

import com.coyotelib.app.ui.util.UICommonUtil;

public class RlItemLayout extends RelativeLayout {

	private TextView tv_name;
	private ImageView iv_icon;
	private View view;

	public RlItemLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
		// 获得自定义属性
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		view = inflater.inflate(R.layout.item_rl_layout, this);
		tv_name = (TextView) findViewById(R.id.tv_name);
		iv_icon = (ImageView) findViewById(R.id.iv_icon);
		TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.iteminfo);
		Drawable drawable = a.getDrawable(R.styleable.iteminfo_item_src);
		if (drawable != null) {
			iv_icon.setImageDrawable(drawable);
		}
		String itemName = a.getString(R.styleable.iteminfo_item_name);
		if (itemName != null) {
			tv_name.setText(itemName);
		}
		a.recycle();

	}

	private void initView(Context context, View view) {
		try {
			android.view.ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
			if (layoutParams != null) {
				layoutParams.height = UICommonUtil.getScreenWidthPixels(getContext()) / 2;
				layoutParams.width = UICommonUtil.getScreenWidthPixels(getContext()) / 2;
				setLayoutParams(layoutParams);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	protected void onLayout(boolean changed, int l, int t, int r, int b) {

		super.onLayout(changed, l, t, r, b);
		if (changed) {
			initView(getContext(), view);
		}

	}

	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
	}
}
