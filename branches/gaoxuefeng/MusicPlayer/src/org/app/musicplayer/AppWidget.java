package org.app.musicplayer;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.RemoteViews;

public class AppWidget extends AppWidgetProvider {
	private static final String PLAY_ACTION = "com.app.playmusic";
	private static final String NEXT_ACTION = "com.app.nextone";
	private static final String lAST_ACTION = "com.app.lastone";
	private static final String START_APP = "com.app.startapp";
	@Override
	public void onDeleted(Context context, int[] appWidgetIds) {
		Log.i("info", "onDeleted...");
		super.onDeleted(context, appWidgetIds);
	}

	@Override
	public void onDisabled(Context context) {
		Log.i("info", "onDisabled...");
		super.onDisabled(context);
	}

	@Override
	public void onEnabled(Context context) {
		Log.i("info", "onEnabled...");
		super.onEnabled(context);
	}

	@Override
	public void onReceive(Context context, Intent intent) {
		RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.appwidgetlayout);
		if (intent.getAction().equals("com.app.pause")){
			views.setImageViewResource(R.id.playButton, R.drawable.player_btn_player_play);
		} else if (intent.getAction().equals("com.app.play")){
			views.setImageViewResource(R.id.playButton, R.drawable.player_btn_player_pause);
		} else if (intent.getAction().equals("com.app.musictitle")){
			String musicName = intent.getExtras().getString("title");
			if (musicName.length()>6){
				musicName = musicName.substring(0, 5)+"...";
			}
			views.setTextViewText(R.id.title, musicName);
		}
		AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context); 
        ComponentName componentName = new ComponentName(context,AppWidget.class); 
        appWidgetManager.updateAppWidget(componentName, views);
		Log.i("info", "onReceive...");
		super.onReceive(context, intent);
	}

	@Override
	public void onUpdate(Context context, AppWidgetManager appWidgetManager,
			int[] appWidgetIds) {
		Log.i("info", "onUpdate...");
		RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.appwidgetlayout);
		/*���ò��ż��Ķ���*/
		views.setImageViewResource(R.id.playButton, R.drawable.player_btn_player_next);
		Intent playIntent = new Intent(PLAY_ACTION);
		PendingIntent playPending = PendingIntent.getBroadcast(context, 0, playIntent, 0);
		views.setOnClickPendingIntent(R.id.playButton, playPending);
		/*������һ�װ�ť�Ķ���*/
		Intent lastIntent = new Intent(lAST_ACTION);
		PendingIntent lastPending = PendingIntent.getBroadcast(context, 0, lastIntent, 0);
		views.setOnClickPendingIntent(R.id.lastButton, lastPending);
		/*������һ�װ�ť�Ķ���*/
		Intent nextIntent = new Intent(NEXT_ACTION);
		PendingIntent nextPending = PendingIntent.getBroadcast(context, 0, nextIntent, 0);
		views.setOnClickPendingIntent(R.id.nextButton, nextPending);
		
		/*��ȡ���ڲ��ŵ�������*/
		Intent intent = new Intent();
		intent.setAction(START_APP);
		context.sendBroadcast(intent);
		
		appWidgetManager.updateAppWidget(appWidgetIds, views);
	}

}
