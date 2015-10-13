package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.LoadingActivity;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.GetRoomInfoRequest;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.ScreenInfo;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.VerifyStringType;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.UMAuthListener;
import com.umeng.socialize.controller.listener.SocializeListeners.UMDataListener;
import com.umeng.socialize.exception.SocializeException;
import com.umeng.socialize.sso.SinaSsoHandler;
import com.umeng.socialize.sso.UMQQSsoHandler;
import com.umeng.socialize.sso.UMSsoHandler;
import com.umeng.socialize.utils.Log;
import com.umeng.socialize.weixin.controller.UMWXHandler;

public class LoginActivity extends BaseActivity implements OnClickListener {
	private UMSocialService mController = UMServiceFactory.getUMSocialService("com.umeng.login");
	@ViewInject(R.id.but_register)
	private Button but_register;
	@ViewInject(R.id.login_et_phone)
	private EditText login_et_phone;
	@ViewInject(R.id.login_et_pwd)
	private EditText login_et_pwd;
	@ViewInject(R.id.but_login)
	private Button but_login;

	@ViewInject(R.id.login_ll_exit)
	private LinearLayout login_ll_exit;// --后退按钮--

	@ViewInject(R.id.login_progress)
	private ProgressBar login_progress;

	@ViewInject(R.id.img_weixin)
	private ImageView img_weixin; // --微信登陆--
	@ViewInject(R.id.img_weibo)
	private ImageView img_weibo; // --微博登陆--
	@ViewInject(R.id.img_qq)
	private ImageView img_qq; // --QQ登陆--

	@ViewInject(R.id.img_ali)
	private ImageView img_ali;

	@ViewInject(R.id.thirdparty_container)
	private LinearLayout thirdPartyContainer;

	@ViewInject(R.id.login_rl_pwd)
	private RelativeLayout login_rl_pwd; // --忘记密码--

	private ScreenInfo mScreenInfo;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		BaseApplication.getInstance().cacheActivityList.add(this);
		mScreenInfo = new ScreenInfo(this);
		ViewUtils.inject(this);
		addThirdPartyLogin();
		but_register.setOnClickListener(this);
		but_login.setOnClickListener(this);
		login_ll_exit.setOnClickListener(this);
		login_rl_pwd.setOnClickListener(this);

		img_weixin.setOnClickListener(this);
		img_weibo.setOnClickListener(this);
		img_qq.setOnClickListener(this);

