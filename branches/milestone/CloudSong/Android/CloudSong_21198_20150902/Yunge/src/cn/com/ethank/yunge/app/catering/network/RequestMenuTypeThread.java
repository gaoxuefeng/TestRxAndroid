package cn.com.ethank.yunge.app.catering.network;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.ethank.yunge.app.catering.bean.TypeContentInfoItem;
import cn.com.ethank.yunge.app.catering.bean.TypeContentItem;
import cn.com.ethank.yunge.app.catering.utils.ConstantsUtils;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestMenuTypeThread {

	public void getTypeContentData(final String ip, final String boxId, final RefreshUiInterface refreshUiInterface, final String url) {

		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {

				ConstantsUtils.TYPECONTENT_LIST = new ArrayList<TypeContentItem>();
				List<String> typelist = new ArrayList<String>();

				Map<String, String> hashMap = new HashMap<String, String>();
				hashMap.put("token", Constants.getToken());
				hashMap.put("reserveBoxId", boxId);
				JSONObject result = null;
				if (Constants.getBoxInfo().isStarting() || Constants.getBoxInfo().isFromLocal()) {
					result = HttpUtils.getJsonByPost(url, hashMap);
				}

				if (result == null) {
					result = HttpUtils.getJsonByPost(Constants.getCartingUrl(false), hashMap);
				}
				if (result == null) {
					return null;
				}
				if (result.getInteger("code") == 0) {
					return setData(result, typelist);
				}
				return null;
			}

			@Override
			protected void onCompletion(Object result, Throwable exception, boolean cancelled) {
				super.onCompletion(result, exception, cancelled);
				refreshUiInterface.refreshUi(result);
				ProgressDialogUtils.dismiss();
			}
		}.run();
	}

	private List<String> setData(JSONObject result, List<String> typelist) {
		String data = result.getString("data");
		JSONArray array = JSONArray.parseArray(data);
		for (int i = 0; i < array.size(); i++) {
			TypeContentItem item = new TypeContentItem();
			TypeContentInfoItem infoitem = JSONObject.parseObject(array.getString(i), TypeContentInfoItem.class);

			item.setInfoitem(infoitem);
			item.setAddNum(0);
			item.setPosition(i);
			ConstantsUtils.TYPECONTENT_LIST.add(item);
			String type = infoitem.getGType();
			if (!typelist.contains(type)) {
				typelist.add(type);
			}
		}

		return typelist;
	}
}
