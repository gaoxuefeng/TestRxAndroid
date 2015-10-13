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
import cn.com.ethank.yunge.app.home.BaseWebActivity;
import cn.com.ethank.yunge.app.startup.BaseActivity;

public class ServiceActivity extends BaseWebActivity implements OnClickListener{
	
	@ViewInject(R.id.service_wv)
	private WebView service_wv;
	
	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;
	
	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;
	
	private String shopUrl;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_service);
		initView();
	}

	private void initView() {
		ViewUtils.inject(this);
		
		title.setTitle("免责声明");
		head_tv_left.setOnClickListener(this);
		
		/*service_wv.getSettings().setJavaScriptEnabled(true);  //设置支持JS脚本
		service_wv.getSettings().setBuiltInZoomControls(true);  //设置支持缩放
		service_wv.loadUrl("http://yunge.ethank.com.cn/serverterms/terms.html");*/
		
		shopUrl = "http://yunge.ethank.com.cn/serverterms/terms.html";
		web.loadUrl(shopUrl);
		
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if((keyCode == KeyEvent.KEYCODE_BACK) && service_wv.canGoBack() ){
			service_wv.goBack();
			return true;
		}
		return super.onKeyDown(keyCode, event);
		
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_back:
			finish();
			break;
		case R.id.head_tv_left:
			finish();
			break;

		default:
			break;
		}
		
	}
}
