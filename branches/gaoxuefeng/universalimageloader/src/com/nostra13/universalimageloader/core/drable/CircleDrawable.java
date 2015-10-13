package com.nostra13.universalimageloader.core.drable;

import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.drawable.Drawable;

/**
 * A drawable with rounded corners; CenterCrop
 * 
 * @author http://www.liaohuqiu.net
 */
public class CircleDrawable extends Drawable {

	protected final RectF mRect = new RectF();
	protected final BitmapShader mBitmapShader;
	protected final Paint mPaint;
	private int mBitmapWidth;
	private int mBitmapHeight;
	private Rect bounds=new Rect();

	public CircleDrawable(Bitmap bitmap) {

		mBitmapShader = new BitmapShader(bitmap, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
		mBitmapWidth = bitmap.getWidth();
		mBitmapHeight = bitmap.getHeight();

		mPaint = new Paint();
		mPaint.setAntiAlias(true);
		mPaint.setShader(mBitmapShader);
	}

	@Override
	protected void onBoundsChange(Rect bounds) {
		super.onBoundsChange(bounds);
		this.bounds = bounds;
		int viewWidth = bounds.width();
		int viewHeight = bounds.height();
		mRect.set(0, 0, viewWidth, viewHeight);
		float scale = Math.max(viewWidth * 1.0f / mBitmapWidth, viewHeight * 1.0f / mBitmapHeight);
		Matrix shaderMatrix = new Matrix();
		// 使得图片截取的宽高为中心
		float scaleWidth = viewWidth / scale;
		float scaleHeight = viewHeight / scale;
		float top = (mBitmapHeight - scaleHeight) / 2;
		float bottom = mBitmapHeight - top;
		float left = (mBitmapWidth - scaleWidth) / 2;
		float right = mBitmapWidth - left;
		shaderMatrix.setRectToRect(new RectF(left, top, right, bottom), mRect, Matrix.ScaleToFit.CENTER);
		mBitmapShader.setLocalMatrix(shaderMatrix);
	}

	@Override
	public void draw(Canvas canvas) {
		int minLength = Math.min(bounds.width(), bounds.height());
		canvas.drawCircle(bounds.width() / 2, bounds.height() / 2, minLength / 2, mPaint);
	}

//	public static Bitmap transform(final Bitmap source, float margin, float radius) {
//		final Paint paint = new Paint();
//		paint.setAntiAlias(true);
//		paint.setShader(new BitmapShader(source, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP));
//
//		Bitmap output = Bitmap.createBitmap(source.getWidth(), source.getHeight(), Bitmap.Config.ARGB_8888);
//		Canvas canvas = new Canvas(output);
//		canvas.drawRoundRect(new RectF(margin, margin, source.getWidth() - margin, source.getHeight() - margin), radius, radius, paint);
//
//		if (source != output) {
//			source.recycle();
//		}
//
//		return output;
//	}

	@Override
	public int getOpacity() {
		return PixelFormat.TRANSLUCENT;
	}

	@Override
	public void setAlpha(int alpha) {
		mPaint.setAlpha(alpha);
	}

	@Override
	public void setColorFilter(ColorFilter cf) {
		mPaint.setColorFilter(cf);
	}
}
