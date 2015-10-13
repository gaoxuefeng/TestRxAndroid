package cn.com.ethank.yunge.app.home.requestNetWork;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.MyFastJson;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.home.bean.CityCircleBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestCityCircledata extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestCityCircledata(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		this.url = Constants.hostUrlCloud.concat(Constants.REQUEST_CITI_CIRCLE);
	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {

				return HttpUtils.getJsonByPost(url, hashMap);

			}

			@Override
			protected void onCompletion(Object result, Throwable exception, boolean cancelled) {
				super.onCompletion(result, exception, cancelled);
				boolean success = resloveResult(requestCallBack, result);
				if (!success) {
					// 测试
					requestCallBack.onLoaderFail();
				} else {
					// requestCallBack.onLoaderFinish(hashMap);
				}

			}

			private boolean resloveResult(RequestCallBack requestCallBack, Object result) {
				try {
					if (result != null && result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {

						JSONArray myResult = MyFastJson.getJsonArray(result, "data");
						if (myResult != null) {
							List<CityCircleBean> cityCircleBeans = JSONObject.parseArray(myResult.toJSONString(), CityCircleBean.class);
							if (cityCircleBeans != null) {
								CityCircleBean cityCircleBean = new CityCircleBean();
								cityCircleBean.setDistrict("全城");
								ArrayList<String> arrayList = new ArrayList<String>();
								arrayList.add("全城");
								cityCircleBean.setCircleName(arrayList);
								cityCircleBeans.add(0, cityCircleBean);
								HashMap<String, List<CityCircleBean>> map = new HashMap<String, List<CityCircleBean>>();
								map.put("data", cityCircleBeans);
								requestCallBack.onLoaderFinish(map);
								return true;
							}

						}

					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				return false;
			}

		}.run();

	}

}
