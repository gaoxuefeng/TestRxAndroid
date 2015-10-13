package cn.com.ethank.yunge.app.discover.adview;

import android.view.View;
import android.view.ViewGroup;

import cn.com.jakewharton.salvage.RecyclingPagerAdapter;

public class DisCoverAdvertImagePagerAdapterDecorator extends RecyclingPagerAdapter {
	private DisCoverAdvertImagePagerAdapter adapter;

	public DisCoverAdvertImagePagerAdapterDecorator(DisCoverAdvertImagePagerAdapter adapter) {
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
