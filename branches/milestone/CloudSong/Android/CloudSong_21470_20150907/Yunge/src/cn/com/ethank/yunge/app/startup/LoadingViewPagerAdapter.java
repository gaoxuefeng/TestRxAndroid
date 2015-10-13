package cn.com.ethank.yunge.app.startup;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.View.OnClickListener;
import cn.com.ethank.yunge.R;

public class LoadingViewPagerAdapter extends PagerAdapter {

	private ArrayList<View> views;
	private Activity context;

	public LoadingViewPagerAdapter(Activity context, ArrayList<View> views) {
		this.context = context;
		this.views = views;

	}

	@Override
	public int getCount() {
		return views.size();
	}

	@Override
	public boolean isViewFromObject(View arg0, Object arg1) {
		return arg0 == arg1;
	}

	@Override
	public void destroyItem(View container, int position, Object object) {

		((ViewPager) container).removeView(views.get(position));
	}

	@Override
	public Object instantiateItem(View container, int position) {
		View view = views.get(position);
		if (position == 3) {
			View iv_click_finish = view.findViewById(R.id.iv_click_finish);
			iv_click_finish.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Intent intent = new Intent(context, MainTabActivity.class);
					context.overridePendingTransition(R.anim.without_anim, R.anim.without_anim);
					context.startActivity(intent);
					context.finish();

				}
			});
		}
		((ViewPager) container).addView(view);

		return view;
	}
}
