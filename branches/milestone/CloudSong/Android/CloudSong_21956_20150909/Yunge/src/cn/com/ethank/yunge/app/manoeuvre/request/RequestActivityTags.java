package cn.com.ethank.yunge.app.manoeuvre.request;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.MyFastJson;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.manoeuvre.bean.TagsBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestActivityTags extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestActivityTags(Context context, HashMap<String, String> hashMap) {
		this.context = context;
		this.hashMap = hashMap;
		this.url = Constants.hostUrlCloud.concat(Constants.REQUEST_ACTIVITY_TAGS);

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
				List<TagsBean> tagsBeans = null;
				try {
					if (result instanceof JSONObject && ResoloveResult.getDataSuccess(context, (JSONObject) result)) {
						JSONArray jsonArray = MyFastJson.getJsonArray(result, "data");
						if (jsonArray != null) {
							tagsBeans = JSONArray.parseArray(jsonArray.toJSONString(), TagsBean.class);
						}

					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				/**
				 * 如果没有数据,或者断网,都要返回全部
				 */
				if (tagsBeans == null) {
					tagsBeans = new ArrayList<TagsBean>();
				}
				if (!tagBeansContainAll(tagsBeans)) {
					TagsBean tagsBean = new TagsBean();
					tagsBean.setTagId(10000);
					tagsBean.setTagName("全部");
					tagsBeans.add(0, tagsBean);
				}

				HashMap<String, List<TagsBean>> map = new HashMap<String, List<TagsBean>>();
				map.put("data", tagsBeans);
				requestCallBack.onLoaderFinish(map);
				return true;
			}

			private boolean tagBeansContainAll(List<TagsBean> tagsBeans) {
				for (int i = 0; i < tagsBeans.size(); i++) {
					if (tagsBeans.get(i).getTagName().equals("全部")) {
						return true;
					}
				}
				return false;
			}
		}.run();

	}

}
