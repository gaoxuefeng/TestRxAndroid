package cn.com.ethank.yunge.app.home.utils;

import com.coyotelib.app.ui.util.UICommonUtil;

import cn.com.ethank.yunge.R;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.View;

public class RingView extends View {

	public RingView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void onDraw(Canvas canvas) {
		Paint paint = new Paint();
		paint.setColor(getResources().getColor(R.color.order_pink));
		
		int left = UICommonUtil.dip2px(getContext(), 320);
		int top = UICommonUtil.dip2px(getContext(), 50);
		// 画圆
		canvas.drawCircle(left, top, 40, paint);
	}

}
