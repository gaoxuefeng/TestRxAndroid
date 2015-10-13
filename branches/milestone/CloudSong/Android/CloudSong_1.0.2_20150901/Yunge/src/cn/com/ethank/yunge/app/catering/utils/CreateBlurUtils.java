package cn.com.ethank.yunge.app.catering.utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.util.Log;
import android.view.View;
import android.view.Window;
import cn.com.ethank.yunge.app.remotecontrol.interactcontrl.FastBlur;

public class CreateBlurUtils {

	private Bitmap showBitMap = null;
	private Activity context;
	private View showView;

	public CreateBlurUtils(Activity context, View showView) {
		super();
		this.context = context;
		this.showView = showView;

	}

	public void applyBlur() {
		View view = context.getWindow().getDecorView();
		view.setDrawingCacheEnabled(true);
		view.buildDrawingCache(true);
		/**
		 * 获取当前窗口快照，相当于截屏
		 */
		Bitmap bmp1 = view.getDrawingCache();
		int height = getOtherHeight();
		/**
		 * 除去状态栏和标题栏
		 */
		showBitMap = Bitmap.createBitmap(bmp1, 0, height, bmp1.getWidth(), bmp1.getHeight() - height);
		blur(showBitMap, showView);
	}

	@SuppressLint("NewApi")
	private void blur(Bitmap bkg, View view) {
		long startMs = System.currentTimeMillis();
		float scaleFactor = 4;// 图片缩放比例；
		float radius = 20;// 模糊程度
		Bitmap overlay = Bitmap.createBitmap((int) (bkg.getWidth() / scaleFactor), (int) (bkg.getHeight() / scaleFactor), Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(overlay);
		canvas.translate(-view.getLeft() / scaleFactor, -view.getTop() / scaleFactor);
		canvas.scale(1 / scaleFactor, 1 / scaleFactor);
		Paint paint = new Paint();
		paint.setFlags(Paint.FILTER_BITMAP_FLAG);
		canvas.drawBitmap(bkg, 0, 0, paint);

		overlay = FastBlur.doBlur(overlay, (int) radius, true);
		view.setBackground(new BitmapDrawable(context.getResources(), overlay));
		/**
		 * 打印高斯模糊处理时间，如果时间大约16ms，用户就能感到到卡顿，时间越长卡顿越明显，如果对模糊完图片要求不高，
		 * 可是将scaleFactor设置大一些。
		 */
		Log.i("jerome", "blur time:" + (System.currentTimeMillis() - startMs));
	}

	/**
	 * 获取系统状态栏和软件标题栏，部分软件没有标题栏，看自己软件的配置；
	 * 
	 * @return
	 */
	private int getOtherHeight() {
		Rect frame = new Rect();
		context.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
		int statusBarHeight = frame.top;
		int contentTop = context.getWindow().findViewById(Window.ID_ANDROID_CONTENT).getTop();
		int titleBarHeight = contentTop - statusBarHeight;
		return statusBarHeight + titleBarHeight;
	}

}
