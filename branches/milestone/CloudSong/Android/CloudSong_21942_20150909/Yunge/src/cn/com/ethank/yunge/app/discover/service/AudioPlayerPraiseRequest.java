package cn.com.ethank.yunge.app.discover.service;

import java.util.Map;

import android.os.AsyncTask;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.discover.bean.ResultBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONObject;

public class AudioPlayerPraiseRequest {

	private RefreshUiInterface refreshUiInterface;
	private Map<String, String> map;

	public AudioPlayerPraiseRequest(RefreshUiInterface refreshUiInterface, Map<String, String> map) {
		super();
		this.refreshUiInterface = refreshUiInterface;
		this.map = map;
	}

	public void requestData() {

		new AsyncTask<Void, Void, JSONObject>() {
			@Override
			protected JSONObject doInBackground(Void... params) {
				JSONObject result = HttpUtils.getJsonByPost(Constants.GETMUSPRAISE, map);
				if (result != null && !result.isEmpty()) {
					ResultBean bean = JSONObject.parseObject(result.toString(), ResultBean.class);
					if (bean.getCode() == 0 && bean.getData() != null && !bean.getData().isEmpty()) {
						try {
							JSONObject obj = JSONObject.parseObject(bean.getData());
							return obj;
						} catch (Exception e) {
							return null;
						}
					} else {
						return null;
					}
				} else {
					return null;
				}
			}

			@Override
			protected void onPostExecute(JSONObject result) {
				refreshUiInterface.refreshUi(result);
				super.onPostExecute(result);
			}
		}.execute();
	}
}
