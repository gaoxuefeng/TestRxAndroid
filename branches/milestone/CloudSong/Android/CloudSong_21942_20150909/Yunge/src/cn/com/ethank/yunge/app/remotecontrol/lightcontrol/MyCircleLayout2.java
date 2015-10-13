package cn.com.ethank.yunge.app.remotecontrol.lightcontrol;

import com.coyotelib.app.ui.util.UICommonUtil;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import cn.com.ethank.yunge.R;

/**
 * 扇形 进来后先执行initView(); 在执行onLayout 再执行onDraw();
 * 
 * @author dddd
 * 
 */
public class MyCircleLayout2 extends ViewGroup {
	// 第一个child的角度
	private float angle = 0;
	// 是否滑到指定位置的中间
	// 是否允许旋转,按下后触发
	// 背景图片
	private Bitmap imageOriginal, imageScaled;
	private Matrix matrix;
	private int circleWidth;
	private int radius = 0;// 半径
	private int childWidth;
	private float angleDelay = 0;// 每一个子布局的角度
	private int selected;
	private OnLayoutFinishListener onLayoutFinishListener;
	private OnItemMoveListener onItemMoveListener;
	private int screenHeight;
	private int screenWidth;
	private int[] circleCenter;
	private int maginTop;

	public MyCircleLayout2(Context context) {
		this(context, null);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	public MyCircleLayout2(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}

	/**
	 * @param context
	 * @param attrs
	 * @param defStyle
	 */
	public MyCircleLayout2(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		addItem();
		setlayout();
		initView(attrs);
	}

	private void setlayout() {
		screenHeight = UICommonUtil.getScreenHeightPixels(getContext());
		screenWidth = UICommonUtil.getScreenWidthPixels(getContext());
		radius = (int) ((float) screenWidth * 335f / 640 / 2);// 半径
		// 子布局的宽高
		childWidth = (int) (screenWidth * 1f / 3);
		int currentShowChildCenterY = screenWidth / 2 - radius;
		maginTop=getShowIconCenTer()[1]-currentShowChildCenterY;
	}

	// item切换监听
	public interface OnItemSelectedListener {
		void onItemSelected(View view, int position, long id, String name);
	}

	// item移动
	public interface OnItemMoveListener {
		void onItemMove(float angle);
	}

	// 可以获取到数值
	public interface OnLayoutFinishListener {
		void onLayoutFinish();
	}

	public void setOnLayoutFinishListener(OnLayoutFinishListener onLayoutFinishListener) {
		this.onLayoutFinishListener = onLayoutFinishListener;
	}

	public void setOnItemMoveListener(OnItemMoveListener onItemMoveListener) {
		this.onItemMoveListener = onItemMoveListener;
	}

	private void initView(AttributeSet attrs) {
		// 初始化布局

		if (attrs == null) {
			return;
		}
		// 旋转属性
		if (matrix == null) {
			matrix = new Matrix();
		} else {

			matrix.reset();
		}
		// 不在重写onDraw()方法
		setWillNotDraw(false);
	}

	/**
	 * 增加子布局
	 */
	private void addItem() {

		CircleImageView2
		// 1
		circleImageView = new CircleImageView2(getContext());
		circleImageView.setName("动感");
		circleImageView.setAlpha(100f);
		circleImageView.setBackgroundResource(R.drawable.remote_dynamic_big_icon);
		this.addView(circleImageView);

		// 2
		circleImageView = new CircleImageView2(getContext());
		circleImageView.setName("浪漫");
		circleImageView.setAlpha(100f);
		circleImageView.setBackgroundResource(R.drawable.remote_romantic_big_icon);
		this.addView(circleImageView);

		// 3
		circleImageView = new CircleImageView2(getContext());
		circleImageView.setName("明亮");
		circleImageView.setAlpha(100f);
		circleImageView.setBackgroundResource(R.drawable.remote_light_big_icon);
		this.addView(circleImageView);

		// 4
		circleImageView = new CircleImageView2(getContext());
		circleImageView.setName("柔和");
		circleImageView.setAlpha(100f);
		circleImageView.setBackgroundResource(R.drawable.remote_gentle_big_icon);
		this.addView(circleImageView);

		// 5
		circleImageView = new CircleImageView2(getContext());
		circleImageView.setName("商务");
		circleImageView.setAlpha(100f);
		circleImageView.setBackgroundResource(R.drawable.remote_business_big_icon);
		this.addView(circleImageView);

		// 6
		circleImageView = new CircleImageView2(getContext());
		circleImageView.setName("抒情");
		circleImageView.setAlpha(100f);
		circleImageView.setBackgroundResource(R.drawable.remote_lyric_big_icon);
		this.addView(circleImageView);

	}

	@SuppressLint("DrawAllocation")
	@Override
	public void onLayout(boolean changed, int l, int t, int r, int b) {
		int layoutWidth = r - l;// 宽
		final int childCount = getChildCount();// 子布局的个数
		radius = (int) ((float) layoutWidth * 335 / 640 / 2);// 半径
		// 子布局的宽高
		childWidth = (int) (layoutWidth * 1 / 3);
		// 子布局占的角度
		angleDelay = 360 / getChildCount();
		angle = initAngle(angle);
		for (int i = 0; i < childCount; i++) {
			final CircleImageView2 child = (CircleImageView2) getChildAt(i);
			// 设置角度在0-360度之间,子布局的真实角度
			float childAngle = initAngle(angle + angleDelay * i);
			child.setAngle(childAngle);
			child.setPosition(i);
			// 子布局的位置
			// 左跟上
			int left = Math.round((float) (((layoutWidth / 2) - childWidth / 2) + radius * Math.cos(Math.toRadians(childAngle))));
			int top = Math.round((float) (((layoutWidth / 2) - childWidth / 2) + radius * Math.sin(Math.toRadians(childAngle))))+maginTop;

			child.layout(left, top, left + childWidth, top + childWidth);

			if (changed) {
				if (changed && childAngle > 250 & childAngle < 290) {
					// 显示动画

					ScaleAnimation scaleAnimation = new ScaleAnimation(0.0f, 1.0f, 0.0f, 1.0f, Animation.RELATIVE_TO_SELF, 0.5f,
							Animation.RELATIVE_TO_SELF, 0.5f);
					scaleAnimation.setDuration(500);
					child.setAnimation(scaleAnimation);
				}
			}
		}
		if (changed) {
			// 改变完成
			if (onLayoutFinishListener != null) {
				onLayoutFinishListener.onLayoutFinish();
			}
		}
	}

	public int[] getShowChildCenter() {
		int layoutWidth = getRight() - getLeft();// 宽
		int left = Math.round((float) (((layoutWidth / 2) - childWidth / 2) + radius * Math.cos(Math.toRadians(270))));
		int top = Math.round((float) (((layoutWidth / 2) - childWidth / 2) + radius * Math.sin(Math.toRadians(270))));
		int[] a = new int[2];
		getLocationOnScreen(a);
		return new int[] { left + childWidth / 2 + a[0], top + a[1] + childWidth / 2 };

	}

	@Override
	protected void onDraw(Canvas canvas) {
		circleWidth = getWidth();

		if (imageOriginal != null) {
			if (imageScaled == null) {
				matrix = new Matrix();
				float sx = (((radius + childWidth / 4) * 2) / (float) imageOriginal.getWidth());
				float sy = (((radius + childWidth / 4) * 2) / (float) imageOriginal.getHeight());
				matrix.postScale(sx, sy);
				imageScaled = Bitmap.createBitmap(imageOriginal, 0, 0, imageOriginal.getWidth(), imageOriginal.getHeight(), matrix, false);
			}

			if (imageScaled != null) {
				// Move the background to the center
				int cx = (circleWidth - imageScaled.getWidth()) / 2;
				int cy = (circleWidth - imageScaled.getHeight()) / 2;

				Canvas g = canvas;
				canvas.rotate(0, circleWidth / 2, circleWidth / 2);
				g.drawBitmap(imageScaled, cx, cy, null);

			}
		}
	}

	/**
	 * 传入移动指定的角度
	 * 
	 * @param moveAngle
	 */
	private void rotateButtons(float moveAngle) {
		// 移动指定的角度
		// 每个单位所占的角度angleDelay
		int childCount = getChildCount();
		angle += moveAngle;

		angle = initAngle(angle);
		if (onItemMoveListener != null) {
			onItemMoveListener.onItemMove(angle);
		}
		for (int i = 0; i < childCount; i++) {

			final CircleImageView2 child = (CircleImageView2) getChildAt(i);
			float childAngle = angle + angleDelay * i;
			childAngle = initAngle(childAngle);
			// 设置子布局的可视范围,在这儿只设置上半部分可见
			if (290 >= childAngle && childAngle >= 250) {
				// if (child.getVisibility() == GONE) {
				// child.setVisibility(View.VISIBLE);
				// }
				if (Math.abs(childAngle - 270) < angleDelay / 2) {
					// 选择的是这个
					selected = i;

				}
			} else {

				// if (child.getVisibility() == VISIBLE) {
				// child.setVisibility(View.GONE);
				// }
			}
			// 确定child的位置
			int left = Math.round((float) (((circleWidth / 2) - childWidth / 2) + radius * Math.cos(Math.toRadians(childAngle))));
			int top = Math.round((float) (((circleWidth / 2) - childWidth / 2) + radius * Math.sin(Math.toRadians(childAngle))))+maginTop;

			child.setAngle(childAngle);

			child.layout(left, top, left + childWidth, top + childWidth);
		}

	}

	/**
	 * 如果需要的角度是0-360,超出这个范围则会回到这个范围
	 * 
	 * @param angle
	 */
	float initAngle(float angle) {
		return Math.abs(angle < 0 ? (360 + angle) : angle) % 360;

	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		final int count = getChildCount();
		for (int i = 0; i < count; i++) {
			final CircleImageView2 child = (CircleImageView2) getChildAt(i);
			float childAngle = 0;

			childAngle = child.getAngle();
			if (290 >= childAngle && childAngle >= 250) {
				// if (child.getVisibility() == GONE) {
				// child.setVisibility(View.VISIBLE);
				// }

			} else {

				// if (child.getVisibility() == VISIBLE) {
				// child.setVisibility(View.GONE);
				// }
			}

		}
	}

	public CharSequence getSeledName() {
		return ((CircleImageView2) getChildAt(selected)).getName();
	}

	public void MoveFirstPosition(float aimAngle) {
		float moveAngle = aimAngle - angle;
		rotateButtons(moveAngle);
	}

	public int[] getShowIconCenTer() {
		if (circleCenter == null) {
			screenHeight = UICommonUtil.getScreenHeightPixels(getContext());
			screenWidth = UICommonUtil.getScreenWidthPixels(getContext());
			radius = (int) ((float) screenWidth * 335 / 640);// 半径
			// 子布局的宽高
			childWidth = (int) (screenWidth / 6);
			// 有Margin
			int currenttop = screenWidth / 2 - radius - childWidth / 2;
			int maginTop = 85 * screenWidth / 640 - currenttop;
			circleCenter = new int[] { screenWidth / 2, screenWidth / 2 + maginTop };
		}

		return circleCenter;
	}
}
