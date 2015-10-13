package cn.com.ethank.yunge.app.room.request;

import java.util.HashMap;
import java.util.Map;

import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.coyotelib.core.threading.BackgroundTask;

public class RequestSendInfo extends BackgroundTask<String> {

	Map<String, String> map = new HashMap<String, String>();
	public RequestSendInfo(Map<String, String> map) {
		this.map = map;
	}
	
	@Override
	protected String doWork() throws Exception {
		return HttpUtils.getJsonByPost(Constants.getKTVIP()+Constants.ADDINFO, map).toString();
	}

	@Override
	protected void onCompletion(String result, Throwable exception, boolean cancelled) {
		super.onCompletion(result, exception, cancelled);
	}
}
