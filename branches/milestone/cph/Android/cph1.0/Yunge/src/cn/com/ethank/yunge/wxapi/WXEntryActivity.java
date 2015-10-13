package cn.com.ethank.yunge.wxapi;

import android.os.Bundle;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.listener.SocializeListeners.SnsPostListener;
import com.umeng.socialize.weixin.view.WXCallbackActivity;

public class WXEntryActivity extends WXCallbackActivity implements SnsPostListener {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
	}

	@Override
	public void onStart() {
		// TODO Auto-generated method stub
		super.onStart();
	}

	@Override
	public void onComplete(SHARE_MEDIA arg0, int arg1, SocializeEntity arg2) {
		// TODO Auto-generated method stub
		if (arg1 == 200) {
			ToastUtil.show("comPlete");

		}
	}
}
