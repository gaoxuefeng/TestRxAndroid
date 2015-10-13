package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.VerifyCodeInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
/** 意见反馈页面     */
public class OpinionActivity extends BaseActivity implements OnClickListener{
	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;

	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;

	@ViewInject(R.id.head_tv_right)
	private TextView head_tv_right;

	@ViewInject(R.id.opinion_et)
	private EditText opinion_et;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_opinion);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);
		head_tv_left.setText("设置");
		head_tv_title.setText("意见反馈");
		head_tv_right.setText("发送");
		
		head_tv_right.setTextColor(getResources().getColor(R.color.send));
		head_tv_left.setOnClickListener(this);
		head_tv_right.setOnClickListener(this);
		opinion_et.setOnClickListener(this);
		
		opinion_et.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				
			}
			
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				
			}
			
			@Override
			public void afterTextChanged(Editable s) {
				
				if(s.toString().trim().length() > 0){
					head_tv_right.setTextColor(getResources().getColor(R.color.order_pink));
				}else{
					head_tv_right.setTextColor(getResources().getColor(R.color.send));
				}
				
				if(s.toString().trim().length() > 250){
					opinion_et.setText(s.toString().trim().substring(0, 250));
				}
			}
		});
	}
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.head_tv_right:
			//TODO  发送到后台
			
			if(TextUtils.isEmpty(Constants.getToken())){
				Intent intent = new Intent(getApplicationContext(), LoginActivity.class);
				startActivity(intent);
			}else{
				
				Map<String, String> map = new HashMap<String, String>();
				map.put("message", opinion_et.getText().toString().trim()+"");
				if(opinion_et.getText().toString().trim().length() <= 0){
					ToastUtil.show("请输入内容");
					return;
				}
				map.put("token", Constants.getToken());
				ProgressDialogUtils.show(this);
				new MyBackgroundTask(map).run();
			}
			break;
		case R.id.opinion_et:
			//head_tv_right.setTextColor(getResources().getColor(R.color.send));
			break;
		}
	}
	
	class MyBackgroundTask extends BackgroundTask<String>{
		Map<String, String> map = new HashMap<String, String>();
		public MyBackgroundTask(Map<String, String> map) {
			this.map = map;
		}
		@Override
		protected String doWork() throws Exception {
			return HttpUtils.getJsonByPost(Constants.hostUrlCloud +Constants.SENDINFO , map).toString();
		}
		
		@Override
		protected void onCompletion(String result, Throwable exception, boolean cancelled) {
			super.onCompletion(result, exception, cancelled);
			if(result != null){
				VerifyCodeInfo codeInfo = JSON.parseObject(result, VerifyCodeInfo.class);
				if(null != codeInfo){
					if(codeInfo.getCode() == 0){
						ToastUtil.show("发送成功");
					}else{
						ToastUtil.show(codeInfo.getMessage());
					}
				}
				
				finish();
			}else{
				ToastUtil.show(R.string.connectfailtoast);
			}
			ProgressDialogUtils.dismiss();
		}
		
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
