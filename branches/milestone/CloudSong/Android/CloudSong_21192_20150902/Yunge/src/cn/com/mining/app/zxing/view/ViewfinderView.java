/*
 * Copyright (C) 2008 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package cn.com.mining.app.zxing.view;

import java.util.Collection;
import java.util.HashSet;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Align;
import android.graphics.Paint.FontMetrics;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import cn.com.ethank.yunge.R;
import cn.com.mining.app.zxing.camera.CameraManager;

import com.google.zxing.ResultPoint;

/**
 * This view is overlaid on top of the camera preview. It adds the viewfinder
 * rectangle and partial transparency outside it, as well as the laser scanner
 * animation and result points.
 * 
 */
public final class ViewfinderView extends View {
	private static final String TAG = "log";

	private static final long ANIMATION_DELAY = 10L;
	private static final int OPAQUE = 0xFF;

	private int ScreenRate;

	private static final int CORNER_WIDTH = 10;

	private static final int MIDDLE_LINE_WIDTH = 6;

	private static final int MIDDLE_LINE_PADDING = 5;

	private static final int SPEEN_DISTANCE = 5;

	private static float density;

	private static final int TEXT_SIZE = 16;

	private static final int TEXT_PADDING_TOP = 30;

	private Paint paint;

	private int slideTop;

	private int slideBottom;

	private Bitmap resultBitmap;
	private final int maskColor;
	private final int resultColor;

	private final int resultPointColor;
	private Collection<ResultPoint> possibleResultPoints;
	private Collection<ResultPoint> lastPossibleResultPoints;

	boolean isFirst;

	public ViewfinderView(Context context, AttributeSet attrs) {
		super(context, attrs);

		density = context.getResources().getDisplayMetrics().density;
		ScreenRate = (int) (20 * density);

		paint = new Paint();
		Resources resources = getResources();
		maskColor = resources.getColor(R.color.viewfinder_mask);
		resultColor = resources.getColor(R.color.result_view);

		resultPointColor = resources.getColor(R.color.possible_result_points);
		possibleResultPoints = new HashSet<ResultPoint>(5);
	}

