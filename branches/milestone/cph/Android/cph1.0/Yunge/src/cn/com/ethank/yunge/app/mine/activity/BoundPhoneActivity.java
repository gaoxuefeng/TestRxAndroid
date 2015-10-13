package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.CodeInfo;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.VerifyStringType;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class BoundPhoneActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.bound_et_code)
	private EditText bound_et_code; // --短信验证码--
	@ViewInject(R.id.bound_ll)
	private LinearLayout bound_ll;
	@ViewInject(R.id.bound_et_phone)
	private EditText bound_et_phone;
	@ViewInject(R.id.bound_tv_des)
	// --绑定页面的信息描述--
	private TextView bound_tv_des;
	@ViewInject(R.id.bound_tv_login)
	private TextView bound_tv_login; // --跳转到登陆页面--
	@ViewInject(R.id.bound_but_code)
	private Button bound_but_code; // --获取验证码按钮--

	@ViewInject(R.id.bound_pwd)
	private EditText bound_pwd; // --密码--
	@ViewInject(R.id.bound_nickName)
	private EditText bound_nickName; // --昵称--
	@ViewInject(R.id.bt_bound_button)
	private Button bt_bound_button; // --绑定--
	@ViewInject(R.id.bound_pb)
	private ProgressBar bound_pb; // --进度条--

	private TimeCount time;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_bound_phone);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
		ViewUtils.inject(this);
		time = new TimeCount(60000, 1000);

		bound_tv_login.setOnClickListener(this);
		bound_et_code.setOnClickListener(this);
		bound_but_code.setOnClickListener(this);
		bt_bound_button.setOnClickListener(this);

		// --验证码个数--
		bound_et_code.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(final CharSequence s, int start, int before, int count) {
				final String phoneNum = bound_et_phone.getText().toString();
				if (TextUtils.isEmpty(phoneNum)) {
					ToastUtil.show("电话号码不能为空");
					return;
				}
				// --对电话号码进行验证--
				if (!isMobileNO(phoneNum))
					return;

				if (s.length() == 6) {
					// --连接网络，判断验证码是否正确--
					final Map<String, String> map = new HashMap<String, String>();
					map.put("phoneNum", phoneNum);
					map.put("verifyCode", s.toString());
					new BackgroundTask<String>() {
						@Override
						protected String doWork() throws Exception {
							return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.GET_CHECK_SMS, map).toString();
						}

						@Override
						protected void onCompletion(String result, Throwable exception, boolean cancelled) {
							UserInfo info = JSON.parseObject(result, UserInfo.class);
							switch (info.getCode()) {
							case 0:
								Log.i("code_0", "成功");
								// --成功之后，弹出输入密码--
								bound_ll.setVisibility(View.VISIBLE);
								bt_bound_button.setOnClickListener(new OnClickListener() {
									@Override
									public void onClick(View v) {

										String phoneNum = bound_et_phone.getText().toString();
										if (TextUtils.isEmpty(phoneNum)) {
											ToastUtil.show("手机号不能为空");
											return;
										}

										String passWord = bound_pwd.getText().toString();
										if (TextUtils.isEmpty(passWord)) {
											ToastUtil.show("密码不能为空");
											return;
										}
										if (passWord.length() < 6) {
											ToastUtil.show("密码不能少于6位");
											return;
										}
										String nickName = bound_nickName.getText().toString();
										if (TextUtils.isEmpty(nickName)) {
											ToastUtil.show("昵称不能为空");
											return;
										}
										// --展示进度条--
										bound_pb.setVisibility(View.VISIBLE);

										final Map<String, String> map = new HashMap<String, String>();
										map.put("passWord", passWord);
										map.put("nickName", nickName);
										map.put("phoneNum", phoneNum);
										map.put("token", Constants.getToken());
										map.put("verifyCode", s.toString());
										getDataForNetBound(map);
									}
								});
								break;
							case 1:
								Log.i("code_1", "频繁发送");
								ToastUtil.show("频繁发送");
								break;
							case 2:
								ToastUtil.show("验证码错误");
								break;
							case 3:
								ToastUtil.show("验证码过期");
								Log.i("code_3", "过期");
								break;
							case 4:
								ToastUtil.show("手机号已经注册，直接绑定");
								bt_bound_button.setOnClickListener(new OnClickListener() {
									@Override
									public void onClick(View v) {
										String phoneNum = bound_et_phone.getText().toString();
										final Map<String, String> hashMap = new HashMap<String, String>();
										hashMap.put("phoneNum", phoneNum);
										hashMap.put("token", Constants.getToken());
										hashMap.put("verifyCode", s.toString());
										getDataForNetBound(hashMap);
									}
								});
								break;
							case 5:
								Log.i("code_5", "服务器异常");
								ToastUtil.show("服务器异常");
								break;
							}
						}
					}.run();

				}
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
			}
		});

		// --手机号码注册，验证手机号码格式--
		bound_et_phone.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if (s.length() == 11) {
					String phone = bound_et_phone.getText().toString();
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

	public void getDataForNetBound(final Map<String, String> map) {
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.BOUND_PHONE, map).toString();
			}

			@Override
			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (result != null) {
					UserInfo info = JSON.parseObject(result.toString(), UserInfo.class);
					if (info.getCode() == 0) {
						// --将token保存到文件中--
						ToastUtil.show("绑定成功");
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.phoneNum, info.getData().getUserInfo().getPhoneNum());
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.token, info.getData().getToken());
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.login_result, result);
						// --登陆成功之后跳转到首页--
						Intent intent = getIntent();
						setResult(RESULT_OK, intent);
						setResult(110, intent);
						finish();
					}
				}
				bound_pb.setVisibility(View.GONE);
			}
		}.run();
	}

	public void getDataForNet(final Map<String, String> map) {
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.BOUND_PHONE, map).toString();
			}

			@Override
			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (result != null) {
					ToastUtil.show(result);
					UserInfo info = JSON.parseObject(result.toString(), UserInfo.class);
					if (info.getCode() == 0) {
						// --将token保存到文件中--
						ToastUtil.show("绑定成功");
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.phoneNum, info.getData().getUserInfo().getPhoneNum());
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.token, info.getData().getToken());
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.login_result, result);
						// --登陆成功之后跳转到首页--
						Intent intent = getIntent();
						setResult(RESULT_OK, intent);
						setResult(110, intent);
						finish();
					} else {
						ToastUtil.show("用户名或密码错误");
					}
				}
			}
		}.run();
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

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.bound_tv_login:
			// --跳转到登陆页面--
			Intent login = new Intent(getApplicationContext(), LoginActivity.class);
			startActivity(login);
			finish();
			break;
		case R.id.bound_et_code:
			break;

		case R.id.bound_but_code:
			// --点击获取验证码--
			getCode();
			break;
		case R.id.bt_bound_button:
			String phoneNum = bound_et_phone.getText().toString();
			if (TextUtils.isEmpty(phoneNum)) {
				ToastUtil.show("电话号码不能为空");
				return;
			}
			// --对电话号码进行验证--
			if (!isMobileNO(phoneNum))
				return;
			String code = bound_et_code.getText().toString();
			if (TextUtils.isEmpty(code)) {
				ToastUtil.show("验证码不能为空");
				return;
			}

			String passWord = bound_pwd.getText().toString();
			if (TextUtils.isEmpty(passWord)) {
				ToastUtil.show("密码不能为空");
				return;
			}
			String nickName = bound_nickName.getText().toString();
			if (TextUtils.isEmpty(nickName)) {
				ToastUtil.show("昵称不能为空");
				return;
			}
			break;
		}
	}

	/**
	 * 短信验证码的计时器
	 */
	class TimeCount extends CountDownTimer {

		public TimeCount(long millisInFuture, long countDownInterval) {
			super(millisInFuture, countDownInterval);
		}

		@Override
		public void onTick(long millisUntilFinished) {
			bound_but_code.setClickable(false);
			bound_but_code.setText(millisUntilFinished / 1000 + "秒后可重新发送");
		}

		@Override
		public void onFinish() {
			bound_but_code.setText("重新获取验证码");
			bound_but_code.setClickable(true);
		}
	}

	/**
	 * 点击获取验证码
	 */
	private void getCode() {
		final String phoneNum = bound_et_phone.getText().toString();
		if (TextUtils.isEmpty(phoneNum)) {
			ToastUtil.show("电话号码不能为空");
			return;
		}
		// --对电话号码进行验证--
		if (!isMobileNO(phoneNum))
			return;

		// --计时开始--
		time.start();

		if (!NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected()) {
			ToastUtil.show("网络状态不佳");
			return;
		}

		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getStringByGet(Constants.hostUrlCloud + "Sms/getSms.json?phoneNum=" + phoneNum + "&action=1");
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				CodeInfo codeInfo = JSON.parseObject(result, CodeInfo.class);
				switch (codeInfo.getCode()) {
				case 0:
					Log.i("register_code_0", "成功");
					break;
				case 1:
					Log.i("register_code_1", "token过期");
					break;
				case 2:
					Log.i("register_code_2", "手机号码错误");
					break;
				case 3:
					Log.i("register_code_3", "手机短信接口请求过于频繁");
					break;
				case 4:
					Log.i("register_code_4", "数据库传输失败");
					break;
				case 5:
					Log.i("register_code_5", "其他错误");
					break;
				case 6:
					ToastUtil.show("手机号码已被注册");
					time.onFinish();
					time.cancel();
					break;
				}
			};
		}.run();

	}
}
