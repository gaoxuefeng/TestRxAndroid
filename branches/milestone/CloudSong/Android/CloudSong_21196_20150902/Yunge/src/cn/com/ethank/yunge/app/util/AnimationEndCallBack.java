package cn.com.ethank.yunge.app.util;

import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;

public class AnimationEndCallBack {

	public static void setAnimationCallBack(Animation anim, final RefreshUiInterface refreshUiInterface) {
		anim.setAnimationListener(new AnimationListener() {

			@Override
			public void onAnimationStart(Animation arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onAnimationRepeat(Animation arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onAnimationEnd(Animation arg0) {
				// TODO Auto-generated method stub
				refreshUiInterface.refreshUi(null);
			}
		});
	}
}
