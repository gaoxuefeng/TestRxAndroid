package cn.com.ethank.yunge.app.home.activity;

import java.io.File;
import java.lang.ref.WeakReference;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import kankan.wheel.widget.OnWheelChangedListener;
import kankan.wheel.widget.WheelView;
import kankan.wheel.widget.WheelViewConstantUtils;
import kankan.wheel.widget.adapters.AbstractWheelTextAdapter;
import kankan.wheel.widget.adapters.ArrayWheelAdapter;
import android.annotation.SuppressLint;
import android.app.ActionBar.LayoutParams;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Message;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.PredeteFragment;
import cn.com.ethank.yunge.app.home.adapter.BoxListAdapter;
import cn.com.ethank.yunge.app.home.adapter.MyGroupAdapter;
import cn.com.ethank.yunge.app.home.adapter.PreAdvertImagePagerAdapter;
import cn.com.ethank.yunge.app.home.bean.BoxInfo;
import cn.com.ethank.yunge.app.home.bean.BoxInfo.Data.Box;
import cn.com.ethank.yunge.app.home.bean.HomeInfo;
import cn.com.ethank.yunge.app.home.bean.OrderInfo;
import cn.com.ethank.yunge.app.home.bean.TimeInfo;
import cn.com.ethank.yunge.app.home.head.ImageHandler;
import cn.com.ethank.yunge.app.home.head.ViewPagerAdapter;
import cn.com.ethank.yunge.app.home.utils.Utility;
import cn.com.ethank.yunge.app.mine.activity.MapActivity;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.PopupWindowUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.VerifyStringType;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;

@SuppressLint("ValidFragment")
public class MerchantDetailActivity extends Activity implements OnClickListener {

	protected static long serviceTime = 0;

	public ImageHandler handler = new ImageHandler(new WeakReference<MerchantDetailActivity>(this));

	public ViewPager vp;

	WheelView wheelview1_id, wheelview2_id, wheelview3_id;
	TextView tv_cancel_id, tv_ok_id;
	int checkDayIndex = 0;
	DayArrayAdapter dayArrayAdapter = null;
	DateArrayAdapter hoursArrayAdapter = null;
	DateArrayAdapter timesArrayAdapter = null;

	String times[] = null;
	String hours[] = null;
	public static String hour;

	PopupWindow mPopupWindow = null;

	String daysParams = "";
	String clocksParams = "";
	String timesParams = "";

