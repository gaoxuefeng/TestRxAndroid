package com.example.lightdemo;

import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.support.v4.util.LruCache;

public class MyApplication extends Application {
	private static MyApplication instance;
	/*
	 * Volley.newRequestQueue()方法在一个app最好执行一次， 可以使用单例设计模式或者在application完成初始化，
	 * 具体原因请查看代码分析见：http://www.apkbus.com/android-155252-1-1.html
	 */
	public static LruCache<String, Bitmap> lruCache;

	@Override
	public void onCreate() {
		super.onCreate();
		instance=this;

	}

	public synchronized LruCache<String, Bitmap> getBitmapCache() {
		if (lruCache == null)
			buildCache();
		return lruCache;
	}

	private void buildCache() {

		// 获取系统分配给每个应用程序的最大内存，每个应用系统分配32M
		int maxMemory = (int) Runtime.getRuntime().maxMemory();
		int mCacheSize = maxMemory / 8;
		// 给LruCache分配1/8 4M

		lruCache = new LruCache<String, Bitmap>(mCacheSize) {
			@Override
			protected int sizeOf(String key, Bitmap bitmap) {
				return bitmap.getRowBytes() * bitmap.getHeight();
			}
		};
	}
	public static Context getIantance(){
		return instance;
		
		
	}
}
