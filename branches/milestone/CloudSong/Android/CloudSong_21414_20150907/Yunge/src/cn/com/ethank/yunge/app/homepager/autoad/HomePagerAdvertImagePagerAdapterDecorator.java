package cn.com.ethank.yunge.app.homepager.autoad;

import android.view.View;
import android.view.ViewGroup;

import cn.com.jakewharton.salvage.RecyclingPagerAdapter;

public class HomePagerAdvertImagePagerAdapterDecorator extends RecyclingPagerAdapter {
	private HomePagerAdvertImagePagerAdapter adapter;

	public HomePagerAdvertImagePagerAdapterDecorator(HomePagerAdvertImagePagerAdapter adapter) {
		this.adapter = adapter;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup container) {
		return adapter.getView(position, convertView, container);
	}

	@Override
	public int getCount() {
		return Integer.MAX_VALUE;
	}

}
