package cn.com.ethank.yunge.app.home.activity;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RatingBar;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.bean.HomeInfo;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.mine.activity.RegisterActivity;
import cn.com.ethank.yunge.app.mine.fragment.CustomDialogNewData;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

import com.lidroid.xutils.BitmapUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

/** 商家详情页面 */
public class MerchantDetailActivity extends Activity {
	@ViewInject(R.id.detail_but_pre)
	private Button detail_but_pre; // --预定房间按钮--

	@ViewInject(R.id.merchant_ll_exit)
	private LinearLayout merchant_ll_exit; // --后退按钮--

	@ViewInject(R.id.merchant_iv)
	private ImageView merchant_iv;

	@ViewInject(R.id.merchant_lv)
	private ListView merchant_lv;

	@ViewInject(R.id.merchant_tv_ktvName)
	private TextView merchant_tv_ktvName;
	
	@ViewInject(R.id.merchant_tv_star)
	private TextView merchant_tv_star;
	
	@ViewInject(R.id.detail_rb_star)
	private RatingBar detail_rb_star;
	
	@ViewInject(R.id.merchant_tv_onePrice)
	private TextView merchant_tv_onePrice;
	
	@ViewInject(R.id.merchant_tv_address)
	private TextView merchant_tv_address;
	
	@ViewInject(R.id.merchant_tv_phone)
	private TextView merchant_tv_phone;
	
	@ViewInject(R.id.merchant_tv_time)
	private TextView merchant_tv_time;
	
	@ViewInject(R.id.merchant_img)
	private ImageView merchant_img;
	
	private MyAdapter myAdapter;

	private CustomDialogNewData customDialogNewData;

	private HomeInfo homeInfo;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_merchant_detail);

		Bundle bundle = getIntent().getExtras();
		if(bundle != null && bundle.containsKey("homeInfo")){
		homeInfo = (HomeInfo) bundle.getSerializable("homeInfo");
		
		}

		initView();
		BaseApplication.getInstance().cacheActivityList.add(this);
	}

	private void initView() {
		ViewUtils.inject(this);

		merchant_iv.setFocusable(true);
		merchant_iv.setFocusableInTouchMode(true);
		merchant_iv.requestFocus();

		BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
		bitmapUtils.display(merchant_img, homeInfo.getImageUrl());
		
		merchant_tv_ktvName.setText(homeInfo.getKTVName());
		merchant_tv_star.setText(homeInfo.getRating()/10+"");
		detail_rb_star.setRating((float) homeInfo.getRating()/10);
		merchant_tv_onePrice.setText("￥"+homeInfo.getPrice()+"/人");
		merchant_tv_address.setText(homeInfo.getAddress());
		merchant_tv_phone.setText(homeInfo.getPhoneNum());
		
		
		detail_but_pre.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token))) {
					// --未登录需要先登陆--
					showAlertDialog();
				} else {
					// --跳转到房间预定界面--
					Intent boxPre = new Intent(getApplicationContext(), BoxDetailActivity.class);
					startActivity(boxPre);

				}
			}
		});

		merchant_ll_exit.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				exit();
			}

		});

		if (myAdapter == null) {
			myAdapter = new MyAdapter();
		}

		merchant_lv.setAdapter(myAdapter);

		merchant_lv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				if (TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token))) {
					// --未登录需要先登陆--
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.groupBuy, "groupBuy");
					showAlertDialog();
				} else {
					// --跳转到房间预定界面--
					Intent boxPre = new Intent(getApplicationContext(), MainTabActivity.class);
					boxPre.putExtra("group", "group");
					startActivity(boxPre);
				}
			}
		});

	}

	/**
	 * 后退按钮/返回键
	 */
	private void exit() {
		if (null != customDialogNewData && customDialogNewData.isShowing()) {
			if (!TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.groupBuy)))
				SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.groupBuy);
			customDialogNewData.dismiss();
		} else {
			finish();
		}
	}


	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == event.KEYCODE_BACK) {
			exit();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	class MyAdapter extends BaseAdapter {
		@Override
		public int getCount() {
			return 2;
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
			return View.inflate(getApplicationContext(), R.layout.item_group_buy, null);
		}

	}

	/**
	 * 判断电话号码是否存在，不存在，弹出需要绑定手机提示框，存在，直接跳转到房间预定界面
	 */
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == 100 || resultCode == 110) {
			// --跳转到房间预定界面--
			Intent boxPre = new Intent(getApplicationContext(), MainTabActivity.class);

			if (!TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.groupBuy))) {
				boxPre.putExtra("group", "group");
				SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.groupBuy);
			}

			startActivity(boxPre);
			/*
			 * if (TextUtils.isEmpty(SharePreferencesUtil.getStringData(
			 * SharePreferenceKeyUtil.phoneNum))) { BoundPhoneDialog.Builder
			 * builder = new BoundPhoneDialog.Builder(this);
			 * builder.setPositiveButton("绑定手机号", new
			 * DialogInterface.OnClickListener() { public void
			 * onClick(DialogInterface dialog, int which) { dialog.dismiss();
			 * Intent bound = new Intent(getApplicationContext(),
			 * BoundPhoneActivity.class); startActivity(bound); } });
			 * BoundPhoneDialog boundPhoneDialog = builder.create();
			 * boundPhoneDialog.setCanceledOnTouchOutside(false);
			 * boundPhoneDialog.show(); } else { // --跳转到房间预定界面-- Intent boxPre
			 * = new Intent(getApplicationContext(), BoxPredeterActivity.class);
			 * startActivity(boxPre); finish(); }
			 */
		}

	}

	/**
	 * 弹出dialog
	 */
	private void showAlertDialog() {
		CustomDialogNewData.Builder builder = new CustomDialogNewData.Builder(this);
		builder.setMessage("歌神，需要登录后才能预定房间哦");

		builder.setPositiveButton("注册", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
				Intent register = new Intent(getApplicationContext(), RegisterActivity.class);
				// TODO 需要测试，是否用startActivityForResult开启
				startActivity(register);
				// startActivityForResult(register, 105);
			}
		});

		builder.setNegativeButton("登陆", new android.content.DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
				Intent login = new Intent(getApplicationContext(), LoginActivity.class);
				// TODO REQUEST_CODE 需要提取到文件中
				startActivityForResult(login, 100);

			}
		});
		customDialogNewData = builder.create();
		customDialogNewData.setCanceledOnTouchOutside(true);
		customDialogNewData.show();

	}
}
