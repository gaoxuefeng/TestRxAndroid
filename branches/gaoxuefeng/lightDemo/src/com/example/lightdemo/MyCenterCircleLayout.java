package com.example.lightdemo;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.util.AttributeSet;
import android.util.Log;
import android.view.GestureDetector;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

/**
 * 扇形 进来后先执行initView(); 在执行onLayout 再执行onDraw();
 * 
 * @author dddd
 * 
 */
public class MyCenterCircleLayout extends ViewGroup {
	private GestureDetector mGestureDetector;
	// 第一个child的角度
	private float angle = 0;
	private float firstChildPos = 0;
	// 是否滑到指定位置的中间
	private boolean rotateToCenter = true;
	// 是否正在旋转
	private boolean isRotating;
	// 是否允许旋转,按下后触发
	private boolean allowRotating;
	// 背景图片
	private Bitmap imageOriginal, imageScaled;
	private Matrix matrix;
	private int circleHeight;
	private int circleWidth;
	private int radius = 0;// 半径
	private int childWidth;
	private int childHeight;
	private float angleDelay = 0;// 每一个子布局的角度
	private double[] startPosition;
	private double[] downPosition;
	private boolean isMove = false;
	private double vX;
	private int selectedPosition;
	private int selected;
	private OnItemSelectedListener mOnItemSelectedListener;

	public MyCenterCircleLayout(Context context) {
		this(context, null);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	public MyCenterCircleLayout(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}

	/**
	 * @param context
	 * @param attrs
	 * @param defStyle
	 */
	public MyCenterCircleLayout(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		initView(attrs);
	}

	// item切换监听
	public interface OnItemSelectedListener {
		void onItemSelected(View view, int position, long id, String name);
	}

	// item移动
	public interface OnItemMoveListener {
		void onItemMove(View view, int position, long id, String name);
	}

	public void setOnItemSelectedListener(OnItemSelectedListener onItemSelectedListener) {
		this.mOnItemSelectedListener = onItemSelectedListener;
	}

	private void initView(AttributeSet attrs) {
		// 初始化布局
		mGestureDetector = new GestureDetector(getContext(), new MyGestureListener());
		if (attrs == null) {
			return;
		}
		TypedArray typedArray = getContext().obtainStyledAttributes(attrs, R.styleable.Circle);
		angle = typedArray.getInt(R.styleable.Circle_firstChildPosition, 90);
		firstChildPos = angle;
		rotateToCenter = typedArray.getBoolean(R.styleable.Circle_rotateToCenter, true);
		isRotating = typedArray.getBoolean(R.styleable.Circle_isRotating, true);
		if (!isRotating) {
			// 如果不是移动,则移动到中间也为false
			rotateToCenter = false;
		}
		// 设置背景图片
		if (imageOriginal == null) {
			int picId = typedArray.getResourceId(R.styleable.Circle_circleBackground, -1);

			// If a background image was set as an attribute,
			// retrieve the image
			if (picId != -1) {
				imageOriginal = BitmapFactory.decodeResource(getResources(), picId);
			}
		}
		typedArray.recycle();
		// 旋转属性
		if (matrix == null) {
			matrix = new Matrix();
		} else {

			matrix.reset();
		}
		// 不在重写onDraw()方法
		setWillNotDraw(false);
	}

	@Override
	protected void onLayout(boolean changed, int l, int t, int r, int b) {
		int layoutWidth = r - l;// 宽
		int layoutHeight = b - t;// 高
		final int childCount = getChildCount();// 子布局的个数
		radius = (int) ((float) layoutWidth * 335 / 640);// 半径
		// 子布局的宽高
		childWidth = (int) (layoutWidth / 6);
		childHeight = (int) (layoutWidth / 6);
		// 子布局占的角度
		angleDelay = 360 / getChildCount();
		angle = initAngle(angle);
		for (int i = 0; i < childCount; i++) {
			final CircleImageView child = (CircleImageView) getChildAt(i);
			// 设置角度在0-360度之间,子布局的真实角度
			float childAngle = initAngle(angle + angleDelay * i);
			child.setAngle(childAngle);
			child.setPosition(i);
			// 子布局的位置
			// 左跟上
			int left = Math.round((float) (((layoutWidth / 2) - childWidth / 2) + radius * Math.cos(Math.toRadians(childAngle))));
			int top = Math.round((float) (((layoutHeight / 2) - childHeight / 2) + radius * Math.sin(Math.toRadians(childAngle))));

			child.layout(left, top, left + childWidth, top + childHeight);

		}

	}

	@Override
	protected void onDraw(Canvas canvas) {
		circleHeight = getHeight();
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
				int cy = (circleHeight - imageScaled.getHeight()) / 2;

				Canvas g = canvas;
				canvas.rotate(0, circleWidth / 2, circleHeight / 2);
				g.drawBitmap(imageScaled, cx, cy, null);

			}
		}
	}

