package cn.com.ethank.yunge.app.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.mine.bean.RoomUserInfo;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.startup.LoadingActivity;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

public class GetRoomInfoRequest extends BaseRequest {

	// /**
	// * 根据用户信息，判断是否有房间，展示不同的tab
	// */

	private Context context;
	private Map<String, String> map;

	public GetRoomInfoRequest(Context context) {
		this.context = context;
		Map<String, String> map = new HashMap<String, String>();
		map.put("token", Constants.getToken());
		this.map = map;
	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<String>() {

			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.QUERYINFO, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				boolean success = resloveResult(requestCallBack, result);
				if (success) {
					requestCallBack.onLoaderFinish(null);
				} else {
					LoadingActivity.myRooms = new ArrayList<BoxDetail>();
					requestCallBack.onLoaderFail();
				}

			};

		}.run();

	}

	private boolean resloveResult(final RequestCallBack requestCallBack, Object result) {
		try {
			if (result != null ) {
				RoomUserInfo roomUserInfo = JSON.parseObject(result.toString(), RoomUserInfo.class);
				List<BoxDetail> myRooms = roomUserInfo.getData().getMyRooms();
				if (myRooms != null && myRooms.size() != 0) {
					LoadingActivity.myRooms = myRooms;
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo,JSONObject.toJSONString(myRooms.get(0)) );
					SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId,myRooms.get(0).getReserveBoxId());
					Constants.setBinded(true);
					return true;
				}

			}else {
				
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}
}
