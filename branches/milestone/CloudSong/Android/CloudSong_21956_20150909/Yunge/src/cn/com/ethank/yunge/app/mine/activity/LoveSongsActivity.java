package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.Map;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.mine.network.ModifyInfoToNetWork;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class LoveSongsActivity extends BaseActivity implements OnClickListener{
	
	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;

	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;

	@ViewInject(R.id.head_tv_right)
	private TextView head_tv_right;

	@ViewInject(R.id.singers_et)
	private EditText singers_et;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_love_singers);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);
		
		initView();
		
	}

	private void initView() {
		singers_et.setText(getIntent().getStringExtra("song"));
		singers_et.setSelection(getIntent().getStringExtra("song").length());
		String editor = getIntent().getStringExtra("editor");
		if(!TextUtils.isEmpty(editor)){
			head_tv_left.setText("信息编辑");
		}else{
			head_tv_left.setText("信息确认");
		}
		head_tv_left.setOnClickListener(this);
		head_tv_title.setText("最爱歌曲");
		
		head_tv_right.setText("确认");
		head_tv_right.setOnClickListener(this);
		head_tv_right.setTextColor(getResources().getColor(R.color.config));
		
		singers_et.setOnClickListener(this);
		
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.singers_et:
			head_tv_right.setTextColor(getResources().getColor(R.color.config2));
			break;
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.head_tv_right:
			final Map<String, String> map = new HashMap<String, String>();
			map.put("loveSongs", singers_et.getText().toString());
			map.put("token", Constants.getToken());
			ProgressDialogUtils.show(this);
			new ModifyInfoToNetWork(map, this).run();
			
			break;
		}

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
