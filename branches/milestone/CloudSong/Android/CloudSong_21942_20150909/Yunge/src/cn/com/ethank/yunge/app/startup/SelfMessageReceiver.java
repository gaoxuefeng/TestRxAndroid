package cn.com.ethank.yunge.app.startup;

import java.util.Map;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.IInterface;
import android.util.Log;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestUnSingedSong;
import cn.com.ethank.yunge.app.jpush.JPushBean;
import cn.com.ethank.yunge.app.jpush.YungeJPushType;
import cn.com.ethank.yunge.app.util.Constants;

import com.alibaba.fastjson.JSONObject;

/***
 * 处理自定义激光推送位置
 */
public class SelfMessageReceiver extends BroadcastReceiver {

	@Override
	public void onReceive(Context context, Intent intent) {
		if (Constants.MESSAGE_RECEIVED_ACTION.equals(intent.getAction())) {
			String message = intent.getStringExtra(Constants.KEY_MESSAGE);
			Object pushObject = JSONObject.parse(message);
			JPushBean jPushBean = JSONObject.parseObject(pushObject.toString(), JPushBean.class);
			Log.i("jpush", message);
			// 登录后才会接收这些消息
			if (Constants.getLoginState() && isCurrentRoom(jPushBean)) {
				Intent sendIntent = new Intent();
				sendIntent.putExtra(Constants.KEY_MESSAGE, message);

				switch (jPushBean.getType()) {
				case roomDynamic:
					// 房间动态
					sendIntent.setAction(YungeJPushType.getAction(YungeJPushType.roomDynamic));
					break;
				case addSong:
					// 点歌
					requestUnSingedSongList(context);// 获取已点未唱
					sendIntent.setAction(YungeJPushType.getAction(YungeJPushType.changeSong));
					break;
				case changeSong:
					// 切歌
					requestUnSingedSongList(context);// 获取已点未唱
					sendIntent.setAction(YungeJPushType.getAction(YungeJPushType.changeSong));
					break;
				case clearRoom:
					// 清房
					sendIntent.setAction(YungeJPushType.getAction(YungeJPushType.clearRoom));
					Intent exitRoomIntent = new Intent();
					exitRoomIntent.setAction(Constants.EXITROOM_RECEIVED_ACTION);
					context.sendBroadcast(exitRoomIntent);
					Constants.setBinded(false);
					break;

				case roomOpen:
					// 开房
					sendIntent.setAction(YungeJPushType.getAction(YungeJPushType.roomOpen));
					break;
				case otherType:
					// 其他类型
					sendIntent.setAction(YungeJPushType.getAction(YungeJPushType.otherType));
					break;
				default:
					break;
				}
				context.sendBroadcast(sendIntent);

			}

		}
	}

	private boolean isCurrentRoom(JPushBean jPushBean) {
		if (jPushBean != null && !jPushBean.getReserveBoxId().isEmpty() && jPushBean.getReserveBoxId().equals(Constants.getReserveBoxId())) {
			return true;
		}
		return false;
	}

	/***
	 * 请求已点未唱列表
	 * 
	 * @param context
	 */
	void requestUnSingedSongList(Context context) {
		RequestUnSingedSong requestUnSingedSong = new RequestUnSingedSong(context);
		requestUnSingedSong.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				// 在请求完成之后已经发送了更新已点未唱显示的广播
			}

			@Override
			public void onLoaderFail() {

			}
		});
	}
}
