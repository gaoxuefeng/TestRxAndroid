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
import android.widget.Toast;
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
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.VerifyStringType;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class ModifyPasswordActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.modify_ll_set)
	private LinearLayout modify_ll_set; // --设置--

	@ViewInject(R.id.modify_but_code)
	private Button modify_but_code; // --获取验证码--

	@ViewInject(R.id.modify_ll)
	private LinearLayout modify_ll; // --隐藏的部分--

	@ViewInject(R.id.modify_et_pwd)
	private EditText modify_et_pwd; // --修改密码--

	@ViewInject(R.id.modify_et_pwd2)
	private EditText modify_et_pwd2; // --确认修改密码--

	@ViewInject(R.id.modify_but)
	private Button modify_but; // --验证按钮--

	@ViewInject(R.id.modify_et_code)
	private EditText modify_et_code; // --短信码--
	private TimeCount time;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_modify_pwd);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);
		
		time = new TimeCount(60000, 1000);
		modify_ll_set.setOnClickListener(this);
		modify_but.setOnClickListener(this);
		modify_but_code.setOnClickListener(this);

		modify_et_code.setOnClickListener(this);
		// --验证码个数--
		modify_et_code.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(final CharSequence s, int start, int before, int count) {
				if (s.length() == 6) {
					String phoneNum = getPhoneNum();
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
							VerifyCodeInfo verifyCodeInfo = JSON.parseObject(result, VerifyCodeInfo.class);
							if(verifyCodeInfo.getCode() == 0){
								// --成功之后，弹出输入密码--
								modify_ll.setVisibility(View.VISIBLE);
								modify_but.setText("确认修改");
								modify_but.setClickable(true);
							}else{
								ToastUtil.show(verifyCodeInfo.getMessage());
								modify_but.setClickable(false);
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

		
	}

	private String getPhoneNum() {
		UserInfo userInfo = JSON.parseObject(Constants.getLoginResult(), UserInfo.class);
		String phoneNum = userInfo.getData().getUserInfo().getPhoneNum();
		return phoneNum;
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.modify_ll_set:
			finish();
			break;
		case R.id.modify_et_code:
			break;
		case R.id.modify_but_code:
			getCode();
			break;
		case R.id.modify_but:
			modifyPwd();
			break;
		}
	}

	private void modifyPwd() {

		String phoneNum = getPhoneNum();
		String verifyCode = modify_et_code.getText().toString();

		if (TextUtils.isEmpty(phoneNum)) {
			ToastUtil.show("手机号码不能为空");
			return;
		}
		String pwd = modify_et_pwd.getText().toString();
		if (TextUtils.isEmpty(pwd)) {
			ToastUtil.show("密码不能为空");
			return;
		}

		String pwd2 = modify_et_pwd2.getText().toString();
		if (TextUtils.isEmpty(pwd2)) {
			ToastUtil.show("确认密码不能为空");
			return;
		}

		if (!pwd.equals(pwd2)) {
			ToastUtil.show("密码与确认密码不一致");
			return;
		}

		/**
		 * 弹出pop，提示正在修改
		 */
		ProgressDialogUtils.show(getApplicationContext());

		final Map<String, String> map = new HashMap<String, String>();
		map.put(SharePreferenceKeyUtil.token, SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token));
		map.put("phoneNum", phoneNum);
		map.put("newPassword", pwd);
		map.put("verifyCode", verifyCode);
		new BackgroundTask<String>() {

			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.MODIFYPWD, map).toString();
			}

			@Override
			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					UserInfo info = JSON.parseObject(result, UserInfo.class);
					switch (info.getCode()) {
					case 0:
						ToastUtil.show("修改密码成功");
						finish();
						ProgressDialogUtils.dismiss();
						break;
					case 1:
						ToastUtil.show("失败");
						break;
					case 5:
						ToastUtil.show("服务器异常");
						break;
					}
				} else {
					ToastUtil.show("联网失败");
				}
			}
		}.run();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		ProgressDialogUtils.dismiss();
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
			modify_but_code.setClickable(false);
			modify_but_code.setText("倒计时" + "(" + millisUntilFinished / 1000 + ")");
		}

		@Override
		public void onFinish() {
			modify_but_code.setText("获取验证码");
			modify_but_code.setClickable(true);
		}
	}

	/**
	 * 点击获取验证码
	 */
	private void getCode() {
		
		String phoneNum = getPhoneNum();
		if (TextUtils.isEmpty(phoneNum)) {
			ToastUtil.show("电话号码不能为空");
			return;
		}

		if (TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token))) {
			ToastUtil.show("您未登录，请先去登录");
			return;
		}

		// --计时开始--
		time.start();

		if (!NetStatusUtil.getInst().getNetStatusManager().isNetworkConnected()) {
			ToastUtil.show("网络状态不佳");
			return;
		}

		final Map<String, String> map = new HashMap<String, String>();
		map.put("phoneNum", phoneNum);
		map.put("action", "2");
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.GET_SMS, map).toString();

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
					ToastUtil.show("用户已存在");
					break;
				case 7:
					ToastUtil.show("手机号未被注册，请先去注册");
					time.cancel();
					time.onFinish();
					break;
				}
			}

		}.run();

	}

}
