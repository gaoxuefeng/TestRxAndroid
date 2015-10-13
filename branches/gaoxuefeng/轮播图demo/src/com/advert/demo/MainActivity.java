package com.advert.demo;

import java.util.ArrayList;
import java.util.List;


import com.advert.demo.adapter.AdvertImagePagerAdapter;
import com.advert.demo.view.AutoScrollViewPager;
import com.advert.demo.view.CirclePageIndicator;
import com.example.advertdemo.R;
import com.viewpagerindicator.PageIndicator;

import android.app.Activity;
import android.os.Bundle;

public class MainActivity extends Activity {

	private AutoScrollViewPager viewPager;
	PageIndicator mIndicator;

	private List<Integer> imageIdList;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main_layout);

		viewPager = (AutoScrollViewPager) findViewById(R.id.view_pager_advert);
		mIndicator = (CirclePageIndicator) findViewById(R.id.indicator);

		imageIdList = new ArrayList<Integer>();
		imageIdList.add(R.drawable.banner1);
		imageIdList.add(R.drawable.banner2);
		imageIdList.add(R.drawable.banner3);
		imageIdList.add(R.drawable.banner4);
		viewPager.setAdapter(new AdvertImagePagerAdapter(this, imageIdList));
		mIndicator.setViewPager(viewPager);
		viewPager.setInterval(2000);
		viewPager.startAutoScroll();
		viewPager.setCurrentItem(Integer.MAX_VALUE / 2 - Integer.MAX_VALUE / 2 %imageIdList.size());

	}

	@Override
	protected void onPause() {
		super.onPause();
		// stop auto scroll when onPause
		viewPager.stopAutoScroll();
	}

	@Override
	protected void onResume() {
		super.onResume();
		// start auto scroll when onResume
		viewPager.startAutoScroll();
	}
}
