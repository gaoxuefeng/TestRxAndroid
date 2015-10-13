package cn.com.ethank.yunge.app.room.adapter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.room.bean.GetNewInfo;
import cn.com.ethank.yunge.app.room.bean.GetNewInfo.New;
import cn.com.ethank.yunge.app.room.request.MyTaskGetData;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;

public class GetRoomData extends BackgroundTask<String> {

	Map<String, String> map;
	New news1;
	List<New> news = new ArrayList<GetNewInfo.New>();
	MyAdapter myAdapter;
	ListView room_lv_info;;

	public GetRoomData(Map<String, String> map, New news1,List<New> news, MyAdapter myAdapter, ListView room_lv_info) {
		this.map = map;
		this.news1 = news1;
		this.news = news;
		this.myAdapter = myAdapter;
		this.room_lv_info = room_lv_info;
	}

	@Override
	protected String doWork() throws Exception {
		return HttpUtils.getJsonByPost(Constants.getKTVIP() + Constants.GETINFO, map).toString();
	}

	protected void onCompletion(String result, Throwable exception, boolean cancelled) {
		if (result != null) {
			GetNewInfo getNewInfo = JSON.parseObject(result, GetNewInfo.class);
			if (getNewInfo != null && getNewInfo.getData() != null) {
				news.clear();
				news.add(news1);
				news.addAll(getNewInfo.getData());
				getNewInfo.getData().size();
				myAdapter.notifyDataSetChanged();
				room_lv_info.setSelection(room_lv_info.getBottom());
			} else {
				// TODO
				new MyTaskGetData(map, news1,news, myAdapter,room_lv_info).run();
			}
		} else {
			ToastUtil.show(R.string.connectfailtoast);
		}
	};
}
