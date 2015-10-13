package cn.com.ethank.yunge.app.catering.utils;

import android.animation.Animator;
import android.animation.Animator.AnimatorListener;
import android.animation.Keyframe;
import android.animation.ObjectAnimator;
import android.animation.PropertyValuesHolder;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.LinearLayout;

public class MyAnim {
	private int count;
	private ObjectAnimator yxBouncer;
	private int endX;
	private int endY;
	private int startX;
	private int startY;
	private View view;

	public MyAnim(View v, int startX, int startY, int endX, int endY, long time) {
		this.view = v;
		this.startX = startX;
		this.startY = startY;
		this.endX = endX;
		this.endY = endY;
		count = Math.abs(endX - startX);

		Keyframe[] keyframesX = new Keyframe[count];
		Keyframe[] keyframesY = new Keyframe[count];
		final float keyStep = 1f / (float) count;// 每一步的距离

		int notificheight = ConstantsUtils.DisplayTopHeight + ConstantsUtils.AcitivityTitleHeight;
		for (int i = 0; i < count; i++) {
			float key = keyStep * (i + 1);
			if (startX > endX) {
				// 第二个参数不能为0
				keyframesX[i] = Keyframe.ofFloat(key, startX - i);// key是时间
				keyframesY[i] = Keyframe.ofFloat(key, getY(startX - i) - notificheight);// 后面的参数数Y轴的位置你们
			} else {
				keyframesX[i] = Keyframe.ofFloat(key, startX + i);// key是时间
				keyframesY[i] = Keyframe.ofFloat(key, getY(startX + i) - notificheight);// 后面的参数数Y轴的位置你们
			}
		}

		// 从 向像素0到keyframes
		PropertyValuesHolder pvhX = PropertyValuesHolder.ofKeyframe("translationX", keyframesX);
		PropertyValuesHolder pvhY = PropertyValuesHolder.ofKeyframe("translationY", keyframesY);

		yxBouncer = ObjectAnimator.ofPropertyValuesHolder(view, pvhY, pvhX).setDuration(time);
		// yxBouncer.setInterpolator(new BounceInterpolator());
		yxBouncer.setInterpolator(new AccelerateDecelerateInterpolator());

		yxBouncer.addListener(new AnimatorListener() {

			@Override
			public void onAnimationStart(Animator arg0) {

			}

			@Override
			public void onAnimationRepeat(Animator arg0) {
				// arg0.cancel();
			}

			@Override
			public void onAnimationEnd(Animator arg0) {
				// view.setVisibility(View.GONE);
				// contentlistadapter.setList(ConstantUtils.ADD_NOODLETYPE_LIST);
				// arg0 = null;
			}

			@Override
			public void onAnimationCancel(Animator arg0) {
				// view.setVisibility(View.INVISIBLE);
			}
		});

		// AccelerateDecelerateInterpolator 在动画开始与结束的地方速率改变比较慢，在中间的时候加速
		//
		// AccelerateInterpolator 在动画开始的地方速率改变比较慢，然后开始加速
		//
		// AnticipateInterpolator 开始的时候向后然后向前甩
		//
		// AnticipateOvershootInterpolator 开始的时候向后然后向前甩一定值后返回最后的值
		//
		// BounceInterpolator 动画结束的时候弹起
		//
		// CycleInterpolator 动画循环播放特定的次数，速率改变沿着正弦曲线
		//
		// DecelerateInterpolator 在动画开始的地方快然后慢
		//
		// LinearInterpolator 以常量速率改变
		//
		// OvershootInterpolator 向前甩一定值后再回到原来位置
	}

	public void StartAnim() {
		yxBouncer.start();
	}

	private float getY(float x) {

		return calculate(x);
	}

	/**
	 * 根据两点求抛物线
	 * 
	 * @param x
	 * @return
	 */
	private float calculate(float x) {
		final float[][] points = { { startX, startY }, { endX, endY }, { startX + (startX - endX), endY } };
		float x1 = points[0][0];
		float y1 = points[0][1];
		float x2 = points[1][0];
		float y2 = points[1][1];
		float x3 = points[2][0];
		float y3 = points[2][1];

		final float a = (y1 * (x2 - x3) + y2 * (x3 - x1) + y3 * (x1 - x2)) / (x1 * x1 * (x2 - x3) + x2 * x2 * (x3 - x1) + x3 * x3 * (x1 - x2));
		final float b = (y1 - y2) / (x1 - x2) - a * (x1 + x2);
		final float c = y1 - (x1 * x1) * a - x1 * b;

		System.out.println("-a->" + a + " b->" + b + " c->" + c);
		return (a * x * x + b * x + c);
	}

}
