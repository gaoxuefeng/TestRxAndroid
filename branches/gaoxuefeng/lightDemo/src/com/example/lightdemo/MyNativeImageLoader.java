package com.example.lightdemo;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.media.Image;
import android.os.Handler;
import android.os.Message;
import android.support.v4.util.LruCache;
import android.widget.ImageView;

/**
 * 本地图片加载器,采用的是异步解析本地图片，单例模式利用getInstance()获取NativeImageLoader实例
 * 调用loadNativeImage()方法加载本地图片，此类可作为一个加载本地图片的工具类
 * 
 * @blog http://blog.csdn.net/xiaanming
 * 
 * @author xiaanming
 * 
 */
public class MyNativeImageLoader {
	private LruCache<String, Bitmap> mMemoryCache = new MyApplication().getBitmapCache();
	private static MyNativeImageLoader mInstance = new MyNativeImageLoader();
	private ExecutorService mImageThreadPool = Executors.newFixedThreadPool(1);
	private Bitmap bitmap;

	private MyNativeImageLoader() {

	}

	/**
	 * 通过此方法来获取NativeImageLoader的实例
	 * 
	 * @return
	 */
	public static MyNativeImageLoader getInstance() {
		return mInstance;
	}

	/**
	 * 加载本地图片，对图片不进行裁剪
	 * 
	 * @param path
	 * @param mCallBack
	 * @return
	 */
	public Bitmap loadNativeImage(final String path, final MyNativeImageCallBack mCallBack) {
		return this.loadNativeImage(path, null, mCallBack);
	}

	/**
	 * 此方法来加载本地图片，这里的mPoint是用来封装ImageView的宽和高，我们会根据ImageView控件的大小来裁剪Bitmap
	 * 如果你不想裁剪图片，调用loadNativeImage(final String path, final NativeImageCallBack
	 * mCallBack)来加载
	 * 
	 * @param path
	 * @param mPoint
	 * @param mCallBack
	 * @return
	 */
	public Bitmap loadNativeImage(final String path, final Point mPoint, final MyNativeImageCallBack mCallBack) {
		// 先获取内存中的Bitmap
		Bitmap bitmap = getBitmapFromMemCache(path);

		final Handler mHander = new Handler() {

			@Override
			public void handleMessage(Message msg) {
				super.handleMessage(msg);
				mCallBack.onImageLoader((Bitmap) msg.obj, path);
			}

		};

		// 若该Bitmap不在内存缓存中，则启用线程去加载本地的图片，并将Bitmap加入到mMemoryCache中
		if (bitmap == null) {
			mImageThreadPool.execute(new Runnable() {

				@Override
				public void run() {
					// 先获取图片的缩略图
					Bitmap mBitmap = decodeThumbBitmapForFile(path, mPoint == null ? 0 : mPoint.x, mPoint == null ? 0 : mPoint.y);
					Message msg = mHander.obtainMessage();
					msg.obj = mBitmap;
					mHander.sendMessage(msg);

					// 将图片加入到内存缓存
					if (mBitmap != null) {
						addBitmapToMemoryCache(path, mBitmap);
					}

				}
			});
		}
		return bitmap;

	}

	public Bitmap loadNativeImage(final int resId, final ImageView imageView) {
		// 先获取内存中的Bitmap
		Bitmap bitmap = getBitmapFromMemCache(resId + "");

		final Handler mHander = new Handler() {

			@Override
			public void handleMessage(Message msg) {
				super.handleMessage(msg);
				imageView.setImageBitmap((Bitmap) msg.obj);
			}

		};

		// 若该Bitmap不在内存缓存中，则启用线程去加载本地的图片，并将Bitmap加入到mMemoryCache中
		if (bitmap == null) {
			mImageThreadPool.execute(new Runnable() {

				@Override
				public void run() {
					// 先获取图片的缩略图
					Resources res = MyApplication.getIantance().getResources();
					Bitmap mBitmap = BitmapFactory.decodeResource(res, resId);
					Message msg = mHander.obtainMessage();
					msg.obj = mBitmap;
					mHander.sendMessage(msg);

					// 将图片加入到内存缓存
					if (mBitmap != null) {
						addBitmapToMemoryCache(resId + "", mBitmap);
					}

				}
			});
		}
		return bitmap;

	}

