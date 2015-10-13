package cn.com.ethank.yunge.app.homepager.request;

import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.SinglerOnLine;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.MyFastJson;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.JsonCacheKeyUtil;
import cn.com.ethank.yunge.app.util.JsonCacheUtil;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestActivityPraise extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;
	private int praiseType;

	public RequestActivityPraise(Context context, HashMap<String, String> hashMap, int praiseType) {
		this.context = context;
		this.hashMap = hashMap;
		// 点赞或者取消点赞 点赞 0,取消点赞1;
		this.praiseType = praiseType;
		this.url = Constants.hostUrlCloud.concat(Constants.REQUEST_ACTIVITY_PRAISE);
		hashMap.put("type", praiseType + "");
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
				} else {
					requestCallBack.onLoaderFinish(null);
				}
			}

			private boolean resloveResult(final RequestCallBack requestCallBack, Object result) {
				try {
					if (result!=null&&result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {
						return true;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				return false;
			}
		}.run();

	}

	public int getPraiseType() {
		return praiseType;

	}
}
