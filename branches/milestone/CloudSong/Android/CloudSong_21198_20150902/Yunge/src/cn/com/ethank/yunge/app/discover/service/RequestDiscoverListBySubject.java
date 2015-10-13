package cn.com.ethank.yunge.app.discover.service;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.discover.bean.ResultBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestDiscoverListBySubject extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestDiscoverListBySubject(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		this.url = Constants.hostUrlCloud.concat(Constants.REQUEST_DISCOVER_LIST_BY_SUBJECT);
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
					requestCallBack.onLoaderFail();
				}
			}

			private boolean resloveResult(final RequestCallBack requestCallBack, Object result) {
				try {

					if (result != null && result instanceof JSONObject) {
						ResultBean bean = JSONObject.parseObject(result.toString(), ResultBean.class);
						if (bean.getCode() == 0 && bean.getData() != null && !bean.getData().isEmpty()) {
							List<DiscoverInfo> discoverInfos = JSONArray.parseArray(bean.getData(), DiscoverInfo.class);
							HashMap<String, List<DiscoverInfo>> hashMapResult = new HashMap<String, List<DiscoverInfo>>();
							hashMapResult.put("data", discoverInfos);
							requestCallBack.onLoaderFinish(hashMapResult);
							return true;

						} else {
							ToastUtil.show(bean.getMessage());
						}

					} else {
						ToastUtil.show(R.string.connectfailtoast);
					}

				} catch (Exception e) {
					e.printStackTrace();
				}

				return false;
			}
		}.run();

	}

}
