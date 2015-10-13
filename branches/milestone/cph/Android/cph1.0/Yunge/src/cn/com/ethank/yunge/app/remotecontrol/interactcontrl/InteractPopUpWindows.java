package cn.com.ethank.yunge.app.remotecontrol.interactcontrl;

import java.io.File;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationSet;
import android.view.animation.AnticipateOvershootInterpolator;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout.LayoutParams;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.util.SDCardPathUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.coyotelib.app.ui.util.UICommonUtil;

public class InteractPopUpWindows extends PopupWindow implements OnClickListener {

	private Activity context;
	private ViewGroup view;
	private float screenWidth;
	private RlItemLayout rl_text;
	private RlItemLayout rl_ducks;
	private RlItemLayout rl_photos;
	private RlItemLayout rl_emoticon;
	private Bitmap showBitMap;
	private ImageView iv_pop_bg;
	private LinearLayout ll_bottom_close;
	private View ll_selectphoto;
	private Button bt_take_photo;
	private Button bt_select_photo;
	private Button bt_dismiss;
	/**
	 * 表示选择的是相机--0
	 */
	private final int IMAGE_CAPTURE = 500;
	/**
	 * 表示选择的是相册--1
	 */
	private final int IMAGE_MEDIA = 501;

	public InteractPopUpWindows(Activity context, ViewGroup activity_interact) {
		super(activity_interact, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, true);
		this.context = context;
		this.setOutsideTouchable(true);
		this.setBackgroundDrawable(new ColorDrawable(0x00000000));
		this.view = activity_interact;
		screenWidth = UICommonUtil.getScreenWidthPixels(context);
		initView();
		initBottomView();

	}

	private void initView() {
		iv_pop_bg = (ImageView) view.findViewById(R.id.iv_pop_bg);
		rl_text = (RlItemLayout) view.findViewById(R.id.rl_text);
		rl_text.setOnClickListener(this);

		rl_ducks = (RlItemLayout) view.findViewById(R.id.rl_ducks);
		rl_ducks.setOnClickListener(this);

		rl_photos = (RlItemLayout) view.findViewById(R.id.rl_photos);
		rl_photos.setOnClickListener(this);

		rl_emoticon = (RlItemLayout) view.findViewById(R.id.rl_emoticon);
		rl_emoticon.setOnClickListener(this);

		ll_bottom_close = (LinearLayout) view.findViewById(R.id.ll_bottom_close);
		ll_bottom_close.setOnClickListener(this);

	}

	private void initBottomView() {
		ll_selectphoto = (View) view.findViewById(R.id.ll_selectphoto);
		bt_take_photo = (Button) view.findViewById(R.id.bt_take_photo);
		bt_take_photo.setOnClickListener(this);
		bt_select_photo = (Button) view.findViewById(R.id.bt_select_photo);
		bt_select_photo.setOnClickListener(this);
		bt_dismiss = (Button) view.findViewById(R.id.bt_dismiss);
		bt_dismiss.setOnClickListener(this);
	}

	private Animation createBottonAnimation(final View animView, float startX, float startY, float endX, float endY, long duration) {
		AnimationSet animationSet = new AnimationSet(true);
		TranslateAnimation translateAnimation = new TranslateAnimation(startX, endX, startY, endY);
		translateAnimation.setDuration(duration);
		AlphaAnimation alphaAnimation = new AlphaAnimation(0, 1);
		alphaAnimation.setDuration(duration);
		animationSet.addAnimation(translateAnimation);
		animationSet.addAnimation(alphaAnimation);

		animationSet.setInterpolator(new AnticipateOvershootInterpolator());
		animationSet.setAnimationListener(new AnimationListener() {

			@Override
			public void onAnimationStart(Animation animation) {
				animView.setVisibility(View.VISIBLE);
			}

			@Override
			public void onAnimationRepeat(Animation animation) {

			}

			@Override
			public void onAnimationEnd(Animation animation) {
				animation = null;
			}
		});
		return animationSet;
	}

