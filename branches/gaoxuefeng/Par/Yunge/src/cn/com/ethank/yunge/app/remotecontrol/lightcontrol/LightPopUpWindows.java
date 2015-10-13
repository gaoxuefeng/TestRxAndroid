package cn.com.ethank.yunge.app.remotecontrol.lightcontrol;

import java.util.ArrayList;
import java.util.Map;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.remotecontrol.bean.ContronBean;
import cn.com.ethank.yunge.app.remotecontrol.requestnetwork.RequestLightContron;

import com.coyotelib.app.ui.util.UICommonUtil;

public class LightPopUpWindows extends PopupWindow implements MyCircleLayout.OnItemSelectedListener, MyCircleLayout.OnItemMoveListener,
		android.widget.PopupWindow.OnDismissListener, OnClickListener {
	ArrayList<ContronBean> contronBeans = new ArrayList<ContronBean>();
	private View view;
	private MyCircleLayout circleMenu;
	private LinearLayout ll_bottom;
	private Button bt_sure;
	private MyCircleLayout2 circleMenu2;
	private ImageView iv_itembg;
	private ImageView iv_bg;
	private int angleDelay;
	private TextView selectedTextView;
	private Button bt_cancel;
	private Activity context;
	private int screenWidth;

	public LightPopUpWindows(Activity context, View view) {
		super(view, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, true);
		this.context = context;
		this.setOutsideTouchable(true);
		this.setBackgroundDrawable(new ColorDrawable(0x00000000));
		this.view = view;
		initView(view);
		initContronLightType();
	}

	// 初始化
	private void initView(View popView) {
		//
		screenWidth = UICommonUtil.getScreenWidthPixels(context);
		circleMenu = (MyCircleLayout) popView.findViewById(R.id.main_circle_layout);
		ll_bottom = (LinearLayout) popView.findViewById(R.id.ll_bottom);
		bt_sure = (Button) popView.findViewById(R.id.bt_sure);
		bt_cancel = (Button) popView.findViewById(R.id.bt_cancel);
		bt_sure.setOnClickListener(this);
		bt_cancel.setOnClickListener(this);
		circleMenu2 = (MyCircleLayout2) popView.findViewById(R.id.main_circle_layout2);
		iv_itembg = (ImageView) popView.findViewById(R.id.iv_itembg);
		android.widget.RelativeLayout.LayoutParams layoutParams = (LayoutParams) iv_itembg.getLayoutParams();
		layoutParams.topMargin = circleMenu.getCenTer()[1] - screenWidth / 2;
		layoutParams.width = screenWidth;
		layoutParams.height = screenWidth;
		iv_itembg.setLayoutParams(layoutParams);
		iv_bg = (ImageView) popView.findViewById(R.id.iv_bg);
		circleMenu.setOnItemSelectedListener(this);
		circleMenu.setOnItemMoveListener(this);
		angleDelay = circleMenu.getChildCount();
		selectedTextView = (TextView) popView.findViewById(R.id.main_selected_textView);
		selectedTextView.setText(circleMenu.getSeledName());

	}

	@SuppressLint("WrongCall")
	public void showAtLocation(View parent, int gravity, int x, int y) {
		super.showAtLocation(parent, gravity, x, y);
		circleMenu.setSelectPosition(1);// 指定选择第几个
		iv_itembg.setAnimation(createItemDisapperAnimation(200));// // 放大动画
		ll_bottom.setAnimation(createBottonAnimation());
		circleMenu.onLayout(true, circleMenu.getLeft(), circleMenu.getTop(), circleMenu.getRight(), circleMenu.getBottom());
		circleMenu2.onLayout(true, circleMenu2.getLeft(), circleMenu2.getTop(), circleMenu2.getRight(), circleMenu2.getBottom());
	}

	@Override
	public void onItemMove(float firstAngle) {
		// 第一个父item的角度
		float a = ((270 - firstAngle < 0) ? (630 - firstAngle) : (270 - firstAngle) % 180) * 2;
		float first2Angle = 270 - a < 0 ? 630 - a : 270 - a;
		circleMenu2.MoveFirstPosition(first2Angle);
	}

	@Override
	public void onItemSelected(View view, int position, long id, String name) {
		selectedTextView.setText(name);
		iv_bg.getDrawable().setLevel(position % 6);
		iv_itembg.getDrawable().setLevel(position % 6);
		bt_sure.getBackground().setLevel(position % 6);

	}

	// 放大缩小动画
	private static Animation createItemDisapperAnimation(final long duration) {
		AnimationSet animationSet = new AnimationSet(true);
		animationSet.addAnimation(new ScaleAnimation(0.0f, 1.0f, 0.0f, 1.0f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f));
		animationSet.setDuration(duration);
		animationSet.setInterpolator(new DecelerateInterpolator());
		animationSet.setFillAfter(true);
		return animationSet;
	}

	// 位移动画
	private static Animation createBottonAnimation() {
		AnimationSet animationSet = new AnimationSet(true);
		TranslateAnimation animation = new TranslateAnimation(0, 0, 500, 500);
		animation.setDuration(500);
		animationSet.addAnimation(animation);
		TranslateAnimation animation2 = new TranslateAnimation(0, 0, 150, 0);
		animation2.setDuration(500);
		animationSet.addAnimation(animation2);

		return animationSet;
	}

	public void OnDismissListener() {

	}

	@Override
	public void onDismiss() {
		if (iv_itembg != null) {
			iv_itembg.clearAnimation();
			ll_bottom.clearAnimation();
		}

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.bt_sure:
			String contronType = selectedTextView.getText().toString();
			ContronBean contronBean = null;
			if (contronType.equals("动感")) {
				contronBean = contronBeans.get(0);
			} else if (contronType.equals("浪漫")) {
				contronBean = contronBeans.get(1);
			} else if (contronType.equals("明亮")) {
				contronBean = contronBeans.get(2);
			} else if (contronType.equals("柔和")) {
				contronBean = contronBeans.get(3);
			} else if (contronType.equals("商务")) {
				contronBean = contronBeans.get(4);
			} else if (contronType.equals("抒情")) {
				contronBean = contronBeans.get(5);
			}
			RequestLightContron requestLightContron = new RequestLightContron(context, contronBean);
			requestLightContron.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {

				}

				@Override
				public void onLoaderFail() {

				}
			});
			dismiss();
			break;
		case R.id.bt_cancel:
			dismiss();
			break;

		default:
			break;
		}
	}

	void initContronLightType() {
		contronBeans.clear();
		ContronBean
		// 动感
		contronBean = new ContronBean();
		contronBean.setModeCode("FB04C0");
		contronBean.setModeName("动感）");
		contronBean.setModeBackCode("FCA4");
		contronBean.setModequeryCode("FCD4");
		contronBeans.add(contronBean);
		// 浪漫
		contronBean = new ContronBean();
		contronBean.setModeCode("FB0AC0");
		contronBean.setModeName("浪漫");
		contronBean.setModeBackCode("FCAA");
		contronBean.setModequeryCode("FCDA");
		contronBeans.add(contronBean);
		// 明亮
		contronBean = new ContronBean();
		contronBean.setModeCode("FB06C0");
		contronBean.setModeName("（明亮");
		contronBean.setModeBackCode("FCA6");
		contronBean.setModequeryCode("FCD6");
		contronBeans.add(contronBean);
		// 柔和
		contronBean = new ContronBean();
		contronBean.setModeCode("FB08C0");
		contronBean.setModeName("柔和");
		contronBean.setModeBackCode("FCA8");
		contronBean.setModequeryCode("FCD8");
		contronBeans.add(contronBean);
		// 商务
		contronBean = new ContronBean();
		contronBean.setModeCode("FB05C0");
		contronBean.setModeName("商务");
		contronBean.setModeBackCode("FCA5");
		contronBean.setModequeryCode("FCD5");
		contronBeans.add(contronBean);
		// 抒情
		contronBean = new ContronBean();
		contronBean.setModeCode("FB02C0");
		contronBean.setModeName("抒情");
		contronBean.setModeBackCode("FCA2");
		contronBean.setModequeryCode("FCD2");
		contronBeans.add(contronBean);
	}
}