	// public Bitmap loadNativeImageFromNet(final String url, final Point
	// mPoint, final MyNativeImageCallBack mCallBack) {
	// // 先获取内存中的Bitmap
	// Bitmap bitmap = getBitmapFromMemCache(url);
	//
	// final Handler mHander = new Handler() {
	//
	// @Override
	// public void handleMessage(Message msg) {
	// super.handleMessage(msg);
	// mCallBack.onImageLoader((Bitmap) msg.obj, url);
	// }
	//
	// };
	//
	// // 若该Bitmap不在内存缓存中，则启用线程去加载本地的图片，并将Bitmap加入到mMemoryCache中
	// if (bitmap == null) {
	// mImageThreadPool.execute(new Runnable() {
	//
	// @Override
	// public void run() {
	// try {
	// // 先获取图片的缩略图
	// Bitmap mBitmap = ImageUtil.decodeURLImageToBitmap(url);
	// Message msg = mHander.obtainMessage();
	// msg.obj = mBitmap;
	// mHander.sendMessageDelayed(msg, 300);
	//
	// // 将图片加入到内存缓存
	// if (mBitmap != null) {
	// addBitmapToMemoryCache(url, mBitmap);
	// }
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// }
	// });
	// }
	// return bitmap;
	//
	// }

	// public Bitmap saveNativeImageFromNet(final String url, final String
	// savePath, final MySaveImageCallBack mySaveImageCallBack) {
	// // 先获取内存中的Bitmap
	// final Handler mHander = new Handler() {
	//
	// @Override
	// public void handleMessage(Message msg) {
	// super.handleMessage(msg);
	// mySaveImageCallBack.onImageLoader( (Boolean)msg.obj, url);
	// }
	//
	// };
	//
	// // 若该Bitmap不在内存缓存中，则启用线程去加载本地的图片，并将Bitmap加入到mMemoryCache中
	// mImageThreadPool.execute(new Runnable() {
	//
	// @Override
	// public void run() {
	// try {
	// // 将图片加入到内存缓存
	// boolean success = PicUtil.saveURLImageToFile(url, savePath);
	// Message message=new Message();
	// message.obj=success;
	// mHander.sendMessage(message);
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// }
	// });
	// return bitmap;
	//
	// }

	/**
	 * 往内存缓存中添加Bitmap
	 * 
	 * @param key
	 * @param bitmap
	 */
	private void addBitmapToMemoryCache(String key, Bitmap bitmap) {
		if (getBitmapFromMemCache(key) == null && bitmap != null) {
			mMemoryCache.put(key, bitmap);
			if(bitmap!=null&!bitmap.isRecycled()){
				bitmap.recycle();
				bitmap=null;
			}
		}
	}

	/**
	 * 根据key来获取内存中的图片
	 * 
	 * @param key
	 * @return
	 */
	private Bitmap getBitmapFromMemCache(String key) {
		return mMemoryCache.get(key);
	}

	/**
	 * 根据View(主要是ImageView)的宽和高来获取图片的缩略图
	 * 
	 * @param path
	 * @param viewWidth
	 * @param viewHeight
	 * @return
	 */
	private Bitmap decodeThumbBitmapForFile(String path, int viewWidth, int viewHeight) {
		BitmapFactory.Options options = new BitmapFactory.Options();
		// 设置为true,表示解析Bitmap对象，该对象不占内存
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(path, options);
		// 设置缩放比例
		options.inSampleSize = computeScale(options, viewWidth, viewHeight);

		// 设置为false,解析Bitmap对象加入到内存中
		options.inJustDecodeBounds = false;

		return BitmapFactory.decodeFile(path, options);
	}

	/**
	 * 根据View(主要是ImageView)的宽和高来计算Bitmap缩放比例。默认不缩放
	 * 
	 * @param options
	 * @param width
	 * @param height
	 */
	private int computeScale(BitmapFactory.Options options, int viewWidth, int viewHeight) {
		int inSampleSize = 1;
		if (viewWidth == 0 || viewWidth == 0) {
			return inSampleSize;
		}
		int bitmapWidth = options.outWidth;
		int bitmapHeight = options.outHeight;

		// 假如Bitmap的宽度或高度大于我们设定图片的View的宽高，则计算缩放比例
		if (bitmapWidth > viewWidth || bitmapHeight > viewWidth) {
			int widthScale = Math.round((float) bitmapWidth / (float) viewWidth);
			int heightScale = Math.round((float) bitmapHeight / (float) viewWidth);

			// 为了保证图片不缩放变形，我们取宽高比例最小的那个
			inSampleSize = widthScale < heightScale ? widthScale : heightScale;
		}
		return inSampleSize;
	}

	/**
	 * 加载本地图片的回调接口
	 * 
	 * @author xiaanming
	 * 
	 */
	public interface MyNativeImageCallBack {
		/**
		 * 当子线程加载完了本地的图片，将Bitmap和图片路径回调在此方法中
		 * 
		 * @param bitmap
		 * @param path
		 */
		public void onImageLoader(Bitmap bitmap, String path);
	}

	public interface MySaveImageCallBack {
		/**
		 * 当子线程加载完了本地的图片，将Bitmap和图片路径回调在此方法中
		 * 
		 * @param bitmap
		 * @param path
		 */
		public void onImageLoader(Boolean success, String path);
	}
}
