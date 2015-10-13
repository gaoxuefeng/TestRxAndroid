package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.Map;
import kankan.wheel.widget.OnWheelChangedListener;
import kankan.wheel.widget.WheelView;
import kankan.wheel.widget.WheelViewConstantUtils;
import kankan.wheel.widget.adapters.ArrayWheelAdapter;
import android.app.ActionBar.LayoutParams;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class UserInfoActivity extends BaseActivity implements OnClickListener {

	@ViewInject(R.id.user_rl_gender)
	private RelativeLayout user_rl_gender; // --性别--
	@ViewInject(R.id.user_your_gender)
	private TextView user_your_gender;

	@ViewInject(R.id.user_your_age)
	private TextView user_your_age;
	@ViewInject(R.id.user_rl_constellation)
	private RelativeLayout user_rl_constellation; // --星座--
	@ViewInject(R.id.user_your_constell)
	private TextView user_your_constell;
	@ViewInject(R.id.user_rl_blood)
	private RelativeLayout user_rl_blood; // --血型--
	@ViewInject(R.id.user_your_blood)
	private TextView user_your_blood;
	@ViewInject(R.id.user_rl_singer)
	private RelativeLayout user_rl_singer; // --喜欢的歌星--
	@ViewInject(R.id.user_your_singer)
	private TextView user_your_singer;
	@ViewInject(R.id.user_rl_song)
	private RelativeLayout user_rl_song; // --喜欢的歌曲--
	@ViewInject(R.id.user_your_song)
	private TextView user_your_song;
	@ViewInject(R.id.user_rl_introduce)
	private RelativeLayout user_rl_introduce; // --个性签名介绍--
	@ViewInject(R.id.user_your_introduce)
	private TextView user_your_introduce;

	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;

	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;

	@ViewInject(R.id.head_tv_right)
	private TextView head_tv_right;

	@ViewInject(R.id.userinfo_ll_parent)
	private LinearLayout userinfo_ll_parent;

	private Map<String, String> userInfo;
	private View pop_modify_nickname;

	private PopupWindow window;

	private Button nickname_cancel;
	private Button nickname_confirm;
	private EditText nickname_et_delete;
	private View pop_gender;

	private TextView gender_boy;
	private TextView gender_cancel;
	private TextView gender_girl;

	WheelView wheelview2_id;
	TextView tv_cancel_id, tv_ok_id;
	int checkDayIndex = 0;

	DateArrayAdapter hoursArrayAdapter = null;

	String age[] = null;

	PopupWindow mPopupWindow = null;

	String clocksParams = "";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_userinfo);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);

		initView();

		findViewById(R.id.user_rl_age).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {

				CreatePopu("年龄");

				mPopupWindow.setAnimationStyle(R.anim.anim_in);
				mPopupWindow.showAtLocation(arg0, 0, 0, 0);
			}
		});

		findViewById(R.id.user_rl_constellation).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				CreatePopu("星座");

				mPopupWindow.setAnimationStyle(R.anim.anim_in);
				mPopupWindow.showAtLocation(v, 0, 0, 0);
			}
		});

		findViewById(R.id.user_rl_blood).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				CreatePopu("血型");

				mPopupWindow.setAnimationStyle(R.anim.anim_in);
				mPopupWindow.showAtLocation(v, 0, 0, 0);
			}
		});

	}
	
	@Override
	protected void onResume() {
		String result = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result);
		UserInfo userInfo = JSON.parseObject(result, UserInfo.class);
		user_your_singer.setText(userInfo.getData().getUserInfo().getLoveSingers());
		user_your_song.setText(userInfo.getData().getUserInfo().getLoveSongs());
		user_your_introduce.setText(userInfo.getData().getUserInfo().getWhatIsUp());
		super.onResume();
	}


	private void initView() {
		head_tv_left.setVisibility(View.GONE);
		head_tv_title.setText("信息确认");
		head_tv_right.setVisibility(View.VISIBLE);
		head_tv_right.setText("开始");

		userInfo = new HashMap<String, String>();

		pop_modify_nickname = View.inflate(getApplicationContext(), R.layout.pop_modify_nickname, null);
		pop_gender = View.inflate(getApplicationContext(), R.layout.pop_gender, null);

		nickname_et_delete = (EditText) pop_modify_nickname.findViewById(R.id.nickname_et_delete);
		nickname_cancel = (Button) pop_modify_nickname.findViewById(R.id.nickname_cancel);
		nickname_confirm = (Button) pop_modify_nickname.findViewById(R.id.nickname_confirm);

		gender_boy = (TextView) pop_gender.findViewById(R.id.gender_boy);
		gender_cancel = (TextView) pop_gender.findViewById(R.id.gender_cancel);
		gender_girl = (TextView) pop_gender.findViewById(R.id.gender_girl);

		gender_boy.setOnClickListener(this);
		gender_cancel.setOnClickListener(this);
		gender_girl.setOnClickListener(this);

		user_rl_gender.setOnClickListener(this);
		head_tv_right.setOnClickListener(this);
		nickname_et_delete.setOnClickListener(this);
		nickname_cancel.setOnClickListener(this);
		nickname_confirm.setOnClickListener(this);

		user_rl_singer.setOnClickListener(this);
		user_rl_song.setOnClickListener(this);
		user_rl_introduce.setOnClickListener(this);
	}

	void CreatePopu(String flag) {
	
		// 在引用空间之前设置文字左边间距
		//int paddingleft = UICommonUtil.getScreenWidthPixels(this) / 2 - 20;
		WheelViewConstantUtils.setChildView(0, false);

		View popview = LayoutInflater.from(this).inflate(R.layout.mywheelview_age, null, true);// 弹出窗口包含的视图
		initView(popview, flag);

		mPopupWindow = new PopupWindow(popview, LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT, true);
		mPopupWindow.setBackgroundDrawable(new ColorDrawable());
		mPopupWindow.setOutsideTouchable(true);
		mPopupWindow.setFocusable(true);

		popview.findViewById(R.id.bg_img).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
			 mPopupWindow.dismiss();
			}
		});
		
		// 设置弹出窗口的背景
		ColorDrawable cd = new ColorDrawable(0x00000000);
		mPopupWindow.setBackgroundDrawable(cd);
		mPopupWindow.update();
	}

	void initView(View view, String flag) {
		tv_cancel_id = (TextView) view.findViewById(R.id.tv_cancel_info);
		tv_ok_id = (TextView) view.findViewById(R.id.tv_ok_info);
		TvOnclickMethod(tv_cancel_id);
		TvOnclickMethod(tv_ok_id);
		// wheelview1_id = (WheelView) view.findViewById(R.id.wheelview1_id);
		wheelview2_id = (WheelView) view.findViewById(R.id.wheelview2_id);
		// wheelview3_id = (WheelView) view.findViewById(R.id.wheelview3_id);

		// 设置可以循环滑动
		wheelview2_id.setCyclic(false);

		if ("年龄".equals(flag)) {
			age = getResources().getStringArray(R.array.age);
		} else if ("星座".equals(flag)) {
			age = new String[] { "白羊座", "金牛座", "双子座", "巨蟹座", "狮子座", "处女座", "天秤座", "天蝎座", "射手座", "摩羯座", "水瓶座", "双鱼座" };
		} else if ("血型".equals(flag)) {
			age = new String[] { "A", "B", "O", "AB" };
		}

		clocksParams = age[0];

		hoursArrayAdapter = new DateArrayAdapter(this, age, 0);
		wheelview2_id.setViewAdapter(hoursArrayAdapter);
		wheelview2_id.setCurrentItem(0);
		updateHourss(wheelview2_id);

	}

	void TvOnclickMethod(final TextView tv) {
		tv.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				if (tv == tv_ok_id) {
					//Toast.makeText(UserInfoActivity.this, clocksParams, 1).show();
					if ("11".equals(age[0])) {
						user_your_age.setText(clocksParams);
						userInfo.put("age", user_your_age.getText().toString());

					} else if ("白羊座".equals(age[0])) {
						user_your_constell.setText(clocksParams);
						userInfo.put("constellation", user_your_constell.getText().toString());
					} else if ("A".equals(age[0])) {

						user_your_blood.setText(clocksParams);
						userInfo.put("bloodType", user_your_blood.getText().toString());
					}

				}
				if (mPopupWindow != null && mPopupWindow.isShowing()) {
					mPopupWindow.dismiss();
				}
			}
		});
	}

	void updateHourss(final WheelView wheelview) {
		wheelview.addChangingListener(new OnWheelChangedListener() {

			@Override
			public void onChanged(WheelView wheel, int oldValue, int newValue) {
				// TODO Auto-generated method stub
				if (wheelview == wheelview2_id) {
					clocksParams = age[newValue];

					hoursArrayAdapter = new DateArrayAdapter(UserInfoActivity.this, age, newValue);
					wheelview2_id.setViewAdapter(hoursArrayAdapter);
				}
			}
		});
	}


	/**
	 * Adapter for string based wheel. Highlights the current value.
	 */
	private class DateArrayAdapter extends ArrayWheelAdapter<String> {
		// Index of current item
		int currentItem;
		// Index of item to be highlighted
		int currentValue;

		/**
		 * Constructor
		 */
		public DateArrayAdapter(Context context, String[] items, int current) {
			super(context, items);
			this.currentValue = current;
			setTextSize(16);
		}

		@Override
		protected void configureTextView(TextView view) {
			super.configureTextView(view);
			view.setTypeface(Typeface.SANS_SERIF);
			if (currentItem == currentValue) {
				view.setTextColor(Color.WHITE);
			} else {
				view.setTextColor(0x55FFFFFF);
			}

			int height = UICommonUtil.dip2px(getApplicationContext(), 30);
			view.setLayoutParams(new LayoutParams(android.view.ViewGroup.LayoutParams.MATCH_PARENT, height));

			view.setBackgroundColor(getResources().getColor(R.color.transparent));
		}

		@Override
		public View getItem(int index, View cachedView, ViewGroup parent) {
			currentItem = index;

			View view = super.getItem(index, cachedView, parent);
			return view;
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {

		case R.id.nickname_et_delete:
			nickname_et_delete.setText("");
			break;
		case R.id.user_rl_gender:
			showPopupWindow();
			break;
		case R.id.user_rl_singer:
			Intent singer = new Intent(getApplicationContext(), LoveSingersActivity.class);
			singer.putExtra("singer", user_your_singer.getText());
			startActivity(singer);
			break;
		case R.id.user_rl_song:
			Intent song = new Intent(getApplicationContext(), LoveSongsActivity.class);
			song.putExtra("song", user_your_song.getText());
			startActivity(song);
			break;
		case R.id.user_rl_introduce:
			Intent introduce = new Intent(getApplicationContext(), WhatIsUpActivity.class);
			introduce.putExtra("introduce", user_your_introduce.getText());
			startActivity(introduce);
			break;
		case R.id.head_tv_right:
			initData();
			break;
		case R.id.gender_cancel:
			window.dismiss();
			break;
		case R.id.gender_boy:
			user_your_gender.setText(gender_boy.getText().toString());
			userInfo.put("gender", user_your_gender.getText().toString());
			window.dismiss();
			break;
		case R.id.gender_girl:
			user_your_gender.setText(gender_girl.getText().toString());
			userInfo.put("gender", user_your_gender.getText().toString());
			window.dismiss();
			break;

		}
	}

	private void initData() {
		ProgressDialogUtils.show(this);
		userInfo.put(SharePreferenceKeyUtil.token, Constants.getToken());
		new BackgroundTask<String>() {

			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PROFILE, userInfo).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					UserInfo info = JSON.parseObject(result, UserInfo.class);
					if(null != info){
						if (info.getCode() == 0) {
							ToastUtil.show("信息填写成功");
							SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.login_result, result);

							/*if (!TextUtils.isEmpty(Constants.getMine())) {
								Intent intent = new Intent(getApplicationContext(), MainTabActivity.class);
								intent.setType(MainTabActivity.TAB_HOME);
								startActivity(intent);
							}*/
							//BaseApplication.getInstance().exitObjectActivity(LoginActivity.class);
							//BaseApplication.getInstance().exitObjectActivity(RegisterActivity.class);
							
							// --将mine设置为null
							//SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.mine, "");
							finish();
						}

					}
					
				} else {
					ToastUtil.show(R.string.connectfailtoast);
				}
				finish();
				ProgressDialogUtils.dismiss();
			};
		}.run();
	}


	/**
	 * 弹出选择性别
	 */
	private void showPopupWindow() {
		window = new PopupWindow(pop_gender, LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

		// 参数1 爹是谁 挂载的对象 参数2
		int[] location = new int[2]; // 现在数据里面没有值
		// 获取到每个条目view对象的具体位置
		userinfo_ll_parent.getLocationInWindow(location);// 往数组里面写入 x和y两个值
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
		window.showAtLocation(userinfo_ll_parent, Gravity.LEFT | Gravity.BOTTOM, 0, 0);// 在代码中出现的单位
		// window. showAsDropDown(this.findViewById(R.id.rl_bottom), 0, 0);
		TranslateAnimation translate = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f,
				Animation.RELATIVE_TO_PARENT, 1.0f, Animation.RELATIVE_TO_SELF, 0f);
		translate.setDuration(250);
		translate.setFillAfter(true);
		pop_gender.startAnimation(translate);

	}

	@Override
	protected void onDestroy() {
		ProgressDialogUtils.dismiss();
		super.onDestroy();
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