	private List<Box> boxInfos;
	private LinearLayout detail_rl_pre_time;
	public Box box1;
	public HomeInfo homeInfo;
	String[] imageUrls = new String[] {};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		initView();

	}

	private void initView() {
		setContentView(R.layout.fragment_merchant_detail);

		merchant_view = findViewById(R.id.merchant_view);

		head_tv_left = (TextView) findViewById(R.id.head_tv_left);
		head_tv_left.setOnClickListener(this);

		detail_ll_parent = (LinearLayout) findViewById(R.id.detail_ll_parent);

		if (PredeteFragment.currentHomeInfo != null) {
			homeInfo = PredeteFragment.currentHomeInfo;
		}

		timeCount = new TimeCount(600000, 1000);

		/**
		 * 预订的时间
		 */
		pre_detail_tv_day = (TextView) findViewById(R.id.pre_detail_tv_day);
		pre_detail_tv_hour = (TextView) findViewById(R.id.pre_detail_tv_hour);
		pre_detail_tv_duration = (TextView) findViewById(R.id.pre_detail_tv_duration);

		// --拨打电话
		detail_ll_phone = (LinearLayout) findViewById(R.id.detail_ll_phone);
		detail_ll_phone.setOnClickListener(this);

		detail_lv_box = (ListView) findViewById(R.id.detail_lv_box);

		// --拨打电话弹出提示框
		pop_utils = (RelativeLayout) View.inflate(this, R.layout.pop_utils, null);
		pop_tv_text2 = (TextView) pop_utils.findViewById(R.id.pop_tv_text2);
		pop_tv_text2.setText("确定要接通电话？");
		pop_tv_text1 = (TextView) pop_utils.findViewById(R.id.pop_tv_text1);
		pop_tv_text1.setVisibility(View.GONE);
		pop_but_left = (Button) pop_utils.findViewById(R.id.pop_but_left);
		pop_but_left.setText("取消");
		pop_but_left.setOnClickListener(this);
		pop_but_right = (Button) pop_utils.findViewById(R.id.pop_but_right);
		pop_but_right.setText("确定");
		pop_but_right.setOnClickListener(this);

		if (homeInfo != null) {
			pre_detail_tv_showName = (TextView) findViewById(R.id.pre_detail_tv_showName);
			pre_detail_tv_showName.setText(homeInfo.getKTVName());
			SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.showName, homeInfo.getKTVName());

			pre_detail_tv_fen = (TextView) findViewById(R.id.pre_detail_tv_fen);
			pre_detail_tv_fen.setText(homeInfo.getRating() / 10 + "分");

			pre_detail_rb_start = (RatingBar) findViewById(R.id.pre_detail_rb_start);
			pre_detail_rb_start.setRating((float) (homeInfo.getRating() / 10));

			detail_tv_address = (TextView) findViewById(R.id.detail_tv_address);
			detail_tv_address.setText(homeInfo.getAddress());

			detail_tv_address.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					BoxDetail myRoomInfoBean = new BoxDetail();
					myRoomInfoBean.setLat(homeInfo.getLat());
					myRoomInfoBean.setLng(homeInfo.getLng());
					myRoomInfoBean.setKtvName(homeInfo.getKTVName());
					myRoomInfoBean.setAddress(homeInfo.getAddress());
					Intent intent = new Intent(getApplicationContext(), MapActivity.class);
					Bundle bundle = new Bundle();
					bundle.putSerializable("myRoomInfoBean", myRoomInfoBean);
					intent.putExtras(bundle);
					startActivity(intent);

				}
			});
			imageUrls = homeInfo.getImageUrlList();
		}

		initDataBoxType();

		onViewPager();

		if (!TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.preState))) {
			SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.preState);
		}

		CreatePopu();
	}

	// 放置点对应view对象的集合
	private List<View> viewList = new ArrayList<View>();

	/**
	 * 轮播图
	 * @return
	 */
	private RelativeLayout onViewPager() {
		RelativeLayout relativeLayout = (RelativeLayout) findViewById(R.id.detail_rl_head);
		// 获取数据后,需要构建点,构建viewpager的数据适配器
		RelativeLayout.LayoutParams llParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT,
				RelativeLayout.LayoutParams.WRAP_CONTENT);

		// 放置点的线性布局,规则由其夫控件,相对布局提供
		LinearLayout linearLayout = new LinearLayout(this);
		// 要将线性布局放到右下角
		llParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
		llParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
		relativeLayout.addView(linearLayout, llParams);

		viewList.clear();
		for (int i = 0; i < imageUrls.length; i++) {
			View view = new View(this);
			if (i == 0) {
				view.setBackgroundResource(R.drawable.schedule_selected_bg);
			} else {
				view.setBackgroundResource(R.drawable.schedule_unselected_bg);
			}

			LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(UICommonUtil.dip2px(this, 18), UICommonUtil.dip2px(this, 2));
			layoutParams.setMargins(0, 0, UICommonUtil.dip2px(this, 6), UICommonUtil.dip2px(this, 6));
			linearLayout.addView(view, layoutParams);

			viewList.add(view);
		}

		vp = (ViewPager) findViewById(R.id.vp);
		
		RelativeLayout layout = (RelativeLayout) findViewById(R.id.merchant_head);
	
		List<View> views = new ArrayList<View>();
		if (imageUrls.length > 0) {
			for (int i = 0; i < imageUrls.length; i++) {
				ImageView imageView = new ImageView(this);
				imageView.setScaleType(ScaleType.CENTER_CROP);
				views.add(imageView);
			}
		} else {
			ImageView imageView = new ImageView(this);
			imageView.setScaleType(ScaleType.CENTER_CROP);
			imageView.setBackgroundResource(R.drawable.schedule_defaul_head_img);
			views.add(imageView);
		}

		vp.setAdapter(new ViewPagerAdapter(views, this, imageUrls));
		vp.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
			// 配合Adapter的currentItem字段进行设置。
			@Override
			public void onPageSelected(int arg0) {
				int index = arg0 % imageUrls.length;
				for (int i = 0; i < imageUrls.length; i++) {
					View view = viewList.get(i);
					if (index == i) {
						view.setBackgroundResource(R.drawable.schedule_selected_bg);
					} else {
						view.setBackgroundResource(R.drawable.schedule_unselected_bg);
					}
				}
				handler.sendMessage(Message.obtain(handler, ImageHandler.MSG_PAGE_CHANGED, arg0, 0));
			}

			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {
			}

			// 覆写该方法实现轮播效果的暂停和恢复
			@Override
			public void onPageScrollStateChanged(int arg0) {
				switch (arg0) {
				case ViewPager.SCROLL_STATE_DRAGGING:
					handler.sendEmptyMessage(ImageHandler.MSG_KEEP_SILENT);
					break;
				case ViewPager.SCROLL_STATE_IDLE:
					handler.sendEmptyMessageDelayed(ImageHandler.MSG_UPDATE_IMAGE, ImageHandler.MSG_DELAY);
					break;
				default:
					break;
				}
			}
		});

		// 默认在中间，使用户看不到边界
		vp.setCurrentItem(imageUrls.length * 1000);
		// 开始轮播效果
		handler.sendEmptyMessageDelayed(ImageHandler.MSG_UPDATE_IMAGE, ImageHandler.MSG_DELAY);

		vp.setFocusable(true);
		vp.setFocusableInTouchMode(true);
		vp.requestFocus();

		TextView head_tv_title = (TextView) layout.findViewById(R.id.head_tv_title);
		head_tv_title.setText("KTV详情");

		ListView item_lv_group = (ListView) findViewById(R.id.item_lv_group);
		if (myGroupAdapter == null) {
			myGroupAdapter = new MyGroupAdapter(this);
		}
		item_lv_group.setAdapter(myGroupAdapter);
		if (item_lv_group != null) {
			Utility.setListViewHeightBasedOnChildren(item_lv_group);
		}

		detail_rl_pre_time = (LinearLayout) findViewById(R.id.detail_rl_pre_time);
		detail_rl_pre_time.setOnClickListener(this);

		return layout;
	}

	
	/**
	 * 获取网络数据
	 */
	private void initDataBoxType() {

		if (homeInfo == null) {
			return;
		} else if (timeInfo == null) {
			timeInfo = new TimeInfo();
		}

		final Map<String, String> map = new HashMap<String, String>();
		if (!TextUtils.isEmpty(timeInfo.getDay())) {
			SimpleDateFormat dateFormat = new SimpleDateFormat("MM月dd日");
			Date date = null;
			try {
				date = dateFormat.parse(timeInfo.getDay());
				dateFormat = new SimpleDateFormat("MM-dd");
				String day = dateFormat.format(date);
				map.put("day", day);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			try {
				if (timesParams != null && timesParams.contains("小")) {
					map.put("duration", timesParams.substring(0, timesParams.indexOf("小")));
				}

			} catch (Exception e) {
				e.printStackTrace();
			}

			map.put("hour", clocksParams);
			map.put("token", Constants.getToken());
		}

		map.put("BLDKTVId", homeInfo.getBLDKTVId());

		new BackgroundTask<String>() {
			private BoxInfo boxInfo2;
			private BoxListAdapter boxListAdapter;

			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.querytime, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (result != null) {
					boxInfo2 = (BoxInfo) JSON.parseObject(result, BoxInfo.class);
					if(boxInfo2 != null){
						
						if (boxInfo2.getCode() != 0) {
							// ToastUtil.show(boxInfo2.getMessage());
						} else {
							String serviceTimeStr = boxInfo2.getData().getDay();
							if (serviceTimeStr == null || serviceTimeStr.isEmpty()) {
								serviceTimeStr = System.currentTimeMillis() + "";
							}
							if (VerifyStringType.isFloatOrNum(serviceTimeStr)) {
								try {
									long serviceTime = Long.parseLong(serviceTimeStr);
									MerchantDetailActivity.serviceTime = serviceTime;
								} catch (Exception e) {
									e.printStackTrace();
									serviceTime = System.currentTimeMillis();
								}
								
							}
							if (!TextUtils.isEmpty(pre_detail_tv_day.getText())) {
								pre_detail_tv_day.setText(timeInfo.getDay());
								pre_detail_tv_hour.setText(timeInfo.getHour());
								pre_detail_tv_duration.setText(timeInfo.getTime());
							} else {
								SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd");
								Date date = null;
								try {
									date = dateFormat.parse(boxInfo2.getData().getDay());
									dateFormat = new SimpleDateFormat("MM月dd日");
									String day = dateFormat.format(date);
									pre_detail_tv_day.setText(day);
									
									timeInfo.setDay(day);
									
								} catch (ParseException e) {
									e.printStackTrace();
								}
								hour = boxInfo2.getData().getHour();
								homeInfo.getBusinessHoursEnd();
								homeInfo.getBusinessHoursStart();
								pre_detail_tv_hour.setText(boxInfo2.getData().getHour() + "起");
								pre_detail_tv_duration.setText("唱" + boxInfo2.getData().getDuration() + "小时");
								
								timeInfo.setHour(pre_detail_tv_hour.getText() + "");
								timeInfo.setTime(pre_detail_tv_duration.getText() + "");
								
								boxInfos = boxInfo2.getData().getRoomQueryList();
							}
							boxInfos = boxInfo2.getData().getRoomQueryList();
							/*
							 * if (myBaseAdapter == null) { myBaseAdapter = new
							 * MyBaseAdapter(); }
							 * 
							 * detail_lv_box.setAdapter(myBaseAdapter);
							 */
							boxListAdapter = new BoxListAdapter(MerchantDetailActivity.this, boxInfos, homeInfo, pre_detail_tv_day, pre_detail_tv_duration,
									pre_detail_tv_hour);
							if (boxListAdapter == null) {
								boxListAdapter = new BoxListAdapter(getApplicationContext(), boxInfos, homeInfo, pre_detail_tv_day,
										pre_detail_tv_duration, pre_detail_tv_hour);
							}
							detail_lv_box.setAdapter(boxListAdapter);
							
							if (detail_lv_box != null) {
								Utility.setListViewHeightBasedOnChildren(detail_lv_box);
							}
							
						}
					}
				} else {
					ToastUtil.show(R.string.connectfailtoast);
				}
			};
		}.run();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.detail_rl_pre_time:
			if (TextUtils.isEmpty(pre_detail_tv_day.getText())) {
				return;
			}
			mPopupWindow.setAnimationStyle(R.anim.anim_in);
			mPopupWindow.showAtLocation(detail_ll_parent, Gravity.CENTER, 0, 0);
			merchant_view.setVisibility(View.VISIBLE);
			break;
		case R.id.detail_ll_phone:
			PopupWindowUtils.show(this, pop_utils, detail_ll_parent,false);
			break;
		case R.id.pop_but_left:
			PopupWindowUtils.dismiss();
			break;
		case R.id.pop_but_right:
			PopupWindowUtils.dismiss();
			Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + homeInfo.getPhoneNum()));
			startActivity(intent);
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

		}

		@Override
		public void onFinish() {
			SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.preState);
		}
	}

	/**
	 * 点击预订按钮，跳转到预订支付界面
	 * 
	 * @param name
	 * @param id
	 */
	private void onPredete(int id, String name) {

		if (!TextUtils.isEmpty(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.preState))) {
			ToastUtil.show("请您10分钟之后再来预订");
			return;
		}

		final Map<String, String> map = new HashMap<String, String>();
		map.put("BLDKTVId", homeInfo.getBLDKTVId());
		SimpleDateFormat dateFormat = new SimpleDateFormat("MM月dd日");
		Date date = null;
		try {
			date = dateFormat.parse(pre_detail_tv_day.getText() + "");
			dateFormat = new SimpleDateFormat("MM-dd");
			String day = dateFormat.format(date);
			map.put("day", day);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		String duration = pre_detail_tv_duration.getText().toString();
		map.put("duration", duration.subSequence(1, duration.indexOf("小")) + "");
		String hour = pre_detail_tv_hour.getText().toString();
		map.put("hour", hour.substring(0, hour.indexOf("起")));
		map.put("boxTypeId", id + "");
		map.put("boxTypeName", name);
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.genorder, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					OrderInfo orderInfo = JSON.parseObject(result, OrderInfo.class);
					if(orderInfo != null){
						if (orderInfo.getCode() == 0) {
							SharePreferencesUtil.deleteData("orderInfo");
							SharePreferencesUtil.saveStringData("orderInfo", result);
							// --跳转到订单支付界面--
							Intent order = new Intent(getApplicationContext(), OrderFormActivity.class);
							startActivity(order);
						} else {
							ToastUtil.show(orderInfo.getMessage());
						}
					}

				} else {
					ToastUtil.show(R.string.connectfailtoast);
				}
			};
		}.run();
	}

	void CreatePopu() {
		//WheelViewConstantUtils.setChildView(0, false);

		int lineHeight = UICommonUtil.dip2px(this, 80);
		WheelViewConstantUtils.setChildView(0, false, 6, lineHeight);
		View popview = LayoutInflater.from(this).inflate(R.layout.mywheelview, null, true);// 弹出窗口包含的视图

		initView(popview);

		int width = UICommonUtil.dip2px(this, 300);
		int height = UICommonUtil.dip2px(this, 300);

		mPopupWindow = new PopupWindow(popview, width, height, true);

		mPopupWindow.setOutsideTouchable(true);
		mPopupWindow.setFocusable(true);

		// 设置弹出窗口的背景
		ColorDrawable cd = new ColorDrawable(0x00000000);
		mPopupWindow.setBackgroundDrawable(cd);
		mPopupWindow.update();

		if (!mPopupWindow.isShowing()) {
			merchant_view.setVisibility(View.GONE);
		}

	
		mPopupWindow.setOnDismissListener(new OnDismissListener() {
			@Override
			public void onDismiss() {
				merchant_view.setVisibility(View.GONE);
			}
		});
	}

	void initView(View view) {
		tv_cancel_id = (TextView) view.findViewById(R.id.tv_cancel_id);
		tv_ok_id = (TextView) view.findViewById(R.id.tv_ok_id);
		TvOnclickMethod(tv_cancel_id);
		TvOnclickMethod(tv_ok_id);
		wheelview1_id = (WheelView) view.findViewById(R.id.wheelview1_id);
		wheelview2_id = (WheelView) view.findViewById(R.id.wheelview2_id);
		wheelview3_id = (WheelView) view.findViewById(R.id.wheelview3_id);
		// 设置可以循环滑动
		wheelview1_id.setCyclic(false);
		wheelview2_id.setCyclic(false);
		wheelview3_id.setCyclic(false);

		hours = getResources().getStringArray(R.array.pre_hours);
		times = getResources().getStringArray(R.array.pre_times);

		clocksParams = hours[0];
		timesParams = times[0];

		hoursArrayAdapter = new DateArrayAdapter(this, hours, 0);
		wheelview2_id.setViewAdapter(hoursArrayAdapter);
		wheelview2_id.setCurrentItem(0);
		updateHourss(wheelview2_id);

		// addFiveItem();
		timesArrayAdapter = new DateArrayAdapter(this, times, 0);
		wheelview3_id.setViewAdapter(timesArrayAdapter);
		wheelview3_id.setCurrentItem(0);
		updateHourss(wheelview3_id);

		Calendar calendar = Calendar.getInstance(Locale.US);
		if (serviceTime == 0) {
			// 中国在东8区
			// 如果时间超过23:30,则把时间设为下一天时间
			if ((calendar.getTimeInMillis() % (24 * 60 * 60 * 1000)) > ((23.5 - 8) * 60 * 60 * 1000)) {
				calendar.setTimeInMillis(calendar.getTimeInMillis() + (30 * 60 * 1000));
			}
			calendar.setTimeInMillis(System.currentTimeMillis());
		} else {
			calendar.setTimeInMillis(serviceTime);
		}

		dayArrayAdapter = new DayArrayAdapter(this, calendar);
		wheelview1_id.setViewAdapter(dayArrayAdapter);
		checkDayIndex = (daysCount / 2) - 15;
		wheelview1_id.setCurrentItem(checkDayIndex);// 默认选中30天中间那一天就是目前时间
		updateHourss(wheelview1_id);

	}

	private BoxInfo boxInfo;

	void TvOnclickMethod(final TextView tv) {
		
		final String[] time1 = getResources().getStringArray(R.array.pre_index);
		tv.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				if (tv == tv_ok_id) {
					// Toast.makeText(this, daysParams + "---" + clocksParams +
					// "----" + timesParams, 1).show();

					timeInfo.setDay(daysParams);

					timeInfo.setHour(clocksParams + "起");

					// timeInfo.setTime(timesParams.substring(0,
					// timesParams.indexOf("小")));
					timeInfo.setTime("唱" + timesParams);
					initDataBoxType();

				}

				if (tv == tv_cancel_id) {
					timeInfo.setDay(pre_detail_tv_day.getText() + "");
					String hour = pre_detail_tv_hour.getText().toString();
					// timeInfo.setHour(hour.subSequence(0, hour.indexOf("起")) +
					// "起");
					timeInfo.setHour(hour);
					String dutation = pre_detail_tv_duration.getText().toString();

					// timeInfo.setTime("唱"+dutation.subSequence(1,
					// dutation.indexOf("小")) + "小时");
					timeInfo.setTime(dutation);
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
				if (wheelview == wheelview1_id) {
					checkDayIndex = newValue;
					wheelview1_id.setViewAdapter(dayArrayAdapter);
				} else if (wheelview == wheelview2_id) {
					setWheelView2Adapter(newValue);
				} else {
					timesParams = times[newValue];

					timesArrayAdapter = new DateArrayAdapter(getApplicationContext(), times, newValue);
					wheelview3_id.setViewAdapter(timesArrayAdapter);
				}
			}
		});
	}

	@SuppressLint("SimpleDateFormat")
	private void setWheelView2Adapter(int newValue) {
		clocksParams = hours[newValue];

		hoursArrayAdapter = new DateArrayAdapter(this, hours, newValue);
		wheelview2_id.setViewAdapter(hoursArrayAdapter);

		int t = 0;
		try {
			SimpleDateFormat dfs = new SimpleDateFormat("HH:mm");
			java.util.Date begin;

			// 判断是否在次日的凌晨，如果在凌晨则直接判断选中的时间倒营业结束时间还剩下多少时间，如果不在临城需要夸天的话，则根据当天所有可预订的时间再加上次日的凌晨时间
			if (chooesTimeToSeleStartTime(clocksParams) && chooesTimeToSeleEndTime(clocksParams)) { // 开始是当天12:00
				// 结束是第二天凌晨06:00
				begin = dfs.parse(clocksParams);
			} else {
				int count = hours.length;
				t = (count - newValue) / 2;
				begin = dfs.parse("00:00");
			}

			java.util.Date end = dfs.parse(homeInfo.getBusinessHoursEnd());
			long between = (end.getTime() - begin.getTime()) / 1000;//
			long hour = between % (24 * 3600) / 3600;

			t += hour;

			String[] pre_times = getResources().getStringArray(R.array.pre_times);
			if (t > 8) {
				times = new String[8];
			} else {
				times = new String[t];
			}
			for (int j = 0; j < t; j++) {
				if (j >= 8) {
					break;
				}
				times[j] = pre_times[j];
			}

			// addFiveItem();
			wheelview3_id.setCurrentItem(0);
			timesArrayAdapter = new DateArrayAdapter(this, times, 0);
			wheelview3_id.setViewAdapter(timesArrayAdapter);
		} catch (Exception e) {
		}
	}

	// 这里比较的是选择的时间是否大于营业的开始时间
	private boolean chooesTimeToSeleStartTime(String chooesStartTme) {
		// java 比较时间大小
		String seleStartTime = "00:00";
		java.text.DateFormat df = new java.text.SimpleDateFormat("HH:mm");
		java.util.Calendar c1 = java.util.Calendar.getInstance();
		java.util.Calendar c2 = java.util.Calendar.getInstance();
		try {
			c1.setTime(df.parse(chooesStartTme));
			c2.setTime(df.parse(seleStartTime));
		} catch (java.text.ParseException e) {
			System.err.println("格式不正确");
		}
		int result = c1.compareTo(c2);
		if (result == 0)
			// System.out.println("c1相等c2");
			return true;
		else if (result < 0)
			// System.out.println("c1小于c2");
			return false;
		else
			// System.out.println("c1大于c2");
			return true;
	}

	// 这里比较的是选择的时间是否小于营业的开始时间
	private boolean chooesTimeToSeleEndTime(String chooesStartTme) {
		// java 比较时间大小
		String seleEndTime = homeInfo.getBusinessHoursEnd();
		java.text.DateFormat df = new java.text.SimpleDateFormat("HH:mm");
		java.util.Calendar c1 = java.util.Calendar.getInstance();
		java.util.Calendar c2 = java.util.Calendar.getInstance();
		try {
			c1.setTime(df.parse(chooesStartTme));
			c2.setTime(df.parse(seleEndTime));
		} catch (java.text.ParseException e) {
			System.err.println("格式不正确");
		}
		int result = c1.compareTo(c2);
		if (result == 0)
			// System.out.println("c1相等c2");
			return false;
		else if (result < 0)
			// System.out.println("c1小于c2");
			return true;
		else
			// System.out.println("c1大于c2");
			return false;
	}

	/**
	 * Day adapter
	 * 
	 */
	private final int daysCount = 30;

	private TimeInfo timeInfo;

	// private MyBaseAdapter myBaseAdapter;
	private MyGroupAdapter myGroupAdapter;
	private LinearLayout detail_ll_phone;
	private TextView pre_detail_tv_day;
	private TextView pre_detail_tv_hour;
	private TextView pre_detail_tv_duration;
	private ListView detail_lv_box;
	private TextView pre_detail_tv_showName;
	private TextView pre_detail_tv_fen;
	private RatingBar pre_detail_rb_start;
	private TextView detail_tv_address;
	private TimeCount timeCount;
	private View merchant_view;

	private RelativeLayout pop_utils;

	private TextView pop_tv_text2;

	private Button pop_but_left;

	private Button pop_but_right;

	private TextView pop_tv_text1;

	private LinearLayout detail_ll_parent;

	private TextView head_tv_left;

	private class DayArrayAdapter extends AbstractWheelTextAdapter {
		// Count of days to be shown

		// Calendar
		Calendar calendar;

		/**
		 * Constructor
		 */
		@SuppressLint("ResourceAsColor")
		protected DayArrayAdapter(Context context, Calendar calendar) {
			super(context, R.layout.time2_day, NO_RESOURCE);
			this.calendar = calendar;

			setItemTextResource(R.id.time2_monthday);
		
		}

		@Override
		public View getItem(int position, View cachedView, ViewGroup parent) {
			int day = -daysCount / 2 + position + 15;
			Calendar newCalendar = (Calendar) calendar.clone();

			newCalendar.roll(Calendar.DAY_OF_YEAR, day);
			// newCalendar.roll(Calendar.DAY_OF_YEAR, daysCount);

			View view = super.getItem(position, cachedView, parent);

			
			view.getLayoutParams().height = UICommonUtil.dip2px(getApplicationContext(), 40);
			view.setPadding(0, UICommonUtil.dip2px(getApplicationContext(), 4), 0, 0);
			TextView weekday = (TextView) view.findViewById(R.id.time2_weekday);
			TextView monthday = (TextView) view.findViewById(R.id.time2_monthday);
		
			weekday.setPadding(0, 10, 0, 0);
			monthday.setPadding(0, 10, 0, 0);

			// DateFormat format = new SimpleDateFormat("EEE");
			DateFormat format2 = new SimpleDateFormat("MM月dd日");

			weekday.setText(format2.format(newCalendar.getTime()));
			// monthday.setText(format.format(newCalendar.getTime()));

			if (checkDayIndex == position) {
				// monthday.setText("Today");
				daysParams = weekday.getText().toString();

				// 发给后天的日期
				String week = weekday.getText().toString();
				timeInfo.setDay(week);
				// String month = monthday.getText().toString();
				// timeInfo.setMonth(month);

				monthday.setTextColor(Color.WHITE);
				weekday.setTextColor(Color.WHITE);
				
				if (wheelview1_id.getCurrentItem() == 0) {
					getPreTime2();
				} else {
					getPreTime();
				}

				wheelview2_id.setCurrentItem(0);

				int oldcurrentitem = wheelview2_id.getCurrentItem();
				setWheelView2Adapter(oldcurrentitem);

			} else {
				monthday.setTextColor(0x55FFFFFF);
				weekday.setTextColor(0x55FFFFFF);
			
			}
			monthday.setTypeface(Typeface.SANS_SERIF);
			weekday.setTypeface(Typeface.SANS_SERIF);
			return view;
		}

		/**
		 * 获取时间轮时间
		 */
		private void getPreTime2() {
			getPreTime();
			int oneIndex = 0;
			int length = 0;
			String[] hours3 = null;

			for (int i = 0; i < hours.length; i++) {
				if (MerchantDetailActivity.hour.equals(hours[i])) {
					oneIndex = i;
					length = hours.length - oneIndex;
					hours3 = new String[hours.length - oneIndex];
				}
			}

			if (length != 0 && hours3 != null) {
				for (int i = 0; i < length; i++) {
					hours3[i] = hours[oneIndex + i];
				}
				hours = new String[length];
			}
			if (length != 0) {
				for (int i = 0; i < length; i++) {
					hours[i] = hours3[i];
				}
			}

		}

		/**
		 * 获取时间轮时间
		 */
		private void getPreTime() {

			String[] currentHours = getResources().getStringArray(R.array.pre_hours);

			String startTime = homeInfo.getBusinessHoursStart();
			startTime = startTime.substring(0, startTime.indexOf(":"));
			if (startTime.startsWith("0")) {
				startTime = startTime.substring(1);
			}

			String endTime = homeInfo.getBusinessHoursEnd();
			endTime = endTime.substring(0, endTime.indexOf(":"));
			if (endTime.startsWith("0")) {
				endTime = endTime.substring(1);
			}

			Integer integer = Integer.parseInt(endTime);
			integer = integer - 1;

			if ((Integer.parseInt(startTime) - Integer.parseInt(endTime)) > 0) {
				String[] hours0 = null;
				int startIndex = 0;
				for (int i = 0; i < currentHours.length; i++) {
					if (homeInfo.getBusinessHoursStart().equals(currentHours[i])) {
						startIndex = i;
						hours0 = new String[48 - startIndex];
					}
				}

				if (startIndex != 0) {
					for (int i = 0; i < (48 - startIndex); i++) {
						hours0[i] = currentHours[startIndex + i];
					}
				}

				String[] hours1 = null;
				int endIndex = 0;

				for (int i = 0; i < currentHours.length; i++) {
					endTime = integer.toString();
					if (!endTime.startsWith("0")) {
						endTime = "0" + endTime;
					}
					if ((endTime + ":00").equals(currentHours[i])) {
						endIndex = i;
						hours1 = new String[endIndex + 1];
					}
				}

				for (int i = 0; i <= endIndex; i++) {
					hours1[i] = currentHours[i];
				}

				hours = new String[48 - startIndex + endIndex + 1];

				for (int i = 0; i < hours.length; i++) {
					if (i <= endIndex) {
						hours[i] = hours1[i];
					} else {
						hours[i] = hours0[i - endIndex - 1];
					}
				}
				int i = hours.length;
			} else {
				int index = 0;
				for (int i = 0; i < currentHours.length; i++) {
					if (homeInfo.getBusinessHoursStart().equals(currentHours[i])) {
						index = i;
					}
				}
				int index2 = 0;
				for (int i = 0; i < currentHours.length; i++) {
					if (homeInfo.getBusinessHoursEnd().equals(currentHours[i])) {
						index2 = 48 - i;
					}
				}
				hours = new String[48 - index - index2];

				for (int i = 0; i < hours.length; i++) {
					hours[i] = currentHours[index];
				}

			}

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
			int weight = UICommonUtil.dip2px(getApplicationContext(), 40);
			view.setLayoutParams(new LayoutParams(android.view.ViewGroup.LayoutParams.WRAP_CONTENT, weight));

			// view.setBackgroundColor(Color.parseColor("#1e1e1e"));
		}

		@Override
		public View getItem(int index, View cachedView, ViewGroup parent) {
			currentItem = index;

			View view = super.getItem(index, cachedView, parent);

			return view;
		}
	}

	/**
	 * 判断是否安装目标应用
	 * 
	 * @param packageName
	 *            目标应用安装后的包名
	 * @return 是否已安装目标应用
	 */
	private boolean isInstallByread(String packageName) {
		return new File("/data/data/" + packageName).exists();
	}

	void setMainTabPosition(int position) {
		Intent intent = new Intent();
		intent.setAction(Constants.CHANGE_VIEWPAGERPOSITION);
		intent.putExtra("position", position);
		this.sendBroadcast(intent);
	}
}