/*
 * Copyright 2014 trinea.cn All right reserved. This software is the confidential and proprietary information of
 * trinea.cn ("Confidential Information"). You shall not disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into with trinea.cn.
 */
package cn.com.ethank.yunge.app.homepager.autoad;

import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.homepager.ActivityWebWithTitleActivity;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.homepager.bean.AutoPlayPhotos;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.picmanager.PictureManager;
import cn.com.ethank.yunge.app.picmanager.PictureManager.OnPictureDownloadFinished;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.jakewharton.salvage.RecyclingPagerAdapter;

/**
 * AdvertImagePagerAdapter
 * 
 * @author <a href="http://www.trinea.cn" target="_blank">Trinea</a> 2014-2-23
 */
public class HomePagerAdvertImagePagerAdapter extends RecyclingPagerAdapter {
	PictureManager pictureManager = new PictureManager();
	OnPictureDownloadFinished downloadFinished = new OnPictureDownloadFinished() {

		@Override
		public void notifyPictureDownloaded() {
			notifyDataSetChanged();

		}
	};
	private Context context;
	private List<AutoPlayPhotos> imageIdList;
	RefreshUiInterface refreshUiInterface;

	private int size;
	private boolean isInfiniteLoop;

	public HomePagerAdvertImagePagerAdapter(Context context, List<AutoPlayPhotos> autoPlayPhotos, RefreshUiInterface refreshUiInterface) {
		this.context = context;
		this.imageIdList = autoPlayPhotos;
		this.refreshUiInterface = refreshUiInterface;
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
			view = holder.imageView = new ImageView(context);
			view.setBackgroundResource(R.drawable.home_defaultimg_bg);
			holder.imageView.setScaleType(ImageView.ScaleType.FIT_XY);
			view.setTag(holder);
		} else {
			holder = (ViewHolder) view.getTag();
		}
		final AutoPlayPhotos autoPlayPhotos = imageIdList.get(getPosition(position));
		// try {
		// bitmap = pictureManager.getmenuLogo(autoPlayPhotos.getImageUrl(),
		// false, downloadFinished);
		// } catch (Exception e) {
		// }
		// if (bitmap != null) {
		// holder.imageView.setImageBitmap(bitmap);
		// }
		pictureManager.getmenuLogo(holder.imageView, autoPlayPhotos.getImageUrl(), R.drawable.home_defaultimg_bg);
		holder.imageView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				ActivityBean activityBean = new ActivityBean();
				activityBean.setHtmlUrl(autoPlayPhotos.getHtmlUrl());
				activityBean.setUidpass(autoPlayPhotos.getUidpass());
				activityBean.setShareTitle(autoPlayPhotos.getShareTitle());
				activityBean.setShareUrl(autoPlayPhotos.getShareUrl());
				Constants.activityBeanitem = activityBean;

				if (autoPlayPhotos.getUidpass() == 1 && !Constants.getLoginState()) {
					// 去登陆
					refreshUiInterface.refreshUi(true);
					return;
				}
				// 测试不让加
				// if (autoPlayPhotos.getHtmlUrl().isEmpty()) {
				// ToastUtil.show("更多精彩，敬请期待...");
				// return;
				// }

				Intent intent = new Intent(context, ActivityWebWithTitleActivity.class);
				intent.putExtra("activityBean", Constants.activityBeanitem);
				context.startActivity(intent);
			}
		});
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
	public HomePagerAdvertImagePagerAdapter setInfiniteLoop(boolean isInfiniteLoop) {
		this.isInfiniteLoop = isInfiniteLoop;
		return this;
	}
}
