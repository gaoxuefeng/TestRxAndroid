package org.app.musicplayer;

import android.os.Bundle;
import android.view.KeyEvent;
import android.webkit.WebView;

public class FavroiteActivity extends BaseActivity {
WebView webview;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.favorite);
		LoadData();
	}

	private void LoadData() {
	  webview=(WebView) findViewById(R.id.music_webview);
	  webview.loadUrl("http://music.qq.com/midportal/static/recom_v2/");
	  webview.getSettings().setJavaScriptEnabled(true);  

		
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if(webview.canGoBack() && keyCode == KeyEvent.KEYCODE_BACK){  
            webview.goBack();   //goBack()表示返回webView的上一页面   

           return true;  
    }  
    return false; 
	}
	
}
