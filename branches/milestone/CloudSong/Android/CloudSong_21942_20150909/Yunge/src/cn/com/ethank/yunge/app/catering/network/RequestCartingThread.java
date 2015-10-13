package cn.com.ethank.yunge.app.catering.network;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.ethank.yunge.app.catering.bean.TypeContentItem;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestCartingThread {

	public void getTypeContentData(final String sumprice, final RefreshUiInterface refreshUiInterface, final String ktvip, final String boxId, final List<TypeContentItem> addlist) {

		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				final Map<String, String> map = new HashMap<String, String>();
				map.put("goMoney", sumprice);
				JSONArray array = new JSONArray();
				for (int i = 0; i < addlist.size(); i++) {
					TypeContentItem item = addlist.get(i);
					JSONObject obj = new JSONObject();
					obj.put("num", item.getAddNum());
					obj.put("goodsId", item.getInfoitem().getGoodsId());
					array.add(obj);
				}
				map.put("goodsList", array.toJSONString());
				map.put("reserveBoxId", boxId);
				map.put("token", Constants.getToken());
				JSONObject result = null;
				if (Constants.getBoxInfo().isStarting() ||Constants.getBoxInfo().isFromLocal()) {
					 result = HttpUtils.getJsonByPost(Constants.getCartingUrl(ktvip, true), map);
				}
				if (result == null) {
					result = HttpUtils.getJsonByPost(Constants.getCartingUrl(true), map);
				}
				String content = "";
				if (result != null) {
					content = result.toString();
				}
				return content;
			}

			@Override
			protected void onCompletion(Object result, Throwable exception, boolean cancelled) {
				super.onCompletion(result, exception, cancelled);
				refreshUiInterface.refreshUi(result);
			}
		}.run();
	}

}
