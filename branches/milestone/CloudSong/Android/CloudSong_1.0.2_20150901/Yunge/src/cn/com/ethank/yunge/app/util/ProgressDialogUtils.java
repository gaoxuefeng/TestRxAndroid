package cn.com.ethank.yunge.app.util;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnKeyListener;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseApplication;

/**
 * 等待框工具类
 * 
 * @author xiangbin
 * 
 */
public class ProgressDialogUtils {
	public static Dialog mProgressDialog = null;

	// private static TimeCount timeCount = null;

	public static void show(Context context) {
		creatDialog(context);
	}

	public static void show(Context context, boolean cancelAble) {
		creatDialog(context, cancelAble);
	}

	private static void creatDialog(Context context) {
		try {
			if (mProgressDialog == null) {

				LayoutInflater inflater = LayoutInflater.from(context);
				View v = inflater.inflate(R.layout.loading_dialog, null);// 得到加载view
				FrameLayout layout = (FrameLayout) v.findViewById(R.id.dialog_view);// 加载布局
				ImageView spaceshipImage = (ImageView) v.findViewById(R.id.img);
				Animation hyperspaceJumpAnimation = AnimationUtils.loadAnimation(context, R.anim.loading_animation);
				// 使用ImageView显示动画
				spaceshipImage.startAnimation(hyperspaceJumpAnimation);
				// tipTextView.setText(msg);// 设置加载信息

				mProgressDialog = new Dialog(context, R.style.loading_dialog);// 创建自定义样式dialog
				// timeCount = new TimeCount(25000, 1000);
				mProgressDialog.setCancelable(false);// 不可以用“返回键”取消
				mProgressDialog.setContentView(layout, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT,
						LinearLayout.LayoutParams.FILL_PARENT));// 设置布局
				mProgressDialog.setOnKeyListener(new OnKeyListener() {

					@Override
					public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
						try {
							if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
								if (mProgressDialog != null && mProgressDialog.isShowing()) {
									mProgressDialog.dismiss();
									return true;
								}
							}
						} catch (Exception e) {
							e.printStackTrace();
						}

						return false;
					}
				});
			}
			mProgressDialog.show();

			// timeCount.start();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void creatDialog(Context context, boolean cancelAble) {
		try {
			if (mProgressDialog == null) {

				LayoutInflater inflater = LayoutInflater.from(context);
				View v = inflater.inflate(R.layout.loading_dialog, null);// 得到加载view
				FrameLayout layout = (FrameLayout) v.findViewById(R.id.dialog_view);// 加载布局
				ImageView spaceshipImage = (ImageView) v.findViewById(R.id.img);
				Animation hyperspaceJumpAnimation = AnimationUtils.loadAnimation(context, R.anim.loading_animation);
				// 使用ImageView显示动画
				spaceshipImage.startAnimation(hyperspaceJumpAnimation);
				// tipTextView.setText(msg);// 设置加载信息

				mProgressDialog = new Dialog(context, R.style.loading_dialog);// 创建自定义样式dialog
				// timeCount = new TimeCount(100000, 1000);//100秒
				mProgressDialog.setCancelable(false);// 不可以用“返回键”取消
				mProgressDialog.setContentView(layout, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT,
						LinearLayout.LayoutParams.FILL_PARENT));// 设置布局
				if (cancelAble) {

					mProgressDialog.setOnKeyListener(new OnKeyListener() {

						@Override
						public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
							try {
								if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
									if (mProgressDialog != null && mProgressDialog.isShowing()) {
										mProgressDialog.dismiss();
										return true;
									}
								}
							} catch (Exception e) {
								e.printStackTrace();
							}

							return false;
						}
					});
				}
			}
			mProgressDialog.show();

			// timeCount.start();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 隐藏
	 */
	public static void dismiss() {
		try {
			if (mProgressDialog != null && mProgressDialog.isShowing()) {
				mProgressDialog.dismiss();
				// timeCount.cancel();
			}
			mProgressDialog = null;
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// /* 定义一个倒计时的内部类 */
	// protected static class TimeCount extends CountDownTimer {
	// public TimeCount(long millisInFuture, long countDownInterval) {
	// super(millisInFuture, countDownInterval);// 参数依次为总时长,和计时的时间间隔
	// }
	//
	// @Override
	// public void onFinish() {
	// ProgressDialogUtils.dismiss();
	// }
	//
	// @Override
	// public void onTick(long millisUntilFinished) {
	//
	// }
	// }
	public static boolean isShowing() {
		if (mProgressDialog != null && mProgressDialog.isShowing()) {
			return true;
		}
		return false;

	}
}
