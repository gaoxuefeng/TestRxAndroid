package cn.com.ethank.yunge.app.manoeuvre;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout.LayoutParams;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.utils.ShareFriend;
import cn.com.ethank.yunge.app.util.Constants;

import com.umeng.socialize.media.QQShareContent;
import com.umeng.socialize.media.SinaShareContent;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.sso.UMQQSsoHandler;
import com.umeng.socialize.weixin.controller.UMWXHandler;
import com.umeng.socialize.weixin.media.CircleShareContent;
import com.umeng.socialize.weixin.media.WeiXinShareContent;

public class SharePopUpWindow extends PopupWindow implements OnClickListener {

	private Context context;
	private View view;
	private View iv_share_pop_bg;
	private ImageView pre_iv_weibo;
	private ImageView pre_iv_wechat;
	private ImageView pre_iv_qq;
	private ImageView pre_iv_friends;
	private View ll_pre_wechat;
	private View ll_pre_QQ;
	private View ll_pre_cricle;

	public SharePopUpWindow(Context context, View view) {
		super(view, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, true);
		this.context = context;
		this.view = view;
		this.setOutsideTouchable(true);
		this.setBackgroundDrawable(new ColorDrawable(0x00000000));
		initView();
		inithareInfo(new ShareBean());
	}

	private void initView() {
		// 背景
		ll_pre_wechat = view.findViewById(R.id.ll_pre_wechat);
		ll_pre_QQ = view.findViewById(R.id.ll_pre_QQ);
		ll_pre_cricle = view.findViewById(R.id.ll_pre_cricle);
		iv_share_pop_bg = view.findViewById(R.id.iv_share_pop_bg);
		iv_share_pop_bg.setOnClickListener(this);
		pre_iv_weibo = (ImageView) view.findViewById(R.id.pre_iv_weibo);
		pre_iv_weibo.setOnClickListener(this);

		pre_iv_wechat = (ImageView) view.findViewById(R.id.pre_iv_wechat);
		pre_iv_wechat.setOnClickListener(this);

		pre_iv_qq = (ImageView) view.findViewById(R.id.pre_iv_qq);
		pre_iv_qq.setOnClickListener(this);

		pre_iv_friends = (ImageView) view.findViewById(R.id.pre_iv_friends);
		pre_iv_friends.setOnClickListener(this);
	}

	public void showAtLocation(View parent, ShareBean shareBean) {
		super.showAtLocation(parent, Gravity.TOP, 0, 0);
		inithareInfo(shareBean);
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.iv_share_pop_bg:
			dismiss();
			break;
		case R.id.pre_iv_weibo:
			ShareFriend.shareSina(context);
			dismiss();
			break;
		case R.id.pre_iv_qq:
			ShareFriend.shareQQ(context);
			dismiss();
			break;
		case R.id.pre_iv_friends:
			ShareFriend.shareWxFriends(context);
			dismiss();
			break;
		case R.id.pre_iv_wechat:
			ShareFriend.shareWx(context);
			dismiss();
			break;

		default:
			break;
		}

	}

	/**
	 * 判断第三方分享是否存在
	 * 
	 * @param context
	 * @param packageName
	 * @return
	 */
	private boolean isAvilible(Context context, String packageName) {
		PackageManager packageManager = context.getPackageManager();
		List<ApplicationInfo> packageInfos = packageManager.getInstalledApplications(0);
		List<String> packnames = new ArrayList<String>();
		if (packageInfos != null) {

			for (int i = 0; i < packageInfos.size(); i++) {
				packnames.add(packageInfos.get(i).packageName);
			}
		}
		return packnames.contains(packageName);
	}

	private void inithareInfo(ShareBean shareBean) {

		// 分享到微信
		// 6.3 添加如下集成代码
		String appID = Constants.wxAppId;
		String appSecret = Constants.wxAppSecrxt;
		// 添加微信平台
		UMWXHandler wxHandler = new UMWXHandler(context, appID, appSecret);
		wxHandler.addToSocialSDK();
		if (wxHandler.isClientInstalled()) {
			ll_pre_cricle.setVisibility(View.VISIBLE);
			ll_pre_wechat.setVisibility(View.VISIBLE);
		} else {
			ll_pre_cricle.setVisibility(View.GONE);
			ll_pre_wechat.setVisibility(View.GONE);
		}
		// 添加微信朋友圈
		UMWXHandler wxCircleHandler = new UMWXHandler(context, appID, appSecret);
		wxCircleHandler.setToCircle(true);
		wxCircleHandler.addToSocialSDK();

		// 设置微信好友分享内容
		WeiXinShareContent weixinContent = new WeiXinShareContent();
		// 设置分享文字
		weixinContent.setShareContent(shareBean.getShareContent());
		// 设置title
		weixinContent.setTitle(shareBean.getShareTitle());
		// 设置分享内容跳转URL
		weixinContent.setTargetUrl(shareBean.getShareUrl());
		// 设置分享图片
		weixinContent.setShareImage(new UMImage(context, shareBean.getShareImageResource()));
		ShareFriend.mController.setShareMedia(weixinContent);

		// 设置微信朋友圈分享内容
		CircleShareContent circleMedia = new CircleShareContent();
		circleMedia.setShareContent(shareBean.getShareContent());
		// 设置朋友圈title
		circleMedia.setTitle(shareBean.getShareContent());
		circleMedia.setShareImage(new UMImage(context, shareBean.getShareImageResource()));
		circleMedia.setTargetUrl(shareBean.getShareUrl());
		ShareFriend.mController.setShareMedia(circleMedia);

		// QQ分享
		// 参数1为当前Activity， 参数2为开发者在QQ互联申请的APP ID，参数3为开发者在QQ互联申请的APP kEY.
		UMQQSsoHandler qqSsoHandler = new UMQQSsoHandler((Activity) context, Constants.qqAppId, Constants.qqAppSecrxt);
		qqSsoHandler.addToSocialSDK();
		if (qqSsoHandler.isClientInstalled()) {
			ll_pre_QQ.setVisibility(View.VISIBLE);
		} else {
			ll_pre_QQ.setVisibility(View.GONE);
		}
		QQShareContent qqShareContent = new QQShareContent();
		// 设置分享文字
		qqShareContent.setShareContent(shareBean.getShareContent());
		// 设置分享title
		qqShareContent.setTitle(shareBean.getShareTitle());
		// 设置分享图片
		qqShareContent.setShareImage(new UMImage(context, shareBean.getShareImageResource()));
		// 设置点击分享内容的跳转链接
		qqShareContent.setTargetUrl(shareBean.getShareUrl());
		ShareFriend.mController.setShareMedia(qqShareContent);
		// 新浪微博
		SinaShareContent sinaShareContent = new SinaShareContent();
		sinaShareContent.setTitle(shareBean.getShareTitle());
		sinaShareContent.setShareContent(shareBean.getShareContent() + shareBean.getShareUrl());
		sinaShareContent.setShareImage(new UMImage(context, shareBean.getShareImageResource()));
		sinaShareContent.setTargetUrl(shareBean.getShareUrl());
		ShareFriend.mController.setShareMedia(sinaShareContent);

	}
}
