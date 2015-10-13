/*
 * Copyright 2014 trinea.cn All right reserved. This software is the confidential and proprietary information of
 * trinea.cn ("Confidential Information"). You shall not disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into with trinea.cn.
 */
package cn.com.ethank.yunge.app.discover.adview;

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
public class DisCoverAdvertImagePagerAdapter extends RecyclingPagerAdapter {
	PictureManager pictureManager = new PictureManager();
	private Context context;
	private List<DiscoverSubjectBean> imageIdList;

	private int size;
	private boolean isInfiniteLoop;

	public DisCoverAdvertImagePagerAdapter(Context context, List<DiscoverSubjectBean> imageIdList) {
		this.context = context;
		this.imageIdList = imageIdList;
		this.size = imageIdList.size();
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
			holder.tv_listen_count = (TextView) view.findViewById(R.id.tv_listen_count);
			holder.tv_like_count = (TextView) view.findViewById(R.id.tv_like_count);
			view.setTag(holder);
		} else {
			holder = (ViewHolder) view.getTag();
		}

		final DiscoverSubjectBean discoverSubjectBean = imageIdList.get(getPosition(position));
		// Bitmap bitmap =
		// pictureManager.getmenuLogo(discoverSubjectBean.getSpecialImgPath(),
		// false, downloadFinished);
		// if (bitmap != null) {
		// holder.imageView.setImageBitmap(bitmap);
		// }
		pictureManager.getmenuLogo(holder.imageView, discoverSubjectBean.getSpecialImgPath(), R.drawable.find_deflaut_bg);
		// holder.tv_like_count.setTag(discoverSubjectBean.getSpecialImgPath());

		holder.tv_listen_count.setText(discoverSubjectBean.getListenCount() + "");
		holder.tv_like_count.setText(discoverSubjectBean.getPraiseCount() + "");
		holder.imageView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(context, DisCoverSubjectActivity.class);
				intent.putExtra("discoverSubjectBean", discoverSubjectBean);
				context.startActivity(intent);

			}
		});
		return view;
	}

	private static class ViewHolder {

		public TextView tv_like_count;
		public TextView tv_listen_count;
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
	public DisCoverAdvertImagePagerAdapter setInfiniteLoop(boolean isInfiniteLoop) {
		this.isInfiniteLoop = isInfiniteLoop;
		return this;
	}
}
