package cn.com.ethank.yunge.app.discover.service;

import java.util.Map;

import android.os.AsyncTask;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.discover.bean.MusicBroadInfo;
import cn.com.ethank.yunge.app.discover.bean.ResultBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONObject;

public class GetMusicBoradRequest {

	private Map<String, String> map;
	private RefreshUiInterface refreshUiInterface;

	public GetMusicBoradRequest(Map<String, String> map, RefreshUiInterface refreshUiInterface) {
		super();
		this.map = map;
		this.refreshUiInterface = refreshUiInterface;
	}

	public void requestData() {

		new AsyncTask<Void, Void, MusicBroadInfo>() {

			@Override
			protected MusicBroadInfo doInBackground(Void... arg0) {
				// TODO Auto-generated method stub
				JSONObject obj = HttpUtils.getJsonByPost(Constants.GETMUSICINFO, map);
				if (obj == null) {
					return null;
				}
				String result = obj.toString();

				if (result != null && !result.isEmpty()) {
					try {
						ResultBean bean = JSONObject.parseObject(result, ResultBean.class);
						if (bean.getCode() == 0 && bean.getData() != null && !bean.getData().isEmpty()) {

							return JSONObject.parseObject(bean.getData(), MusicBroadInfo.class);
						} else {
							return null;
						}
					} catch (Exception e) {
						// TODO: handle exception
						return null;
					}
				} else {
					return null;
				}
			}

			@Override
			protected void onPostExecute(MusicBroadInfo result) {
				// TODO Auto-generated method stub
				super.onPostExecute(result);
				refreshUiInterface.refreshUi(result);
			}
		}.execute();
	}

}
