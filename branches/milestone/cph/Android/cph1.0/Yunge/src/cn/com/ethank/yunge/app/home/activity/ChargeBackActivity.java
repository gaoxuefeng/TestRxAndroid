package cn.com.ethank.yunge.app.home.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.activity.ConsumeActivity;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;

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
			Intent consume = new Intent(getApplicationContext(), ConsumeActivity.class);
			startActivity(consume);
			finish();
			break;
		}
	}
}
