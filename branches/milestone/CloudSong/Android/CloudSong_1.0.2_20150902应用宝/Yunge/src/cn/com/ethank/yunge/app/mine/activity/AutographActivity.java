package cn.com.ethank.yunge.app.mine.activity;

import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseActivity;
/**
 * 纪念册
 *
 */
public class AutographActivity extends BaseActivity implements OnClickListener{
	
	@ViewInject(R.id.autograph_wv)
	private WebView autograph_wv;
	
	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;
	
	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_autopraph);
		initView();
	}

	private void initView() {
		ViewUtils.inject(this);
		
		head_tv_left.setText("我的");
		head_tv_title.setText("纪念册");
		head_tv_left.setOnClickListener(this);
		
		autograph_wv.getSettings().setJavaScriptEnabled(true);  //设置支持JS脚本
		autograph_wv.getSettings().setBuiltInZoomControls(true);  //设置支持缩放
		autograph_wv.loadUrl("http://www.baidu.com");
		
		
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if((keyCode == KeyEvent.KEYCODE_BACK) && autograph_wv.canGoBack() ){
			autograph_wv.goBack();
			return true;
		}
		return super.onKeyDown(keyCode, event);
		
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;

		}
		
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