	@Override
	public void onDraw(Canvas canvas) {
		Rect frame = CameraManager.get().getFramingRect();

		if (frame == null) {
			return;
		}

		if (!isFirst) {
			isFirst = true;

			slideTop = frame.top;
			slideBottom = frame.bottom;
		}

		int width = canvas.getWidth();
		int height = canvas.getHeight();

		paint.setColor(resultBitmap != null ? resultColor : maskColor);
		// 话其余空白地方
		canvas.drawRect(0, 0, width, frame.top, paint);
		canvas.drawRect(0, frame.top, frame.left, frame.bottom + 1, paint);
		canvas.drawRect(frame.right + 1, frame.top, width, frame.bottom + 1, paint);
		canvas.drawRect(0, frame.bottom + 1, width, height, paint);
		if (resultBitmap != null) {
			paint.setAlpha(OPAQUE);
			canvas.drawBitmap(resultBitmap, frame.left, frame.top, paint);
		} else {

			paint.setColor(Color.parseColor("#F844A8"));
			// 左上右下
			// 上线
			canvas.drawRect(frame.left, frame.top, frame.left + ScreenRate, frame.top + CORNER_WIDTH, paint);
			// 左线
			canvas.drawRect(frame.left, frame.top, frame.left + CORNER_WIDTH, frame.top + ScreenRate, paint);
			// 右线
			canvas.drawRect(frame.right - ScreenRate, frame.top, frame.right, frame.top + CORNER_WIDTH, paint);
			// 下线
			canvas.drawRect(frame.right - CORNER_WIDTH, frame.top, frame.right, frame.top + ScreenRate, paint);
			canvas.drawRect(frame.left, frame.bottom - CORNER_WIDTH, frame.left + ScreenRate, frame.bottom, paint);
			canvas.drawRect(frame.left, frame.bottom - ScreenRate, frame.left + CORNER_WIDTH, frame.bottom, paint);
			canvas.drawRect(frame.right - ScreenRate, frame.bottom - CORNER_WIDTH, frame.right, frame.bottom, paint);
			canvas.drawRect(frame.right - CORNER_WIDTH, frame.bottom - ScreenRate, frame.right, frame.bottom, paint);

			slideTop += SPEEN_DISTANCE;
			if (slideTop >= frame.bottom) {
				slideTop = frame.top;
			}
			//中间线
			canvas.drawRect(frame.left + MIDDLE_LINE_PADDING, slideTop - MIDDLE_LINE_WIDTH / 2, frame.right - MIDDLE_LINE_PADDING, slideTop
					+ MIDDLE_LINE_WIDTH / 2, paint);

			// 写字
			paint.setColor(Color.parseColor("#E3E3E3"));
			paint.setTextSize(14 * density);
			// paint.setAlpha(0x40);
			// paint.setTypeface(Typeface.create("System", Typeface.BOLD));
			WindowManager manager = (WindowManager) getContext().getSystemService(Context.WINDOW_SERVICE);
			Display display = manager.getDefaultDisplay();
			int screenHeight = display.getHeight();
			int screenWidth = display.getWidth();

			int baseLine1 = (int) (730f / 1136 * screenHeight);
			// canvas.drawText("点击歌台上的“手机点歌”", frame.left, (float) (frame.bottom
			// + (float) TEXT_PADDING_TOP * density), paint);
			//
			paint.setTextAlign(Align.CENTER);
			canvas.drawText("点击歌台上的“手机点歌”", width / 2, baseLine1, paint);
			FontMetrics fontMetrics = paint.getFontMetrics(); //
			// 计算文字高度
			float fontHeight = fontMetrics.bottom - fontMetrics.top;
			// 2
			int magin1 = (int) (20f * height / 1136);
			int baseLine2 = (int) (baseLine1 + fontHeight + magin1);
			paint.setColor(Color.parseColor("#F844A8"));
			paint.setTextSize(19 * density);
			canvas.drawText("扫描二维码连接房间", width / 2, baseLine2, paint);

			FontMetrics fontMetrics2 = paint.getFontMetrics(); //
			// 计算文字高度
			float fontHeight2 = fontMetrics2.bottom - fontMetrics2.top;
			int magin2 = (int) (60f * height / 1136);
			int baseLine3 = (int) (baseLine2 + fontHeight2 + magin2);
			paint.setColor(Color.parseColor("#6F6F70"));
			paint.setTextSize(14 * density);
			canvas.drawText("建议使用KTV提供的免费WiFi", width / 2, baseLine3, paint);
			//

			Collection<ResultPoint> currentPossible = possibleResultPoints;
			Collection<ResultPoint> currentLast = lastPossibleResultPoints;
			if (currentPossible.isEmpty()) {
				lastPossibleResultPoints = null;
			} else {
				possibleResultPoints = new HashSet<ResultPoint>(5);
				lastPossibleResultPoints = currentPossible;
				paint.setAlpha(OPAQUE);
				paint.setColor(resultPointColor);
				for (ResultPoint point : currentPossible) {
					canvas.drawCircle(frame.left + point.getX(), frame.top + point.getY(), 6.0f, paint);
				}
			}
			if (currentLast != null) {
				paint.setAlpha(OPAQUE / 2);
				paint.setColor(resultPointColor);
				for (ResultPoint point : currentLast) {
					canvas.drawCircle(frame.left + point.getX(), frame.top + point.getY(), 3.0f, paint);
				}
			}

			postInvalidateDelayed(ANIMATION_DELAY, frame.left, frame.top, frame.right, frame.bottom);

		}
	}

	public void drawViewfinder() {
		resultBitmap = null;
		invalidate();
	}

	/**
	 * Draw a bitmap with the result points highlighted instead of the live
	 * scanning display.
	 * 
	 * @param barcode
	 *            An image of the decoded barcode.
	 */
	public void drawResultBitmap(Bitmap barcode) {
		resultBitmap = barcode;
		invalidate();
	}

	public void addPossibleResultPoint(ResultPoint point) {
		possibleResultPoints.add(point);
	}

}
