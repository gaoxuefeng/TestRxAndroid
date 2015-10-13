package cn.com.ethank.yunge.app.home.head;

import java.util.List;

import com.lidroid.xutils.BitmapUtils;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;

public class ViewPagerAdapter extends PagerAdapter {

	private List<View> viewlist;
	Context context;
	String[] strings;
	public ViewPagerAdapter(List<View> viewlist, Context context,String[] imgs) {
		this.viewlist = viewlist;
		this.context = context;
		this.strings = imgs;
	}

	@Override
	public int getCount() {
		// 设置成最大，使用户看不到边界
		return Integer.MAX_VALUE;
	}

	@Override
	public boolean isViewFromObject(View arg0, Object arg1) {
		return arg0 == arg1;
	}

	@Override
	public void destroyItem(View arg0, int arg1, Object arg2) {
		// ((ViewPager) arg0).removeView((View) arg2);
	}

	@Override
	public Object instantiateItem(ViewGroup container, int position) {
		// 对ViewPager页号求模取出View列表中要显示的项
		position %= viewlist.size();
		if (position < 0) {
			position = viewlist.size() + position;
		}
		View view = viewlist.get(position);
		BitmapUtils bitmapUtils = new BitmapUtils(context);
		bitmapUtils.display(view, strings[position]);
		// 如果View已经在之前添加到了一个父组件，则必须先remove，否则会抛出IllegalStateException。
		ViewParent vp = view.getParent();
		if (vp != null) {
			ViewGroup parent = (ViewGroup) vp;
			parent.removeView(view);
		}
		container.addView(view);
		// add listeners here if necessary
		return view;
	}

}