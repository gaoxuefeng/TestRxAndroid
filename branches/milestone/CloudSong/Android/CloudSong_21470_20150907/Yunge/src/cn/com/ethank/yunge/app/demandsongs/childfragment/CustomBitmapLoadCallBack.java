package cn.com.ethank.yunge.app.demandsongs.childfragment;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.widget.ImageView;

import com.lidroid.xutils.bitmap.BitmapDisplayConfig;
import com.lidroid.xutils.bitmap.callback.BitmapLoadFrom;
import com.lidroid.xutils.bitmap.callback.DefaultBitmapLoadCallBack;

public class CustomBitmapLoadCallBack extends DefaultBitmapLoadCallBack<ImageView> {

	

	@Override
	public void onLoading(ImageView container, String uri, BitmapDisplayConfig config, long total, long current) {
	}

	@Override
	public void onLoadCompleted(ImageView container, String uri, Bitmap bitmap, BitmapDisplayConfig config, BitmapLoadFrom from) {
		try {
			container.setBackgroundDrawable(new BitmapDrawable(container.getContext().getResources(), bitmap));
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
