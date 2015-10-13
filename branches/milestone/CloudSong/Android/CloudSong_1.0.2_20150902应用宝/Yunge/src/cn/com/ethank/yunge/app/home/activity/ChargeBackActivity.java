package cn.com.ethank.yunge.app.home.activity;

import java.util.Timer;
import java.util.TimerTask;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.activity.MenuActivity;
import cn.com.ethank.yunge.app.mine.activity.ConsumeActivity;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.PopupWindowUtils;

import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
/**  退单确认页面   **/
public class ChargeBackActivity extends BaseActivity implements OnClickListener{
	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title; 
	
	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;
	
	@ViewInject(R.id.charge_but)
	private Button charge_but;

	@ViewInject(R.id.tv_price)
	private TextView tv_price;
	private String reserveBoxId;

	private String price;

	private RelativeLayout success;

	private ImageView img_money_success;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_charge_back);
		BaseApplication.getInstance().cacheActivityList.add(this);
		Intent intent = getIntent();
		//订单号
		reserveBoxId = intent.getStringExtra("ReserveBoxId");
		//价钱
		price = intent.getStringExtra("Price");
		initView();
		
		success = (RelativeLayout) View.inflate(getApplicationContext(), R.layout.pop_back_money_success, null);
		img_money_success = (ImageView) success.findViewById(R.id.img_money_success);
		
		
	}
	
	
	
	private void initView() {
		ViewUtils.inject(this);
		head_tv_title.setText("退单确认");
		tv_price.setText(price);
		head_tv_left.setOnClickListener(this);
		charge_but.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
//			Intent detail = new Intent(getApplicationContext(), ConsumeDetailActivity.class);
//			startActivity(detail);
			finish();
			break;
		case R.id.charge_but:
			//TODO 申请退款 
			PopupWindowUtils.show(getApplicationContext(), success , head_tv_left, true);
			BaseApplication.getInstance().exitObjectActivity(ConsumeDetailActivity.class);
			//Intent consume = new Intent(getApplicationContext(), ConsumeActivity.class);
			//startActivity(consume);
			dismissPop();
			break;
		}
	}
	
	/**
	 * 定时器，4秒后提示的pop消失
	 */
	private void dismissPop() {
		Timer timer = new Timer();
		final Handler handler = new Handler() {
			public void handleMessage(android.os.Message msg) {
				PopupWindowUtils.dismiss();
				finish();
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

		timer.schedule(task, 2000);
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if(keyCode == event.KEYCODE_BACK){
			BaseApplication.getInstance().exitObjectActivity(ConsumeDetailActivity.class);
			finish();
		}
		return super.onKeyDown(keyCode, event);
	}
	
	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
