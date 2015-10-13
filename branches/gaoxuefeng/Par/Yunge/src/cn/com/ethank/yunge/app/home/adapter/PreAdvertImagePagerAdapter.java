/*
 * Copyright 2014 trinea.cn All right reserved. This software is the confidential and proprietary information of
 * trinea.cn ("Confidential Information"). You shall not disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into with trinea.cn.
 */
package cn.com.ethank.yunge.app.home.adapter;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.imageloader.MyImageLoader;
import cn.com.jakewharton.salvage.RecyclingPagerAdapter;

/**
 * AdvertImagePagerAdapter
 * 
 * @author <a href="http://www.trinea.cn" target="_blank">Trinea</a> 2014-2-23
 */
public class PreAdvertImagePagerAdapter extends RecyclingPagerAdapter {

	private Context context;
	private String[] iStrings;
	private int size;
	private boolean isInfiniteLoop;
	private ImageLoader imageLoader;

	public PreAdvertImagePagerAdapter(Context context, String[] imageUrls) {
		this.context = context;
		this.iStrings = imageUrls;
		isInfiniteLoop = false;
		imageLoader = ImageLoaderUtil.CreatImageLoader(context, R.drawable.find_deflaut_bg);
	}

	@Override
	public int getCount() {
		return isInfiniteLoop ? Integer.MAX_VALUE : iStrings.length;
	}

	/**
	 * get really position
	 * 
	 * @param position
	 * @return
	 */
	private int getPosition(int position) {
		return position % iStrings.length;
	}

	@Override
	public View getView(int position, View view, ViewGroup container) {
		ViewHolder holder;
		if (view == null) {
			holder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.item_discover_subject, null);
			holder.imageView = (CubeImageView) view.findViewById(R.id.iv_auto_image);
			view.setTag(holder);
		} else {
			holder = (ViewHolder) view.getTag();
		}
		holder.imageView.loadImage(imageLoader, iStrings[getPosition(position)]);

		return view;
	}

	private static class ViewHolder {

		CubeImageView imageView;
	}

	/**
	 * @return the isInfiniteLoop
	 */
	public boolean isInfiniteLoop() {
		return isInfiniteLoop;
	}

	/**
	 * @param isInfiniteLoop
	 *            the isInfiniteLoop to set
	 */
	public PreAdvertImagePagerAdapter setInfiniteLoop(boolean isInfiniteLoop) {
		this.isInfiniteLoop = isInfiniteLoop;
		return this;
	}
}
