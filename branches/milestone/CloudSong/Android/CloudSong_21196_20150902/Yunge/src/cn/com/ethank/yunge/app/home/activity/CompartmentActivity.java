package cn.com.ethank.yunge.app.home.activity;

import android.app.ActionBar.LayoutParams;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.activity.MenuActivity;
import cn.com.ethank.yunge.app.home.bean.OrderInfo;
import cn.com.ethank.yunge.app.home.utils.RingView;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.jpush.android.data.p;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.lidroid.xutils.ViewUtils;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.SnsPostListener;
import com.umeng.socialize.media.QQShareContent;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.sso.SinaSsoHandler;
import com.umeng.socialize.sso.UMQQSsoHandler;
import com.umeng.socialize.weixin.controller.UMWXHandler;
import com.umeng.socialize.weixin.media.CircleShareContent;
import com.umeng.socialize.weixin.media.WeiXinShareContent;

/** 包房页面 */
public class CompartmentActivity extends BaseActivity implements OnClickListener {

	private PopupWindow window;

	private TextView head_tv_right, head_tv_left, head_tv_title;

	private View success;

	private LinearLayout compart_ll_parent;

	private Button success_but; // --确定按钮--

	private RelativeLayout compartment_head;

	private View share;

	private ImageView pre_iv_weibo;

	private ImageView pre_iv_wechat;

	private ImageView pre_iv_qq;

	private ImageView pre_iv_friends;

	final UMSocialService mController = UMServiceFactory.getUMSocialService("com.umeng.share");

	private ListView id_compart_vp;

