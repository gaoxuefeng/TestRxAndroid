package cn.com.ethank.yunge.app.mine.network;

import java.util.Map;

import android.text.TextUtils;
import android.widget.EditText;
import android.widget.PopupWindow;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.mine.network.GetUserInfo.OnSuccess;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
/**
 *  信息编辑的网络请求
 */
public class ModifyInfoTask extends BackgroundTask<String> {
	Map<String, String> map ;
	PopupWindow popupWindow ;
	TextView editText;
	String textView;
	OnSuccess onSuccess;
	public ModifyInfoTask(Map<String, String> map, PopupWindow popupWindow, TextView editText,
			String textView, OnSuccess onSuccess) {
		this.map = map;
		this.popupWindow = popupWindow;
		this.editText = editText;
		this.textView = textView;
		this.onSuccess = onSuccess;
	}
	
	@Override
	protected String doWork() throws Exception {
		return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.PROFILE, map).toString();
	}

	protected void onCompletion(String result, Throwable exception, boolean cancelled) {
		if (!TextUtils.isEmpty(result)) {
			UserInfo info = JSON.parseObject(result, UserInfo.class);
			if(null != info){
				if (info.getCode() == 0) {
					SharePreferencesUtil.saveStringData("login_result", result);
					if(null != editText && null != textView){
						editText.setText(textView);
					}
					onSuccess.success();
				}
			}
		} else {
			ToastUtil.show(R.string.connectfailtoast);
		}
		if(null != popupWindow){
			popupWindow.dismiss();
		}
		ProgressDialogUtils.dismiss();
	};

}