	private Animation createCloseAnimation(final View animView, float startX, float startY, float endX, float endY, long duration) {
		AnimationSet animationSet = new AnimationSet(true);
		TranslateAnimation translateAnimation = new TranslateAnimation(startX, endX, startY, endY);
		translateAnimation.setDuration(duration);
		AlphaAnimation alphaAnimation = new AlphaAnimation(1, 0);
		alphaAnimation.setDuration(duration);
		animationSet.addAnimation(translateAnimation);
		animationSet.addAnimation(alphaAnimation);

		animationSet.setInterpolator(new AnticipateOvershootInterpolator());
		animationSet.setAnimationListener(new AnimationListener() {

			@Override
			public void onAnimationStart(Animation animation) {
				animView.setVisibility(View.VISIBLE);
			}

			@Override
			public void onAnimationRepeat(Animation animation) {

			}

			@Override
			public void onAnimationEnd(Animation animation) {
				animView.setVisibility(View.INVISIBLE);
				animation = null;
				if (animView == rl_emoticon) {
					dismiss();
				}
			}
		});
		return animationSet;
	}

	@Override
	public void showAtLocation(View parent, int gravity, int x, int y) {
		super.showAtLocation(parent, gravity, x, y);
		rl_text.setVisibility(View.INVISIBLE);
		rl_ducks.setVisibility(View.INVISIBLE);
		rl_photos.setVisibility(View.INVISIBLE);
		rl_emoticon.setVisibility(View.INVISIBLE);
		dismissBottomPop();

		new Thread() {
			public void run() {
				try {
					rl_text.setAnimation(createBottonAnimation(rl_text, screenWidth / 4, screenWidth / 4, 0, 0, 300));
					sleep(100);
					rl_ducks.setAnimation(createBottonAnimation(rl_ducks, -screenWidth / 4, screenWidth / 4, 0, 0, 300));
					sleep(100);
					rl_photos.setAnimation(createBottonAnimation(rl_photos, screenWidth / 4, -screenWidth / 4, 0, 0, 300));
					sleep(100);
					rl_emoticon.setAnimation(createBottonAnimation(rl_emoticon, -screenWidth / 4, -screenWidth / 4, 0, 0, 300));
				} catch (Exception e) {
					e.printStackTrace();
				}

			};
		}.start();
		if (showBitMap == null) {
			applyBlur(iv_pop_bg);
		}

	}

	private void dismissBottomPop() {
		if (ll_selectphoto.getVisibility() == View.VISIBLE) {
			ll_selectphoto.setVisibility(View.GONE);
		}
	}

	private void applyBlur(View showView) {
		View view = context.getWindow().getDecorView();
		view.setDrawingCacheEnabled(true);
		view.buildDrawingCache(true);
		/**
		 * 获取当前窗口快照，相当于截屏
		 */
		Bitmap bmp1 = view.getDrawingCache();
		int height = getOtherHeight();
		/**
		 * 除去状态栏和标题栏
		 */
		showBitMap = Bitmap.createBitmap(bmp1, 0, height, bmp1.getWidth(), bmp1.getHeight() - height);
		blur(showBitMap, showView);
	}

