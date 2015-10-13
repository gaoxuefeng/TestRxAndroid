package cn.com.ethank.yunge.app.mine.network;

import java.util.HashMap;
import java.util.Map;

import android.text.TextUtils;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;

public class GetUserInfo extends BackgroundTask<String> {

	public interface OnSuccess{
		void success();
	}
	
	public OnSuccess mOnSuccess;
	
	public void setmOnSuccess(OnSuccess mOnSuccess) {
		this.mOnSuccess = mOnSuccess;
	}

	
	
	Map<String, String> map = new HashMap<String, String>();
	public GetUserInfo(Map<String, String> map, OnSuccess onSuccess) {
		this.map = map;
		this.mOnSuccess = onSuccess;
	}
	
	@Override
	protected String doWork() throws Exception {
		return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.QUERYINFO, map).toString();
	}

	protected void onCompletion(String result, Throwable exception, boolean cancelled) {
		if (!TextUtils.isEmpty(result)) {
			UserInfo info = JSON.parseObject(result, UserInfo.class);
			if(null != info){
				if (info.getCode() == 0) {
					SharePreferencesUtil.saveStringData("login_result", result);
					
					mOnSuccess.success();
				}
			}
		} else {
			ToastUtil.show(R.string.connectfailtoast);
		}
	};
}
