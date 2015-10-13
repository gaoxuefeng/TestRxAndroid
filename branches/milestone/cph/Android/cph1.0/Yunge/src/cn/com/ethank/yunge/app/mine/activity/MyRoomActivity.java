package cn.com.ethank.yunge.app.mine.activity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.adapter.MyRoomAdapter;
import cn.com.ethank.yunge.app.mine.bean.MyRoomBean;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class MyRoomActivity extends BaseActivity implements OnClickListener {
	private ListView lv_room;
	List<BoxDetail> rooms = new ArrayList<BoxDetail>();
	protected String tag = "MyRoomActivity";
	private MyRoomAdapter adapter;
	private MyRefreshListView mrfg_room;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_mine_room);
		initView();
		initData();
		getNetData(true);
	}

	private void initData() {
		adapter = new MyRoomAdapter(this, rooms);
		lv_room.setAdapter(adapter);
		// BoxDetail bean =new BoxDetail();
		// bean.setAddress("陕西西安未央区太元路华远君城....");
		// bean.setDiscribe("离开始还有1分钟");
		// bean.setJoinCount(1);
		// bean.setKtvName("望京KTV");
		// bean.setReservationAvatarUrl("");
		// bean.setReservationName("哈哈");
		// bean.setReserveBoxId("110");
		// bean.setStarting(false);
		// rooms.add(bean);
		// adapter.setList(rooms);

	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void initView() {
		TextView head_tv_left = (TextView) findViewById(R.id.head_tv_left);
		TextView head_tv_title = (TextView) findViewById(R.id.head_tv_title);
		head_tv_left.setText("我的");
		head_tv_title.setText("我的房间");
		mrfg_room = (MyRefreshListView) findViewById(R.id.mrfg_room);
		mrfg_room.setMode(Mode.BOTH);
		mrfg_room.setPullToRefreshEnabled(false);// 禁止滚动
		lv_room = mrfg_room.getRefreshableView();
		mrfg_room.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				// 下拉刷新
				clearRoomList();
				getNetData(true);
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				getNetData(false);
			}
		});

		head_tv_left.setOnClickListener(this);

	}

	private void getNetData(final boolean isFristRequest) {
		try {

			if (isFristRequest) {
				clearRoomList();
			}
			String token = Constants.getToken();
			final HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("token", token);
			if(TextUtils.isEmpty(token)){
				ToastUtil.show("用户未登陆");
				return;
			}
			new BackgroundTask<String>() {

				private List<BoxDetail> myRoomInfoBeans = new ArrayList<BoxDetail>();
				@Override
				protected String doWork() throws Exception {
					return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.myRoom, hashMap).toString();
				}

				@Override
				protected void onCompletion(String result, Throwable exception, boolean cancelled) {
					super.onCompletion(result, exception, cancelled);
					if (result != null) {
						MyRoomBean myRoomBean = JSON.parseObject(result, MyRoomBean.class);

						if (myRoomBean.getCode() == 0) {
							if (myRoomBean.getData().size() == 0) {
								Log.e(tag, "没有更多数据了");
								mrfg_room.onRefreshComplete();
								ToastUtil.show("没有更多数据");
							} else {
								if (isFristRequest) {
									clearRoomList();
								}
								myRoomInfoBeans = myRoomBean.getData();
								
								Collections.sort(myRoomInfoBeans);
								for (int i = 0; i < myRoomInfoBeans.size(); i++) {
									rooms.add(myRoomInfoBeans.get(i));
									adapter.setList(rooms);
								}
							}
						}
						mrfg_room.onRefreshComplete();
					} else {
						ToastUtil.show("当前网络出现异常,请稍后再试");
					}

				}
			}.run();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void clearRoomList() {
		rooms.clear();
		adapter.setList(rooms);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;

		default:
			break;
		}
	}

}
