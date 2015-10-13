package cn.com.ethank.yunge.app.remotecontrol.interactcontrl;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.AnticipateOvershootInterpolator;
import android.view.animation.TranslateAnimation;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.RoomBaseActivity;

import com.coyotelib.app.ui.util.UICommonUtil;

public class InteractActivity extends RoomBaseActivity {

	private View rl_activity_layout;
	private RlItemLayout rl_text;
	private RlItemLayout rl_ducks;
	private RlItemLayout rl_photos;
	private RlItemLayout rl_emoticon;
	private float screenWidth;
	private float screenHeight;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_interact);
		screenWidth = UICommonUtil.getScreenWidthPixels(context);
		screenHeight = UICommonUtil.getScreenHeightPixels(context);
		initLayout();
		initView();
		title.setVisibility(View.GONE);

	}

	private void initView() {
		rl_text = (RlItemLayout) findViewById(R.id.rl_text);
		rl_ducks = (RlItemLayout) findViewById(R.id.rl_ducks);
		rl_photos = (RlItemLayout) findViewById(R.id.rl_photos);
		rl_emoticon = (RlItemLayout) findViewById(R.id.rl_emoticon);
		rl_text.setAnimation(createBottonAnimation(screenWidth / 4, screenWidth / 4, 0, 0, 500));
		rl_ducks.setAnimation(createBottonAnimation(-screenWidth / 4, screenWidth / 4, 0, 0, 500));
		rl_photos.setAnimation(createBottonAnimation(screenWidth / 4, -screenWidth / 4, 0, 0, 500));
		rl_emoticon.setAnimation(createBottonAnimation(-screenWidth / 4, -screenWidth / 4, 0, 0, 500));
	}

	private void initLayout() {
		rl_activity_layout = findViewById(R.id.rl_activity_layout);
		LayoutParams layoutParams = rl_activity_layout.getLayoutParams();
		layoutParams.width = UICommonUtil.getScreenWidthPixels(context);
		// layoutParams.height=UICommonUtil.getScreenHeightPixels(context);
		rl_activity_layout.setLayoutParams(layoutParams);
	}

	// 位移动画
	private static Animation createBottonAnimation(float startX, float startY, float endX, float endY, long duration) {
		AnimationSet animationSet = new AnimationSet(true);
		TranslateAnimation animation = new TranslateAnimation(startX, endX, startY, endY);
		animation.setDuration(duration);
		animationSet.addAnimation(animation);
		animation.setInterpolator(new AnticipateOvershootInterpolator());

		return animationSet;
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}

}
