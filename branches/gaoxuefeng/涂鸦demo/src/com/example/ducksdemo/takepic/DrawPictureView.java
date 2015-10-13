package com.example.ducksdemo.takepic;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

public class DrawPictureView extends View {

	// 进行判断是否第一次调用ondraw用的
	private boolean setFlag, currentFlag, saveFlag, deleteFlag;
	// 画图用到的
	private final float TOUCH_TOLERANCE = 4;
	private Bitmap mBitmap;
	// 路线集合
	private ArrayList<DrawPath> drawPathList;
	private ArrayList<Integer> colorList = new ArrayList<Integer>();
	private Paint mPaint;
	private Path mPath;
	private DrawPath dp;
	private float mX, mY;
	private static final int wideStrokeWidth = 15;
	private static final int defaultStrokeWidth = 10;
	private static final int smallStrokeWidth = 5;
	// 画笔颜色
	private static final int BLACK = Color.BLACK;
	private static final int WHITE = Color.WHITE;
	private static final int BLUE = Color.parseColor("#388FED");
	private static final int GREEN = Color.parseColor("#63C142");
	private static final int ORANGE = Color.parseColor("#E63622");
	private static final int PINK = Color.parseColor("#ED30A6");
	private static final int VIOLET = Color.parseColor("#BD3FE1");
	private static final int YELLOW = Color.parseColor("#FCCD39");

	public DrawPictureView(Context context) {
		super(context);
		init();
	}

	public DrawPictureView(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}

	public DrawPictureView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init();
	}

	/**
	 * 传入图片路径参数后必用此方法
	 */
	private void init() {
		if (colorList.size() == 0) {
			colorList.add(BLACK);// 1
			colorList.add(WHITE);// 2
			colorList.add(PINK);// 3
			colorList.add(ORANGE);// 4
			colorList.add(YELLOW);// 5
			colorList.add(BLUE);// 6
			colorList.add(GREEN);// 7
			colorList.add(VIOLET);// 8
		}
		drawPathList = new ArrayList<DrawPath>();
		mPath = new Path();

		// 初始化画笔
		initPaint();
		mPaint.setColor(Color.RED); // 默认为红色画笔

		// 初始化2个标识
		setFlag = true;
		deleteFlag = false;
		saveFlag = false;
	}

	private void initPaint() {
		if (mPaint != null) {
			float currentWidth = mPaint.getStrokeWidth();
			float currentColor = mPaint.getColor();
			mPaint = new Paint();
			mPaint.setAntiAlias(true); // 设置抗锯齿
			mPaint.setStyle(Paint.Style.STROKE); // 设置画笔类型
			mPaint.setStrokeJoin(Paint.Join.ROUND); // 默认MITER
			mPaint.setStrokeCap(Paint.Cap.SQUARE); // 默认BUTT
			mPaint.setStrokeWidth(currentWidth); // 设置描边宽度
			mPaint.setColor((int) currentColor); // 设置描边宽度
		} else {
			mPaint = new Paint();
			mPaint.setAntiAlias(true); // 设置抗锯齿
			mPaint.setStyle(Paint.Style.STROKE); // 设置画笔类型
			mPaint.setStrokeJoin(Paint.Join.ROUND); // 默认MITER
			mPaint.setStrokeCap(Paint.Cap.SQUARE); // 默认BUTT
			mPaint.setStrokeWidth(defaultStrokeWidth); // 设置描边宽度
			mPaint.setColor(BLACK); // 设置描边宽度

		}

	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		float x = event.getX();
		float y = event.getY();

		switch (event.getAction()) {
		case MotionEvent.ACTION_DOWN:
			dp = new DrawPath();
			mPath = new Path();
			dp.path = mPath;
			dp.paint = mPaint;
			currentFlag = true;
			touch_start(x, y);
			invalidate();
			break;
		case MotionEvent.ACTION_MOVE:
			touch_move(x, y);
			invalidate();
			break;
		case MotionEvent.ACTION_UP:
			touch_up();
			invalidate();
			currentFlag = false;
			break;
		default:
			break;
		}
		return true;
	}

	private void touch_start(float x, float y) {
		mPath.moveTo(x, y);
		mX = x;
		mY = y;
	}

	private void touch_move(float x, float y) {
		float dx = Math.abs(x - mX);
		float dy = Math.abs(mY - y);
		if (dx >= TOUCH_TOLERANCE || dy >= TOUCH_TOLERANCE) {
			mPath.quadTo(mX, mY, (x + mX) / 2, (y + mY) / 2);
			mX = x;
			mY = y;
		}
	}

	private void touch_up() {
		mPath.lineTo(mX, mY);
		drawPathList.add(dp);

	}

	/**
	 * 调用此方法可以撤销上一次话的线段
	 */
	public void deleteDrawPath() {
		if (drawPathList != null && !drawPathList.isEmpty()) {
			drawPathList.remove(drawPathList.size() - 1);
			deleteFlag = true;
			setFlag = false;
			invalidate();
		}
		return;
	}

	// 获取画了几条线
	public int GetDrawPathSize() {
		if (drawPathList != null && !drawPathList.isEmpty()) {

		}
		return drawPathList.size();
	}

	/**
	 * 储存每一条二次贝塞尔曲线的类，相当于bean
	 * 
	 * @author Administrator
	 * 
	 */
	public class DrawPath {
		public Path path;
		public Paint paint;
	}

	

	// 根据选择的位置设置颜色
	public void setPaintByPosition(int checkedPosition) {
		initPaint();

		mPaint.setColor(colorList.get(checkedPosition));
	}

	// 设置画笔宽度
	public void setPaintTrickness(int trickness) {
		initPaint();
		if (trickness != 0) {
			mPaint.setStrokeWidth(trickness);
		} else {
			mPaint.setStrokeWidth(defaultStrokeWidth);
		}

	}

	/**
	 * 每次刷新
	 */
	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		if (setFlag) {
			if (drawPathList != null && !drawPathList.isEmpty()) {
				for (DrawPath dp2 : drawPathList) {
					canvas.drawPath(dp2.path, dp2.paint);
				}
			}
			if (currentFlag)
				canvas.drawPath(mPath, mPaint);
		}
		if (deleteFlag) {
			if (drawPathList != null && !drawPathList.isEmpty()) {
				for (DrawPath dp1 : drawPathList) {
					canvas.drawPath(dp1.path, dp1.paint);
				}
			}
			deleteFlag = false;
			setFlag = true;
		}
		if (saveFlag) {
			closeBitmap(mBitmap);
		}
	}

	private void closeBitmap(Bitmap bm) {
		if (bm != null && !bm.isRecycled()) {
			bm.recycle();
			bm = null;
		}
	}

}
