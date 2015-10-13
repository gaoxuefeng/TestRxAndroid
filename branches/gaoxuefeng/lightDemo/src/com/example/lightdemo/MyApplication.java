package com.example.lightdemo;

import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.support.v4.util.LruCache;

public class MyApplication extends Application {
	private static MyApplication instance;
	/*
	 * Volley.newRequestQueue()������һ��app���ִ��һ�Σ� ����ʹ�õ������ģʽ������application��ɳ�ʼ����
	 * ����ԭ����鿴�����������http://www.apkbus.com/android-155252-1-1.html
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

		// ��ȡϵͳ�����ÿ��Ӧ�ó��������ڴ棬ÿ��Ӧ��ϵͳ����32M
		int maxMemory = (int) Runtime.getRuntime().maxMemory();
		int mCacheSize = maxMemory / 8;
		// ��LruCache����1/8 4M

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
