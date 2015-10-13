package com.example.imageload;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

public class ViewAdapter extends BaseAdapter {

	private Context context;
	private List<String> images;
	private ImageLoader mImageLoader;

	public ViewAdapter(Context context, ImageLoader mImageLoader, List<String> images) {
		this.context = context;
		this.mImageLoader = mImageLoader;
		this.images = images;
	}

	@Override
	public int getCount() {
		return images.size();
	}

	@Override
	public String getItem(int position) {
		return images.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.load_small_image_list_item, null);
			viewHolder.mImageView = (CubeImageView) convertView.findViewById(R.id.load_small_image_list_item_image_view);
			viewHolder.mImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		viewHolder.mImageView.loadImage(mImageLoader, getItem(position), ImageSize.sSmallImageReuseInfo);
		return convertView;
	}

	class ViewHolder {

		public CubeImageView mImageView;

	}
}
