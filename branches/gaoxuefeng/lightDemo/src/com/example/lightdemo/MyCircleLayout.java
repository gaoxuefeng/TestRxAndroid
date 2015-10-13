package com.example.lightdemo;

import android.content.Context;
import android.content.Intent;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.util.Log;
import android.view.GestureDetector;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AnticipateOvershootInterpolator;
import android.view.animation.TranslateAnimation;
import android.widget.Toast;

/**
 * 扇形 进来后先执行initView(); 在执行onLayout 再执行onDraw();
 * 
 * @author dddd
 * 
 */
public class MyCircleLayout extends ViewGroup {
	private GestureDetector mGestureDetector;
	// 第一个child的角度
	private float angle = 0;
	private float firstChildPos = 0;
	// 是否滑到指定位置的中间
	private boolean rotateToCenter = true;
	// 是否正在旋转
	private boolean isRotating = true;
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
	private OnItemMoveListener onItemMoveListener;

	public MyCircleLayout(Context context) {
		this(context, null);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	public MyCircleLayout(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}

	/**
	 * @param context
	 * @param attrs
	 * @param defStyle
	 */
	public MyCircleLayout(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		addItem();
		initView(attrs);
	}

	// item切换监听
	public interface OnItemSelectedListener {
		void onItemSelected(View view, int position, long id, String name);
	}

	// item移动
	public interface OnItemMoveListener {
		void onItemMove(float angle);
	}

	public void setOnItemSelectedListener(OnItemSelectedListener onItemSelectedListener) {
		this.mOnItemSelectedListener = onItemSelectedListener;
	}

	public void setOnItemMoveListener(OnItemMoveListener onItemMoveListener) {
		this.onItemMoveListener = onItemMoveListener;
	}

	private void initView(AttributeSet attrs) {
		// 初始化布局
		mGestureDetector = new GestureDetector(getContext(), new MyGestureListener());
		if (attrs == null) {
			return;
		}
		// TypedArray typedArray = getContext().obtainStyledAttributes(attrs,
		// R.styleable.Circle);
		// angle = typedArray.getInt(R.styleable.Circle_firstChildPosition, 90);
		// firstChildPos = angle;
		// rotateToCenter =
		// typedArray.getBoolean(R.styleable.Circle_rotateToCenter, true);
		// isRotating = typedArray.getBoolean(R.styleable.Circle_isRotating,
		// true);
		// if (!isRotating) {
		// // 如果不是移动,则移动到中间也为false
		// rotateToCenter = false;
		// }
		// // 设置背景图片
		// if (imageOriginal == null) {
		// int picId =
		// typedArray.getResourceId(R.styleable.Circle_circleBackground, -1);
		//
		// // If a background image was set as an attribute,
		// // retrieve the image
		// if (picId != -1) {
		// imageOriginal = BitmapFactory.decodeResource(getResources(), picId);
		// }
		// }
		// typedArray.recycle();
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

		CircleImageView
		// 1
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("动感");
		circleImageView.setImageResource(R.drawable.remote_dynamic_icon);
		this.addView(circleImageView);

		// 2
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("浪漫");
		circleImageView.setImageResource(R.drawable.remote_romantic_icon);
		this.addView(circleImageView);

		// 3
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("明亮");
		circleImageView.setImageResource(R.drawable.remote_light_icon);
		this.addView(circleImageView);

		// 4
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("柔和");
		circleImageView.setImageResource(R.drawable.remote_gentle_icon);
		this.addView(circleImageView);

		// 5
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("商务");
		circleImageView.setImageResource(R.drawable.remote_business_icon);
		this.addView(circleImageView);

		// 6
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("抒情");
		circleImageView.setImageResource(R.drawable.remote_lyric_icon);
		this.addView(circleImageView);
		// 7,8,9,10,11,12
		// 1
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("动感");
		circleImageView.setImageResource(R.drawable.remote_dynamic_icon);
		this.addView(circleImageView);

		// 2
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("浪漫");
		circleImageView.setImageResource(R.drawable.remote_romantic_icon);
		this.addView(circleImageView);

		// 3
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("明亮");
		circleImageView.setImageResource(R.drawable.remote_light_icon);
		this.addView(circleImageView);

		// 4
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("柔和");
		circleImageView.setImageResource(R.drawable.remote_gentle_icon);
		this.addView(circleImageView);

		// 5
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("商务");
		circleImageView.setImageResource(R.drawable.remote_business_icon);
		this.addView(circleImageView);

		// 6
		circleImageView = new CircleImageView(getContext());
		circleImageView.setName("抒情");
		circleImageView.setImageResource(R.drawable.remote_lyric_icon);
		this.addView(circleImageView);
		// 7,8,9,10,11,12

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
			if (changed && childAngle > 180 & childAngle < 360) {
				float n = (childAngle - 180) / 60;
				// 显示动画

				TranslateAnimation translateAnimation = new TranslateAnimation(layoutWidth / 2 - (left + childWidth / 2), 0, layoutHeight / 2 - top
						- childWidth / 2, 0);
				translateAnimation.setDuration((long) (300 + 150 * n));
				translateAnimation.setInterpolator(new AnticipateOvershootInterpolator());
				child.setAnimation(translateAnimation);
			}
		}
		if (changed) {
			rotateButtons(0);
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

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		if (isEnabled()) {
			if (isRotating) {
				switch (event.getAction()) {
				case MotionEvent.ACTION_DOWN:
					// 按下
					allowRotating = false;
					startPosition = new double[] { event.getX(), event.getY() };
					downPosition = startPosition;
					mGestureDetector.onTouchEvent(event);
					return true;
				case MotionEvent.ACTION_MOVE:
					// 移动
					// 当前的位置
					double[] currentPosition = new double[] { event.getX(), event.getY() };

					// 移动的坐标距离
					double[] vPosition = { currentPosition[0] - startPosition[0], currentPosition[1] - startPosition[1] };

					// 计算手指滑动的角度
					float vAngle = getTouchAngle(vPosition) > 90 ? 180 - getTouchAngle(vPosition) : getTouchAngle(vPosition);
					if ((startPosition == downPosition)) {
						// 按下后第一次移动计算,如果角度小于30度则认为是在横向移动
						if (vPosition[0] == 0) {
							currentPosition = startPosition;
						}

						if (vAngle < 40) {
							isMove = true;
						} else {
							isMove = false;
						}

					}

					// 是左右滑动手势
					if (!isMove) {
						startPosition = currentPosition;
						return true;
					}
					// 开始与当前角度差,getWidth这儿应该用屏幕宽度
					vX = currentPosition[0] - startPosition[0];
					Log.i("x距离", vX + "");
					rotateButtons((float) (angleDelay * (vX / getWidth())));// 移动指定的角度
					startPosition = currentPosition;

					break;
				case MotionEvent.ACTION_UP:
					// 按起
					allowRotating = true;
					for (int i = 0; i < getChildCount(); i++) {
						CircleImageView circleView = (CircleImageView) getChildAt(i);
						// 那个离得最近
						if (Math.abs(circleView.getAngle() - 270) <= angleDelay) {

							if (event.getX() > downPosition[0] && circleView.getAngle() < 270) {
								// 正方向,小于270
								selected = i;
								selectedPosition = i;
								break;
							} else if (event.getX() < downPosition[0] && circleView.getAngle() > 270) {
								// 反方向,大于270
								selected = i;
								selectedPosition = i;
								break;
							}

						}

					}
					// 是不是来自于post

					// rotateViewToCenter((CircleImageView)
					// getChildAt(selected), false);
					if (isMove) {
						rotateViewToCenter(270 - ((CircleImageView) getChildAt(selected)).getAngle());
					}

					break;

				}
				mGestureDetector.onTouchEvent(event);
			}
		}
		return false;
	}

	// 点击离开后后自己移动,是不是第一次调整
	private void rotateViewToCenter(CircleImageView childSelect, boolean b) {

		// onTouch 100毫秒调一次,但是由于通常处理别的事物,要稍微慢一点
		if (rotateToCenter) {
			// 转动速度
			float velocityTemp = 1;

			float destAngle = (float) (270 - (childSelect.getAngle()));
			// 开始速度

			int reverser = 1;
			if (destAngle > 0) {

				reverser = 1;// 方向.1是正方向,-1是反方向

				// 当放手时速度大于10且距离不够时继续向左滑动
				// if (vX < 0 && Math.abs(vX) > 1 && isMove) {
				// // 当放手时速度大于10且距离不够时继续滑动
				// destAngle = angleDelay - destAngle;
				// reverser = -1;
				// }
			} else {
				destAngle = destAngle;
				// 当放手时速度大于10且距离不够时继续向右滑动
				reverser = -1;// 方向.1是正方向,-1是反方向
				// if (vX > 0 && Math.abs(vX) > 1 && isMove) {
				// // 当放手时速度大于10且距离不够时继续滑动
				// destAngle = angleDelay - destAngle;
				// reverser = 1;
				// }
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
			this.post(new FlingRunnable(reverser * velocityTemp, b));
		}

	}

	// 点击离开后后自己移动,是不是第一次调整
	private void rotateViewToCenter(final float destAngle) {
		// 还需要转这个角度

		final int n = (int) (Math.abs(destAngle) + 0.5);

		new Thread() {
			public void run() {
				float a = 0;
				if (destAngle > 0) {
					a = 1;
				} else {
					a = -1;
				}
				for (int i = 0; i < n; i++) {
					Message msg = new Message();
					if (i == n - 1) {

						msg.obj = (Math.abs(destAngle) - n + 1) * a;
					} else {
						msg.obj = a;
					}

					handler.sendMessage(msg);
					try {
						sleep(10);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			};
		}.start();

		// // onTouch 100毫秒调一次,但是由于通常处理别的事物,要稍微慢一点
		// if (rotateToCenter) {
		// // 转动速度
		// float velocityTemp = 1;
		//
		// float destAngle = (float) (270 - (childSelect.getAngle()));
		// // 开始速度
		//
		// int reverser = 1;
		// if (destAngle > 0) {
		//
		// reverser = 1;// 方向.1是正方向,-1是反方向
		//
		// } else {
		// destAngle = destAngle;
		// // 当放手时速度大于10且距离不够时继续向右滑动
		// reverser = -1;// 方向.1是正方向,-1是反方向
		// // if (vX > 0 && Math.abs(vX) > 1 && isMove) {
		// // // 当放手时速度大于10且距离不够时继续滑动
		// // destAngle = angleDelay - destAngle;
		// // reverser = 1;
		// // }
		// }
		//
		// float startAngle = 0;
		//
		// if (destAngle < 0) {
		// destAngle += 360;
		// }
		//
		// if (destAngle > 180) {
		//
		// destAngle = 360 - destAngle;
		// }
		//
		// while (startAngle < destAngle) {
		// startAngle += velocityTemp / 75;
		// velocityTemp *= 1.0666F;
		// }
		// this.post(new FlingRunnable(reverser * velocityTemp, b));
		// }

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

			if (Math.abs(velocity) > 0 && allowRotating) {
				// 当前的距离
				if (Math.abs(velocity) < 15) {
					float dAngle = angle % angleDelay / 2;
					float myDAngle = 0f;
					if (Math.abs(dAngle) > Math.abs(angleDelay / 2 - dAngle)) {
						// 往出走
						myDAngle = Math.abs(angleDelay / 2 - dAngle);
						// rotateButtons(Math.abs(angleDelay/2 - dAngle));
					} else {
						// 往回走
						// rotateButtons(-Math.abs(dAngle));
						myDAngle = -Math.abs(dAngle);
					}
					if (Math.abs(myDAngle + velocity / 75) > Math.abs(myDAngle)) {
						rotateButtons(Math.abs(myDAngle));
						return;
					}
				}

				rotateButtons(velocity / 75);
				velocity /= 1.0666F;
				MyCircleLayout.this.post(this);

			} else {
				if (isFirstForwarding) {
					isFirstForwarding = false;
					MyCircleLayout.this.rotateViewToCenter((CircleImageView) getChildAt(selected), isFirstForwarding);
				} else {
					// 最后一次调教a
					// float dAngle =((CircleImageView)
					// getChildAt(0)).getAngle()% (angleDelay/2);
					// if (Math.abs(dAngle) > Math.abs(angleDelay/2 - dAngle)) {
					// // 往回走
					// rotateButtons(-Math.abs(dAngle-angleDelay/2));
					// } else {
					// // 往出走
					// rotateButtons(Math.abs(-dAngle));
					// }

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
		if (onItemMoveListener != null) {
			onItemMoveListener.onItemMove(angle);
		}
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
						mOnItemSelectedListener.onItemSelected(child, i, child.getId(), child.getName());
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
			return false;
			// int clickPostition = pointToPosition(event.getX(), event.getY());
			// if (clickPostition >= 0) {
			// CircleImageView clickChildView = (CircleImageView)
			// getChildAt(clickPostition);
			// if (clickChildView.getVisibility() == GONE) {
			// return false;
			// }
			// clickChildView.setPressed(true);
			// rotateViewToCenter(clickChildView);
			//
			// }
			// return super.onSingleTapUp(event);

		}
	}

	/**
	 * 根据手指移动的坐标计算移动的角度
	 * 
	 * @return滑动的角度
	 */
	private float getTouchAngle(double[] vPosition) {
		double x = vPosition[0];
		double y = vPosition[1];

		float reallyResult = 0;
		switch (getQuadrant(x, y)) {
		case 1:
			reallyResult = (float) (180f * Math.asin(y / Math.hypot(x, y)) / Math.PI);
			return Math.abs(reallyResult % 180);
		case 2:
		case 3:
			reallyResult = (float) (180f - (Math.asin(y / Math.hypot(x, y)) * 180f / Math.PI));
			return Math.abs(reallyResult % 180);
		case 4:
			reallyResult = (float) (360f + Math.asin(y / Math.hypot(x, y)) * 180f / Math.PI);
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

	public CharSequence getSeledName() {
		return ((CircleImageView) getChildAt(selected)).getName();
	}

	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			float arg = (Float) msg.obj;
			rotateButtons(arg);
		};
	};

}
