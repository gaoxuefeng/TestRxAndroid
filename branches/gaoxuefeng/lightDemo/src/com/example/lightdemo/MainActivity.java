package com.example.lightdemo;

import android.app.Activity;
import android.content.res.AssetManager;
import android.graphics.ColorFilter;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.SurfaceView;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;

import com.example.lightdemo.MyCircleLayout.OnItemMoveListener;
import com.example.lightdemo.MyCircleLayout.OnItemSelectedListener;
import com.example.lightdemo.MyCircleLayout2.OnLayoutFinishListener;

public class MainActivity extends Activity implements OnItemSelectedListener, OnItemMoveListener {
	TextView selectedTextView;
	private MyCircleLayout circleMenu;
	private int angleDelay;
	private MyCircleLayout2 circleMenu2;
	private ImageView iv_itembg;
	private int iv_bg_res = 0;
	private ImageView iv_bg;
	private LinearLayout ll_bottom;
	private Button bt_sure;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		circleMenu = (MyCircleLayout) findViewById(R.id.main_circle_layout);
		ll_bottom = (LinearLayout) findViewById(R.id.ll_bottom);
		bt_sure = (Button) findViewById(R.id.bt_sure);
		circleMenu2 = (MyCircleLayout2) findViewById(R.id.main_circle_layout2);
		iv_itembg = (ImageView) findViewById(R.id.iv_itembg);

		iv_bg = (ImageView) findViewById(R.id.iv_bg);
		circleMenu.setOnItemSelectedListener(this);
		circleMenu.setOnItemMoveListener(this);
		angleDelay = circleMenu.getChildCount();
		selectedTextView = (TextView) findViewById(R.id.main_selected_textView);
		selectedTextView.setText(circleMenu.getSeledName());
		Animation animation = createItemDisapperAnimation(200);// 放大动画
		iv_itembg.setAnimation(animation);
		ll_bottom.setAnimation(createBottonAnimation());

		circleMenu2.setOnLayoutFinishListener(new OnLayoutFinishListener() {

			@Override
			public void onLayoutFinish() {
				// 可以得到边框数值

				int[] menu2Center = circleMenu2.getShowChildCenter();
				View group = (View) iv_itembg.getParent();
				// group.getLocationInWindow(location)
				int maginTop = menu2Center[1] - iv_itembg.getWidth() / 2;
				int[] b = new int[2];
				iv_itembg.getLocationOnScreen(b);
				LayoutParams layoutParams = (LayoutParams) iv_itembg.getLayoutParams();
				layoutParams.setMargins(0, maginTop - b[1], 0, 0);
				layoutParams.height = iv_itembg.getWidth();
				iv_itembg.setLayoutParams(layoutParams);
			}
		});

	}

	@Override
	public void onItemSelected(View view, final int position, long id, String name) {
		selectedTextView.setText(name);
		iv_bg.getDrawable().setLevel(position % 6);
		iv_itembg.getDrawable().setLevel(position % 6);
		bt_sure.getBackground().setLevel(position % 6);

	}

	

	@Override
	public void onItemMove(float firstAngle) {
		// 第一个父item的角度
		float a = ((270 - firstAngle < 0) ? (630 - firstAngle) : (270 - firstAngle) % 180) * 2;
		float first2Angle = 270 - a < 0 ? 630 - a : 270 - a;
		circleMenu2.MoveFirstPosition(first2Angle);

		// setBackGround(first2Angle);

		// 设置背景的透明度变化
	}

	// 放大缩小动画
	private static Animation createItemDisapperAnimation(final long duration) {
		AnimationSet animationSet = new AnimationSet(true);
		// ScaleAnimation scaleAnimation=new ScaleAnimation(context, attrs)
		animationSet.addAnimation(new ScaleAnimation(0.0f, 1.0f, 0.0f, 1.0f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f));
		// 可见不可见
		// animationSet.addAnimation(new AlphaAnimation(1.0f, 0.0f));

		animationSet.setDuration(duration);
		animationSet.setInterpolator(new DecelerateInterpolator());
		animationSet.setFillAfter(true);

		return animationSet;
	}

	// 放大缩小动画
	private static Animation createBottonAnimation() {
		AnimationSet animationSet = new AnimationSet(true);
		TranslateAnimation animation = new TranslateAnimation(0, 0, 500, 500);
		animation.setDuration(1000);
		animationSet.addAnimation(animation);
		TranslateAnimation animation2 = new TranslateAnimation(0, 0, 300, 0);
		animation2.setDuration(500);
		animationSet.addAnimation(animation2);

		return animationSet;
	}

}
