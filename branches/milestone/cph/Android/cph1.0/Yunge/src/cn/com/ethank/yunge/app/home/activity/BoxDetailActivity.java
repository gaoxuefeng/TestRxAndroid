package cn.com.ethank.yunge.app.home.activity;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.bean.BoxDetailInfo;
import cn.com.ethank.yunge.app.home.bean.CancleOrderInfo;
import cn.com.ethank.yunge.app.home.bean.OrderInfo;
import cn.com.ethank.yunge.app.home.bean.OrderInfo.Order;
import cn.com.ethank.yunge.app.mine.activity.ConsumeActivity;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.XCRoundImageViewByXfermode;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.BitmapUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

/**
 * 我的房间--房间详情界面
 */
public class BoxDetailActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.box_tv_detail)
	private TextView box_tv_detail; // --详情

	@ViewInject(R.id.box_tv_uname)
	private TextView box_tv_uname;

	@ViewInject(R.id.box_tv_day)
	private TextView box_tv_day;

	@ViewInject(R.id.box_tv_month)
	private TextView box_tv_month;

	@ViewInject(R.id.box_tv_hour)
	private TextView box_tv_hour;

	@ViewInject(R.id.box_tv_typeName)
	private TextView box_tv_typeName;

	@ViewInject(R.id.box_tv_address)
	private TextView box_tv_address;

	@ViewInject(R.id.box_tv_showName)
	private TextView box_tv_showName;

	@ViewInject(R.id.box_detail_ll_parent)
	private LinearLayout box_detail_ll_parent;



	@ViewInject(R.id.box_but_cancel)
	private Button box_but_cancel;

	@ViewInject(R.id.box_tv_disTime)
	private TextView box_tv_disTime;

	private OrderInfo orderInfo;

	private View cancel;

	private TextView pop_tv_text1;

	private TextView pop_tv_text2;

	private Button yes;

	private Button point;

	private PopupWindow window;

	Order order = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_box_detail);
		ViewUtils.inject(this);

		initData();
	
		box_tv_disTime = (TextView) findViewById(R.id.box_tv_disTime);
		box_rl_people = (HorizontalScrollView) findViewById(R.id.box_rl_people);
		box_room_num = (TextView) findViewById(R.id.box_room_num);
		
		BaseApplication.getInstance().cacheActivityList.add(this);
	}

	private BoxDetailInfo boxDetailInfo;
	private void initData() {
		final Map<String, String> map = new HashMap<String, String>();
		map.put("reserveBoxId", SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.reserveBoxId));
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {

			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.boxDetail, map).toString();
			}
			
			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if(result != null){
					boxDetailInfo = JSON.parseObject(result, BoxDetailInfo.class);
					if(boxDetailInfo.getCode() == 0){
						initView();
					}
				}else{
					ToastUtil.show("当前网络出现异常,请稍后再试");
				}
			};
		}.run();
		
	}

	Handler handler = new Handler() {
		public void handleMessage(Message msg) {
			if (msg.what == 1) {
				
				if(time3 > 0){
					Long days = time3 / (1000 * 60 * 60 * 24);
					Long hour = (time3 - days * (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
					Long minutes = (time3 - days * (1000 * 60 * 60 * 24) - hour * (1000 * 60 * 60)) / (1000 * 60);

					Long second = (time3 - days * (1000 * 60 * 60 * 24) - hour * (1000 * 60 * 60) - minutes * (1000 * 60)) / 1000;

					time3 -= 1000;
					
					// String date = dateFormat.format(new Date(time2));
					if (days == 0) {
						box_tv_disTime.setText("离结束还有：" + hour + "小时" + minutes + "分钟" + second + "秒");
					} else {
						box_tv_disTime.setText("离结束还有：" + days + "天" + hour + "小时" + minutes + "分钟" + second + "秒");
					}
					
					return;
				}
				
				Long days = time2 / (1000 * 60 * 60 * 24);
				Long hour = (time2 - days * (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
				Long minutes = (time2 - days * (1000 * 60 * 60 * 24) - hour * (1000 * 60 * 60)) / (1000 * 60);

				Long second = (time2 - days * (1000 * 60 * 60 * 24) - hour * (1000 * 60 * 60) - minutes * (1000 * 60)) / 1000;

				time2 -= 1000;
				
				// String date = dateFormat.format(new Date(time2));
				if (days == 0) {
					box_tv_disTime.setText("离开始还有：" + hour + "小时" + minutes + "分钟" + second + "秒");
				} else {
					box_tv_disTime.setText("离开始还有：" + days + "天" + hour + "小时" + minutes + "分钟" + second + "秒");
				}
				
				
			}
			super.handleMessage(msg);
		};
	};
	Timer timer = new Timer();
	TimerTask task = new TimerTask() {

		@Override
		public void run() {
			// 需要做的事:发送消息
			Message message = new Message();
			message.what = 1;
			handler.sendMessage(message);
		}
	};

	private Long disTime;

	private Long time2;

	private BoxDetail myRoom;

	private Long time3 = (long) 0;

	private HorizontalScrollView box_rl_people;

	private void initView() {
		if (boxDetailInfo != null) {
			
			box_room_num.setText("已加入"+boxDetailInfo.getData().getAvatarUrls().size()+"人");
			box_tv_detail.setText(boxDetailInfo.getData().getRoomName() + "详情");

			box_tv_uname.setText(boxDetailInfo.getData().getNickName());
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("MM月dd日");
			String day = dateFormat.format(new Date(boxDetailInfo.getData().getStartTime()*1000L));
			box_tv_day.setText(day);
		
			SimpleDateFormat dateFormat1 = new SimpleDateFormat("HH:mm");
			String hour1 = dateFormat1.format(new Date(boxDetailInfo.getData().getStartTime()*1000L));
			SimpleDateFormat dateFormat2 = new SimpleDateFormat("HH:mm");
			String hour2 = dateFormat2.format(new Date(boxDetailInfo.getData().getRbEndTime()*1000L));
			box_tv_hour.setText(hour1+"-"+hour2);

			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date(boxDetailInfo.getData().getStartTime()*1000L));
			int week = calendar.get(Calendar.DAY_OF_WEEK);
			String[] strings = new String[]{"周天","周一","周二","周三","周四","周五","周六"};
			box_tv_month.setText(strings[week-1]);
			
			box_tv_typeName.setText(boxDetailInfo.getData().getRoomName());
			box_tv_showName.setText(boxDetailInfo.getData().getKtvName());
			box_tv_address.setText(boxDetailInfo.getData().getAddress());
			
			Long nowTimeLong = boxDetailInfo.getData().getServiceDate();
			Long startTimeLong = boxDetailInfo.getData().getStartTime();
			Long endTimeLong = boxDetailInfo.getData().getRbEndTime();
			Date date1 = new Date();
			Date date2 = new Date(startTimeLong * 1000L);
			Date date3 = new Date(endTimeLong * 1000L);
			
			time2 = date2.getTime() - date1.getTime();
			if(time2 < 0){
				time3 = date3.getTime() - date1.getTime();
			}
			
			timer.schedule(task, 1000, 1000); // 1s后执行task,经过1s再次执行
		}

		getRoomPeople();
		
		cancel = View.inflate(getApplicationContext(), R.layout.pop_register, null);
		pop_tv_text1 = (TextView) cancel.findViewById(R.id.pop_tv_text1);
		pop_tv_text1.setText("取消后，将无法恢复，确定");

		pop_tv_text2 = (TextView) cancel.findViewById(R.id.pop_tv_text2);
		pop_tv_text2.setText("取消本次活动吗？");

		yes = (Button) cancel.findViewById(R.id.pop_but_exit_login);
		yes.setText("是");
		point = (Button) cancel.findViewById(R.id.pop_but_forgert_pwd);
		point.setText("否");

		box_rl_exit = (RelativeLayout) this.findViewById(R.id.box_rl_exit);
		box_rl_exit.setOnClickListener(this);

		yes.setOnClickListener(this);
		point.setOnClickListener(this);
		box_but_cancel.setOnClickListener(this);
	}

	List<XCRoundImageViewByXfermode> viewList = new ArrayList<XCRoundImageViewByXfermode>();

	private TextView box_room_num;

	private RelativeLayout box_rl_exit;
	
	/**
	 * 获取房间加入人数
	 */
	@SuppressLint("NewApi")
	private void getRoomPeople() {
		// 获取数据后,需要构建点,构建viewpager的数据适配器
		HorizontalScrollView.LayoutParams llParams = new HorizontalScrollView.LayoutParams(HorizontalScrollView.LayoutParams.WRAP_CONTENT,
				HorizontalScrollView.LayoutParams.WRAP_CONTENT);

		// 放置点的线性布局,规则由其夫控件,相对布局提供
		LinearLayout linearLayout = new LinearLayout(getApplicationContext());
		// 要将线性布局放到右下角
		
		//llParams.addRule(HorizontalScrollView.FOCUS_LEFT);
		//llParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
		box_rl_people.addView(linearLayout, llParams);

		viewList.clear();
		for (int i = 0; i < boxDetailInfo.getData().getAvatarUrls().size(); i++) {
			//View view = new View(getApplicationContext());
			XCRoundImageViewByXfermode view = new XCRoundImageViewByXfermode(getApplicationContext());
			
			BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
			bitmapUtils.display(view, boxDetailInfo.getData().getAvatarUrls().get(i));
			
			LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(UICommonUtil.dip2px(getApplicationContext(), 40), UICommonUtil.dip2px(
					getApplicationContext(), 40));
			layoutParams.setMargins(0, 0, UICommonUtil.dip2px(getApplicationContext(), 10), UICommonUtil.dip2px(getApplicationContext(), 10));
			linearLayout.addView(view, layoutParams);

			viewList.add(view);
		}
		
	}

	/**
	 * 弹出取消房间的popupwindow
	 */
	private void showBoxType() {
		int width = UICommonUtil.dip2px(getApplicationContext(), 300);
		int height = UICommonUtil.dip2px(getApplicationContext(), 145);

		window = new PopupWindow(cancel, width, height);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(false);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(box_detail_ll_parent, Gravity.CENTER, 0, 0);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.pop_but_exit_login:
			final Map<String, String> map = new HashMap<String, String>();
			if (order != null) {
				map.put("orderId", order.getReserveBoxId());
			} else {
				map.put("orderId", "");
			}
			map.put("token", Constants.getToken());
			new BackgroundTask<String>() {
				@Override
				protected String doWork() throws Exception {
					return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.cancelOrder, map).toString();
				}

				protected void onCompletion(String result, Throwable exception, boolean cancelled) {
					if (!TextUtils.isEmpty(result)) {
						CancleOrderInfo cancleOrderInfo = JSON.parseObject(result, CancleOrderInfo.class);
						ToastUtil.show(cancleOrderInfo.getCode());
						if (cancleOrderInfo.getCode() == 0) {
							Intent intent = new Intent(getApplicationContext(), ConsumeActivity.class);
							startActivity(intent);
							finish();
						}

						ToastUtil.show(cancleOrderInfo.getMessage());

					} else {
						ToastUtil.show("当前网络出现异常,请稍后再试");
					}
				};
			}.run();

			window.dismiss();
			break;
		case R.id.pop_but_forgert_pwd:
			window.dismiss();
			break;
		case R.id.box_but_cancel:
			showBoxType();
			break;
		case R.id.box_rl_exit:
			finish();
			break;
		}

	}
}