	@SuppressLint("NewApi")
	private void blur(Bitmap bkg, View view) {
		long startMs = System.currentTimeMillis();
		float scaleFactor = 4;// 图片缩放比例；
		float radius = 20;// 模糊程度
		Bitmap overlay = Bitmap.createBitmap((int) (bkg.getWidth() / scaleFactor), (int) (bkg.getHeight() / scaleFactor), Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(overlay);
		canvas.translate(-view.getLeft() / scaleFactor, -view.getTop() / scaleFactor);
		canvas.scale(1 / scaleFactor, 1 / scaleFactor);
		Paint paint = new Paint();
		paint.setFlags(Paint.FILTER_BITMAP_FLAG);
		canvas.drawBitmap(bkg, 0, 0, paint);

		overlay = FastBlur.doBlur(overlay, (int) radius, true);
		view.setBackground(new BitmapDrawable(context.getResources(), overlay));
		/**
		 * 打印高斯模糊处理时间，如果时间大约16ms，用户就能感到到卡顿，时间越长卡顿越明显，如果对模糊完图片要求不高，
		 * 可是将scaleFactor设置大一些。
		 */
		Log.i("jerome", "blur time:" + (System.currentTimeMillis() - startMs));
	}

	/**
	 * 获取系统状态栏和软件标题栏，部分软件没有标题栏，看自己软件的配置；
	 * 
	 * @return
	 */
	private int getOtherHeight() {
		Rect frame = new Rect();
		context.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
		int statusBarHeight = frame.top;
		int contentTop = context.getWindow().findViewById(Window.ID_ANDROID_CONTENT).getTop();
		int titleBarHeight = contentTop - statusBarHeight;
		return statusBarHeight + titleBarHeight;
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.rl_text:
			// 文字
			sendText();
			super.dismiss();
			break;
		case R.id.rl_ducks:
			sendDucks();
			super.dismiss();
			// 涂鸦
			break;
		case R.id.rl_photos:
			// 图片
			sendPhotos();
			break;
		case R.id.rl_emoticon:
			// 表情
			sendEmotion();
			super.dismiss();
			break;
		case R.id.ll_bottom_close:
			// 关闭
			dismiss();
			break;
		case R.id.bt_take_photo:
			// 拍照
			takePhoto();
			super.dismiss();
			break;
		case R.id.bt_select_photo:
			// 相册
			selectPhoto();
			super.dismiss();
			break;
		case R.id.bt_dismiss:
			// 消失
			dismissBottomPop();
			break;

		default:
			break;
		}

	}

	private void selectPhoto() {
		Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
		intent.setType("image/*");
		context.startActivityForResult(intent, IMAGE_MEDIA);
	}

	private void takePhoto() {
		String pictureRootFile = SDCardPathUtil.getImagePath();
		File picFile = new File(pictureRootFile, "temppic.jpg");
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(picFile));
		intent.putExtra(MediaStore.Images.Media.ORIENTATION, 0);
		context.startActivityForResult(intent, IMAGE_CAPTURE);
		dismissBottomPop();

	}

	/**
	 * 表情
	 */
	private void sendEmotion() {
		ToastUtil.show("发表情");
		Intent intent = new Intent(context, SendEmotionActivity.class);
		context.startActivity(intent);
	}

	// 图片
	private void sendPhotos() {
		ToastUtil.show("发图片");
		showBottomPop();
	}

	private void showBottomPop() {
		try {
			if (ll_selectphoto.getVisibility() == View.GONE) {
				ll_selectphoto.setVisibility(View.VISIBLE);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// 涂鸦
	private void sendDucks() {
		ToastUtil.show("发涂鸦");
		Intent intent = new Intent(context, DrawHraffitiActivity.class);
		context.startActivity(intent);
	}

	// 文字
	private void sendText() {
		ToastUtil.show("发文字");
		Intent intent = new Intent(context, SendTextActivity.class);
		context.startActivity(intent);
	}

	@Override
	public void dismiss() {

		if (ll_selectphoto.getVisibility() == View.VISIBLE) {
			ll_selectphoto.setVisibility(View.GONE);
			return;
		}
		if (rl_emoticon.getVisibility() == View.INVISIBLE) {
			super.dismiss();
		} else {
			dismissAnim();
		}

	}

	private void dismissAnim() {
		rl_text.clearAnimation();
		rl_ducks.clearAnimation();
		rl_photos.clearAnimation();
		rl_emoticon.clearAnimation();
		new Thread() {
			public void run() {
				try {

					rl_text.setAnimation(createCloseAnimation(rl_text, 0, 0, screenWidth / 4, screenWidth / 4, 300));
					sleep(100);

					rl_ducks.setAnimation(createCloseAnimation(rl_ducks, 0, 0, -screenWidth / 4, screenWidth / 4, 300));
					sleep(100);

					rl_photos.setAnimation(createCloseAnimation(rl_photos, 0, 0, screenWidth / 4, -screenWidth / 4, 300));
					sleep(100);

					rl_emoticon.setAnimation(createCloseAnimation(rl_emoticon, 0, 0, -screenWidth / 4, -screenWidth / 4, 300));
				} catch (Exception e) {
					e.printStackTrace();
				}
			};
		}.start();
	}

}
