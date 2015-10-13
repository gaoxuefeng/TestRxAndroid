package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.HashMap;
import java.util.List;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import cn.com.ethank.yunge.app.demandsongs.activity.SongListActivity;
import cn.com.ethank.yunge.app.mine.fragment.CustomDialogNewData;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 在收到切歌变化的时候调用 已点未唱歌曲 只能连接KTV服务器
 * 
 * @author Gao Xuefeng
 * 
 */
public class RequestUnSingedSong extends BaseRequest {

	private Context context;
	private HashMap<String, String> hashMap;
	private String url;

	public RequestUnSingedSong(Context context) {
		this.context = context;
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("reserveBoxId", Constants.getReserveBoxId());
		hashMap.put("token", Constants.getToken());
		this.hashMap = hashMap;
		this.url = Constants.getKTVIP().concat(Constants.REQUEST_UNSINGED_SONG);

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
				boolean success = resloveResult(result);
				if (!success) {
				} else {
				}
			}

			private boolean resloveResult(Object result) {
				if (result != null && result instanceof JSONObject) {
					JSONObject resObject = (JSONObject) result;
					if (ResoloveResult.getDataSuccess(context, resObject) && resObject.containsKey("data")) {
						JSONArray jsonArray = resObject.getJSONArray("data");
						List<String> singedSongList = JSONArray.parseArray(jsonArray.toJSONString(), String.class);
						if (singedSongList != null) {
							Constants.demandedSongIdList = singedSongList;
							Intent bindIntent = new Intent(Constants.UNSINGED_SONG_RECEIVED_ACTION);
							context.sendBroadcast(bindIntent);
						}

						return true;
					}
				}
				return false;
			}
		}.run();

	}

}
