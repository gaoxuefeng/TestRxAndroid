package cn.com.ethank.yunge.app.imageloader;

import cn.com.ethank.yunge.R;
import android.content.Context;
import in.srain.cube.image.ImageLoader;
import in.srain.cube.image.ImageLoaderFactory;
import in.srain.cube.image.impl.DefaultImageLoadHandler;

public class ImageLoaderUtil {
	// 普通的
	public static ImageLoader CreatImageLoader(Context context) {

		return ImageLoaderFactory.create(context);

	}

	// 有默认图片的
	public static ImageLoader CreatImageLoader(Context context, int defaultResource) {
		ImageLoader imageLoader = CreatImageLoader(context);
		((DefaultImageLoadHandler) imageLoader.getImageLoadHandler()).setDefaultResources(defaultResource);
		return imageLoader;

	}

	// 有圆角的的
	public static ImageLoader CreatImageLoader(Context context, boolean isRound) {
		ImageLoader imageLoader = CreatImageLoader(context);
		if (isRound) {
			((DefaultImageLoadHandler) imageLoader.getImageLoadHandler()).setImageRounded(true, 10);
		}
		return imageLoader;

	}

	// 有圆角并且有默认图片
	public static ImageLoader CreatImageLoader(Context context, boolean isRound, int defaultResource) {
		ImageLoader imageLoader = CreatImageLoader(context, defaultResource);
		if (isRound) {
			((DefaultImageLoadHandler) imageLoader.getImageLoadHandler()).setImageRounded(true, 10);
		}
		return imageLoader;

	}
	
	// 是圆圈并且有默认图片
	public static ImageLoader CreatImageLoader(Context context, int defaultResource,boolean isCircle) {
		ImageLoader imageLoader = CreatImageLoader(context, defaultResource);
		if (isCircle) {
			((DefaultImageLoadHandler) imageLoader.getImageLoadHandler()).setImageCircled(isCircle);
		}
		return imageLoader;
		
	}
}
