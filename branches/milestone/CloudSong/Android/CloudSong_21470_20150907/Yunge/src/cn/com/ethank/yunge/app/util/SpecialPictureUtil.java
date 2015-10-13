package cn.com.ethank.yunge.app.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.media.ExifInterface;
import android.text.TextPaint;
import android.util.Log;

public class SpecialPictureUtil {

	/**
	 * 自定义的照相调用此方法
	 * 
	 * @param picturePath
	 * @return
	 */
	public static Bitmap getSpecialBitmap(String picturePath) {
		File file = new File(picturePath);
		if (!file.exists() || !file.isFile())
			return null;

		Bitmap tempBitmap = BitmapFactory.decodeFile(picturePath);
		// Bitmap tempBitmap = BitmapFactory.decodeFile(picturePath, options);
		if (tempBitmap == null)
			return null;
		Bitmap bitmap = cutBitmap(tempBitmap);
		cloceBitmap(tempBitmap);
		return bitmap;
	}

	/**
	 * 按照要求等比例压缩
	 * 
	 * @param options
	 * @param reqWidth
	 * @param reqHeight
	 * @return
	 */
	private static int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;

		if (height > reqHeight || width > reqWidth) {

			final int heightRatio = Math.round((float) height / (float) reqHeight);
			final int widthRatio = Math.round((float) width / (float) reqWidth);

			inSampleSize = heightRatio < widthRatio ? widthRatio : heightRatio;
		}
		return inSampleSize;
	}

	/**
	 * 截出一个正方形的图片
	 * 
	 * @param bitmap
	 * @param rotate
	 * @return
	 */
	public static Bitmap cutBitmap(Bitmap bitmap) {
		if (bitmap == null) {
			// 设置背景颜色
			int[] colors = initColors(720, 720, Color.WHITE);

			return Bitmap.createBitmap(colors, 720, 720, Config.RGB_565);
		} else {
			// 有照片传人
			int w = bitmap.getWidth();
			int h = bitmap.getHeight();
			int difference = Math.abs((w - h) / 2);
			if (w > h) {
				return Bitmap.createBitmap(bitmap, difference, 0, h, h);
			}else {
				return Bitmap.createBitmap(bitmap, 0, difference, w, w);
			}

			
		}

	}

	public static Bitmap rotateBitmap(Bitmap bitmap, int rotate) {
		if (bitmap == null)
			return null;

		int w = bitmap.getWidth();
		int h = bitmap.getHeight();

		Matrix mtx = new Matrix();
		mtx.postRotate(rotate);
		return Bitmap.createBitmap(bitmap, 0, 0, w, h, mtx, true);
	}

	// /**
	// * 查看图片是否旋转过，如某些三星手机拍照完自动旋转,获取旋转的度数
	// *
	// * @param path
	// * @return
	// */
	// private static int readPictureDegree(String path) {
	// int degree = 0;
	// try {
	// ExifInterface exifInterface = new ExifInterface(path);
	// int orientation =
	// exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION,
	// ExifInterface.ORIENTATION_NORMAL);
	// switch (orientation) {
	// case ExifInterface.ORIENTATION_ROTATE_90:
	// degree = 90 + rotate;
	// break;
	// case ExifInterface.ORIENTATION_ROTATE_180:
	// degree = 180 + rotate;
	// break;
	// case ExifInterface.ORIENTATION_ROTATE_270:
	// degree = 270 + rotate;
	// break;
	// case ExifInterface.ORIENTATION_NORMAL:
	// degree = rotate;
	// break;
	// }
	// } catch (IOException e) {
	// e.printStackTrace();
	// }
	// return degree;
	// }

	private static void cloceBitmap(Bitmap bitmap) {
		if (bitmap != null) {
			bitmap.recycle();
			bitmap = null;
		}
	}

	/**
	 * 传入一张图片和要保存到的路径，将图片替换保存
	 * 
	 * @param bm
	 * @param savePath
	 * @return
	 */
	public static boolean savePicture(Bitmap bm, String savePath) {
		if (bm == null)
			return false;
		InputStream is = null;
		FileOutputStream outputStream = null;
		ByteArrayOutputStream baos = null;
		try {
			File file = new File(savePath);
			if (file.exists()) {
				file.createNewFile();
			}
			baos = new ByteArrayOutputStream();
			bm.compress(Bitmap.CompressFormat.JPEG, 75, baos);
			is = new ByteArrayInputStream(baos.toByteArray());
			outputStream = new FileOutputStream(file);
			byte[] buffer = new byte[1024];
			int len = 0;
			while (len != -1) {
				len = is.read(buffer);
				if (len > 0) {
					outputStream.write(buffer, 0, len);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if (baos != null) {
					baos.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				baos = null;
			}

			try {
				if (is != null) {
					is.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				is = null;
			}

			try {
				if (outputStream != null) {
					outputStream.flush();
					outputStream.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				outputStream = null;
			}
		}
		return true;
	}

	/**
	 * 加水印 也可以加文字
	 * 
	 * @param src
	 * @param watermark
	 * @param title
	 * @return
	 */
	public static Bitmap watermarkBitmap(Bitmap src, Bitmap watermark, String title) {
		if (src == null) {
			return null;
		}
		int w = src.getWidth();
		int h = src.getHeight();
		// 需要处理图片太大造成的内存超过的问题,这里我的图已经压缩过
		Bitmap newb = Bitmap.createBitmap(w, h, Config.ARGB_8888);// 创建一个新的和SRC长度宽度一样的位图
		Canvas cv = new Canvas(newb);
		cv.drawBitmap(src, 0, 0, null);// 在 0，0坐标开始画入src
		Paint paint = new Paint();
		// 加入图片
		if (watermark != null) {
			int ww = watermark.getWidth();
			int wh = watermark.getHeight();
			paint.setAlpha(50);
			// cv.drawBitmap(watermark, w - ww + 5, h - wh + 5, paint);//
			// 在src的右下角画入水印
			cv.drawBitmap(watermark, 0, 0, paint);// 在src的左上角画入水印
		} else {
			Log.i("i", "water mark failed");
		}
		// 加入文字
		if (title != null) {
			String familyName = "宋体";
			Typeface font = Typeface.create(familyName, Typeface.NORMAL);
			TextPaint textPaint = new TextPaint();
			textPaint.setColor(Color.YELLOW);
			textPaint.setTypeface(font);
			textPaint.setTextSize(28);
			// 这里是自动换行的
			// StaticLayout layout = new
			// StaticLayout(title,textPaint,w,Alignment.ALIGN_OPPOSITE,1.0F,0.0F,true);
			// layout.draw(cv);
			// 文字就加左上角算了
			// cv.drawText(title, w - 300, h - 30, textPaint);
		}
		cv.save(Canvas.ALL_SAVE_FLAG);// 保存
		cv.restore();// 存储
		return newb;
	}

	public static int[] initColors(int width, int height, int color) {
		int[] colors = new int[width * height];
		for (int i = 0; i < colors.length; i++) {

			colors[i] = color;
		}

		return colors;
	}

}
