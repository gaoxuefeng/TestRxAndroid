package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.activity.CompartmentActivity;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

/**
 * 我的房间页面
 * 
 */
public class MyBoxActivity extends BaseActivity implements OnClickListener {

	@ViewInject(R.id.box_rl_parent)
	private RelativeLayout box_rl_parent;
	private TextView head_tv_left;

	@ViewInject(R.id.my_rl_box)
	private RelativeLayout my_rl_box;

	@ViewInject(R.id.box_tv_part)
	private TextView box_tv_part; // --参与人数

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_my_box);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);

		initData();
		initView();
	}

	private void initData() {
		final Map<String, String> map = new HashMap<String, String>();
		map.put(SharePreferenceKeyUtil.token, Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.myBox, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (result != null) {

				} else {
					ToastUtil.show("联网失败");
				}
			};
		}.run();
	}

	private void initView() {
		TextView head_tv_title = (TextView) box_rl_parent.findViewById(R.id.head_tv_title);
		head_tv_title.setText("我的房间");
		head_tv_left = (TextView) box_rl_parent.findViewById(R.id.head_tv_left);
		head_tv_left.setOnClickListener(this);

		my_rl_box.setOnClickListener(this);
		box_tv_part.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.my_rl_box:
			Intent intent = new Intent(getApplicationContext(), MainTabActivity.class);
			intent.setType(MainTabActivity.TAB_RESERVE);
			// 临时先这样
			if (!Constants.isBinded()) {
				Constants.setBinded(true);
			}
			startActivity(intent);
			break;
		case R.id.box_tv_part:
			Intent part = new Intent(getApplicationContext(), PartInActivity.class);
			startActivity(part);
			break;
		}
	}
}
