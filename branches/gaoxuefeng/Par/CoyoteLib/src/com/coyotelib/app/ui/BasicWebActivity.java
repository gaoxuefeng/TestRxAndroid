package com.coyotelib.app.ui;

import android.app.Activity;
import android.app.ProgressDialog;
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


import com.coyotelib.R;

import java.lang.reflect.Method;

public class BasicWebActivity extends Activity {
	private static final String KEY_URL = "intent_url";
	private static final String KEY_TITLE = "intent_title";
	private static final String KEY_HIDE_ACTION = "intent_hide_action";

	private String mainUrl;
	private ProgressDialog mLoading = null;
	private WebView web;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.basicwebview);
		showLoading();
		web = (WebView) this.findViewById(R.id.result_detail_webview);
        mainUrl = this.getIntent().getStringExtra(KEY_URL);
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
		web.getSettings().setCacheMode(
				android.webkit.WebSettings.LOAD_DEFAULT);
		web.getSettings().setSupportMultipleWindows(true);
		
		web.getSettings().setGeolocationEnabled(true);
		web.getSettings().setDatabaseEnabled(true);
		
		String dir = this.getApplicationContext().getDir("database", Context.MODE_PRIVATE).getPath();
		web.getSettings().setGeolocationDatabasePath(dir);
		web.getSettings().setDomStorageEnabled(true);

		Class<?> settingsClazz = web.getSettings().getClass();

		try {
			Method method = settingsClazz.getDeclaredMethod(
					"setDomStorageEnabled", boolean.class);
			method.invoke(web.getSettings(), new Object[] { true });
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			Method method = settingsClazz.getDeclaredMethod(
					"setAppCacheMaxSize", long.class);
			method.invoke(web.getSettings(), new Object[] { 1024 * 1024 * 8 });
		} catch (Exception e) {
			e.printStackTrace();
		}

		String appCachePath = getApplicationContext().getCacheDir()
				.getAbsolutePath();

		try {
			Method method = settingsClazz.getDeclaredMethod("setAppCachePath",
					String.class);
			method.invoke(web.getSettings(), appCachePath);
		} catch (Exception e) {
			e.printStackTrace();
		}

		web.getSettings().setAllowFileAccess(true);
		try {
			Method method = settingsClazz.getDeclaredMethod(
					"setAppCacheEnabled", boolean.class);
			method.invoke(web.getSettings(), true);
		} catch (Exception e) {
			e.printStackTrace();
		}



        web.setWebChromeClient(new MyWebChromeClient());
		web.setWebViewClient(new WebViewClient() {

			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				if(TextUtils.isEmpty(url)){
					return false;
				}
				
				try {
					final Uri uri = Uri.parse(url);
					final String scheme = uri.getScheme();
					if("http".equals(scheme) || "https".equals(scheme) || url.startsWith("www")){
						view.loadUrl(url);
					}else if ("tel".equals(scheme)) {
						Intent intent = new Intent("android.intent.action.CALL", uri);
						startActivity(intent);
					} else if("sms".equals(scheme)){
						Intent intent = new Intent(Intent.ACTION_SENDTO, uri);
						startActivity(intent);
					} else if("hmt".equals(scheme)){
						final String host = uri.getHost();
						if("wv_close".equals(host)){
							finish();
						}else if("wv_back".equals(host)){
							goBack();
						}
					}else if (!TextUtils.isEmpty(url)
							&& url.startsWith("wtai://")) {
						int sepIndex = url.lastIndexOf(";");
						if (sepIndex >= 0 && sepIndex < url.length() - 1) {
							String number = url.substring(sepIndex + 1);
                            //TODO 拨打电话
							/*PhoneUtil.telPhone(number,
									BasicWebActivity.this);*/
						}
					} else {
						try {
							Intent intent = new Intent(Intent.ACTION_VIEW, uri);
							startActivity(intent);
							return true;
						} catch (Exception e) {
						}
						view.loadUrl(url);
					}
					return true;
				} catch (Exception e) {
					e.printStackTrace();
					return false;
				}
			}

			@Override
			public void onPageFinished(WebView view, String url) {
				dissmissLoading();
				web.setVisibility(View.VISIBLE);
			}
		});
        /*Class<?> webClazz = web.getClass();
        try {
            Method method = webClazz.getDeclaredMethod(
                    "removeJavascriptInterface", String.class);
            method.invoke(web.getSettings(),
                    new String[] { "searchBoxJavaBridge_" });
        } catch (Exception e) {
            e.printStackTrace();
        }
*/
        web.loadUrl(mainUrl);
	}

	@Override
	protected void onDestroy() {
		web.clearCache(false);
		super.onDestroy();
	}
	
	private void goBack(){
		if (web.canGoBack()) {
			web.goBack();
		} else {
			finish();
		}
	}

	private void showLoading() {
		if (mLoading == null) {
			mLoading = new ProgressDialog(this);
			mLoading.setTitle("");
			mLoading.setMessage("正在加载");
			mLoading.setCanceledOnTouchOutside(false);
		}
		mLoading.show();
	}

	private void dissmissLoading() {
		if (mLoading != null) {
			mLoading.dismiss();
			mLoading = null;
		}
	}

	
	
	public static void initIntent(Intent intent, String title, String url) {
		intent.putExtra(KEY_TITLE, title);
		intent.putExtra(KEY_URL, url);
	}

	public static void initIntent(Intent intent, String title, String url,
			boolean hideAction) {
		intent.putExtra(KEY_TITLE, title);
		intent.putExtra(KEY_URL, url);
		intent.putExtra(KEY_HIDE_ACTION, hideAction);
	}
	
	final static class MyWebChromeClient extends WebChromeClient {
		
		@Override
		public void onGeolocationPermissionsShowPrompt(String origin, GeolocationPermissions.Callback callback) {
			callback.invoke(origin, true, false);
			super.onGeolocationPermissionsShowPrompt(origin, callback);
		}
	}
}
