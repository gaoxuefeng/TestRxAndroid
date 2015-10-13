package cn.com.ethank.yunge.view;

import com.coyotelib.app.ui.util.UICommonUtil;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;

public class MyHeightImageView extends ImageView {

	public MyHeightImageView(Context context) {
		this(context, null);
	}

	public MyHeightImageView(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}

	public MyHeightImageView(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
		initView(context);
	}

	private void initView(Context context) {
		LayoutParams layoutParams = getLayoutParams();
		if (layoutParams == null) {
			return;
		}
		if (getWidth() != 0) {
			layoutParams.height = (int) (getWidth() * 104f / 165);
			setLayoutParams(layoutParams);
		} else {
			layoutParams.height = (int) (UICommonUtil.getScreenWidthPixels(context) * 104f / 720);
			setLayoutParams(layoutParams);
		}

	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		heightMeasureSpec = (int) (widthMeasureSpec * 104f / 165);
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
	}
}
