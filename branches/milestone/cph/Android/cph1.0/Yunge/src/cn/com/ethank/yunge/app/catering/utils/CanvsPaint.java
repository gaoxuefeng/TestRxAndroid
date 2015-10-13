package cn.com.ethank.yunge.app.catering.utils;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import cn.com.ethank.yunge.app.util.DisplayUtil;

public class CanvsPaint extends View implements Runnable {
	/* 声明Paint对象 */
	private Paint mPaint = null;

	public CanvsPaint(Context context) {
		super(context);
		/* 构建对象 */
		mPaint = new Paint();

		/* 开启线程 */
		new Thread(this).start();
	}

	public void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		/* 设置取消锯齿效果 */
		mPaint.setAntiAlias(true);
		mPaint.setColor(Color.parseColor("#93005c"));
		mPaint.setStrokeJoin(Paint.Join.ROUND);
		mPaint.setStrokeCap(Paint.Cap.ROUND);
		mPaint.setStrokeWidth(3);

		int pxTodp = DisplayUtil.dip2px(10);
		canvas.drawCircle(100, 50, pxTodp, mPaint);
	}

	// 触笔事件
	public boolean onTouchEvent(MotionEvent event) {
		return true;
	}

	// 按键按下事件
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		return true;
	}

	// 按键弹起事件
	public boolean onKeyUp(int keyCode, KeyEvent event) {
		return false;
	}

	public boolean onKeyMultiple(int keyCode, int repeatCount, KeyEvent event) {
		return true;
	}

	public void run() {
		while (!Thread.currentThread().isInterrupted()) {
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				Thread.currentThread().interrupt();
			}
			// 使用postInvalidate可以直接在线程中更新界面
			postInvalidate();
		}
	}
}
