package cn.com.ethank.yunge.app.mine.network;

import java.util.Map;

import android.app.Activity;
import android.text.TextUtils;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.jpush.android.util.ac;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;

public class ModifyInfoToNetWork extends BackgroundTask<String> {
	Map<String, String> map ;
	Activity activity;
	public ModifyInfoToNetWork(Map<String, String> map, Activity activity) {
		this.map = map;
		this.activity = activity;
	}
	@Override
	protected String doWork() throws Exception {
		return HttpUtils.getJsonByPost(Constants.hostUrlCloud+Constants.PROFILE, map).toString();
	}

	protected void onCompletion(String result, Throwable exception, boolean cancelled) {
		if(!TextUtils.isEmpty(result)){
			UserInfo info = JSON.parseObject(result, UserInfo.class);
			if(null != info){
				if(info.getCode() == 0){
					SharePreferencesUtil.saveStringData("login_result", result);
					ToastUtil.show("保存成功");
				}
			}
			activity.finish();
		}else{
			ToastUtil.show(R.string.connectfailtoast);
			activity.finish();
		}
		
		ProgressDialogUtils.dismiss();
	};

}
