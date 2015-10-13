package cn.com.ethank.yunge.app.room;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.ActionBar.LayoutParams;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnPreDrawListener;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.LayoutAnimationController;
import android.view.animation.LinearInterpolator;
import android.view.animation.TranslateAnimation;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.activity.MenuActivity;
import cn.com.ethank.yunge.app.demandsongs.DemandSongsActivity;
import cn.com.ethank.yunge.app.home.activity.BoxDetailActivity;
import cn.com.ethank.yunge.app.home.utils.ShareFriend;
import cn.com.ethank.yunge.app.jpush.YungeJPushType;
import cn.com.ethank.yunge.app.remotecontrol.RemoteControlActivity;
import cn.com.ethank.yunge.app.remotecontrol.interactcontrl.DrawHraffitiActivity;
import cn.com.ethank.yunge.app.remotecontrol.interactcontrl.SendPictureActivity;
import cn.com.ethank.yunge.app.room.activity.MagicFaceActivity;
import cn.com.ethank.yunge.app.room.activity.RoomCodeActivity;
import cn.com.ethank.yunge.app.room.adapter.GetRoomData;
import cn.com.ethank.yunge.app.room.adapter.MyAdapter;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.room.bean.GetNewInfo;
import cn.com.ethank.yunge.app.room.bean.GetNewInfo.New;
import cn.com.ethank.yunge.app.room.request.MyTaskSendInfo;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseFragment;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.SDCardPathUtil;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.umeng.analytics.MobclickAgent;
import com.umeng.socialize.media.QQShareContent;
import com.umeng.socialize.media.SinaShareContent;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.sso.UMQQSsoHandler;
import com.umeng.socialize.weixin.controller.UMWXHandler;
import com.umeng.socialize.weixin.media.CircleShareContent;
import com.umeng.socialize.weixin.media.WeiXinShareContent;

public class RoomFragment extends BaseFragment implements OnClickListener {
	private TextView room_iv_click;
	private LinearLayout room_ll_pic;
	private ListView room_lv_info;
	private RelativeLayout rl_room_remote;
	private View share; // 分享
	private RelativeLayout room_rl_friend;

	private ImageView pre_iv_weibo, carting_iv_id, pre_iv_wechat, pre_iv_qq;

	private ImageView pre_iv_friends;
	private View fragment_room;
	private MyAdapter myAdapter;
	private RelativeLayout rl_room_demandsong;
	private View pop_photo;
	private RelativeLayout room_rl_parent;
	private TextView room_tv_photo;

	private PopupWindow window;
	List<New> news = new ArrayList<GetNewInfo.New>();

	LinearLayout ll_bottom_layout;
	ChatMessageReceive chatMessageReceive;
	/**
	 * 表示选择的是相机--0
	 */
	private final int IMAGE_CAPTURE = 0;
	/**
	 * 表示选择的是相册--1
	 */
	private final int IMAGE_MEDIA = 1;

	private LinearLayout room_ll_send;
	private EditText room_et_send;
	private InputMethodManager inputManager;
	private LinearLayout room_ll_code;
	private BoxDetail myRoom;
	private ImageView rl_iv_remote;
	private View pop_get_stating;
	private boolean hasMeasured;
	private RelativeLayout room_rl_head;
	private TextView room_tv_name;
	private TextView room_tv_picture;
	private View iv_share_pop_bg;
	private GetNewInfo.New new1;
	private TextView room_tv_face;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		fragment_room = inflater.inflate(R.layout.fragment_room, container, false);

		// initData();

		getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);

		initView(fragment_room);

		return fragment_room;
	}

	/**
	 * 根据用户选择,返回图片资源
	 */
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == -1) {
			if (requestCode == IMAGE_MEDIA) {
				if (data == null) {
					return;
				}
				if (data.getData() == null) {
				} else {
					// 获得图片的uri
					Uri uri = data.getData();
					if (uri != null) {
						String imagePath = SDCardPathUtil.getImageAbsolutePath(getActivity(), uri);
						if (imagePath == null || imagePath.isEmpty()) {
							return;
						}
						if (!SDCardPathUtil.isPhotosPath(imagePath)) {
							ToastUtil.show("请选择图片文件");
							return;
						}
						ToastUtil.show("选择照片成功");
						Intent intent = new Intent(getActivity(), SendPictureActivity.class);
						intent.putExtra("imagePath", imagePath);
						startActivity(intent);
					}
				}

			} else if (requestCode == IMAGE_CAPTURE) {// 相机
				String imagePath = Environment.getExternalStorageDirectory() + "/image.jpg";
				Intent intent = new Intent(getActivity(), SendPictureActivity.class);
				intent.putExtra("imagePath", imagePath);
				startActivity(intent);
			} else if (requestCode == 100) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("msgContent", data.getStringExtra("name"));
				map.put("msgType", "2");
				map.put("picName", "");
				map.put("reserveBoxId", Constants.getReserveBoxId());
				map.put("token", Constants.getToken());
				new MyTaskSendInfo(map, room_et_send, room_iv_click, news, myRoom).run();
			}
		}
	}

	private void initView(View view) {

		room_rl_parent = (RelativeLayout) fragment_room.findViewById(R.id.room_rl_parent);

		ll_bottom_layout = (LinearLayout) fragment_room.findViewById(R.id.ll_bottom_layout);

		room_tv_name = (TextView) fragment_room.findViewById(R.id.room_tv_name);

		room_rl_head = (RelativeLayout) fragment_room.findViewById(R.id.room_rl_head);
		room_rl_head.setOnClickListener(this);

		pop_get_stating = View.inflate(getActivity(), R.layout.pop_get_stating, null);

		// -- 魔法表情
		room_tv_face = (TextView) fragment_room.findViewById(R.id.room_tv_face);
		room_tv_face.setOnClickListener(this);

		// --- 相册图片
		room_tv_photo = (TextView) fragment_room.findViewById(R.id.room_tv_photo);
		room_tv_photo.setOnClickListener(this);

		// -- 趣味涂鸦
		room_tv_picture = (TextView) fragment_room.findViewById(R.id.room_tv_picture);
		room_tv_picture.setOnClickListener(this);

		room_ll_code = (LinearLayout) fragment_room.findViewById(R.id.room_ll_code);
		room_ll_code.setOnClickListener(this);

		DisplayMetrics metrics = new DisplayMetrics();
		getActivity().getWindowManager().getDefaultDisplay().getMetrics(metrics);
		final int widthPixels = metrics.widthPixels;
		final HorizontalScrollView hscroll = (HorizontalScrollView) fragment_room.findViewById(R.id.hscroll);
		final LinearLayout ll = (LinearLayout) fragment_room.findViewById(R.id.ll);
		ViewTreeObserver vto = ll.getViewTreeObserver();
		vto.addOnPreDrawListener(new OnPreDrawListener() {

			@Override
			public boolean onPreDraw() {
				if (!hasMeasured) {
					int llWidth = ll.getMeasuredWidth();
					float bb = (float) (llWidth - widthPixels) / widthPixels;
					hscroll.setAnimationCacheEnabled(true);
					TranslateAnimation animation = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0, Animation.RELATIVE_TO_PARENT, (float) -bb, Animation.RELATIVE_TO_PARENT, 0,
							Animation.RELATIVE_TO_PARENT, 0);
					animation.setDuration(4000);
					animation.setFillAfter(false);
					animation.setRepeatCount(-1);
					animation.setRepeatMode(Animation.REVERSE);
					LinearInterpolator lir = new LinearInterpolator();
					animation.setInterpolator(lir);
					hscroll.setLayoutAnimation(new LayoutAnimationController(animation));
					hscroll.startLayoutAnimation();
					hasMeasured = true;
				}
				return true;
			}
		});

		// --相册的popwindow
		pop_photo = View.inflate(getActivity(), R.layout.pop_photo, null);

		pop_photo.findViewById(R.id.photo_tv).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
				String fileName = "image.jpg";
				Uri imageUri = Uri.fromFile(new File(Environment.getExternalStorageDirectory(), fileName));
				// 指定照片保存路径（SD卡），image.jpg为一个临时文件，每次拍照后这个图片都会被替换
				intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
				startActivityForResult(intent, IMAGE_CAPTURE);
				window.dismiss();
			}
		});

		pop_photo.findViewById(R.id.photo_tv_alum).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
				intent.setType("image/*");
				startActivityForResult(intent, IMAGE_MEDIA);
				window.dismiss();
			}
		});

		pop_photo.findViewById(R.id.photo_cancel).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				window.dismiss();

			}
		});

		// 分享的布局
		share = View.inflate(getActivity(), R.layout.layout_pre_share, null);
		iv_share_pop_bg = share.findViewById(R.id.iv_share_pop_bg);
		iv_share_pop_bg.setOnClickListener(this);

		carting_iv_id = (ImageView) view.findViewById(R.id.carting_iv_id);
		carting_iv_id.setOnClickListener(this);

		// 点击弹出图片
		room_iv_click = (TextView) view.findViewById(R.id.room_iv_click);
		room_iv_click.setOnClickListener(this);

		// 邀请好友
		room_rl_friend = (RelativeLayout) view.findViewById(R.id.room_rl_friend);
		room_rl_friend.setOnClickListener(this);

		room_ll_pic = (LinearLayout) view.findViewById(R.id.room_ll_pic);

		room_lv_info = (ListView) view.findViewById(R.id.room_lv_info);
		if (myAdapter == null) {
			myAdapter = new MyAdapter(news, getActivity());
		}

		room_lv_info.setAdapter(myAdapter);

		room_lv_info.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				room_ll_pic.setVisibility(View.GONE);

				InputMethodManager imm = (InputMethodManager) getActivity().getSystemService(getActivity().getBaseContext().INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(room_lv_info.getWindowToken(), 0);

				return false;
			}
		});

		room_ll_send = (LinearLayout) view.findViewById(R.id.room_ll_send);
		room_ll_send.setOnClickListener(this);

		room_et_send = (EditText) view.findViewById(R.id.room_et_send);

		room_et_send.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if (s.length() > 0) {
					room_et_send.setTextColor(getResources().getColor(R.color.five_write));
					room_iv_click.setText("发送");
					room_iv_click.setTextColor(getResources().getColor(R.color.five_write));
					room_iv_click.setBackgroundResource(R.drawable.send_img);
				} else {
					room_iv_click.setText("");
					// room_et_send.setTextColor(getResources().getColor(R.color.send_write));
					room_iv_click.setBackgroundResource(R.drawable.room_add_icon);
				}
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {

			}

			@Override
			public void afterTextChanged(Editable s) {

			}
		});

		// rl_room_remote.setBackgroundResource(R.drawable.room_remote_disabled_button));

		rl_room_remote = (RelativeLayout) view.findViewById(R.id.rl_room_remote);
		rl_room_demandsong = (RelativeLayout) view.findViewById(R.id.rl_room_demandsong);
		rl_room_demandsong.setOnClickListener(this);
		rl_iv_remote = (ImageView) view.findViewById(R.id.rl_iv_remote);

		rl_room_remote.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (Constants.getReserveBoxId().equals(Constants.getScanBoxId())) {
					Intent intent = new Intent(getActivity(), RemoteControlActivity.class);
					getActivity().startActivity(intent);
					getActivity().overridePendingTransition(R.anim.anim_to_up, R.anim.without_anim_out);
				} else if (Constants.getReserveBoxId().equals(Constants.getPreBoxId()) && myRoom != null && myRoom.isStarting()) {
					Intent intent = new Intent(getActivity(), RemoteControlActivity.class);
					getActivity().startActivity(intent);
					getActivity().overridePendingTransition(R.anim.anim_to_up, R.anim.without_anim_out);
				} else {
					showStating();
				}
				MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomControl");
			}
		});
	}

	/**
	 * 弹出未到预约时间的提示
	 */
	private void showStating() {

		int width = UICommonUtil.dip2px(getActivity(), 120);
		int height = UICommonUtil.dip2px(getActivity(), 90);

		window = new PopupWindow(pop_get_stating, width, height);
		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(true);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(room_rl_parent, Gravity.CENTER, 0, 0);

	}

	private void shareInfo() {

		// 分享到微信
		// 6.3 添加如下集成代码
		String appID = "wx0975dfb9e6a3d9f1";
		String appSecret = "19ea70ea651daa2a0c88a9180a119ef4";
		// 添加微信平台
		UMWXHandler wxHandler = new UMWXHandler(getActivity(), appID, appSecret);
		wxHandler.addToSocialSDK();
		// 添加微信朋友圈
		UMWXHandler wxCircleHandler = new UMWXHandler(getActivity(), appID, appSecret);
		wxCircleHandler.setToCircle(true);
		wxCircleHandler.addToSocialSDK();

		// 设置微信好友分享内容
		WeiXinShareContent weixinContent = new WeiXinShareContent();
		// 设置分享文字
		weixinContent.setShareContent("我在潮趴汇上预订了" + myRoom.getKtvName() + "K歌活动,诚邀各位参与!");
		// 设置title
		weixinContent.setTitle("潮趴汇");
		// 设置分享内容跳转URL
		weixinContent.setTargetUrl(Constants.hostUrlCloud + "html/market/invite-ktv.html?reserveBoxId=" + myRoom.getReserveBoxId());
		// 设置分享图片
		weixinContent.setShareImage(new UMImage(getActivity(), R.drawable.ic_launch));
		ShareFriend.mController.setShareMedia(weixinContent);

		// 设置微信朋友圈分享内容
		CircleShareContent circleMedia = new CircleShareContent();
		circleMedia.setShareContent("我在潮趴汇上预订了" + myRoom.getKtvName() + "K歌活动,诚邀各位参与!");
		// 设置朋友圈title
		circleMedia.setTitle("潮趴汇");
		circleMedia.setShareImage(new UMImage(getActivity(), R.drawable.ic_launch));
		circleMedia.setTargetUrl(Constants.hostUrlCloud + "html/market/invite-ktv.html?reserveBoxId=" + myRoom.getReserveBoxId());
		ShareFriend.mController.setShareMedia(circleMedia);

		// QQ分享
		// 参数1为当前Activity， 参数2为开发者在QQ互联申请的APP ID，参数3为开发者在QQ互联申请的APP kEY.
		UMQQSsoHandler qqSsoHandler = new UMQQSsoHandler(getActivity(), "1104563078", "M9mZnpH8RuxYn3uD");
		qqSsoHandler.addToSocialSDK();

		QQShareContent qqShareContent = new QQShareContent();
		// 设置分享文字
		qqShareContent.setShareContent("我在潮趴汇上预订了" + myRoom.getKtvName() + "K歌活动,诚邀各位参与!");
		// 设置分享title
		qqShareContent.setTitle("潮趴汇"); 
		// 设置分享图片
		qqShareContent.setShareImage(new UMImage(getActivity(), R.drawable.ic_launch));
		// 设置点击分享内容的跳转链接
		qqShareContent.setTargetUrl(Constants.hostUrlCloud + "html/market/invite-ktv.html?reserveBoxId=" + myRoom.getReserveBoxId());
		ShareFriend.mController.setShareMedia(qqShareContent);

		// final UMSocialService mController =
		// UMServiceFactory.getUMSocialService("com.umeng.share");
		SinaShareContent sinaShareContent = new SinaShareContent();
		sinaShareContent.setTitle("潮趴汇");
		sinaShareContent.setShareContent("我在潮趴汇上预订了" + myRoom.getKtvName() + "K歌活动,诚邀各位参与!" + Constants.hostUrlCloud + "html/market/invite-ktv.html?" + SharePreferenceKeyUtil.reserveBoxId);
		sinaShareContent.setShareImage(new UMImage(getActivity(), R.drawable.ic_launch));
		ShareFriend.mController.setShareMedia(sinaShareContent);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.room_tv_picture:
			// 发送涂鸦
			Intent picture = new Intent(getActivity(), DrawHraffitiActivity.class);
			startActivity(picture);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomSendPainting");
			break;

		case R.id.room_et_send:
			if (myRoom != null && !myRoom.isStarting()) {
				room_iv_click.setFocusable(true);
				room_iv_click.setFocusableInTouchMode(true);
				room_iv_click.requestFocus();
				ToastUtil.show("活动未开始，该功能不可用");
				return;
			}
			room_ll_pic.setVisibility(View.GONE);
			break;
		case R.id.room_rl_head:
			Intent boxDetail = new Intent(getActivity(), BoxDetailActivity.class);
			startActivity(boxDetail);
			break;
		case R.id.room_ll_code:
			Intent code = new Intent(getActivity(), RoomCodeActivity.class);
			if (myRoom != null && myRoom.isStarting()) {
				code.putExtra("reserveBoxId", myRoom.getReserveBoxId());
				startActivity(code);
			} else {
				ToastUtil.show("房间未开始，该功能不可用");
			}
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomQrCode");
			break;
		case R.id.room_tv_face:
			// ShareFriend.showPopupWindow(getActivity(), v, face);
			// ll_bottom_layout.setVisibility(View.GONE);
			Intent magic = new Intent(getActivity(), MagicFaceActivity.class);
			startActivityForResult(magic, 100);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomSendEmoji");
			break;
		case R.id.room_tv_photo:
			showPopupWindow();
			room_ll_pic.setVisibility(View.GONE);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomSendImg");
			break;
		case R.id.room_rl_friend:

			ShareFriend.showPopupWindow(getActivity(), v, share);

			pre_iv_weibo = (ImageView) share.findViewById(R.id.pre_iv_weibo);
			pre_iv_weibo.setOnClickListener(this);
			pre_iv_qq = (ImageView) share.findViewById(R.id.pre_iv_qq);

			LinearLayout ll_pre_wechat = (LinearLayout) share.findViewById(R.id.ll_pre_wechat);
			LinearLayout ll_pre_cricle = (LinearLayout) share.findViewById(R.id.ll_pre_cricle);
			LinearLayout ll_pre_QQ = (LinearLayout) share.findViewById(R.id.ll_pre_QQ);

			boolean qq = isAvilible(getActivity(), "com.tencent.mobileqq");
			boolean mm = isAvilible(getActivity(), "com.tencent.mm");

			if (qq) {
				ll_pre_QQ.setVisibility(View.VISIBLE);
				pre_iv_qq.setVisibility(View.VISIBLE);
				pre_iv_qq.setOnClickListener(this);
			} else {
				ll_pre_QQ.setVisibility(View.GONE);
				pre_iv_qq.setVisibility(View.GONE);
			}
			// 微信
			if (mm) {

				ll_pre_wechat.setVisibility(View.VISIBLE);
				ll_pre_cricle.setVisibility(View.VISIBLE);

				pre_iv_wechat = (ImageView) share.findViewById(R.id.pre_iv_wechat);
				pre_iv_wechat.setOnClickListener(this);

				pre_iv_friends = (ImageView) share.findViewById(R.id.pre_iv_friends);
				pre_iv_friends.setOnClickListener(this);

			} else {

				ll_pre_wechat.setVisibility(View.GONE);
				ll_pre_cricle.setVisibility(View.GONE);

			}

			break;
		case R.id.room_iv_click:
			if (myRoom != null && !myRoom.isStarting()) {
				ToastUtil.show("活动未开始，该功能不可用");
				return;
			}

			if (room_iv_click.getText().length() > 0) {
				room_ll_pic.setVisibility(View.GONE);

				// TODO 发送文字
				final Map<String, String> map = new HashMap<String, String>();
				map.put("msgContent", room_et_send.getText() + "");
				map.put("msgType", "0");
				map.put("reserveBoxId", myRoom.getReserveBoxId());
				map.put("token", Constants.getToken());

				new MyTaskSendInfo(map, room_et_send, room_iv_click, news, myRoom).run();
				MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomSendText");

			} else {
				room_ll_pic.setVisibility(View.VISIBLE);
				MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomSendNoText");
			}
			inputManager = (InputMethodManager) getActivity().getSystemService(getActivity().getBaseContext().INPUT_METHOD_SERVICE);
			inputManager.hideSoftInputFromWindow(room_lv_info.getWindowToken(), 0);
			break;
		case R.id.rl_room_demandsong:
			Intent demandIntent = new Intent(getActivity(), DemandSongsActivity.class);
			startActivity(demandIntent);
			getActivity().overridePendingTransition(R.anim.anim_to_up, R.anim.without_anim_out);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomRequestSong");
			break;
		case R.id.pre_iv_weibo:
			/*
			 * Intent pre_iv_weibo = new Intent(getActivity(),
			 * InviteFriendActivity.class); pre_iv_weibo.putExtra("ktvName",
			 * myRoom.getKtvName());
			 * pre_iv_weibo.putExtra(SharePreferenceKeyUtil.reserveBoxId,
			 * myRoom.getReserveBoxId()); startActivity(pre_iv_weibo);
			 */
			boolean flag = NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected();
			if (!flag) {
				ToastUtil.show("网络状态不佳");
				return;
			}
			ShareFriend.shareSina(getActivity());
			ShareFriend.window.dismiss();
			break;
		case R.id.pre_iv_qq:
			if (!NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected()) {
				ToastUtil.show("网络状态不佳");
				return;
			}
			ShareFriend.shareQQ(getActivity());
			ShareFriend.window.dismiss();
			break;
		case R.id.pre_iv_friends:
			if (!NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected()) {
				ToastUtil.show("网络状态不佳");
				return;
			}
			ShareFriend.shareWxFriends(getActivity());
			ShareFriend.window.dismiss();
			break;
		case R.id.pre_iv_wechat:
			if (!NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected()) {
				ToastUtil.show("网络状态不佳");
				return;
			}
			ShareFriend.shareWx(getActivity());
			ShareFriend.window.dismiss();
			break;
		case R.id.carting_iv_id:
			Intent intent = new Intent(getActivity(), MenuActivity.class);
			if (myRoom != null) {
				intent.putExtra("ktvip", myRoom.getKtvIP());
				intent.putExtra("boxId", myRoom.getReserveBoxId());
				intent.putExtra("ktvname", myRoom.getKtvName());
				intent.putExtra("roomname", myRoom.getRoomName());
				startActivity(intent);
				MobclickAgent.onEvent(BaseApplication.getInstance(), "RoomSuperMarket");
			}
			break;
		case R.id.iv_share_pop_bg:
			ShareFriend.window.dismiss();
			break;
		case R.id.face_bg:
			ShareFriend.window.dismiss();
			ll_bottom_layout.setVisibility(View.VISIBLE);
			break;
		}
	}

	@Override
	public void onDestroyView() {
		super.onDestroyView();
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

	/**
	 * 弹出选择照片选择
	 */
	private void showPopupWindow() {
		window = new PopupWindow(pop_photo, LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

		// 参数1 爹是谁 挂载的对象 参数2
		int[] location = new int[2]; // 现在数据里面没有值
		// 获取到每个条目view对象的具体位置
		room_rl_parent.getLocationInWindow(location);// 往数组里面写入 x和y两个值
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
		window.showAtLocation(room_rl_parent, Gravity.LEFT | Gravity.BOTTOM, 0, 0);// 在代码中出现的单位
		// window. showAsDropDown(this.findViewById(R.id.rl_bottom), 0, 0);
		TranslateAnimation translate = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_PARENT, 1.0f, Animation.RELATIVE_TO_SELF, 0f);
		translate.setDuration(250);
		translate.setFillAfter(true);
		pop_photo.startAnimation(translate);

	}

	@Override
	public void setBind(boolean isBind) {
		// TODO Auto-generated method stub

	}

	@Override
	public void OnFragmentResume() {
		try {
			getRooms();
			registChatBroadCastReceive();
			MobclickAgent.onEvent(BaseApplication.getInstance(), "Room");

			shareInfo();

			if (myRoom != null && myRoom.isStarting()) {
				room_et_send.setClickable(true);
				room_et_send.setEnabled(true);
				room_et_send.setOnClickListener(this);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void getRooms() {

		myRoom = Constants.getBoxInfo();

		room_tv_name.setText(myRoom.getRoomName() + "(" + myRoom.getJoinCount() + ")");

		if (!TextUtils.isEmpty(Constants.getReserveBoxId()) && !TextUtils.isEmpty(Constants.getReserveBoxId()) && Constants.getReserveBoxId().equals(Constants.getScanBoxId())) {
			rl_iv_remote.setBackgroundResource(R.drawable.room_remote);
		} else if (!TextUtils.isEmpty(Constants.getReserveBoxId()) && !TextUtils.isEmpty(Constants.getReserveBoxId()) && Constants.getReserveBoxId().equals(Constants.getPreBoxId())) {
			// --预定进来的，按照时间点判断是否可以进行遥控
			if (myRoom != null && myRoom.isStarting()) {
				rl_iv_remote.setBackgroundResource(R.drawable.room_remote);

			} else {
				rl_iv_remote.setBackgroundResource(R.drawable.room_remote_disabled_button);
			}
		} else {
			rl_iv_remote.setBackgroundResource(R.drawable.room_remote_disabled_button);

		}

		room_et_send.setText("");
		room_iv_click.setBackgroundResource(R.drawable.room_add_icon);

		GetNewInfo getNewInfo = new GetNewInfo();
		new1 = getNewInfo.new New();
		new1.setUserName("潮趴汇小助手");
		if (Constants.getReserveBoxId().equals(Constants.getScanBoxId())) {
			new1.setMsgContent("欢迎光临宝乐迪KTV！活动开始啦，请开启或保持KTV内WIFI连接状态哦！祝您活动愉快！");
		} else if (myRoom != null && myRoom.isStarting()) {
			new1.setMsgContent("欢迎光临宝乐迪KTV！活动开始啦，请开启或保持KTV内WIFI连接状态哦！祝您活动愉快！");
		} else {
			new1.setMsgContent("欢迎光临宝乐迪KTV!活动暂未开始，您可以预先点歌，或在超市预先点酒水食品。");
		}
		news.clear();
		news.add(new1);

		final Map<String, String> map = new HashMap<String, String>();
		map.put("msgId", news.size() + "");
		map.put("reserveBoxId", myRoom.getReserveBoxId());
		map.put("token", Constants.getToken());

		new GetRoomData(map, new1, news, myAdapter, room_lv_info).run();

	}

	@Override
	public void OnFragmentChanged() {
		unRegistChatBroadCastReceive();
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		unRegistChatBroadCastReceive();
	}

	// 注册聊天接收
	private void registChatBroadCastReceive() {
		try {
			if (chatMessageReceive == null) {
				chatMessageReceive = new ChatMessageReceive();
			}
			IntentFilter filter = new IntentFilter();
			filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
			filter.addAction(YungeJPushType.getAction(YungeJPushType.roomDynamic));
			getActivity().registerReceiver(chatMessageReceive, filter);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// 注销聊天接收
	private void unRegistChatBroadCastReceive() {
		try {
			if (chatMessageReceive != null) {
				getActivity().unregisterReceiver(chatMessageReceive);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	class ChatMessageReceive extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			try {
				if (action.equals(YungeJPushType.getAction(YungeJPushType.roomDynamic)) && Constants.isBinded()) {
					// 重新获取聊天信息
					final Map<String, String> map = new HashMap<String, String>();
					map.put("msgId", news.size() + "");
					map.put("reserveBoxId", myRoom.getReserveBoxId());
					map.put("token", Constants.getToken());
					new GetRoomData(map, new1, news, myAdapter, room_lv_info).run();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

}
