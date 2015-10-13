package cn.com.ethank.yunge.app.startup;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.ToastUtil;

/***
 * 处理自定义激光推送位置
 */
public class JpushMessageReceiver extends BroadcastReceiver {

	@Override
	public void onReceive(Context context, Intent intent) {
		if (Constants.MESSAGE_RECEIVED_ACTION.equals(intent.getAction())) {
			String message = intent.getStringExtra(Constants.KEY_MESSAGE);
			JSONObject object=JSON.parseObject(message);
			if (message != null && !message.isEmpty()) {
				if (Constants.isBinded()) {
					
					if (object.getString("nextSongId") != null) {
						// 切歌了
//						ToastUtil.show("切歌了");
						Intent nextSongIntent=new Intent("nextsongupdate");
						context.sendBroadcast(nextSongIntent);
						
					} else if (message.equals("roomJoin")) {
						// 新成员加入房间
						//ToastUtil.show("新成员加入房间");
					} else if (message.equals("clearRoom")) {
						// 房间关闭,清理成员
						//ToastUtil.show("清理成员");
						Constants.setBinded(false);

					}

				}

			}

		}
	}

}
