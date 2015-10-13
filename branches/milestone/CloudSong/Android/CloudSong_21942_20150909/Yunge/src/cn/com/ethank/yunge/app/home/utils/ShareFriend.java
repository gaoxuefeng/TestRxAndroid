package cn.com.ethank.yunge.app.home.utils;

import android.app.ActionBar.LayoutParams;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.PopupWindow;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.SnsPostListener;
import com.umeng.socialize.sso.SinaSsoHandler;

public class ShareFriend {

	public static PopupWindow window;
	public static View share;

	public final static UMSocialService mController = UMServiceFactory.getUMSocialService("com.umeng.share");

	
	public static void shareQQ(Context context) {
		mController.getConfig().closeToast();
		
		mController.postShare(context, SHARE_MEDIA.QQ, new SnsPostListener() {
			@Override
			public void onStart() {
			}

			@Override
			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
				if (eCode == 200) {
					//ToastUtil.show("分享成功.");
				} else {
					String eMsg = "";
					if (eCode == -101) {
						eMsg = "没有授权";
					}
					//ToastUtil.show("分享失败 ");
				}
			}
		});

	}

	/**
	 * 分享到微信朋友圈
	 */
	public static void shareWxFriends(Context context) {

		mController.getConfig().closeToast();
		mController.postShare(context, SHARE_MEDIA.WEIXIN_CIRCLE, new SnsPostListener() {
			@Override
			public void onStart() {
			}

			@Override
			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
				if (eCode == 200) {
					//ToastUtil.show("分享成功.");
				} else {
					String eMsg = "";
					if (eCode == -101) {
						eMsg = "没有授权";
					}
					//ToastUtil.show("分享失败");
				}
			}
		});

	}

	/**
	 * 分享到微信
	 */
	public static void shareWx(Context context) {

		mController.getConfig().closeToast();
		mController.directShare(context, SHARE_MEDIA.WEIXIN, new SnsPostListener() {
			@Override
			public void onStart() {
			}

			@Override
			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
				if (eCode == 200) {
					//ToastUtil.show("分享成功.");
				} else {
					String eMsg = "";
					if (eCode == -101) {
						eMsg = "没有授权";
					}
					//ToastUtil.show("分享失败");
				}
			}
		});
//		mController.postShare(context, SHARE_MEDIA.WEIXIN, new SnsPostListener() {
//			@Override
//			public void onStart() {
//			}
//
//			@Override
//			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
//				if (eCode == 200) {
//					//ToastUtil.show("分享成功.");
//				} else {
//					String eMsg = "";
//					if (eCode == -101) {
//						eMsg = "没有授权";
//					}
//					//ToastUtil.show("分享失败");
//				}
//			}
//		});

	}

	public static void shareSina(Context context) {
		mController.getConfig().closeToast();
		// 点击分享
		// mController.openShare(this, false);
		// 参数1为Context类型对象， 参数2为要分享到的目标平台， 参数3为分享操作的回调接口
		mController.directShare(context, SHARE_MEDIA.SINA, new SnsPostListener() {
			
			@Override
			public void onStart() {
				
			}
			
			@Override
			public void onComplete(SHARE_MEDIA arg0, int eCode, SocializeEntity arg2) {
				if (eCode == 200) {
					ToastUtil.show("分享成功");
				} else {
					ToastUtil.show("分享失败");
				}
			}
		});
		
		// 设置新浪SSO handler
		mController.getConfig().setSsoHandler(new SinaSsoHandler());

	}

	public static void showPopupWindow(Context context, View view, View share) {
		int height = UICommonUtil.dip2px(context, 114);
		window = new PopupWindow(share, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		
		window.showAtLocation(view, Gravity.LEFT | Gravity.BOTTOM, 0, 0);// 在代码中出现的单位
		// window. showAsDropDown(this.findViewById(R.id.rl_bottom), 0, 0);
		TranslateAnimation translate = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f,
				Animation.RELATIVE_TO_PARENT, 1.0f, Animation.RELATIVE_TO_SELF, 0f);
		translate.setDuration(250);
		translate.setFillAfter(true);
		
		share.startAnimation(translate);
	}

}
