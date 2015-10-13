package cn.com.ethank.yunge.app.room.activity;

import java.util.HashMap;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.RoomBaseActivity;
import cn.com.ethank.yunge.app.remotecontrol.MipcaActivityCapture;
import cn.com.ethank.yunge.app.room.bean.QueryCode;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.BitmapUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class RoomCodeActivity extends RoomBaseActivity {

	@ViewInject(R.id.room_tv_left)
	private TextView room_tv_left;

	@ViewInject(R.id.room_tv_title)
	private TextView room_tv_title;

	@ViewInject(R.id.code_img)
	private ImageView code_img;

	@ViewInject(R.id.room_code_iv)
	private ImageView room_code_iv;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_room_code);

		initView();
		title.setVisibility(View.GONE);
		initData();
	}

	private void initData() {
		final Map<String, String> map = new HashMap<String, String>();
		String reserveBoxId = getIntent().getStringExtra("reserveBoxId");
		map.put("reserveBoxId", reserveBoxId);
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.getKTVIP() + Constants.GENQRCODE, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					QueryCode queryCode = JSON.parseObject(result, QueryCode.class);
					if (queryCode != null) {

						if (queryCode.getCode() == 0) {
							String imgUrl = queryCode.getData().getImageUrl();

							BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
							bitmapUtils.display(code_img, imgUrl);

						} else {
							ToastUtil.show(queryCode.getMessage());
						}
					}
				} else {
					ToastUtil.show(R.string.connectfailtoast);
				}
			};
		}.run();

	}

	private void initView() {
		ViewUtils.inject(this);
		room_tv_title.setText("房间二维码");
		room_tv_left.setText("房间");

		room_tv_left.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});

		room_code_iv.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(getApplicationContext(), MipcaActivityCapture.class);
				startActivity(intent);
			}
		});

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}

}
