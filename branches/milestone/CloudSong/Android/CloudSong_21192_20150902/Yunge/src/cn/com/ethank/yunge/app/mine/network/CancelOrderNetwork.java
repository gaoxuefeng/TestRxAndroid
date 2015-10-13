package cn.com.ethank.yunge.app.mine.network;

import java.util.HashMap;
import java.util.Map;

import android.text.TextUtils;
import android.widget.PopupWindow;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.VerifyCodeInfo;
import cn.com.ethank.yunge.app.mine.network.GetUserInfo.OnSuccess;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;

public class CancelOrderNetwork extends BackgroundTask<String> {

	Map<String, String> map = new HashMap<String, String>();
	OnSuccess onSuccess;
	PopupWindow window;
	public CancelOrderNetwork(Map<String, String> map,OnSuccess success, PopupWindow window) {
		this.map = map;
		this.onSuccess = success;
		this.window = window;
	}
	@Override
	protected String doWork() throws Exception {
		return HttpUtils.getJsonByPost(Constants.hostUrlCloud+Constants.cancelOrder, map).toString();
	}
	
	@Override
	protected void onCompletion(String result, Throwable exception, boolean cancelled) {
		if(!TextUtils.isEmpty(result)){
			VerifyCodeInfo codeInfo= JSON.parseObject(result, VerifyCodeInfo.class);
			if(codeInfo != null){
				//ToastUtil.show(codeInfo.getMessage());
				onSuccess.success();
				window.dismiss();
			}
		}else{
			ToastUtil.show(R.string.connectfailtoast);
			window.dismiss();
		}
	}

}
