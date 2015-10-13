package cn.com.ethank.yunge.app.home;

import java.lang.reflect.Method;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.GeolocationPermissions;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;

import com.coyotelib.R;

public class BaseWebActivity extends BaseTitleActivity {

	protected WebView web;

	@SuppressLint("SetJavaScriptEnabled")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.basicwebview);
		title.setVisibility(View.VISIBLE);
		web = (WebView) this.findViewById(R.id.result_detail_webview);
		web.setOnKeyListener(new View.OnKeyListener() {
			@Override
			public boolean onKey(View v, int keyCode, KeyEvent event) {
				if (event.getAction() == KeyEvent.ACTION_DOWN) {
					if (keyCode == KeyEvent.KEYCODE_BACK) {
						goBack();
						return true;
					}
				}
				return false;
			}
		});

		web.getSettings().setJavaScriptEnabled(true);
		web.getSettings().setUseWideViewPort(true);
		web.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
		web.getSettings().setBuiltInZoomControls(false);
		web.getSettings().setCacheMode(android.webkit.WebSettings.LOAD_DEFAULT);
		web.getSettings().setSupportMultipleWindows(true);

		web.getSettings().setGeolocationEnabled(true);
		web.getSettings().setDatabaseEnabled(true);

		String dir = this.getApplicationContext().getDir("database", Context.MODE_PRIVATE).getPath();
		web.getSettings().setGeolocationDatabasePath(dir);
		web.getSettings().setDomStorageEnabled(true);
		String content = web.getSettings().getUserAgentString();
		if (!content.isEmpty()) {
			web.getSettings().setUserAgentString(content + "ethank-browser-Android");
		}

		Class<?> settingsClazz = web.getSettings().getClass();

		try {
			Method method = settingsClazz.getDeclaredMethod("setDomStorageEnabled", boolean.class);
			method.invoke(web.getSettings(), new Object[] { true });
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			Method method = settingsClazz.getDeclaredMethod("setAppCacheMaxSize", long.class);
			method.invoke(web.getSettings(), new Object[] { 1024 * 1024 * 8 });
		} catch (Exception e) {
			e.printStackTrace();
		}

		String appCachePath = getApplicationContext().getCacheDir().getAbsolutePath();

		try {
			Method method = settingsClazz.getDeclaredMethod("setAppCachePath", String.class);
			method.invoke(web.getSettings(), appCachePath);
		} catch (Exception e) {
			e.printStackTrace();
		}

		web.getSettings().setAllowFileAccess(true);
		try {
			Method method = settingsClazz.getDeclaredMethod("setAppCacheEnabled", boolean.class);
			method.invoke(web.getSettings(), true);
		} catch (Exception e) {
			e.printStackTrace();
		}

		web.setWebChromeClient(new MyWebChromeClient());
		web.setWebViewClient(new WebViewClient() {

			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				if (TextUtils.isEmpty(url)) {
					return false;
				}

				view.loadUrl(url);
				return true;
//				try {
//					final Uri uri = Uri.parse(url);
//					final String scheme = uri.getScheme();
//					if ("http".equals(scheme) || "https".equals(scheme) || url.startsWith("www")) {
//						
//					} 
//					return false;
//				} catch (Exception e) {
//					e.printStackTrace();
//					return false;
//				}
			}

			@Override
			public void onPageFinished(WebView view, String url) {
				web.setVisibility(View.VISIBLE);
			}
		});
	}

	private void goBack() {
		if (web.canGoBack()) {
			web.goBack();
		} else {
			finish();
		}
	}

	final static class MyWebChromeClient extends WebChromeClient {

		@Override
		public void onGeolocationPermissionsShowPrompt(String origin, GeolocationPermissions.Callback callback) {
			callback.invoke(origin, true, false);
			super.onGeolocationPermissionsShowPrompt(origin, callback);
		}
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
