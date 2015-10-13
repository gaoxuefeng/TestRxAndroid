package cn.com.ethank.yunge.pad.tabs;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.tabs.fragment.DemandFragment;
import cn.com.ethank.yunge.pad.tabs.fragment.DemandedFragment;
import cn.com.ethank.yunge.pad.tabs.fragment.HistorySongFragment;
import cn.com.ethank.yunge.pad.view.MyFragmentPagerAdapter;

public class TabMainActivity extends MainTabActivity implements OnClickListener {

	private FrameLayout ll_control_up;
	private LinearLayout ll_control_ll;
	private RadioGroup rg_fgsong_title;
	private ViewPager vp_fgcontent;
	private RadioButton rb_fgsong1;
	private RadioButton rb_fgsong2;
	private LinearLayout ll_below;
	private DemandFragment demandFragment;
	private DemandedFragment demandedFragment;
	private HistorySongFragment histirySongFragment;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_tab_activity_a);
		setView();
		initData();
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
			public android.app.Fragment getItem(int position) {
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
					//
					demandedFragment.OnRefresh();
					break;
				case R.id.rb_fgsong3:
					if (vp_fgcontent.getCurrentItem() != 2)
						vp_fgcontent.setCurrentItem(2);
					break;
				}
			}
		});
		vp_fgcontent.setOnPageChangeListener(new OnPageChangeListener() {

			@Override
			public void onPageSelected(int position) {
				rg_fgsong_title.check(rg_fgsong_title.getChildAt(position).getId());

			}

			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {

			}

			@Override
			public void onPageScrollStateChanged(int arg0) {

			}
		});

	}

	private void setView() {
		// 控制区顶部的部分
		ll_control_up = (FrameLayout) findViewById(R.id.ll_control_up);
		ll_control_ll = (LinearLayout) findViewById(R.id.ll_control_ll);
		rg_fgsong_title = (RadioGroup) findViewById(R.id.rg_fgsong_title);
		rg_fgsong_title.check(R.id.rb_fgsong1);
		vp_fgcontent = (ViewPager) findViewById(R.id.vp_fgcontent);
		rb_fgsong1 = (RadioButton) findViewById(R.id.rb_fgsong1);
		rb_fgsong2 = (RadioButton) findViewById(R.id.rb_fgsong2);// 已点
		vp_fgcontent.setOffscreenPageLimit(2);// 缓冲两页使fragment不被ViewPager摧毁

		ll_below = (LinearLayout) findViewById(R.id.ll_below);

	}

	@Override
	public void initBaseView() {
		super.initBaseView();
		setTitleVisible(false);
		setCenterText(R.string.title_activity_tab_activity_a);

	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {

		default:
			break;
		}
	}

	@Override
	protected void onRestart() {
		super.onRestart();
	}

	@Override
	protected void onResume() {
		super.onResume();
	}

	@Override
	protected void onPause() {
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}
}
