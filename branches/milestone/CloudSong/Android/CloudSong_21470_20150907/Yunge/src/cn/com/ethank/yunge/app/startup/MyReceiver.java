package cn.com.ethank.yunge.app.startup;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.jpush.android.api.CustomPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;

/**
 * 激光推送所有接收位置,如果是自定义推送则跳到JpushMessageReceiver中处理信息
 * 
 * 如果不定义这个 Receiver，则： 1) 默认用户会打开主界面 2) 接收不到自定义消息
 */
public class MyReceiver extends BroadcastReceiver {
	private static final String TAG = "JPush";

	@Override
	public void onReceive(Context context, Intent intent) {
		try {
			resoloveReceive(context, intent);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void resoloveReceive(Context context, Intent intent) {
		Bundle bundle = intent.getExtras();
		// Log.d(TAG, "[MyReceiver] onReceive - " + intent.getAction() +
		// ", extras: " + printBundle(bundle));

		if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
			String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
			Log.d(TAG, "[MyReceiver] 接收Registration Id : " + regId);
			// send the Registration Id to your server...

		} else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
			Log.d(TAG, "[MyReceiver] 接收到推送下来的自定义消息: " + bundle.getString(JPushInterface.EXTRA_MESSAGE));
			processCustomMessage(context, bundle);

		} else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {

			Log.d(TAG, "[MyReceiver] 接收到推送下来的通知");
			int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);
			Log.d(TAG, "[MyReceiver] 接收到推送下来的通知的ID: " + notifactionId);
			CustomPushNotificationBuilder builder = new CustomPushNotificationBuilder(context, R.layout.customer_notitfication_layout, R.id.icon,
					R.id.title, R.id.text); // 指定定制的 Notification
											// Layout
			builder.statusBarDrawable = R.drawable.ic_launcher; // 指定最顶层状态栏小图标
			builder.layoutIconDrawable = R.drawable.ic_language; // 指定下拉状态栏时显示的通知图标
			JPushInterface.setPushNotificationBuilder(2, builder);
		} else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
			Log.d(TAG, "[MyReceiver] 用户点击打开了通知");

			// 打开自定义的Activity
			Intent i = new Intent(context, LoginActivity.class);
			i.putExtras(bundle);
			// i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
			context.startActivity(i);

		} else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
			Log.d(TAG, "[MyReceiver] 用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
			// 在这里根据 JPushInterface.EXTRA_EXTRA 的内容处理代码，比如打开新的Activity，
			// 打开一个网页等..

		} else if (JPushInterface.ACTION_CONNECTION_CHANGE.equals(intent.getAction())) {
			boolean connected = intent.getBooleanExtra(JPushInterface.EXTRA_CONNECTION_CHANGE, false);
			Log.w(TAG, "[MyReceiver]" + intent.getAction() + " connected state change to " + connected);
		} else {
			Log.d(TAG, "[MyReceiver] Unhandled intent - " + intent.getAction());
		}
	}

	// 打印所有的 intent extra 数据
	private static String printBundle(Bundle bundle) {
		// StringBuilder sb = new StringBuilder();
		// for (String key : bundle.keySet()) {
		// if (key.equals(JPushInterface.EXTRA_NOTIFICATION_ID)) {
		// sb.append("\nkey:" + key + ", value:" + bundle.getInt(key));
		// } else if (key.equals(JPushInterface.EXTRA_CONNECTION_CHANGE)) {
		// sb.append("\nkey:" + key + ", value:" + bundle.getBoolean(key));
		// } else {
		// sb.append("\nkey:" + key + ", value:" + bundle.getString(key));
		// }
		// }
		// return sb.toString();
		return "";
	}

	// send msg to MainActivity
	private void processCustomMessage(Context context, Bundle bundle) {
		if (MainTabActivity.isForeground) {
			String message = bundle.getString(JPushInterface.EXTRA_MESSAGE);
			String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
			Intent msgIntent = new Intent(Constants.MESSAGE_RECEIVED_ACTION);
			msgIntent.putExtra(Constants.KEY_MESSAGE, message);
			// ToastUtil.show(message);
			// if (extras != null && !extras.isEmpty()) {
			try {
				JSONObject extraJson = new JSONObject(extras);
				if (null != extraJson && extraJson.length() > 0) {
					msgIntent.putExtra(Constants.KEY_EXTRAS, extras);
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}

			// }
			context.sendBroadcast(msgIntent);
		}
	}
}
