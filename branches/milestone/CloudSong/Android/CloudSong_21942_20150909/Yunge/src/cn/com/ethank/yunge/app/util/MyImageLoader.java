package cn.com.ethank.yunge.app.util;

import android.widget.ImageView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.DisplayImageOptions.Builder;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.imageaware.ImageViewAware;

public class MyImageLoader {
	public static void displayImage(ImageView imageView, String uri) {
		if (imageView == null || uri == null) {
			return;
		}
		displayImage(imageView, uri, 0);
	}

	public static void displayImage(ImageView imageView, String uri, int defaultImageResource) {
		try {
			if (defaultImageResource == 0) {
				ImageLoader.getInstance().displayImage(uri, imageView);
			} else {
				Builder builder = new DisplayImageOptions.Builder();
				builder.cacheInMemory(true).cacheOnDisk(true);
				builder.showImageForEmptyUri(defaultImageResource);
				builder.showImageOnFail(defaultImageResource);
				DisplayImageOptions displayImageOptions = builder.build();
				ImageLoader.getInstance().displayImage(uri, new ImageViewAware(imageView), displayImageOptions, null, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