//	@Override
//	public boolean onTouchEvent(MotionEvent event) {
//		if (isEnabled()) {
//			if (isRotating) {
//				switch (event.getAction()) {
//				case MotionEvent.ACTION_DOWN:
//					// 按下
//					allowRotating = false;
//					startPosition = new double[] { event.getX(), event.getY() };
//					downPosition = startPosition;
//					mGestureDetector.onTouchEvent(event);
//					return true;
//				case MotionEvent.ACTION_MOVE:
//					// 移动
//					// 当前的位置
//					double[] currentPosition = new double[] { event.getX(), event.getY() };
//					// 移动的坐标距离
//					double[] vPosition = { currentPosition[0] - startPosition[0], currentPosition[1] - startPosition[1] };
//					// 计算手指滑动的角度
//					double vAngle = getTouchAngle(vPosition) > 90 ? 180 - getTouchAngle(vPosition) : getTouchAngle(vPosition);
//
//					if ((startPosition == downPosition)) {
//						// 按下后第一次移动计算,如果角度小于30度则认为是在横向移动
//						if (vAngle < 30) {
//							isMove = true;
//						} else {
//							isMove = false;
//						}
//					}
//					// 是左右滑动手势
//					if (!isMove) {
//						startPosition = currentPosition;
//						return true;
//					}
//					// 开始与当前角度差,getWidth这儿应该用屏幕宽度
//					vX = currentPosition[0] - startPosition[0];
//					Log.i("x距离", vX + "");
//					rotateButtons((float) (angleDelay * (vX / getWidth())));// 移动指定的角度
//					startPosition = currentPosition;
//
//					break;
//				case MotionEvent.ACTION_UP:
//					// 按起
//					allowRotating = true;
//					for (int i = 0; i < getChildCount(); i++) {
//						CircleImageView circleView = (CircleImageView) getChildAt(i);
//						// 那个离得最近
//						if (Math.abs(circleView.getAngle() % 270) <= angleDelay / 2) {
//							selected = i;
//							selectedPosition = i;
//							break;
//						}
//
//					}
//					// 是不是来自于post
//					rotateViewToCenter((CircleImageView) getChildAt(selected), false);
//					break;
//
//				}
//				mGestureDetector.onTouchEvent(event);
//			}
//		}
//		return false;
//	}

	// 点击离开后后自己移动
	private void rotateViewToCenter(CircleImageView childSelect, boolean b) {

		// onTouch 100毫秒调一次,但是由于通常处理别的事物,要稍微慢一点
		if (rotateToCenter) {
			// 转动速度
			float velocityTemp = 1;
			// 转动角度
			float destAngle = (float) (childSelect.getAngle() % 30);
			// 开始速度

			int reverser = 1;
			if (destAngle - 15 > 0) {

				destAngle = 30 - destAngle;
				reverser = 1;// 方向.1是正方向,-1是反方向

				// 当放手时速度大于10且距离不够时继续向左滑动
				if (vX < 0 && Math.abs(vX) > 1 && isMove) {
					// 当放手时速度大于10且距离不够时继续滑动
					destAngle = 30 - destAngle;
					reverser = -1;
				}
			} else {
				destAngle = destAngle;
				// 当放手时速度大于10且距离不够时继续向右滑动
				reverser = -1;// 方向.1是正方向,-1是反方向
				if (vX > 0 && Math.abs(vX) > 1 && isMove) {
					// 当放手时速度大于10且距离不够时继续滑动
					destAngle = 30 - destAngle;
					reverser = 1;
				}
			}

			float startAngle = 0;

			if (destAngle < 0) {
				destAngle += 360;
			}

			if (destAngle > 180) {

				destAngle = 360 - destAngle;
			}

			while (startAngle < destAngle) {
				startAngle += velocityTemp / 75;
				velocityTemp *= 1.0666F;
			}
			this.post(new FlingRunnable(reverser * velocityTemp, false));
		}

	}

	// 点击离开后后自己移动,用于点击Item后
	private void rotateViewToCenter(CircleImageView childSelect) {

		// onTouch 100毫秒调一次,但是由于通常处理别的事物,要稍微慢一点
		// 转动速度
		float velocityTemp = 1;
		// 转动角度
		float destAngle = (float) (270 - childSelect.getAngle());
		int reverser = 1;
		// 开始速度
		if (destAngle >= 0) {
			reverser = 1;
		} else {
			reverser = -1;
		}

		float startAngle = 0f;

		if (destAngle < 0) {
			destAngle += 360;
		}

		if (destAngle > 180) {

			destAngle = 360 - destAngle;
		}

		while (startAngle < destAngle) {
			startAngle += velocityTemp / 75;
			velocityTemp *= 1.0666F;
		}
		// Toast.makeText(getContext(), "距离:" + destAngle + "-" + "方向:" +
		// reverser + "_" + "滑动距离:" + vX, Toast.LENGTH_SHORT).show();
		this.post(new FlingRunnable(reverser * velocityTemp, false));

	}

	/**
	 * 自由移动 A {@link Runnable} for animating the menu rotation.
	 */
	private class FlingRunnable implements Runnable {

		private float velocity;
		boolean isFirstForwarding = true;

		public FlingRunnable(float velocity) {
			this(velocity, true);
		}

		public FlingRunnable(float velocity, boolean isFirst) {
			this.velocity = velocity;
			this.isFirstForwarding = isFirst;
		}

		public void run() {
			// rotateButtons((float) vX * 360 / getChildCount() / getWidth());
			if (Math.abs(velocity) > 5 && allowRotating) {
				if (rotateToCenter) {

					// if (!(Math.abs(velocity) < 200 && (Math.abs(angle -
					// firstChildPos) % angleDelay < 2))) {
					rotateButtons(velocity / 75);
					velocity /= 1.0666F;
					MyCenterCircleLayout.this.post(this);
					// }

				} else {
					rotateButtons(velocity / 75);
					velocity /= 1.0666F;

					MyCenterCircleLayout.this.post(this);
				}
			} else {
				if (isFirstForwarding) {
					isFirstForwarding = true;
					MyCenterCircleLayout.this.rotateViewToCenter((CircleImageView) getChildAt(selected), true);
				}
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

		for (int i = 0; i < childCount; i++) {

			final CircleImageView child = (CircleImageView) getChildAt(i);
			float childAngle = angle + angleDelay * i;
			childAngle = initAngle(childAngle);
			// 设置子布局的可视范围,在这儿只设置上半部分可见
			if (350 >= childAngle && childAngle >= 190) {
				if (child.getVisibility() == GONE) {
					child.setVisibility(View.VISIBLE);
				}
				if (Math.abs(childAngle - 270) < angleDelay / 2) {
					// 选择的是这个
					selectedPosition = i;// 选择的是哪个Item
					selected = i;

					if (mOnItemSelectedListener != null && rotateToCenter) {
						mOnItemSelectedListener.onItemSelected(child, selected, child.getId(), child.getName());
					}
				}
			} else {

				if (child.getVisibility() == VISIBLE) {
					child.setVisibility(View.GONE);
				}
			}
			// 确定child的位置
			int left = Math.round((float) (((circleWidth / 2) - childWidth / 2) + radius * Math.cos(Math.toRadians(childAngle))));
			int top = Math.round((float) (((circleHeight / 2) - childHeight / 2) + radius * Math.sin(Math.toRadians(childAngle))));

			child.setAngle(childAngle);

			child.layout(left, top, left + childWidth, top + childHeight);
		}

	}

	class MyGestureListener extends SimpleOnGestureListener {
		@Override
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
			return false;

		}

		@Override
		public boolean onSingleTapUp(MotionEvent event) {
			// onClick事件,判断点击在哪个item
			int clickPostition = pointToPosition(event.getX(), event.getY());
			if (clickPostition >= 0) {
				CircleImageView clickChildView = (CircleImageView) getChildAt(clickPostition);
				if (clickChildView.getVisibility() == GONE) {
					return false;
				}
				clickChildView.setPressed(true);
				rotateViewToCenter(clickChildView);

			}
			return super.onSingleTapUp(event);

		}
	}

	/**
	 * 根据手指移动的坐标计算移动的角度
	 * 
	 * @return滑动的角度
	 */
	private double getTouchAngle(double[] vPosition) {
		double x = vPosition[0];
		double y = vPosition[1];

		double reallyResult = 0;
		switch (getQuadrant(x, y)) {
		case 1:
			reallyResult = Math.asin(y / Math.hypot(x, y)) * 180 / Math.PI;
			return Math.abs(reallyResult % 180);
		case 2:
		case 3:
			reallyResult = 180 - (Math.asin(y / Math.hypot(x, y)) * 180 / Math.PI);
			return Math.abs(reallyResult % 180);
		case 4:
			reallyResult = 360 + Math.asin(y / Math.hypot(x, y)) * 180 / Math.PI;
			return Math.abs(reallyResult % 180);
		default:
			// ignore, does not happen
			reallyResult = 0;
		}
		return Math.abs(reallyResult % 180);
	}

	/**
	 * 计算X,Y先确定在哪个象限
	 * 
	 * @1是右上角,2是右下角 3是左下角,4是左上角
	 * 
	 * @return The selected quadrant.
	 */
	private static int getQuadrant(double x, double y) {
		if (x >= 0) {
			return y >= 0 ? 1 : 4;
		} else {
			return y >= 0 ? 2 : 3;
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

	private int pointToPosition(float x, float y) {

		for (int i = 0; i < getChildCount(); i++) {

			View item = (View) getChildAt(i);
			if (item.getLeft() < x && item.getRight() > x & item.getTop() < y && item.getBottom() > y) {
				return i;
			}

		}
		return -1;
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		final int count = getChildCount();
		for (int i = 0; i < count; i++) {
			final CircleImageView child = (CircleImageView) getChildAt(i);
			float childAngle = 0;

			childAngle = child.getAngle();
			if (350 >= childAngle && childAngle >= 190) {
				if (child.getVisibility() == GONE) {
					child.setVisibility(View.VISIBLE);
				}

			} else {

				if (child.getVisibility() == VISIBLE) {
					child.setVisibility(View.GONE);
				}
			}

		}
	}
}
