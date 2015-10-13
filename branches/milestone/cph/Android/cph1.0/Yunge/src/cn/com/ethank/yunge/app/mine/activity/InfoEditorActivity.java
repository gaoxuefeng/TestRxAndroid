package cn.com.ethank.yunge.app.mine.activity;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import kankan.wheel.widget.OnWheelChangedListener;
import kankan.wheel.widget.WheelView;
import kankan.wheel.widget.WheelViewConstantUtils;
import kankan.wheel.widget.adapters.AbstractWheelTextAdapter;
import kankan.wheel.widget.adapters.ArrayWheelAdapter;
import android.app.ActionBar.LayoutParams;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class InfoEditorActivity extends BaseActivity implements OnClickListener {

	@ViewInject(R.id.edit_your_nickname)
	private TextView edit_your_nickname;

	@ViewInject(R.id.edit_gender)
	private RelativeLayout edit_gender; // --性别--
	@ViewInject(R.id.edit_your_gender)
	private TextView edit_your_gender;
	@ViewInject(R.id.edit_age)
	private RelativeLayout edit_age;
	@ViewInject(R.id.edit_your_age)
	private TextView edit_your_age;
	@ViewInject(R.id.edit_constell)
	private RelativeLayout edit_constell;
	@ViewInject(R.id.edit_your_constell)
	private TextView edit_your_constell;
	@ViewInject(R.id.edit_blood)
	private RelativeLayout edit_blood;
	@ViewInject(R.id.edit_your_blood)
	private TextView edit_your_blood;
	@ViewInject(R.id.edit_singer)
	private RelativeLayout edit_singer;
	@ViewInject(R.id.edit_your_singer)
	private TextView edit_your_singer;
	@ViewInject(R.id.edit_song)
	private RelativeLayout edit_song;
	@ViewInject(R.id.edit_your_song)
	private TextView edit_your_song;
	@ViewInject(R.id.edit_introduce)
	private RelativeLayout edit_introduce;
	@ViewInject(R.id.edit_your_introduce)
	private TextView edit_your_introdue;

	@ViewInject(R.id.edit_nickName)
	private RelativeLayout edit_nickName; // --昵称--

	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;

	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;

	@ViewInject(R.id.head_tv_right)
	private TextView head_tv_right;

	@ViewInject(R.id.info_ll_parent)
	private LinearLayout info_ll_parent;// --父布局--

	private View pop_modify_nickname;

	private EditText nickname_et_delete;
	private Button nickname_cancel;
	private Button nickname_confirm;
	private PopupWindow window;

	private UserInfo userInfo;

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
		setContentView(R.layout.activity_info_editor);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);

		initView();

		findViewById(R.id.edit_age).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {

				CreatePopu("年龄");

				mPopupWindow.setAnimationStyle(R.anim.anim_in);
				mPopupWindow.showAtLocation(arg0, 0, 0, 0);
			}
		});

		findViewById(R.id.edit_constell).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				CreatePopu("星座");

				mPopupWindow.setAnimationStyle(R.anim.anim_in);
				mPopupWindow.showAtLocation(v, 0, 0, 0);
			}
		});

		findViewById(R.id.edit_blood).setOnClickListener(new OnClickListener() {
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
		userInfo = JSON.parseObject(result, UserInfo.class);
		edit_your_nickname.setText(userInfo.getData().getUserInfo().getNickName());
		edit_your_gender.setText(userInfo.getData().getUserInfo().getGender());
		edit_your_age.setText(userInfo.getData().getUserInfo().getAge());
		edit_your_constell.setText(userInfo.getData().getUserInfo().getConstellation());
		edit_your_blood.setText(userInfo.getData().getUserInfo().getBloodType());
		edit_your_singer.setText(userInfo.getData().getUserInfo().getLoveSingers());
		edit_your_song.setText(userInfo.getData().getUserInfo().getLoveSongs());
		edit_your_introdue.setText(userInfo.getData().getUserInfo().getWhatIsUp());
		super.onResume();
	}

	private void initView() {

		head_tv_left.setText("个人主页");
		head_tv_title.setText("信息编辑");
		head_tv_right.setVisibility(View.GONE);

		pop_gender = View.inflate(getApplicationContext(), R.layout.pop_gender, null);

		pop_modify_nickname = View.inflate(getApplicationContext(), R.layout.pop_modify_nickname, null);

		edit_gender.setOnClickListener(this);
		edit_age.setOnClickListener(this);
		edit_constell.setOnClickListener(this);
		edit_blood.setOnClickListener(this);
		edit_singer.setOnClickListener(this);
		edit_song.setOnClickListener(this);
		edit_introduce.setOnClickListener(this);
		head_tv_left.setOnClickListener(this);

		edit_nickName.setOnClickListener(this);

		gender_boy = (TextView) pop_gender.findViewById(R.id.gender_boy);
		gender_cancel = (TextView) pop_gender.findViewById(R.id.gender_cancel);
		gender_girl = (TextView) pop_gender.findViewById(R.id.gender_girl);

		gender_boy.setOnClickListener(this);
		gender_cancel.setOnClickListener(this);
		gender_girl.setOnClickListener(this);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.edit_nickName:
			showBoxType();
			
			nickname_et_delete = (EditText) pop_modify_nickname.findViewById(R.id.nickname_et_delete);
			nickname_et_delete.setOnClickListener(this);

			nickname_et_delete.addTextChangedListener(new TextWatcher() {
				@Override
				public void onTextChanged(CharSequence s, int start, int before, int count) {
					
				}
				@Override
				public void beforeTextChanged(CharSequence s, int start, int count, int after) {
					
				}
				
				@Override
				public void afterTextChanged(Editable s) {
					if(s.toString().getBytes().length > 30){
						nickname_et_delete.setText(s.toString().substring(0, 10));
					}
				}
			});
			
			nickname_cancel = (Button) pop_modify_nickname.findViewById(R.id.nickname_cancel);
			nickname_cancel.setOnClickListener(this);

			nickname_confirm = (Button) pop_modify_nickname.findViewById(R.id.nickname_confirm);
			nickname_confirm.setOnClickListener(this);
			
			nickname_iv_exit = (ImageView) pop_modify_nickname.findViewById(R.id.nickname_iv_exit);
			nickname_iv_exit.setOnClickListener(this);
			
			break;
			
		case R.id.nickname_iv_exit:
			nickname_et_delete.setText("");
			break;
		case R.id.nickname_et_delete:
			//nickname_et_delete.setText("");
			break;
		case R.id.edit_gender:
			// initGender();
			showPopupWindow();
			break;
		case R.id.gender_cancel:
			window.dismiss();
			break;
		case R.id.gender_boy:
			final Map<String, String> boy = new HashMap<String, String>();
			boy.put("gender", gender_boy.getText().toString());
			boy.put("token", Constants.getToken());
			new BackgroundTask<String>() {
				@Override
				protected String doWork() throws Exception {
					return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PROFILE, boy).toString();
				}

				protected void onCompletion(String result, Throwable exception, boolean cancelled) {
					if (!TextUtils.isEmpty(result)) {
						UserInfo info = JSON.parseObject(result, UserInfo.class);
						if (info.getCode() == 0) {
							SharePreferencesUtil.saveStringData("login_result", result);
							edit_your_gender.setText(gender_boy.getText().toString());
							window.dismiss();
						}
					} else {
						ToastUtil.show("联网失败");
					}
				};
			}.run();
			break;
		case R.id.gender_girl:
			final Map<String, String> girl = new HashMap<String, String>();
			girl.put("gender", gender_girl.getText().toString());
			girl.put("token", Constants.getToken());
			new BackgroundTask<String>() {
				@Override
				protected String doWork() throws Exception {
					return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PROFILE, girl).toString();
				}

				protected void onCompletion(String result, Throwable exception, boolean cancelled) {
					if (!TextUtils.isEmpty(result)) {
						UserInfo info = JSON.parseObject(result, UserInfo.class);
						if (info.getCode() == 0) {
							SharePreferencesUtil.saveStringData("login_result", result);
							edit_your_gender.setText(gender_girl.getText().toString());
							window.dismiss();
						}
					} else {
						ToastUtil.show("联网失败");
					}
				};
			}.run();
			break;

		case R.id.edit_singer:
			Intent singer = new Intent(getApplicationContext(), LoveSingersActivity.class);
			singer.putExtra("singer", edit_your_singer.getText());
			startActivity(singer);
			break;
		case R.id.edit_song:
			Intent song = new Intent(getApplicationContext(), LoveSongsActivity.class);
			song.putExtra("song", edit_your_song.getText());
			startActivity(song);
			break;
		case R.id.edit_introduce:
			Intent introduce = new Intent(getApplicationContext(), WhatIsUpActivity.class);
			introduce.putExtra("introduce", edit_your_introdue.getText());
			startActivity(introduce);
			break;
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.nickname_cancel:
			window.dismiss();
			break;
		case R.id.nickname_confirm:
			String name = nickname_et_delete.getText().toString();
			if(name.length() < 1){
				ToastUtil.show("昵称不能为空");
				return ;
			}
			
			final Map<String, String> nickname = new HashMap<String, String>();
			nickname.put("nickName", nickname_et_delete.getText().toString());
			nickname.put("token", Constants.getToken());
			new BackgroundTask<String>() {
				@Override
				protected String doWork() throws Exception {
					return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PROFILE, nickname).toString();
				}

				protected void onCompletion(String result, Throwable exception, boolean cancelled) {
					if (!TextUtils.isEmpty(result)) {
						UserInfo info = JSON.parseObject(result, UserInfo.class);
						if (info.getCode() == 0) {
							ToastUtil.show("昵称修改成功");
							SharePreferencesUtil.saveStringData("login_result", result);
							edit_your_nickname.setText(nickname_et_delete.getText().toString());
						}

					} else {
						ToastUtil.show("联网失败");
					}

					window.dismiss();
				};
			}.run();
			break;
		}
	}

	/**
	 * 弹出选择性别
	 */
	private void showPopupWindow() {
		window = new PopupWindow(pop_gender, LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

		// 参数1 爹是谁 挂载的对象 参数2
		int[] location = new int[2]; // 现在数据里面没有值
		// 获取到每个条目view对象的具体位置
		info_ll_parent.getLocationInWindow(location);// 往数组里面写入 x和y两个值
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
		window.showAtLocation(info_ll_parent, Gravity.LEFT | Gravity.BOTTOM, 0, 0);// 在代码中出现的单位
		// window. showAsDropDown(this.findViewById(R.id.rl_bottom), 0, 0);
		TranslateAnimation translate = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_PARENT, 1.0f, Animation.RELATIVE_TO_SELF, 0f);
		translate.setDuration(250);
		translate.setFillAfter(true);
		pop_gender.startAnimation(translate);

	}

	/**
	 * 弹出修改昵称的pop
	 */
	private void showBoxType() {
		int width = UICommonUtil.dip2px(getApplicationContext(), 300);
		int height = UICommonUtil.dip2px(getApplicationContext(), 185);
		window = new PopupWindow(pop_modify_nickname, width, height);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(info_ll_parent, Gravity.CENTER, 0, 0);

	}

	void CreatePopu(String flag) {

		// 在引用空间之前设置文字左边间距
		int paddingleft = UICommonUtil.getScreenWidthPixels(this) / 2 - 50;
		WheelViewConstantUtils.setChildView(paddingleft, false);

		View popview = LayoutInflater.from(this).inflate(R.layout.mywheelview_age, null, true);// 弹出窗口包含的视图

		initView(popview, flag);

		mPopupWindow = new PopupWindow(popview, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, true);
		mPopupWindow.setBackgroundDrawable(new ColorDrawable());
		mPopupWindow.setOutsideTouchable(false);
		mPopupWindow.setFocusable(true);

		// 设置弹出窗口的背景
		ColorDrawable cd = new ColorDrawable(0x99000000);
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
					//Toast.makeText(InfoEditorActivity.this, clocksParams, 1).show();
					if ("11".equals(age[0])) {
						modify_age();

					} else if ("白羊座".equals(age[0])) {

						modify_constell();

					} else if ("A".equals(age[0])) {

						modify_blood();
					}

				}
				if (mPopupWindow != null && mPopupWindow.isShowing()) {
					mPopupWindow.dismiss();
				}
			}

		});
	}

	private void modify_age() {
		final Map<String, String> age = new HashMap<String, String>();
		age.put("age", clocksParams);
		age.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PROFILE, age).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					UserInfo info = JSON.parseObject(result, UserInfo.class);
					if (info.getCode() == 0) {
						SharePreferencesUtil.saveStringData("login_result", result);
						edit_your_age.setText(clocksParams);
						mPopupWindow.dismiss();
					}
				} else {
					ToastUtil.show("联网失败");
				}
			};
		}.run();
	}

	private void modify_constell() {
		final Map<String, String> constellation = new HashMap<String, String>();
		constellation.put("constellation", clocksParams);
		constellation.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PROFILE, constellation).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					UserInfo info = JSON.parseObject(result, UserInfo.class);
					if (info.getCode() == 0) {
						SharePreferencesUtil.saveStringData("login_result", result);
						edit_your_constell.setText(clocksParams);
						mPopupWindow.dismiss();
					}
				} else {
					ToastUtil.show("联网失败");
				}
			};
		}.run();
	}

	private void modify_blood() {
		final Map<String, String> blood = new HashMap<String, String>();
		blood.put("bloodType", clocksParams);
		blood.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PROFILE, blood).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					UserInfo info = JSON.parseObject(result, UserInfo.class);
					if (info.getCode() == 0) {
						SharePreferencesUtil.saveStringData("login_result", result);
						edit_your_blood.setText(clocksParams);
						mPopupWindow.dismiss();
					}
				} else {
					ToastUtil.show("联网失败");
				}
			};
		}.run();
	}

	void updateHourss(final WheelView wheelview) {
		wheelview.addChangingListener(new OnWheelChangedListener() {

			@Override
			public void onChanged(WheelView wheel, int oldValue, int newValue) {
				// TODO Auto-generated method stub
				if (wheelview == wheelview2_id) {
					clocksParams = age[newValue];

					hoursArrayAdapter = new DateArrayAdapter(InfoEditorActivity.this, age, newValue);
					wheelview2_id.setViewAdapter(hoursArrayAdapter);
				}
			}
		});
	}

	/**
	 * Day adapter
	 * 
	 */
	private final int daysCount = 30;
	private View popview;

	private ImageView nickname_iv_exit;

	private class DayArrayAdapter extends AbstractWheelTextAdapter {
		// Count of days to be shown

		// Calendar
		Calendar calendar;

		/**
		 * Constructor
		 */
		protected DayArrayAdapter(Context context, Calendar calendar) {
			super(context, R.layout.time2_day, NO_RESOURCE);
			this.calendar = calendar;

			setItemTextResource(R.id.time2_monthday);
		}

		@Override
		public int getItemsCount() {
			return daysCount + 1;
		}

		@Override
		protected CharSequence getItemText(int index) {
			return "";
		}
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
			view.setLayoutParams(new LayoutParams(android.view.ViewGroup.LayoutParams.WRAP_CONTENT, 120));

			view.setBackgroundColor(Color.parseColor("#1e1e1e"));
		}

		@Override
		public View getItem(int index, View cachedView, ViewGroup parent) {
			currentItem = index;

			View view = super.getItem(index, cachedView, parent);
			return view;
		}
	}

}