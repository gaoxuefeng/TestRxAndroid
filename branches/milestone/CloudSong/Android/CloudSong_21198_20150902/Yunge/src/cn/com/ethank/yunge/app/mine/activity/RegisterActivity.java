package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.Map;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.Editable;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.ProgressBar;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.CodeInfo;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.mine.bean.VerifyCodeInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.StringUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.VerifyStringType;
import cn.com.ethank.yunge.app.util.StringUtil.CharType;
import cn.com.ethank.yunge.app.util.StringUtil.EditTextCallBack;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class RegisterActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.reg_et_code)
	private EditText reg_et_code; // --短信验证码--
	@ViewInject(R.id.reg_et_phone)
	private EditText reg_et_phone; // --手机号码--
	@ViewInject(R.id.reg_et_pwd)
	private EditText reg_et_pwd; // --登录密码--
	@ViewInject(R.id.reg_et_nick)
	private EditText reg_et_nick; // --昵称--
	@ViewInject(R.id.register_ll)
	private LinearLayout register_ll; // --隐藏的布局--
	@ViewInject(R.id.reg_but_code)
	private Button reg_but_code; // --获取验证码按钮--
	@ViewInject(R.id.reg_but)
	private Button reg_but; // --用户注册按钮--
	@ViewInject(R.id.reg_tv_login)
	private TextView reg_tv_login; // --退回到登录页面--
	@ViewInject(R.id.reg_pb)
	private ProgressBar reg_pb; // --进度条--
	@ViewInject(R.id.register_ll_parent)
	private LinearLayout register_ll_parent; // --父布局--
	private TimeCount time;
	private String phoneNum;
	private String code;
	private String pwd;
	private View pop_utils;
	private PopupWindow window;
	private Button pop_but_exit_login; // --pop 返回登录按钮--
	private Button pop_but_forgert_pwd; // -- pop 忘记密码--
	private TextView pop_tv_text1;
	private TextView pop_tv_text2;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_register);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);

		pop_utils = View.inflate(getApplicationContext(), R.layout.pop_utils, null);
		pop_tv_text1 = (TextView) pop_utils.findViewById(R.id.pop_tv_text1);
		pop_tv_text1.setText("该手机号已被注册，无法重复注册");
		pop_tv_text2 = (TextView) pop_utils.findViewById(R.id.pop_tv_text2);
		pop_tv_text2.setVisibility(View.GONE);
		// pop_tv_text2.setText("，无法重复注册");

		pop_but_exit_login = (Button) pop_utils.findViewById(R.id.pop_but_left);
		pop_but_exit_login.setText("返回登录");
		pop_but_forgert_pwd = (Button) pop_utils.findViewById(R.id.pop_but_right);
		pop_but_forgert_pwd.setText("忘记密码");

		pop_but_exit_login.setOnClickListener(this);
		pop_but_forgert_pwd.setOnClickListener(this);

		time = new TimeCount(60000, 1000);
		reg_but_code.setOnClickListener(this);

		reg_et_code.setOnClickListener(this);
		reg_but.setOnClickListener(this);
		reg_tv_login.setOnClickListener(this);

		reg_but.setText("验证");

		/**
		 * 昵称的位数
		 */
		StringUtil.setEditContentlimit(new EditTextCallBack() {
			@Override
			public void after(String result) {
			}
		}, reg_et_nick);

		
		reg_et_pwd.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {

			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {

			}

			@Override
			public void afterTextChanged(Editable s) {
				if (s.length() > 32) {
					reg_et_pwd.setText(s.toString().substring(0, 32));
				}
			}
		});

		// --验证码个数--
		reg_et_code.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(final CharSequence s, int start, int before, int count) {
				final String phoneNum = reg_et_phone.getText().toString();
				if (TextUtils.isEmpty(phoneNum)) {
					ToastUtil.show("电话号码不能为空");
					return;
				}
				// --对电话号码进行验证--
				if (!isMobileNO(phoneNum))
					return;

				if (s.length() == 6) {
					ProgressDialogUtils.show(RegisterActivity.this, false);
					final Map<String, String> map = new HashMap<String, String>();
					map.put("phoneNum", phoneNum);
					map.put("verifyCode", s.toString());
					// --连接网络，判断验证码是否正确--
					new BackgroundTask<String>() {
						@Override
						protected String doWork() throws Exception {
							return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.GET_CHECK_SMS, map).toString();
						}

						@Override
						protected void onCompletion(String result, Throwable exception, boolean cancelled) {
							if (!TextUtils.isEmpty(result)) {
								VerifyCodeInfo verifyCodeInfo = JSON.parseObject(result, VerifyCodeInfo.class);
								if (null != verifyCodeInfo) {
									if (verifyCodeInfo.getCode() == 0) {
										// --成功之后，弹出输入密码--
										InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
										imm.hideSoftInputFromWindow(reg_but_code.getWindowToken(), 0);

										register_ll.setVisibility(View.VISIBLE);
										reg_but.setText("注册");

										reg_et_phone.setClickable(false);
										reg_et_phone.setEnabled(false);

										reg_et_code.setClickable(false);
										reg_et_code.setEnabled(false);
										
										reg_but_code.setClickable(true);
										reg_but_code.setEnabled(true);
										
										reg_but.setClickable(true);

										ProgressDialogUtils.dismiss();
									} else {
										ToastUtil.show(verifyCodeInfo.getMessage());

										ProgressDialogUtils.dismiss();
									}
								}

							} else {
								ToastUtil.show(R.string.connectfailtoast);
								ProgressDialogUtils.dismiss();
							}

						}

						// private void setClickable() {
						// reg_but.setClickable(false);
						// }
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
		reg_et_phone.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if (s.length() == 11) {
					String phone = reg_et_phone.getText().toString();
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

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == event.KEYCODE_BACK) {
			if (window != null && window.isShowing()) {
				window.dismiss();
			}
		}
		return super.onKeyDown(keyCode, event);
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

	/**
	 * 短信验证码的计时器
	 */
	class TimeCount extends CountDownTimer {

		public TimeCount(long millisInFuture, long countDownInterval) {
			super(millisInFuture, countDownInterval);
		}

		@Override
		public void onTick(long millisUntilFinished) {
			reg_but_code.setClickable(false);
			reg_but_code.setText("倒计时" + millisUntilFinished / 1000 + "秒");
		}

		@Override
		public void onFinish() {
			reg_but_code.setText("获取验证码");
			reg_but_code.setClickable(true);
			reg_but_code.setEnabled(true);
			reg_et_phone.setClickable(true);
			reg_et_phone.setEnabled(true);
			reg_et_code.setClickable(true);
			reg_et_code.setEnabled(true);
			
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		// --点击获取验证码，计时开始--
		case R.id.reg_but_code:
			if(!NetStatusUtil.isNetConnect()){
				ToastUtil.show("当前网络异常，请检查网络连接");
				return;
			}
			getCode();
			break;
		// --点击注册--
		case R.id.reg_but:
			register();
			break;
		case R.id.reg_et_code:
			break;
		case R.id.reg_tv_login:
			// --退回到登录页面--
			finish();
			break;
		case R.id.pop_but_left:
			// --返回到登录页面--
			window.dismiss();
			finish();
			break;
		case R.id.pop_but_right:
			// --跳转到忘记密码页面--
			Intent pwd = new Intent(getApplicationContext(), ForgetPasswordActivity.class);
			pwd.putExtra("phoneNum", reg_et_phone.getText().toString());
			pwd.putExtra("register", "register");
			startActivity(pwd);
			// finish();
			window.dismiss();
			break;
		}
	}

	/**
	 * 用户手机号码注册
	 */
	private void register() {
		final Map<String, String> map = new HashMap<String, String>();
		String phone = reg_et_phone.getText().toString();
		String code = reg_et_code.getText().toString();
		String pwd = reg_et_pwd.getText().toString();

		if (TextUtils.isEmpty(phone)) {
			ToastUtil.show("手机号码不能为空");
			return;
		}
		if (TextUtils.isEmpty(code)) {
			ToastUtil.show("验证码不能为空");
			return;
		}
		if (register_ll.getVisibility() == View.GONE) {
			ToastUtil.show("验证码错误");
			return;
		}
		if (TextUtils.isEmpty(pwd)) {
			ToastUtil.show("登录密码不能为空");
			return;
		}

		if (pwd.length() < 6) {
			ToastUtil.show("登录密码至少6位");
			return;
		}

		String regEx = "^[a-zA-Z0-9]+$";
		if (!pwd.matches(regEx)) {
			ToastUtil.show("密码不能输入非法字符");
			return;
		}
		
		String nick = reg_et_nick.getText().toString();
		if (TextUtils.isEmpty(nick)) {
			ToastUtil.show("昵称不能为空");
			return;
		}

		ProgressDialogUtils.show(this);

		map.put("phoneNum", phone);
		map.put("verifyCode", code);
		map.put("passWord", pwd);
		map.put("nickName", nick);
		map.put("regisType", "0");
		// --对网络状态进行判断--
		boolean flag = NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected();
		if (!flag) {
			ToastUtil.show("网络状态不佳");
			// reg_pb.setVisibility(View.GONE);
			ProgressDialogUtils.dismiss();
			return;
		}

		new MyBackground(map).run();
	}

	class MyBackground extends BackgroundTask<String> {
		private Map map;

		public MyBackground(Map<String, String> map) {
			this.map = map;
		}

		@Override
		protected String doWork() throws Exception {
			return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.REGISTER, map).toString();
		}

		protected void onCompletion(String result, Throwable exception, boolean cancelled) {
			if (result != null) {
				// --注册完了，跳转到信息确认页面--
				UserInfo info = JSON.parseObject(result, UserInfo.class);
				if (null != info) {
					if (info.getCode() == 0) {
						ToastUtil.show("注册成功");

						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.token, info.getData().getToken());
						SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.login_result, result);

						Intent intent = new Intent(getApplicationContext(), UserInfoActivity.class);
						startActivity(intent);
						BaseApplication.getInstance().exitObjectActivity(LoginActivity.class);
						finish();

					} else {
						ToastUtil.show(info.getMessage());
					}
				}
			} else {
				ToastUtil.show("注册未成功");
			}
			// --进度条关闭--
			// reg_pb.setVisibility(View.GONE);
			reg_et_phone.setClickable(true);
			reg_et_phone.setEnabled(true);
			reg_et_code.setClickable(true);
			reg_et_code.setEnabled(true);
			ProgressDialogUtils.dismiss();
		};

	}

	/**
	 * 点击获取验证码
	 */
	private void getCode() {

		InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(reg_but_code.getWindowToken(), 0);

		final String phoneNum = reg_et_phone.getText().toString();
		if (TextUtils.isEmpty(phoneNum)) {
			ToastUtil.show("电话号码不能为空");
			return;
		}
		// --对电话号码进行验证--
		if (!isMobileNO(phoneNum))
			return;


		if (!NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected()) {
			ToastUtil.show("网络状态不佳");
			return;
		}

		final Map<String, String> map = new HashMap<String, String>();
		map.put("phoneNum", phoneNum);
		map.put("action", "0");

		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.GET_SMS, map).toString();

			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					CodeInfo codeInfo = JSON.parseObject(result, CodeInfo.class);
					if (null != codeInfo) {
						if (codeInfo.getCode() == 0) {
							
							// --计时开始--
							time.start();
							
						} else if (codeInfo.getCode() == 6) {
							
							showBoxType();

						} else {
							ToastUtil.show(codeInfo.getMessage());

						}

					}

				} else {
					ToastUtil.show("验证码获取失败，请稍后再试");

				}
			}

		}.run();

	}

	/**
	 * 弹出手机号码已被注册的popupwindow
	 */
	private void showBoxType() {
		int width = UICommonUtil.dip2px(getApplicationContext(), 300);
		int height = UICommonUtil.dip2px(getApplicationContext(), 145);
		window = new PopupWindow(pop_utils, android.widget.RelativeLayout.LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(register_ll_parent, Gravity.CENTER, 0, 0);

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}
}
