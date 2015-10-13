package cn.com.ethank.yunge.app.demandsongs;

import android.app.Activity;
import android.app.Fragment;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.BaseFragment;
import cn.com.ethank.yunge.app.demandsongs.childfragment.DemandFragment;
import cn.com.ethank.yunge.app.demandsongs.childfragment.DemandedFragment;
import cn.com.ethank.yunge.app.demandsongs.childfragment.HistorySongFragment;
import cn.com.ethank.yunge.view.MyFragmentPagerAdapter;

public class DemandSongsFragment extends BaseFragment {

	private OnFragmentInteractionListener mListener;
	private RadioGroup rg_fgsong_title;
	private RadioButton rb_fgsong1;
	private ViewPager vp_fgcontent;
	private DemandFragment demandFragment;
	private DemandedFragment demandedFragment;
	private HistorySongFragment histirySongFragment;

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
	}

	@Override
	public void onResume() {
		super.onResume();
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View View = inflater.inflate(R.layout.fragment_song, container, false);
		initView(View);
		initData();

		return View;
	}

	private void initData() {
		demandFragment = new DemandFragment();
		demandedFragment = new DemandedFragment();
		histirySongFragment = new HistorySongFragment();
		vp_fgcontent.setAdapter(new MyFragmentPagerAdapter(getFragmentManager()) {

			@Override
			public int getCount() {
				return 3;
			}

			@Override
			public Fragment getItem(int position) {
				if (position == 0) {
					return demandFragment;
				} else if (position == 1) {
					return demandedFragment;
				} else {
					return histirySongFragment;
				}
			}
		});

		rg_fgsong_title.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				switch (checkedId) {
				case R.id.rb_fgsong1:
					if (vp_fgcontent.getCurrentItem() != 0)
						vp_fgcontent.setCurrentItem(0);
					break;
				case R.id.rb_fgsong2:
					if (vp_fgcontent.getCurrentItem() != 1)
						vp_fgcontent.setCurrentItem(1);
					break;
				case R.id.rb_fgsong3:
					if (vp_fgcontent.getCurrentItem() != 2)
						vp_fgcontent.setCurrentItem(2);
					break;
				}
			}
		});
		vp_fgcontent.setOnPageChangeListener(new pageChangeListener());

	}

	private void initView(View view) {
		rg_fgsong_title = (RadioGroup) view.findViewById(R.id.rg_fgsong_title);
		rg_fgsong_title.check(R.id.rb_fgsong1);
		vp_fgcontent = (ViewPager) view.findViewById(R.id.vp_fgcontent);
		rb_fgsong1 = (RadioButton) view.findViewById(R.id.rb_fgsong1);
		vp_fgcontent.setOffscreenPageLimit(2);// 缓冲两页使fragment不被ViewPager摧毁
	}

	public void onButtonPressed(Uri uri) {
		if (mListener != null) {
			mListener.onFragmentInteraction(uri);
		}
	}

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
	}

	@Override
	public void onDetach() {
		super.onDetach();
		mListener = null;
	}

	public interface OnFragmentInteractionListener {
		public void onFragmentInteraction(Uri uri);
	}

	private class pageChangeListener implements ViewPager.OnPageChangeListener {
		@Override
		public void onPageScrolled(int i, float v, int i2) {

		}

		@Override
		public void onPageSelected(int i) {
			if (i == 0) {
				rg_fgsong_title.check(R.id.rb_fgsong1);

			} else if (i == 1) {
				rg_fgsong_title.check(R.id.rb_fgsong2);
			} else if (i == 2) {
				rg_fgsong_title.check(R.id.rb_fgsong3);
			}

		}

		@Override
		public void onPageScrollStateChanged(int i) {

		}
	}

	@Override
	public void setBind(boolean isBind) {

	}

	@Override
	public void OnFragmentResume() {

	}

	@Override
	public void OnFragmentChanged() {

	}
}
