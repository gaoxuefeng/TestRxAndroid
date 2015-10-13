package cn.com.ethank.yunge.app.mine.network;

import java.util.HashMap;
import java.util.Map;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.bean.Order;
import cn.com.ethank.yunge.app.mine.network.GetUserInfo.OnSuccess;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;

public class GetRoomNetwork extends BackgroundTask<String> {

	Map<String, String> map = new HashMap<String, String>();
	OnSuccess onSuccess ;
	public GetRoomNetwork(Map<String, String> map, OnSuccess onSuccess) {
		this.map = map;
		this.onSuccess = onSuccess;
	}
	@Override
	protected String doWork() throws Exception {
		return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.ktvorderDetail, map).toString();
	}

	protected void onCompletion(String result, Throwable exception, boolean cancelled) {
		if (result != null) {
			Order orderInfo = JSON.parseObject(result, Order.class);
			if(orderInfo != null){
				if (orderInfo.getCode() == 0) {
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.orderDetail, result);
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.orderInfo, result);
					onSuccess.success();
					
				} else {
					ToastUtil.show(orderInfo.getMessage());
				}
			}
		} else {
			ToastUtil.show(R.string.connectfailtoast);
		}
	};

}
