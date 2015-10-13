package cn.com.ethank.yunge.app.mine.activity;

import java.util.ArrayList;
import java.util.List;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.fragment.FragmentAdapter;
import cn.com.ethank.yunge.app.mine.fragment.HistoryFragment;
import cn.com.ethank.yunge.app.mine.fragment.ProcessFragment;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.Constants;

/**
 * 我的消费界面
 * 
 */
public class ConsumeActivity extends FragmentActivity implements OnClickListener {

	private ViewPager mPageVp;

	private List<Fragment> mFragmentList = new ArrayList<Fragment>();
	private FragmentAdapter mFragmentAdapter;

	/**
	 * Tab显示内容TextView
	 */
	private TextView mProcessChatTv, mHistoryTv;
	/**
	 * Tab的那个引导线
	 */
	private ImageView mTabLineIv;
	/**
	 * Fragment
	 */
	private ProcessFragment mProcess;
	private HistoryFragment mHistoryFg;
	/**
	 * ViewPager的当前选中页
	 */
	private int currentIndex;
	/**
	 * 屏幕的宽度
	 */
	private int screenWidth;

	private LinearLayout id_tab_progress_ll;

	private LinearLayout id_tab_history_ll;

	private LinearLayout consume_ll_exit;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_consume);
		BaseApplication.getInstance().cacheActivityList.add(this);

		consume_ll_exit = (LinearLayout) findViewById(R.id.consume_ll_exit);
		consume_ll_exit.setOnClickListener(this);

		findById();
		init();
		initTabLineWidth();

	}

	private void findById() {
		mProcessChatTv = (TextView) this.findViewById(R.id.id_progress_tv);
		mHistoryTv = (TextView) this.findViewById(R.id.id_history_tv);

		id_tab_progress_ll = (LinearLayout) this.findViewById(R.id.id_tab_progress_ll);
		id_tab_progress_ll.setOnClickListener(this);
		id_tab_history_ll = (LinearLayout) this.findViewById(R.id.id_tab_history_ll);
		id_tab_history_ll.setOnClickListener(this);

		mTabLineIv = (ImageView) this.findViewById(R.id.id_tab_line_iv);

		mPageVp = (ViewPager) this.findViewById(R.id.id_page_vp);
		mPageVp.setOffscreenPageLimit(1);
	}

	private void init() {
		mHistoryFg = new HistoryFragment();
		mProcess = new ProcessFragment();
		mFragmentList.add(mProcess);
		mFragmentList.add(mHistoryFg);

		mFragmentAdapter = new FragmentAdapter(this.getSupportFragmentManager(), mFragmentList);
		mPageVp.setAdapter(mFragmentAdapter);
		mPageVp.setCurrentItem(0);

		mPageVp.setOnPageChangeListener(new OnPageChangeListener() {

			/**
			 * state滑动中的状态 有三种状态（0，1，2） 1：正在滑动 2：滑动完毕 0：什么都没做。
			 */
			@Override
			public void onPageScrollStateChanged(int state) {

			}

			/**
			 * position :当前页面，及你点击滑动的页面 offset:当前页面偏移的百分比
			 * offsetPixels:当前页面偏移的像素位置
			 */
			@Override
			public void onPageScrolled(int position, float offset, int offsetPixels) {
				LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) mTabLineIv.getLayoutParams();

				Log.e("offset:", offset + "");
				/**
				 * 利用currentIndex(当前所在页面)和position(下一个页面)以及offset来
				 * 设置mTabLineIv的左边距 滑动场景： 记3个页面, 从左到右分别为0,1,2 0->1; 1->2; 2->1;
				 * 1->0
				 */

				if (currentIndex == 0 && position == 0)// 0->1
				{
					lp.leftMargin = (int) (offset * (screenWidth * 1.0 / 2) + currentIndex * (screenWidth / 2)) + 50;

				} else if (currentIndex == 1 && position == 0) // 1->0
				{
					lp.leftMargin = (int) (-(1 - offset) * (screenWidth * 1.0 / 2) + currentIndex * (screenWidth / 2)) + 50;

				}
				mTabLineIv.setLayoutParams(lp);
			}

			@Override
			public void onPageSelected(int position) {
				resetTextView();
				switch (position) {
				case 0:
					mProcessChatTv.setTextColor(getResources().getColor(R.color.select));
					break;
				case 1:
					mHistoryTv.setTextColor(getResources().getColor(R.color.select));
					break;
				}
				currentIndex = position;
			}
		});

	}

	/**
	 * 设置滑动条的宽度为屏幕的1/2(根据Tab的个数而定)
	 */
	private void initTabLineWidth() {
		DisplayMetrics dpMetrics = new DisplayMetrics();
		getWindow().getWindowManager().getDefaultDisplay().getMetrics(dpMetrics);
		screenWidth = dpMetrics.widthPixels;
		LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) mTabLineIv.getLayoutParams();

		// lp.width = screenWidth / 3;
		lp.width = (screenWidth - 50 * 4) / 2;
		mTabLineIv.setLayoutParams(lp);
	}

	/**
	 * 重置颜色
	 */
	private void resetTextView() {
		mProcessChatTv.setTextColor(getResources().getColor(R.color.nomal));
		mHistoryTv.setTextColor(getResources().getColor(R.color.nomal));
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.id_tab_progress_ll:
			mPageVp.setCurrentItem(0);
			break;
		case R.id.id_tab_history_ll:
			mPageVp.setCurrentItem(1);
			break;
		case R.id.consume_ll_exit:
			finish();
			break;
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			finish();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

}
