package cn.com.ethank.yunge.app.remotecontrol.sing;

import com.coyotelib.app.ui.util.UICommonUtil;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
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
import cn.com.ethank.yunge.R;


/**
 * 扇形 进来后先执行initView(); 在执行onLayout 再执行onDraw();
 * 
 * @author dddd
 * 
 */
public class MySingCircleLayout extends ViewGroup {
	private GestureDetector mGestureDetector;
	// 第一个child的角度
	private float angle = 0;
	// 是否滑到指定位置的中间
	private boolean rotateToCenter = true;
	// 是否正在旋转
	private boolean isRotating = true;
	// 背景图片
	private Bitmap imageOriginal, imageScaled;
	private Matrix matrix;
	private int circleWidth;
	private int radius = 0;// 半径
	private int childWidth;
	private int childHeight;
	private float angleDelay = 0;// 每一个子布局的角度
	private double[] startPosition;
	private double[] downPosition;
	private boolean isMove = false;
	private double vX;
	private int selected;
	private OnItemSelectedListener mOnItemSelectedListener;
	private OnItemMoveListener onItemMoveListener;
	private int screenHeight;
	private int screenWidth;
	private int maginTop;
	private int[] circleCenter;

	public MySingCircleLayout(Context context) {
		this(context, null);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	public MySingCircleLayout(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}

	/**
	 * @param context
	 * @param attrs
	 * @param defStyle
	 */
	public MySingCircleLayout(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		addItem();
		initLayout(context);
		initView(attrs);
	}

	@SuppressLint("WrongCall")
	private void initLayout(Context context) {
		screenHeight = UICommonUtil.getScreenHeightPixels(context);
		screenWidth = UICommonUtil.getScreenWidthPixels(context);
		radius = (int) ((float) screenWidth * 335 / 640);// 半径
		// 子布局的宽高
		childWidth = (int) (screenWidth / 6);
		// 有Margin
		int currenttop = screenWidth / 2 - radius - childWidth / 2;
		maginTop = 85 * screenWidth / 640 - currenttop;
		circleCenter = new int[] { screenWidth / 2, screenWidth / 2 + maginTop };
		this.onLayout(false, 0, 0, screenWidth, screenWidth);

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

		SingCircleImageView
		// 1
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("唱将");
		circleImageView.setImageResource(R.drawable.remote_singer_icon);
		this.addView(circleImageView);

		// 2
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("剧院");
		circleImageView.setImageResource(R.drawable.remote_theatre_icon);
		this.addView(circleImageView);

		// 3
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("卡拉OK");
		circleImageView.setImageResource(R.drawable.remote_caraok_icon);
		this.addView(circleImageView);

		// 4
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("魔音");
		circleImageView.setImageResource(R.drawable.remote_magic_icon);
		this.addView(circleImageView);

		// 5
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("演唱会");
		circleImageView.setImageResource(R.drawable.remote_concert_icon);
		this.addView(circleImageView);
		// 1
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("唱将");
		circleImageView.setImageResource(R.drawable.remote_singer_icon);
		this.addView(circleImageView);

		// 2
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("剧院");
		circleImageView.setImageResource(R.drawable.remote_theatre_icon);
		this.addView(circleImageView);

		// 3
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("卡拉OK");
		circleImageView.setImageResource(R.drawable.remote_caraok_icon);
		this.addView(circleImageView);

		// 4
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("魔音");
		circleImageView.setImageResource(R.drawable.remote_magic_icon);
		this.addView(circleImageView);

		// 5
		circleImageView = new SingCircleImageView(getContext());
		circleImageView.setName("演唱会");
		circleImageView.setImageResource(R.drawable.remote_concert_icon);
		this.addView(circleImageView);

	}

	@SuppressLint("DrawAllocation")
	@Override
	public void onLayout(boolean changed, int l, int t, int r, int b) {
		int layoutWidth = screenWidth;// 宽
		final int childCount = getChildCount();// 子布局的个数
		radius = (int) ((float) layoutWidth * 335 / 640);// 半径
		// 子布局的宽高
		childWidth = (int) (layoutWidth / 6);
		childHeight = (int) (layoutWidth / 6);
		// 子布局占的角度
		angleDelay = 360 / getChildCount();
		angle = initAngle(angle);
		for (int i = 0; i < childCount; i++) {
			final SingCircleImageView child = (SingCircleImageView) getChildAt(i);
			// 设置角度在0-360度之间,子布局的真实角度
			float childAngle = initAngle(angle + angleDelay * i);
			child.setAngle(childAngle);
			child.setPosition(i);

			// 子布局的位置
			// 左跟上
			int left = Math.round((float) (((layoutWidth / 2) - childWidth / 2) + radius * Math.cos(Math.toRadians(childAngle))));
			int top = Math.round((float) (((screenWidth / 2) - childHeight / 2) + radius * Math.sin(Math.toRadians(childAngle)))) + maginTop;

			child.layout(left, top, left + childWidth, top + childHeight);

			if (changed && childAngle > 180 & childAngle < 360) {
				float n = (childAngle - 180) / 60;
				// 显示动画
				TranslateAnimation translateAnimation = new TranslateAnimation(layoutWidth / 2 - (left + childWidth / 2), 0, getCenTer()[1] - top
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

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		if (isEnabled()) {
			if (isRotating) {
				switch (event.getAction()) {
				case MotionEvent.ACTION_DOWN:
					// 按下
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
					for (int i = 0; i < getChildCount(); i++) {
						SingCircleImageView circleView = (SingCircleImageView) getChildAt(i);
						// 那个离得最近
						if (Math.abs(circleView.getAngle() - 270) <= angleDelay) {

							if (event.getX() > downPosition[0] && circleView.getAngle() < 270) {
								// 正方向,小于270
								selected = i;
								break;
							} else if (event.getX() < downPosition[0] && circleView.getAngle() > 270) {
								// 反方向,大于270
								selected = i;
								break;
							}

						}

					}

					if (isMove) {
						rotateViewToCenter(270 - ((SingCircleImageView) getChildAt(selected)).getAngle());
					}

					break;

				}
				mGestureDetector.onTouchEvent(event);
			}
		}
		return false;
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

			final SingCircleImageView child = (SingCircleImageView) getChildAt(i);
			float childAngle = angle + angleDelay * i;
			childAngle = initAngle(childAngle);
			// 设置子布局的可视范围,在这儿只设置上半部分可见
			if (350 >= childAngle && childAngle >= 190) {
				if (child.getVisibility() == GONE) {
					child.setVisibility(View.VISIBLE);
				}
				if (child.getVisibility() == VISIBLE) {
					if (Math.abs(child.getAngle() - 270) < 5) {
						child.setAlpha(1f);
					} else {
						child.setAlpha(0.4f);
					}
				}
				if (Math.abs(childAngle - 270) < angleDelay / 2) {
					// 选择的是这个
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
			int top = Math.round((float) (((circleWidth / 2) - childHeight / 2) + radius * Math.sin(Math.toRadians(childAngle)))) + maginTop;

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

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		final int count = getChildCount();
		for (int i = 0; i < count; i++) {
			final SingCircleImageView child = (SingCircleImageView) getChildAt(i);
			float childAngle = 0;

			childAngle = child.getAngle();
			if (350 >= childAngle && childAngle >= 190) {
				if (child.getVisibility() == GONE) {
					child.setVisibility(View.VISIBLE);
				}
				if (child.getVisibility() == VISIBLE) {
					if (Math.abs(child.getAngle() - 270) < 5) {
						child.setAlpha(1f);
					} else {
						child.setAlpha(0.4f);
					}
				}

			} else {

				if (child.getVisibility() == VISIBLE) {
					child.setVisibility(View.GONE);
				}
			}

		}
	}

	public CharSequence getSeledName() {
		return ((SingCircleImageView) getChildAt(selected)).getName();
	}

	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			float arg = (Float) msg.obj;
			rotateButtons(arg);
		};
	};

	/**
	 * 初始化时设置选择第几个
	 * 
	 * @param position
	 */
	public void setSelectPosition(int position) {
		// 这是候还没有走完on
		if (getChildCount() == 0) {
			angleDelay = 360f / 10;// 12是child的个数,由于这儿还不能得出,所以放入12
			float moveAngle = 270 - angleDelay * position;
			rotateButtons(moveAngle);
		} else {
			float selectAngle = ((SingCircleImageView) getChildAt(position)).getAngle();
			rotateButtons(270 - selectAngle);
		}

	}

	public int[] getCenTer() {
		if (circleCenter == null) {
			screenHeight = UICommonUtil.getScreenHeightPixels(getContext());
			screenWidth = UICommonUtil.getScreenWidthPixels(getContext());
			radius = (int) ((float) screenWidth * 335 / 640);// 半径
			// 子布局的宽高
			childWidth = (int) (screenWidth / 6);
			// 有Margin
			int currenttop = screenWidth / 2 - radius - childWidth / 2;
			maginTop = 85 * screenWidth / 640 - currenttop;
			circleCenter = new int[] { screenWidth / 2, screenWidth / 2 + maginTop };
		}

		return circleCenter;
	}
}
