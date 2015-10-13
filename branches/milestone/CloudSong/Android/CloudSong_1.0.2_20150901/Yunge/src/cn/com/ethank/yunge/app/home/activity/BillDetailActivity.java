package cn.com.ethank.yunge.app.home.activity;

import android.os.Bundle;
import android.view.KeyEvent;
import android.webkit.WebView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
/**
 * 计费详情页面
 */
public class BillDetailActivity extends BaseActivity {
	private WebView bill_wv_detail;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_bill_detail);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
		bill_wv_detail = (WebView) this.findViewById(R.id.bill_wv_detail);
		bill_wv_detail.getSettings().setJavaScriptEnabled(true);  //设置支持JS脚本
		bill_wv_detail.getSettings().setBuiltInZoomControls(true);  //设置支持缩放
		bill_wv_detail.loadUrl("http://www.baidu.com");
		
		
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if((keyCode == KeyEvent.KEYCODE_BACK) && bill_wv_detail.canGoBack() ){
			bill_wv_detail.goBack();
			return true;
		}
		return super.onKeyDown(keyCode, event);
		
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
