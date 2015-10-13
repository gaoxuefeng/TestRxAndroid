package cn.com.ethank.yunge.app.discover.util;

import android.app.Activity;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.SnsPostListener;
import com.umeng.socialize.media.QQShareContent;
import com.umeng.socialize.media.SinaShareContent;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.sso.SinaSsoHandler;
import com.umeng.socialize.sso.UMQQSsoHandler;
import com.umeng.socialize.weixin.controller.UMWXHandler;
import com.umeng.socialize.weixin.media.CircleShareContent;
import com.umeng.socialize.weixin.media.WeiXinShareContent;

public class ShareFriendUtils {

	Activity context;
	UMSocialService mController;
	private String shopname;
	DiscoverInfo discoverInfo;

	public ShareFriendUtils(Activity context, UMSocialService mController) {
		super();
		this.context = context;
		this.mController = mController;
		shopname = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.showName);
	}

	public void setDiscoverInfo(DiscoverInfo discoverInfo) {
		this.discoverInfo = discoverInfo;
	}

	public void startShare() {
		/**
		 * 分享到新浪
		 */
		com.umeng.socialize.utils.Log.LOG = true;

		// 设置分享内容
		// mController.setShareContent("友盟社会化组件（SDK）让移动应用快速整合社交分享功能,http://www.umeng.com/social");
		// mController.setShareContent("小伙伴们,赶紧来听听"+discoverInfo.getUserNickName()+"唱的《"+discoverInfo.getMusicName()+"》吧,TA马上就要变成歌神啦！你还在等什么,赶快来挑战吧！http://www.thankyou99.com/");
		// 设置分享图片, 参数2为图片的url地址
		// mController.setShareMedia(new
		// UMImage(context,"http://www.baidu.com/img/bdlogo.png"));
		// mController.setShareMedia(new UMImage(context,R.drawable.ic_launch));

		SinaShareContent sinaShareContent = new SinaShareContent();
		sinaShareContent.setTitle(discoverInfo.getMusicName());
		sinaShareContent.setShareContent("小伙伴们,赶紧来听听@" + discoverInfo.getUserNickName() + "唱的《" + discoverInfo.getMusicName()
				+ "》吧,TA马上就要变成歌神啦！你还在等什么,赶快来挑战吧！" + discoverInfo.getShareUrl() + "?id=" + discoverInfo.getDiscoverId());
		sinaShareContent.setShareImage(new UMImage(context, R.drawable.ic_launch));
		// sinaShareContent.setTargetUrl(discoverInfo.getShareUrl()+"?id="+discoverInfo.getDiscoverId());
		mController.setShareMedia(sinaShareContent);

		/**
		 * 分享到微信
		 */
		// 6.3 添加如下集成代码
		String appID = "wx0975dfb9e6a3d9f1";
		String appSecret = "19ea70ea651daa2a0c88a9180a119ef4";
		// String appID = "wx5c07842a8d88f1ca";
		// String appSecret = "19ea70ea651daa2a0c88a9180a119ef4";
		// 添加微信平台
		UMWXHandler wxHandler = new UMWXHandler(context, appID, appSecret);
		wxHandler.addToSocialSDK();
		// 添加微信朋友圈
		UMWXHandler wxCircleHandler = new UMWXHandler(context, appID, appSecret);
		wxCircleHandler.setToCircle(true);
		wxCircleHandler.addToSocialSDK();

		// 设置微信好友分享内容
		WeiXinShareContent weixinContent = new WeiXinShareContent();
		// 设置分享文字
		// weixinContent.setShareContent("我在潮趴汇上预订了一个"+shopname+"活动,诚邀各位参与,http://www.baidu.com");
		weixinContent.setShareContent("小伙伴们,赶紧来听听@" + discoverInfo.getUserNickName() + "唱的《" + discoverInfo.getMusicName()
				+ "》吧,TA马上就要变成歌神啦！你还在等什么,赶快来挑战吧！");
		// 设置title
		weixinContent.setTitle(discoverInfo.getMusicName());
		// 设置分享内容跳转URL
		weixinContent.setTargetUrl(discoverInfo.getShareUrl() + "?id=" + discoverInfo.getDiscoverId());
		// 设置分享图片
		weixinContent.setShareImage(new UMImage(context, R.drawable.ic_launch));
		mController.setShareMedia(weixinContent);

		// 设置微信朋友圈分享内容
		CircleShareContent circleMedia = new CircleShareContent();
		// circleMedia.setShareContent("我在潮趴汇上预订了一个"+shopname+"活动,诚邀各位参与,http://www.baidu.com");
		circleMedia.setShareContent("小伙伴们,赶紧来听听@" + discoverInfo.getUserNickName() + "唱的《" + discoverInfo.getMusicName()
				+ "》吧,TA马上就要变成歌神啦！你还在等什么,赶快来挑战吧！");
		// 设置朋友圈title
		// circleMedia.setTitle("潮趴汇KTV主题活动邀请函");
		circleMedia.setTitle("小伙伴们,赶紧来听听@" + discoverInfo.getUserNickName() + "唱的《" + discoverInfo.getMusicName()
				+ "》吧,TA马上就要变成歌神啦！你还在等什么,赶快来挑战吧！");
//		circleMedia.setTitle(discoverInfo.getMusicName());
		circleMedia.setShareImage(new UMImage(context, R.drawable.ic_launch));
		circleMedia.setTargetUrl(discoverInfo.getShareUrl() + "?id=" + discoverInfo.getDiscoverId());
		mController.setShareMedia(circleMedia);

		// QQ分享
		// 参数1为当前Activity, 参数2为开发者在QQ互联申请的APP ID,参数3为开发者在QQ互联申请的APP kEY.
		UMQQSsoHandler qqSsoHandler = new UMQQSsoHandler(context, Constants.qqAppId, Constants.qqAppSecrxt);
		qqSsoHandler.addToSocialSDK();

		QQShareContent qqShareContent = new QQShareContent();
		// 设置分享文字
		// qqShareContent.setShareContent("我在潮趴汇上预订了一个"+shopname+"活动,诚邀各位参与,http://www.baidu.com");
		qqShareContent.setShareContent("小伙伴们,赶紧来听听@" + discoverInfo.getUserNickName() + "唱的《" + discoverInfo.getMusicName()
				+ "》吧,TA马上就要变成歌神啦！你还在等什么,赶快来挑战吧！");
		// 设置分享title
		// qqShareContent.setTitle("潮趴汇KTV主题活动邀请函");
		qqShareContent.setTitle(discoverInfo.getMusicName());
		// 设置分享图片
		qqShareContent.setShareImage(new UMImage(context, R.drawable.ic_launch));
		// 设置点击分享内容的跳转链接
		qqShareContent.setTargetUrl(discoverInfo.getShareUrl() + "?id=" + discoverInfo.getDiscoverId());
		// qqShareContent.setTargetUrl(discoverInfo.getShareUrl());
		mController.setShareMedia(qqShareContent);
	}

	/**
	 * 分享到微信
	 */
	public void shareWx() {
		mController.postShare(context, SHARE_MEDIA.WEIXIN, new SnsPostListener() {
			@Override
			public void onStart() {
				// ToastUtil.show("开始分享.");
			}

			@Override
			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
				if (eCode == 200) {
					// ToastUtil.show("分享成功.");

				} else {
					String eMsg = "";
					if (eCode == -101) {
						eMsg = "没有授权";
					}
					// ToastUtil.show("分享失败[" + eCode + "] " + eMsg);
				}
			}
		});
	}

	/**
	 * 分享到新浪
	 */
	public void shareSina() {
//		// 参数1为Context类型对象, 参数2为要分享到的目标平台, 参数3为分享操作的回调接口
//		mController.postShare(context, SHARE_MEDIA.SINA, new SnsPostListener() {
//			@Override
//			public void onStart() {
//				// ToastUtil.show("开始分享.");
//			}
//
//			@Override
//			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
//				if (eCode == 200) {
//					// ToastUtil.show("分享成功.");
//				} else {
//					String eMsg = "";
//					if (eCode == -101) {
//						eMsg = "没有授权";
//					}
//					// ToastUtil.show("分享失败[" + eCode + "] " + eMsg);
//				}
//			}
//		});
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

	/**
	 * 分享到微信朋友圈
	 */
	public void shareWxFriends() {
		mController.postShare(context, SHARE_MEDIA.WEIXIN_CIRCLE, new SnsPostListener() {
			@Override
			public void onStart() {
				// ToastUtil.show("开始分享.");
			}

			@Override
			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
				if (eCode == 200) {
					// ToastUtil.show("分享成功.");
				} else {
					String eMsg = "";
					if (eCode == -101) {
						eMsg = "没有授权";
					}
					// ToastUtil.show("分享失败[" + eCode + "] " + eMsg);
				}
			}
		});
	}

	/**
	 * 分享到QQ
	 */
	public void shareQQ() {
		mController.postShare(context, SHARE_MEDIA.QQ, new SnsPostListener() {
			@Override
			public void onStart() {
				// ToastUtil.show("开始分享");
			}

			@Override
			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
				if (eCode == 200) {
					// ToastUtil.show("分享成功.");
				} else {
					String eMsg = "";
					if (eCode == -101) {
						eMsg = "没有授权";
					}
					// ToastUtil.show("分享失败[" + eCode + "] " + eMsg);
				}
			}
		});
	}

}
