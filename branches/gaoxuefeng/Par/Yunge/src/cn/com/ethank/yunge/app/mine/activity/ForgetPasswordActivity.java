package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.CodeInfo;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.VerifyStringType;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class ForgetPasswordActivity extends Activity implements OnClickListener {
	@ViewInject(R.id.pwd_et_phone)
	private EditText pwd_et_phone; // --手机号码--

	@ViewInject(R.id.pwd_but_code)
	private Button pwd_but_code; // --获取动态密码--

	@ViewInject(R.id.pwd_ll_login)
	private LinearLayout pwd_ll_login; // --返回按钮--

	@ViewInject(R.id.pwd_ll_parent)
	private LinearLayout pwd_ll_parent;

	@ViewInject(R.id.pwd_but)
	private Button pwd_but; // --登陆--

	@ViewInject(R.id.pwd_et_code)
	private EditText pwd_et_code; // --动态密码--

	@ViewInject(R.id.pwd_tv_login)
	private TextView pwd_tv_login;

	private TimeCount time;

	private View pop_get_pwd;

	private PopupWindow window;

	private String phoneNum;

	private String register;

	private Button but_pwd_confirm;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_forget_password);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);

		initView();
	}

	private void initView() {
		Intent intent = getIntent();
		phoneNum = intent.getStringExtra("phoneNum");
		register = intent.getStringExtra("register");
		if (!TextUtils.isEmpty(phoneNum)) {
			pwd_et_phone.setText(phoneNum);
			pwd_tv_login.setText("手机号码...");
		} else {
			pwd_tv_login.setText("返回");
		}

		time = new TimeCount(60000, 1000);
		pwd_but_code.setOnClickListener(this);
		pwd_but.setOnClickListener(this);
		pwd_ll_login.setOnClickListener(this);

		pop_get_pwd = View.inflate(getApplicationContext(), R.layout.pop_get_pwd, null);
		but_pwd_confirm = (Button) pop_get_pwd.findViewById(R.id.but_pwd_confirm);
		but_pwd_confirm.setOnClickListener(this);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.but_pwd_confirm:
			window.dismiss();
			break;
		case R.id.pwd_but_code:
			getCode();
			break;
		case R.id.pwd_but:
			pwdLogin();
			break;
		case R.id.pwd_ll_login:
			/*if (TextUtils.isEmpty(register)) {
				Intent login = new Intent(getApplicationContext(), LoginActivity.class);
				startActivity(login);
			} else {
				Intent register = new Intent(getApplicationContext(), RegisterActivity.class);
				startActivity(register);
			}*/
			if(window != null && window.isShowing()){
				window.dismiss();
			}
			finish();
			break;
		}

	}

	/**
	 * 忘记密码页面的登录
	 */
	private void pwdLogin() {
		String phoneNum = pwd_et_phone.getText().toString();
		if (TextUtils.isEmpty(phoneNum)) {
			ToastUtil.show("手机号码不能为空");
			return;
		}
		String pwd = pwd_et_code.getText().toString();
		if (TextUtils.isEmpty(pwd)) {
			ToastUtil.show("动态密码不能为空");
			return;
		}
		
		ProgressDialogUtils.show(this);
		
		final Map<String, String> map = new HashMap<String, String>();
		map.put("phoneNum", phoneNum);
		map.put("dynamicPw", pwd);
		new BackgroundTask<String>() {

			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.GET_PWD, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					UserInfo info = JSON.parseObject(result, UserInfo.class);
					if(null != info){
						if (info.getCode() == 0) {
							
							SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.token, info.getData().getToken());
							SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.login_result, result);

							/*Intent intent = new Intent(getApplicationContext(), MainTabActivity.class);
							intent.setType(MainTabActivity.TAB_HOME);
							startActivity(intent);*/
							BaseApplication.getInstance().exitObjectActivity(LoginActivity.class);
							BaseApplication.getInstance().exitObjectActivity(RegisterActivity.class);
							finish();
						
						}else{
							ToastUtil.show(info.getMessage());
						}
					}
				} else {
					ToastUtil.show(R.string.connectfailtoast);
				}
				
				ProgressDialogUtils.dismiss();
			};

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

	/**
	 * 短信验证码的计时器
	 */
	class TimeCount extends CountDownTimer {

		public TimeCount(long millisInFuture, long countDownInterval) {
			super(millisInFuture, countDownInterval);
		}

		@Override
		public void onTick(long millisUntilFinished) {
			pwd_but_code.setClickable(false);
			pwd_but_code.setText("倒计时"  + millisUntilFinished / 1000 + "秒");
		}

		@Override
		public void onFinish() {
			pwd_but_code.setText("获取动态密码");
			pwd_but_code.setClickable(true);
		}
	}

	/**
	 * 点击获取验证码
	 */
	private void getCode() {
		final String phoneNum = pwd_et_phone.getText().toString();
		if (TextUtils.isEmpty(phoneNum)) {
			ToastUtil.show("电话号码不能为空");
			return;
		}
		// --对电话号码进行验证--
		if (!isMobileNO(phoneNum))
			return;

		if (!NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected()) {
			ToastUtil.show(R.string.connectfailtoast);
			return;
		}

		final Map<String, String> map = new HashMap<String, String>();
		map.put("phoneNum", phoneNum);
		map.put("action", "1");

		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.GET_SMS, map).toString();

			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if(!TextUtils.isEmpty(result)){
					CodeInfo codeInfo = JSON.parseObject(result, CodeInfo.class);
					if(null != codeInfo){
						if(codeInfo.getCode() == 0){
							
							// --计时开始--
							time.start();
							
							showBoxType();
							dismissPop();
						}else{
							ToastUtil.show(codeInfo.getMessage());
						}
					}
				}else{
					ToastUtil.show(R.string.connectfailtoast);
				}
				//time.onFinish();
				//time.cancel();
			}
		}.run();
	}

	/**
	 * 定时器，4秒后提示的pop消失
	 */
	private void dismissPop() {
		Timer timer = new Timer();

		final Handler handler = new Handler() {
			public void handleMessage(android.os.Message msg) {
				window.dismiss();
			};
		};

		TimerTask task = new TimerTask() {
			@Override
			public void run() {
				Message message = new Message();
				message.what = 1;
				handler.sendMessage(message);
			}
		};

		timer.schedule(task, 4000);
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if(keyCode == event.KEYCODE_BACK){
			if(window != null && window.isShowing()){
				window.dismiss();
			}
		}
		return super.onKeyDown(keyCode, event);
	}
	
	/**
	 * 弹出房间类型的popupwindow
	 */
	private void showBoxType() {
		
		InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(pwd_but.getWindowToken(), 0);
		
		int width = UICommonUtil.dip2px(getApplicationContext(), 250);
		int height = UICommonUtil.dip2px(getApplicationContext(), 150);
		
		window = new PopupWindow(pop_get_pwd, width, height);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(true);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		
		//pwd_ll_parent.removeView();
		
		window.showAtLocation(pwd_ll_parent, Gravity.CENTER, 0, 0);

	}
}
