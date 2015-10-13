package cn.com.ethank.yunge.pad.adapter;

import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;

public abstract class FragmentpaperViewAdapater extends PagerAdapter {


//	@Override
//	public boolean isViewFromObject(View arg0, Object arg1) {
//		// TODO Auto-generated method stub
//		return false;
//	}
	private static final String TAG = "FragmentPagerAdapter";
	private static final boolean DEBUG = true;

	private final FragmentManager mFragmentManager;

	public FragmentpaperViewAdapater(FragmentManager fm) {
	    mFragmentManager = fm;
	}

	/**
	 * Return the Fragment associated with a specified position.
	 */
	public abstract Fragment getItem(int position);
	
	@Override
	public void startUpdate(ViewGroup container) {
	}

	@Override
	public Object instantiateItem(ViewGroup container, int position) {
	    Fragment fragment = getItem(position);
	    if(!fragment.isAdded()){
	        FragmentTransaction ft = mFragmentManager.beginTransaction();
	        ft.add(fragment, fragment.getClass().getName());
	        ft.commit();
	        mFragmentManager.executePendingTransactions();
	    }
	    if(fragment.getView().getParent() == null){
	        container.addView(fragment.getView()); // 为viewpager增加布局
	    }

	    return fragment.getView();
	}

	@Override
	public void destroyItem(ViewGroup container, int position, Object object) {
	    container.removeView((View) object);
	}


	@Override
	public boolean isViewFromObject(View view, Object object) {
	    return view == object;
	}

	@Override
	public Parcelable saveState() {
	    return null;
	}

	@Override
	public void restoreState(Parcelable state, ClassLoader loader) {
	}

	private static String makeFragmentName(int viewId, int index) {
	    return "android:switcher:" + viewId + ":" + index;
	}

}