		img_ali.setOnClickListener(this);
		login_et_phone.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if (s.length() == 11) {
					String phone = login_et_phone.getText().toString();
					isMobileNO(phone);
				}
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {

			}
		});

	}

	private void addThirdPartyLogin() {
		int width = mScreenInfo.getWidthPixels() - 2 * UICommonUtil.dip2px(this, 35) - 4 * UICommonUtil.dip2px(this, (float) 39.5);
		int space = width / 3;
		ImageView img_wx = new ImageView(this);
		img_wx.setImageDrawable(getResources().getDrawable(R.drawable.signin_wechat_icon));
		img_wx.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				login_WX();
			}
		});
		ImageView img_qq = new ImageView(this);
		LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.setMargins(space, 0, 0, 0);
		img_qq.setImageDrawable(getResources().getDrawable(R.drawable.signin_qq_icon));
		img_qq.setLayoutParams(lp);
		img_qq.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				login_QQ();
			}
		});

		ImageView img_weibo = new ImageView(this);
		img_weibo.setImageDrawable(getResources().getDrawable(R.drawable.signin_weibo_icon));
		img_weibo.setLayoutParams(lp);
		img_weibo.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				login_weibo();
			}
		});
		ImageView img_ali = new ImageView(this);
		img_ali.setImageDrawable(getResources().getDrawable(R.drawable.signin_alipay_icon));
		img_ali.setLayoutParams(lp);

		thirdPartyContainer.addView(img_wx);
		thirdPartyContainer.addView(img_weibo);
		thirdPartyContainer.addView(img_qq);
		thirdPartyContainer.addView(img_ali);

	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		/** 使用SSO授权必须添加如下代码 */
		UMSsoHandler ssoHandler = mController.getConfig().getSsoHandler(requestCode);
		if (ssoHandler != null) {
			ssoHandler.authorizeCallBack(requestCode, resultCode, data);

		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.but_register:
			// --手机号注册页面--
			Intent intent = new Intent(getApplicationContext(), RegisterActivity.class);
			startActivity(intent);
			break;
		case R.id.but_login:
			// --用户登录--
			login();
			break;
		case R.id.login_ll_exit:
			// --后退--
			finish();
			break;

		case R.id.img_weibo:
			login_weibo();
			break;

		case R.id.img_weixin:
			login_WX();
			break;

		case R.id.img_qq:
			login_QQ();
			break;

		case R.id.login_rl_pwd:
			// -- 跳转到忘记密码界面--
			Intent getPwd = new Intent(getApplicationContext(), ForgetPasswordActivity.class);
			startActivity(getPwd);
			
			break;
		}
	}

	/**
	 * 微博登陆
	 */
	private void login_weibo() {
		// 设置新浪SSO handler
		mController.getConfig().setSsoHandler(new SinaSsoHandler());
		mController.doOauthVerify(LoginActivity.this, SHARE_MEDIA.SINA, new UMAuthListener() {
			@Override
			public void onError(SocializeException e, SHARE_MEDIA platform) {
				// login_progress.setVisibility(View.GONE);
				ProgressDialogUtils.dismiss();
			}

			@Override
			public void onComplete(Bundle value, SHARE_MEDIA platform) {
				if (value != null && !TextUtils.isEmpty(value.getString("uid"))) {
					ToastUtil.show("授权成功.");
					// --获取新浪微博数据--
					getWeiboData();
				} else {
					ToastUtil.show("授权失败");
				}
			}

			@Override
			public void onCancel(SHARE_MEDIA platform) {
				// login_progress.setVisibility(View.GONE);
				ProgressDialogUtils.dismiss();
			}

			@Override
			public void onStart(SHARE_MEDIA platform) {
				// login_progress.setVisibility(View.VISIBLE);
				ProgressDialogUtils.show(getApplication());
			}
		});
	}

	/**
	 * QQ登陆
	 */
	private void login_QQ() {
		UMQQSsoHandler qqSsoHandler = new UMQQSsoHandler(this, "1104563078", "M9mZnpH8RuxYn3uD");
		qqSsoHandler.addToSocialSDK();

		mController.doOauthVerify(LoginActivity.this, SHARE_MEDIA.QQ, new UMAuthListener() {
			@Override
			public void onStart(SHARE_MEDIA platform) {
				ToastUtil.show("授权开始");
				// login_progress.setVisibility(View.VISIBLE);
				ProgressDialogUtils.show(getApplication());
			}

			@Override
			public void onError(SocializeException e, SHARE_MEDIA platform) {
				ToastUtil.show("授权错误");
				// login_progress.setVisibility(View.GONE);
				ProgressDialogUtils.dismiss();
			}

			@Override
			public void onComplete(Bundle value, SHARE_MEDIA platform) {
				// login_progress.setProgress(View.VISIBLE);
				ProgressDialogUtils.show(getApplication());
				getQQData();
			}

			@Override
			public void onCancel(SHARE_MEDIA platform) {
				ToastUtil.show("授权取消");
				// login_progress.setVisibility(View.GONE);
				ProgressDialogUtils.dismiss();
			}
		});
	}

	/**
	 * 获取用户qq数据
	 */
	private void getQQData() {
		ToastUtil.show("授权完成");
		// 获取相关授权信息
		mController.getPlatformInfo(LoginActivity.this, SHARE_MEDIA.QQ, new UMDataListener() {
			@Override
			public void onStart() {
			}

			@Override
			public void onComplete(int status, Map<String, Object> info) {
				if (status == 200 && info != null) {
					StringBuilder sb = new StringBuilder();
					Set<String> keys = info.keySet();
					for (String key : keys) {
						sb.append(key + "=" + info.get(key).toString() + "\r\n");
					}
					Log.d("TestData", sb.toString());
					// --请求参数--
					String gender;
					if (info.get("gender").toString().equals("2")) {
						gender = "女";
					} else {
						gender = "男";
					}
					String nickName = info.get("screen_name").toString();
					String profileUrl = info.get("profile_image_url").toString();
					final Map<String, String> map = new HashMap<String, String>();
					map.put("gender", gender);
					map.put("nickName", nickName);
					map.put("profileUrl", profileUrl);
					map.put("type", "3");

					// --将获取的数据传递给服务器--
					getDataForNet(map);

				} else {
					// login_progress.setVisibility(View.GONE);
					ProgressDialogUtils.dismiss();
					Log.d("TestData", "发生错误：" + status);
				}
			}

		});
	}

	private void getDataForNet(final Map<String, String> map) {
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.THIRD_PARTY_LOGIN, map).toString();

			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {

				if (result != null) {
					UserInfo info = JSON.parseObject(result.toString(), UserInfo.class);
					if (info.getCode() == 0) {
						// --将token保存到文件中--
						ToastUtil.show(result);
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.token, info.getData().getToken());
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.login_result, result);
						// --登陆成功之后跳转到首页--
						Intent intent = getIntent();
						setResult(RESULT_OK, intent);
						setResult(100, intent);
						finish();
					} else {
						ToastUtil.show("用户名或密码错误");
					}
					// login_progress.setVisibility(View.GONE);
					ProgressDialogUtils.dismiss();
				}
			};
		}.run();
	}

	/**
	 * 微信登陆
	 */
	private void login_WX() {
		// 添加微信平台
		UMWXHandler wxHandler = new UMWXHandler(LoginActivity.this, "wx5c07842a8d88f1ca", "c1ef7c51c2e650d4acaec0b0b8a35a1e");
		wxHandler.addToSocialSDK();

		mController.doOauthVerify(LoginActivity.this, SHARE_MEDIA.WEIXIN, new UMAuthListener() {
			@Override
			public void onStart(SHARE_MEDIA platform) {
				ToastUtil.show("授权开始");

			}

			@Override
			public void onError(SocializeException e, SHARE_MEDIA platform) {
				ToastUtil.show("授权错误");
				// login_progress.setVisibility(View.GONE);
				ProgressDialogUtils.dismiss();
			}

			@Override
			public void onComplete(Bundle value, SHARE_MEDIA platform) {
				ToastUtil.show("授权完成");
				getWeixinData();
			}

			@Override
			public void onCancel(SHARE_MEDIA platform) {
				ToastUtil.show("授权取消");
				// login_progress.setVisibility(View.GONE);
				ProgressDialogUtils.dismiss();
			}
		});
	}

	/**
	 * 获取微信相关信息
	 */
	public void getWeixinData() {
		// 获取相关授权信息
		mController.getPlatformInfo(LoginActivity.this, SHARE_MEDIA.WEIXIN, new UMDataListener() {
			@Override
			public void onStart() {
			}

			@Override
			public void onComplete(int status, Map<String, Object> info) {
				if (status == 200 && info != null) {
					StringBuilder sb = new StringBuilder();
					Set<String> keys = info.keySet();
					for (String key : keys) {
						sb.append(key + "=" + info.get(key).toString() + "\r\n");
					}
					Log.d("TestData", sb.toString());
					// --请求参数--
					String openid = (String) info.get("openid");
					String gender;
					if (info.get("sex").toString().equals("2")) {
						gender = "女";
					} else {
						gender = "男";
					}

					String nickName = info.get("nickname").toString();
					final Map<String, String> map = new HashMap<String, String>();
					map.put("openid", openid);
					map.put("gender", gender);
					map.put("nickName", nickName);
					map.put("type", "2");

					getDataForNet(map);

				} else {
					// login_progress.setVisibility(View.GONE);
					ProgressDialogUtils.dismiss();
					Log.d("TestData", "发生错误：" + status);
				}
			}
		});
	}

	/**
	 * 获取新浪微博数据
	 */
	public void getWeiboData() {
		mController.getPlatformInfo(LoginActivity.this, SHARE_MEDIA.SINA, new UMDataListener() {
			@Override
			public void onStart() {
			}

			@Override
			public void onComplete(int status, final Map<String, Object> info) {
				if (status == 200 && info != null) {
					StringBuilder sb = new StringBuilder();
					Set<String> keys = info.keySet();
					for (String key : keys) {
						sb.append(key + "=" + info.get(key).toString() + "\r\n");
					}
					Log.d("TestData", sb.toString());

					// --请求参数--
					String openid = info.get("uid") + "";
					String gender;
					if (info.get("gender").toString().equals("0")) {
						gender = "女";
					} else {
						gender = "男";
					}
					String nickname = info.get("screen_name").toString();
					String profileUrl = info.get("profile_image_url").toString();
					final Map<String, String> map = new HashMap<String, String>();
					map.put("gender", gender);
					map.put("nickName", nickname);
					map.put("openid", openid);
					map.put("profileUrl", profileUrl);
					map.put("type", "1");

					getDataForNet(map);

				} else {
					// login_progress.setVisibility(View.GONE);
					ProgressDialogUtils.dismiss();
					Log.d("TestData", "发生错误：" + status);
				}
			}
		});
	}

	/**
	 * 点击登录按钮，用户登录
	 */
	public void login() {

		String phone = login_et_phone.getText().toString();
		String pwd = login_et_pwd.getText().toString();
		if (TextUtils.isEmpty(phone)) {
			ToastUtil.show("手机号码不能为空");
			return;
		}
		if (TextUtils.isEmpty(pwd)) {
			ToastUtil.show("密码不能为空");
			return;
		}
		// --对网络状态进行判断--
		// login_progress.setVisibility(View.VISIBLE);
		ProgressDialogUtils.show(this);

		boolean flag = NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected();
		if (!flag) {
			ToastUtil.show("网络状态不佳");
			// login_progress.setVisibility(View.GONE);
			ProgressDialogUtils.dismiss();
			return;
		}
		new MyBackTask(phone, pwd).run();
	}

	/**
	 * 从网络获取user数据
	 */
	class MyBackTask extends BackgroundTask<String> {
		private String phone;
		private String pwd;
		private String userType;
		private HashMap<String, String> map;

		public MyBackTask(String phone, String pwd) {
			this.phone = phone;
			this.pwd = pwd;
			map = new HashMap<String, String>();
			map.put("phoneNum", phone);
			map.put("passWord", pwd);

		}

		public MyBackTask() {
		}

		@Override
		protected String doWork() throws Exception {
			return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PHONE_LOGIN, map).toString();
		}

		@Override
		protected void onCompletion(final String result, Throwable exception, boolean cancelled) {
			ProgressDialogUtils.dismiss();
			// login_progress.setVisibility(View.GONE);
			if (result != null) {
				final UserInfo info = JSON.parseObject(result.toString(), UserInfo.class);
				if (info.getCode() == 0) {

					// --将token保存到文件中--
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.token, info.getData().getToken());
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.login_result, result);

					GetRoomInfoRequest getRoomInfoRequest = new GetRoomInfoRequest(context);
					getRoomInfoRequest.start(new RequestCallBack() {

						@Override
						public void onLoaderFinish(Map<String, ?> map) {

							// 获取房间列表
							
							for (int i = 0; i < LoadingActivity.myRooms.size(); i++) {
								if (Constants.getReserveBoxId().equals(LoadingActivity.myRooms.get(i).getReserveBoxId()) ||
										Constants.getScanBoxId().equals(LoadingActivity.myRooms.get(i).getReserveBoxId())) {
									SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo,JSONObject.toJSONString(LoadingActivity.myRooms.get(i)));
									SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, Constants.getReserveBoxId());
								}else{
									String reserveBoxId = LoadingActivity.myRooms.get(0).getReserveBoxId();
									SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo, JSONObject.toJSONString(LoadingActivity.myRooms.get(0)));
									SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, reserveBoxId);
								}
							}
							Constants.setBinded(true);
							// --登陆成功之后跳转到首页--
							Intent intent = getIntent();
							setResult(RESULT_OK, intent);
							setResult(100, intent);
							if (!TextUtils.isEmpty(Constants.getMine())) {
								Intent intent2 = new Intent(getApplicationContext(), MainTabActivity.class);
								// intent2.setType(MainTabActivity.TAB_HOME);
								startActivity(intent2);
							}

							finish();
						}

						@Override
						public void onLoaderFail() {
							// 获取房间列表成功
							SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.reserveBoxId);
							if (Constants.isBinded()) {
								Constants.setBinded(false);
							}
							// --登陆成功之后跳转到首页--
							Intent intent = getIntent();
							setResult(RESULT_OK, intent);
							setResult(100, intent);
							if (!TextUtils.isEmpty(Constants.getMine())) {
								Intent intent2 = new Intent(getApplicationContext(), MainTabActivity.class);
								// intent2.setType(MainTabActivity.TAB_HOME);
								startActivity(intent2);
							}
							SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.mine, "");

							finish();

						}
					});

				} else {
					ToastUtil.show("用户名或密码错误");
				}
			}
		}
	}

	/**
	 * 验证手机格式
	 */
	public boolean isMobileNO(String mobiles) {

		if (!VerifyStringType.isMobileNO(mobiles)) {
			ToastUtil.show("手机号格式不正确");
			return false;
		}
		return true;
	}
}
