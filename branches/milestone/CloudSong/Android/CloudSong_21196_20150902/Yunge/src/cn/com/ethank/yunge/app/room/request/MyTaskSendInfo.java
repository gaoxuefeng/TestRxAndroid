package cn.com.ethank.yunge.app.room.request;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.view.TextureView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.room.bean.GetNewInfo.New;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.room.bean.RoomStateInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;

public class MyTaskSendInfo extends BackgroundTask<String> {

	Map<String, String> map;
	EditText room_et_send;
	TextView room_iv_click;
	List<New> news = new ArrayList<New>();
	BoxDetail myRoom;
	public MyTaskSendInfo(Map<String, String> map, EditText room_et_send, TextView room_iv_click,
			List<New> news, BoxDetail myRoom) {
		this.map = map;
		this.room_et_send = room_et_send;
		this.room_iv_click = room_iv_click;
		this.news = news;
		this.myRoom = myRoom;
	}

	@Override
	protected String doWork() throws Exception {
		// TODO 修改网络琨
		return HttpUtils.getJsonByPost(Constants.getKTVIP() + Constants.ADDINFO, map).toString();

	}

	protected void onCompletion(String result, Throwable exception, boolean cancelled) {
		if (result != null) {
			RoomStateInfo roomStateInfo = (RoomStateInfo) JSON.parseObject(result, RoomStateInfo.class);
			if(roomStateInfo != null){
				
				if (roomStateInfo.getCode() == 0) {
					ToastUtil.show("发送成功");
					room_et_send.setText("");
					room_iv_click.setBackgroundResource(R.drawable.room_add_icon);
					
					final Map<String, String> map = new HashMap<String, String>();
					map.put("msgId", news.size() + "");
					map.put("reserveBoxId", myRoom.getReserveBoxId());
					map.put("token", Constants.getToken());
					
					// new GetRoomData(map,new1).run();
					
				} else {
					ToastUtil.show(roomStateInfo.getMessage());
				}
			}
		} else {
			ToastUtil.show(R.string.connectfailtoast);
		}
	};

}
