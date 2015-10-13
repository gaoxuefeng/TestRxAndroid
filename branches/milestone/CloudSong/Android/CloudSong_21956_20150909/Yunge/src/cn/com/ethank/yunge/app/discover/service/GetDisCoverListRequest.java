package cn.com.ethank.yunge.app.discover.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import android.os.AsyncTask;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.discover.bean.ResultBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class GetDisCoverListRequest {

	private RefreshUiInterface refreshUiInterface;
	private Map<String, String> map;

	public GetDisCoverListRequest(RefreshUiInterface refreshUiInterface, Map<String, String> map) {
		super();
		this.refreshUiInterface = refreshUiInterface;
		this.map = map;
	}

	public void requestData() {

		new AsyncTask<Void, Void, List<DiscoverInfo>>() {
			@Override
			protected List<DiscoverInfo> doInBackground(Void... params) {

				JSONObject result = HttpUtils.getJsonByPost(Constants.GETDISCOVERLIST, map);

				if (result != null && !result.isEmpty()) {
					ResultBean bean = JSONObject.parseObject(result.toString(), ResultBean.class);
					if (bean.getCode() == 0 && bean.getData() != null && !bean.getData().isEmpty()) {
						List<DiscoverInfo> list = JSONArray.parseArray(bean.getData(), DiscoverInfo.class);
					
						return list;
					} else {
						return null;
					}
				} else {
					return null;
				}
			}

			@Override
			protected void onPostExecute(List<DiscoverInfo> result) {
				if (result != null) {
					refreshUiInterface.refreshUi(result);
				} else {
					refreshUiInterface.refreshUi(new ArrayList<DiscoverInfo>());
				}
				super.onPostExecute(result);
			}
		}.execute();
	}
}
