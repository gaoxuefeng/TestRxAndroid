package cn.com.ethank.yunge.view;

import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;

public class GifPlayView extends ImageView {

	private long lasttime = 0;

	public GifPlayView(Context context, AttributeSet attributeSet) {
		super(context, attributeSet);

		new Thread() {
			public void run() {
				while (true) {
					try {
						if (getBackground() != null) {
							sleep(100);
							if (getBackground().getLevel() == 0) {
								getBackground().setLevel(1);
							} else {
								getBackground().setLevel(0);
							}
							long a = System.currentTimeMillis();
							if (a - lasttime >= 100) {
								postInvalidate();
								lasttime = a;
							}

						}
					} catch (Exception e) {
						e.printStackTrace();
					}

				}

			};
		}.start();

	}

	public GifPlayView(Context context) {
		super(context);

	}

	@Override
	protected void onDraw(Canvas canvas) {

	}

	@Override
	public void setLayoutParams(LayoutParams params) {
		super.setLayoutParams(params);
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
	}

	@Override
	public void postInvalidate() {
		super.postInvalidate();
		lasttime = System.currentTimeMillis();
	}
}