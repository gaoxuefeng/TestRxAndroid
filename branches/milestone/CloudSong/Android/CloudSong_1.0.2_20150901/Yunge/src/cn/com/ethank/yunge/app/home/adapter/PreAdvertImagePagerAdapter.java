/*
 * Copyright 2014 trinea.cn All right reserved. This software is the confidential and proprietary information of
 * trinea.cn ("Confidential Information"). You shall not disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into with trinea.cn.
 */
package cn.com.ethank.yunge.app.home.adapter;

import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.discover.activity.DisCoverSubjectActivity;
import cn.com.ethank.yunge.app.discover.bean.DiscoverSubjectBean;
import cn.com.ethank.yunge.app.picmanager.PictureManager;
import cn.com.ethank.yunge.app.picmanager.PictureManager.OnPictureDownloadFinished;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.jakewharton.salvage.RecyclingPagerAdapter;

/**
 * AdvertImagePagerAdapter
 * 
 * @author <a href="http://www.trinea.cn" target="_blank">Trinea</a> 2014-2-23
 */
public class PreAdvertImagePagerAdapter extends RecyclingPagerAdapter {
	PictureManager pictureManager = new PictureManager();
	OnPictureDownloadFinished downloadFinished = new OnPictureDownloadFinished() {

		@Override
		public void notifyPictureDownloaded() {
			notifyDataSetChanged();

		}
	};
	private Context context;
	private List<View> imageIdList;
	private String[] iStrings;
	private int size;
	private boolean isInfiniteLoop;


	public PreAdvertImagePagerAdapter(List<View> views, Context context, String[] imageUrls) {
		this.imageIdList = views;
		this.context = context;
		this.iStrings = imageUrls;
		isInfiniteLoop = false;
	}

	@Override
	public int getCount() {
		return isInfiniteLoop ? Integer.MAX_VALUE : imageIdList.size();
	}

	/**
	 * get really position
	 * 
	 * @param position
	 * @return
	 */
	private int getPosition(int position) {
		return position % size;
	}

	@Override
	public View getView(int position, View view, ViewGroup container) {
		ViewHolder holder;
		if (view == null) {

			holder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.item_discover_subject, null);
			holder.imageView = (ImageView) view.findViewById(R.id.iv_auto_image);
			view.setTag(holder);
		} else {
			holder = (ViewHolder) view.getTag();
		}

		final ImageView discoverSubjectBean = (ImageView) imageIdList.get(getPosition(position));
		if (holder.imageView.getTag() != null) {
			if (!holder.imageView.getTag().equals(discoverSubjectBean)) {
				Bitmap bitmap = pictureManager.getmenuLogo(iStrings[position], false, downloadFinished);
				if (bitmap != null) {
					holder.imageView.setImageBitmap(bitmap);
				}
				// BaseApplication.bitmapUtils.display(holder.imageView,
				// discoverSubjectBean.getSpecialImgPath(),
				// R.drawable.find_deflaut_bg);
				holder.imageView.setTag(discoverSubjectBean);
			}
		} else {
			Bitmap bitmap = pictureManager.getmenuLogo(iStrings[position], false, downloadFinished);
			if (bitmap != null) {
				holder.imageView.setImageBitmap(bitmap);
			}
			// BaseApplication.bitmapUtils.display(holder.imageView,
			// discoverSubjectBean.getSpecialImgPath(),
			// R.drawable.find_deflaut_bg);
			holder.imageView.setTag(discoverSubjectBean);
		}
		
		return view;
	}

	private static class ViewHolder {

		ImageView imageView;
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