	private MyAdpater adpater;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_compartment);
		BaseApplication.getInstance().cacheActivityList.add(this);

		findById();
		shareInfo();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			this.finish();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	private void shareInfo() {

		// 分享到微信
		// 6.3 添加如下集成代码
		String appID = "wx5c07842a8d88f1ca";
		String appSecret = "c1ef7c51c2e650d4acaec0b0b8a35a1e";
		// 添加微信平台
		UMWXHandler wxHandler = new UMWXHandler(this, appID, appSecret);
		wxHandler.addToSocialSDK();
		// 添加微信朋友圈
		UMWXHandler wxCircleHandler = new UMWXHandler(this, appID, appSecret);
		wxCircleHandler.setToCircle(true);
		wxCircleHandler.addToSocialSDK();

		// 设置微信好友分享内容
		WeiXinShareContent weixinContent = new WeiXinShareContent();
		// 设置分享文字
		weixinContent.setShareContent("我在云歌上预订了一个K歌活动,诚邀各位参与!");
		// 设置title
		weixinContent.setTitle("云歌K歌主题活动邀请函");
		// 设置分享内容跳转URL
		weixinContent.setTargetUrl("http://yunge.com/16253");
		// 设置分享图片
		weixinContent.setShareImage(new UMImage(getApplicationContext(), R.drawable.mine_default_avatar_female));
		mController.setShareMedia(weixinContent);

		// 设置微信朋友圈分享内容
		CircleShareContent circleMedia = new CircleShareContent();
		circleMedia.setShareContent("我在云歌上预订了一个K歌活动,诚邀各位参与！");
		// 设置朋友圈title
		circleMedia.setTitle("云歌K歌主题活动邀请函");
		circleMedia.setShareImage(new UMImage(getApplicationContext(), R.drawable.mine_default_avatar_female));
		circleMedia.setTargetUrl("http://yunge.com/16253");
		mController.setShareMedia(circleMedia);

		// QQ分享
		// 参数1为当前Activity， 参数2为开发者在QQ互联申请的APP ID，参数3为开发者在QQ互联申请的APP kEY.
		UMQQSsoHandler qqSsoHandler = new UMQQSsoHandler(this, "1104563078", "M9mZnpH8RuxYn3uD");
		qqSsoHandler.addToSocialSDK();

		QQShareContent qqShareContent = new QQShareContent();
		// 设置分享文字
		qqShareContent.setShareContent("我在云歌上预订了一个K歌活动,诚邀各位参与！");
		// 设置分享title
		qqShareContent.setTitle("云歌K歌主题活动邀请函");
		// 设置分享图片
		qqShareContent.setShareImage(new UMImage(this, R.drawable.mine_default_avatar_female));
		// 设置点击分享内容的跳转链接
		qqShareContent.setTargetUrl("http://yunge.com/16253");
		mController.setShareMedia(qqShareContent);

	}

	private void shareQQ() {
		mController.postShare(getApplicationContext(), SHARE_MEDIA.QQ, new SnsPostListener() {
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
	 * 分享到微信朋友圈
	 */
	private void shareWxFriends() {

		mController.postShare(this, SHARE_MEDIA.WEIXIN_CIRCLE, new SnsPostListener() {
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
	 * 分享到微信
	 */
	private void shareWx() {

		mController.postShare(this, SHARE_MEDIA.WEIXIN, new SnsPostListener() {
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

	private void shareSina() {
		// 点击分享
		// mController.openShare(this, false);
		// 参数1为Context类型对象， 参数2为要分享到的目标平台， 参数3为分享操作的回调接口
		mController.postShare(this, SHARE_MEDIA.SINA, new SnsPostListener() {
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

		// 设置新浪SSO handler
		mController.getConfig().setSsoHandler(new SinaSsoHandler());

	}

	private void findById() {
		success = View.inflate(getApplicationContext(), R.layout.pop_reserve_success, null);

		share = View.inflate(getApplicationContext(), R.layout.layout_pre_share, null);

		compart_ll_parent = (LinearLayout) this.findViewById(R.id.compart_ll_parent);

		success_but = (Button) success.findViewById(R.id.success_but);
		success_but.setOnClickListener(this);

		head_tv_title = (TextView) this.findViewById(R.id.head_tv_title);
		String result = SharePreferencesUtil.getStringData("orderInfo");
		if (TextUtils.isEmpty(result)) {
			head_tv_title.setText("A808");
		} else {
			// OrderInfo orderInfo = JSON.parseObject(result, OrderInfo.class);
			head_tv_title.setText("A809");

		}

		// --时间轴的listview--
		id_compart_vp = (ListView) this.findViewById(R.id.id_compart_vp);
		if (adpater == null) {
			adpater = new MyAdpater();
		}
		id_compart_vp.setAdapter(adpater);

		// --头部--
		compartment_head = (RelativeLayout) this.findViewById(R.id.compartment_head);
		compartment_head.setOnClickListener(this);

		// --退出按钮--
		head_tv_left = (TextView) this.findViewById(R.id.head_tv_left);
		head_tv_left.setText("返回");
		head_tv_left.setOnClickListener(this);

		// --邀请好友--
		head_tv_right = (TextView) this.findViewById(R.id.head_tv_right);
		head_tv_right.setText("邀请好友");
		head_tv_right.setOnClickListener(this);

		String box = getIntent().getStringExtra("myBox");
		if (TextUtils.isEmpty(box)) {

			compart_ll_parent.post(new Runnable() {
				@Override
				public void run() {
					showBoxType();
				}
			});

		}

	}

	class MyAdpater extends BaseAdapter {
		@Override
		public int getCount() {
			return 5;
		}

		@Override
		public Object getItem(int position) {
			return null;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View view = View.inflate(getApplicationContext(), R.layout.item_friend, null);

			TextView tv2 = (TextView) view.findViewById(R.id.tv2);
			TextView tv3 = (TextView) view.findViewById(R.id.tv3);

			View view2 = view.findViewById(R.id.view2);
			if (position == 0) {
				tv2.setBackgroundColor(getResources().getColor(R.color.transparent));
				tv3.setVisibility(View.VISIBLE);
				tv3.setText("唱歌");
				tv3.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent intent = new Intent(getApplicationContext(), MainTabActivity.class);
						intent.setType(MainTabActivity.TAB_RESERVE);
						startActivity(intent);

					}
				});
			} else if (position == 1) {
				tv3.setVisibility(View.VISIBLE);
				tv3.setText("超市");
				tv3.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent intent = new Intent(getApplicationContext(), MenuActivity.class);
						startActivity(intent);
					}
				});
			}

			if (position == 4) {
				view2.setVisibility(View.GONE);

			}
			return view;
		}

	}

	/**
	 * 弹出房间类型的popupwindow
	 */
	private void showBoxType() {
		int width = UICommonUtil.dip2px(getApplicationContext(), 300);
		int height = UICommonUtil.dip2px(getApplicationContext(), 200);

		window = new PopupWindow(success, width, height);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(compart_ll_parent, Gravity.CENTER, 0, 0);

	}

	private void showPopupWindow() {
		int height = UICommonUtil.dip2px(getApplicationContext(), 125);
		window = new PopupWindow(share, LayoutParams.MATCH_PARENT, height);

		// 参数1 爹是谁 挂载的对象 参数2
		int[] location = new int[2]; // 现在数据里面没有值
		// 获取到每个条目view对象的具体位置
		compart_ll_parent.getLocationInWindow(location);// 往数组里面写入 x和y两个值
		int x = location[0];
		int y = location[1];

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(true);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(compart_ll_parent, Gravity.LEFT | Gravity.BOTTOM, 0, 0);// 在代码中出现的单位
		// window. showAsDropDown(this.findViewById(R.id.rl_bottom), 0, 0);
		TranslateAnimation translate = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f,
				Animation.RELATIVE_TO_PARENT, 1.0f, Animation.RELATIVE_TO_SELF, 0f);
		translate.setDuration(250);
		translate.setFillAfter(true);
		success.startAnimation(translate);

		pre_iv_weibo = (ImageView) share.findViewById(R.id.pre_iv_weibo);
		pre_iv_weibo.setOnClickListener(this);

		pre_iv_wechat = (ImageView) share.findViewById(R.id.pre_iv_wechat);
		pre_iv_wechat.setOnClickListener(this);

		pre_iv_qq = (ImageView) share.findViewById(R.id.pre_iv_qq);
		pre_iv_qq.setOnClickListener(this);

		pre_iv_friends = (ImageView) share.findViewById(R.id.pre_iv_friends);
		pre_iv_friends.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.head_tv_right:
			// --跳转到邀请好友界面--
			showPopupWindow();
			break;
		case R.id.head_tv_title:
			finish();
			break;
		case R.id.success_but:
			// --确定按钮--
			window.dismiss();
			break;
		case R.id.compartment_head:
			// --跳转到消费详情页面--
			Intent intent = new Intent(getApplicationContext(), BoxDetailActivity.class);
			startActivity(intent);
			break;
		case R.id.pre_iv_weibo:
			Intent pre_iv_weibo = new Intent(getApplicationContext(), InviteFriendActivity.class);
			startActivity(pre_iv_weibo);
			window.dismiss();
			break;
		case R.id.pre_iv_qq:
			shareQQ();
			break;
		case R.id.pre_iv_friends:
			shareWxFriends();
			break;
		case R.id.pre_iv_wechat:
			shareWx();
			break;
		}
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
