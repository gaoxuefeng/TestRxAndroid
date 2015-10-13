package org.app.music.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.app.music.db.DBHelper;
import org.app.musicplayer.PlayMusicActivity;
import org.app.musicplayer.R;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.Uri;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.provider.MediaStore;
import android.telephony.TelephonyManager;
import android.util.Log;
/**
 * ���в��Ų�������������,Ҫ�������Ϊ��ʵ�ֺ�̨����,������÷�����ôһ������رպ�����Ҳ������ʧ�ˡ� �������˷�����������������ˡ�����Ҫ��������
 * �ں�̨���š�ֱ���û��ѷ�����ɱ�ˡ�
 * @author ����
 */
public class MusicService extends Service implements MediaPlayer.OnCompletionListener {
	/** ���͸�����һЩAction */
	private static final String MUSIC_CURRENT = "com.app.currentTime";
	private static final String MUSIC_DURATION = "com.app.duration";
	private static final String MUSIC_UPDATE = "com.app.update";
	private static final String MUSIC_LIST = "com.app.list";
	private static final int MUSIC_PLAY = 1;
	private static final int MUSIC_PAUSE = 2;
	private static final int MUSIC_STOP = 3;
	private static final int PROGRESS_CHANGE = 4;
	private MediaPlayer mp = null;// Mediaplayer����
	private Uri uri = null;
	private int id = 10000;
	private Handler handler = null;
	private int currentTime;// ����ʱ��
	private int duration;// ��ʱ��
	private DBHelper dbHelper = null;// ���ݿ����
	private int flag;// ��ʶ
	private int position;// λ��
	private int _ids[];// ����id
	private String _titles[];// ����
	private String _artists[];// ������
	private int _id;
	private String _title;
	private String _artist;
	public static Notification notification;// ֪ͨ����ʾ��ǰ��������
	public static NotificationManager nm;
	
   
	@Override
	public void onCreate() {
		super.onCreate();
		if (mp != null) {
			mp.reset();
			mp.release();
			mp = null;
		}
		mp = new MediaPlayer();// ʵ����mediaplayer
		mp.setOnCompletionListener(this);// ������һ�ײ��ż���
		ShowNotifcation();
		IntentFilter filter = new IntentFilter();
		filter.addAction("android.intent.action.ANSWER");
		registerReceiver(PhoneListener, filter);

		IntentFilter filter1 = new IntentFilter();
		filter1.addAction("com.app.playmusic");
		filter1.addAction("com.app.nextone");
		filter1.addAction("com.app.lastone");
		filter1.addAction("com.app.startapp");
		registerReceiver(appWidgetReceiver, filter1);
		
		

	}

	/**
	 * ����ʼ����ʱ��֪ͨ����ʾ��ǰ������Ϣ
	 */
	private void ShowNotifcation() {
		nm = (NotificationManager) getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);//��ȡ֪ͨ��ϵͳ�������
		notification = new Notification();// ʵ����֪ͨ��
		notification.icon = R.drawable.music;// Ϊ֪ͨ������ͼ��
		notification.defaults = Notification.DEFAULT_LIGHTS;// Ĭ�ϵ�
		notification.flags |= Notification.FLAG_AUTO_CANCEL;// ��Զפ��
		notification.when = System.currentTimeMillis();// ���ϵͳʱ��
		notification.tickerText = _title;//��֪ͨ����ʾ�йص���Ϣ
		notification.tickerText = _artist;
		Intent intent2 = new Intent(getApplicationContext(),PlayMusicActivity.class);
		intent2.putExtra("_ids", _ids);
		intent2.putExtra("_titles", _titles);
		intent2.putExtra("_artists", _artists);
		intent2.putExtra("position", position);
		PendingIntent contentIntent = PendingIntent.getActivity(getApplicationContext(), 0, intent2,PendingIntent.FLAG_UPDATE_CURRENT);
		notification.setLatestEventInfo(getApplicationContext(), _title, _artist,contentIntent);
		nm.notify(0, notification);

	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		Log.e("Service:-------->", "�����Ѿ��ر�");
		nm.cancelAll();// �����֪ͨ������Ϣ
		if (mp != null) {
			mp.stop();// ֹͣ����
			mp = null;
		}
		if (dbHelper != null) {
			dbHelper.close();// �ر����ݿ�
			dbHelper = null;
		}
		if (handler != null) {
			handler.removeMessages(1);//�Ƴ���Ϣ
			handler = null;
		}
	}

	@Override
	public void onStart(Intent intent, int startId) {
		super.onStart(intent, startId);
		if ((flag == 0) && (intent.getExtras().getInt("list") == 1)) {
			System.out.println("Service flag=0");
			return;
		}
		if (intent.getIntArrayExtra("_ids") != null) {
			_ids = intent.getIntArrayExtra("_ids");
			_titles = intent.getStringArrayExtra("_titles");
			_artists = intent.getStringArrayExtra("_artists");
		}
		int position1 = intent.getIntExtra("position", -1);
		if (position1 != -1) {
			position = position1;
			_id = _ids[position];
			_title = _titles[position];
			_artist = _artists[position];
		}
		// ���͵ĳ���
		int length = intent.getIntExtra("length", -1);
		if (_id != -1) {
			if (id != _id) {
				id = _id;
				uri = Uri.withAppendedPath(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, "" + _id);
				DBOperate(_id);
				try {
					mp.reset();
					mp.setDataSource(this, uri);

				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (length == 1) {

				try {
					mp.reset();
					mp.setDataSource(this, uri);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		setup();
		init();
		if (position != -1) {
			Intent intent1 = new Intent();
			intent1.setAction(MUSIC_LIST);
			intent1.putExtra("position", position);
			sendBroadcast(intent1);
			Intent intent2 = new Intent("com.app.musictitle");
			intent2.putExtra("title", _title);
			sendBroadcast(intent2);
			Intent playIntent = new Intent("com.app.play");
			sendBroadcast(playIntent);
		}
		/**
		 * ��ʼ������
		 */
		int op = intent.getIntExtra("op", -1);
		if (op != -1) {
			switch (op) {
			case MUSIC_PLAY:// ����
				if (!mp.isPlaying()) {
					play();
				}
				break;
			case MUSIC_PAUSE:// ��ͣ
				if (mp.isPlaying()) {
					pause();
				}
				break;
			case MUSIC_STOP:// ֹͣ��
				stop();
				break;
			case PROGRESS_CHANGE:// �������ı�
				currentTime = intent.getExtras().getInt("progress");
				mp.seekTo(currentTime);
				break;

			}
		}
		ShowNotifcation();
	
	}

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}

	/***����*/
	private void play() {
		if (mp != null) {
			mp.start();
		}
		flag = 1;

	}

	/**��ͣ*/
	private void pause() {
		if (mp != null) {
			mp.pause();
		}
		flag = 1;
	}

	/** ֹͣ*/
	private void stop() {
		if (mp != null) {
			mp.stop();
			try {
				mp.prepare();
				mp.seekTo(0);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			handler.removeMessages(1);

		}
	}

	/** ��ʼ������*/
	private void init() {
		final Intent intent = new Intent();
		intent.setAction(MUSIC_CURRENT);
		if (handler == null) {
			handler = new Handler() {
				@Override
				public void handleMessage(Message msg) {
					super.handleMessage(msg);
					if (msg.what == 1) {
						if (flag == 1) {
							currentTime = mp.getCurrentPosition();
							intent.putExtra("currentTime", currentTime);
							sendBroadcast(intent);
						}
						handler.sendEmptyMessageDelayed(1, 600);
					}
				}
			};
		}
	}

	/** ��ʼ��1*/
	private void setup() {
		final Intent intent = new Intent();
		intent.setAction(MUSIC_DURATION);
		try {
			if (!mp.isPlaying()) {
				mp.prepare();
			}
			mp.setOnPreparedListener(new OnPreparedListener() {
				@Override
				public void onPrepared(MediaPlayer mp) {
					handler.sendEmptyMessage(1);
				}
			});
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		duration = mp.getDuration();
		intent.putExtra("duration", duration);
		sendBroadcast(intent);
	}

	/** ������λ��*/
	private int getRandomPostion(boolean loopAll) {
		int ret = -1;

		if (PlayMusicActivity.randomNum < _ids.length - 1) {
			PlayMusicActivity.randomIDs[PlayMusicActivity.randomNum] = position;
			ret = PlayMusicActivity.findRandomSound(_ids.length);
			PlayMusicActivity.randomNum++;

		} else if (loopAll == true) {
			PlayMusicActivity.randomNum = 0;
			for (int i = 0; i < _ids.length; i++) {
				PlayMusicActivity.randomIDs[i] = -1;
			}
			PlayMusicActivity.randomIDs[PlayMusicActivity.randomNum] = position;
			ret = PlayMusicActivity.findRandomSound(_ids.length);
			PlayMusicActivity.randomNum++;
		}

		return ret;
	}

	/**
	 * ��һ��
	 */
	private void nextOne() {
		ShowNotifcation();
		if (_ids.length == 1|| PlayMusicActivity.loop_flag == PlayMusicActivity.LOOP_ONE) {
			position = position;

		} else if (PlayMusicActivity.loop_flag == PlayMusicActivity.LOOP_ALL) {
			if (PlayMusicActivity.random_flag == true) {// ������λ��
				int i = getRandomPostion(true);
				if (i == -1) {
					stop();
					return;
				} else {
					position = i;
				}
			} else {
				if (position == _ids.length - 1) {
					position = 0;
				} else if (position < _ids.length - 1) {
					position++;
				}
			}

		} else if (PlayMusicActivity.loop_flag == PlayMusicActivity.LOOP_NONE) {
			if (PlayMusicActivity.random_flag == true) {//
				int i = getRandomPostion(false);
				if (i == -1) {
					stop();
					return;
				} else {
					position = i;
				}
			} else {
				if (position == _ids.length - 1) {
					stop();
					return;
				} else if (position < _ids.length - 1) {
					position++;
				}
			}
		}
		uri = Uri.withAppendedPath(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
				"" + _ids[position]);
		DBOperate(_ids[position]);
		id = _ids[position];
		_title = _titles[position];
		_id = id;
		try {
			mp.reset();
			mp.setDataSource(this, uri);

		} catch (Exception e) {
			e.printStackTrace();
		}
		handler.removeMessages(1);

		setup();
		init();
		play();

		Intent intent = new Intent();
		intent.setAction(MUSIC_LIST);
		intent.putExtra("position", position);
		sendBroadcast(intent);

		Intent intent1 = new Intent();
		intent1.setAction(MUSIC_UPDATE);
		intent1.putExtra("position", position);
		sendBroadcast(intent1);

		Intent intent2 = new Intent("com.app.musictitle");
		intent2.putExtra("title", _title);
		sendBroadcast(intent2);

	}

	/** ��һ��*/
	private void lastOne() {
		ShowNotifcation();
		if (_ids.length == 1) {
			position = position;

		} else if (position == 0) {
			position = _ids.length - 1;
		} else if (position > 0) {
			position--;
		}
		uri = Uri.withAppendedPath(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
				"" + _ids[position]);
		DBOperate(_ids[position]);
		id = _ids[position];
		_title = _titles[position];
		_id = id;
		try {
			mp.reset();
			mp.setDataSource(this, uri);
		} catch (Exception e) {
			e.printStackTrace();
		}
		handler.removeMessages(1);
		setup();
		init();
		play();

		Intent intent = new Intent();
		intent.setAction(MUSIC_LIST);
		intent.putExtra("position", position);
		sendBroadcast(intent);

		Intent intent1 = new Intent();
		intent1.setAction(MUSIC_UPDATE);
		intent1.putExtra("position", position);
		sendBroadcast(intent1);

		Intent intent2 = new Intent("com.app.musictitle");
		intent2.putExtra("title", _title);
		sendBroadcast(intent2);
	}

	@Override
	public void onCompletion(MediaPlayer mp) {
		nextOne();
	}

	/** �������ݿ�*/
	private void DBOperate(int pos) {
		dbHelper = new DBHelper(this, "music.db", null, 2);
		Cursor c = dbHelper.query(pos);
		Date currentTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String dateString = formatter.format(currentTime);
		try {
			if (c==null||c.getCount()==0){
				ContentValues values = new ContentValues();
				values.put("music_id", pos);
				values.put("clicks", 1);
				values.put("latest", dateString);
				dbHelper.insert(values);
			} else {
				c.moveToNext();
				int clicks = c.getInt(2);
				clicks++;
				ContentValues values = new ContentValues();
				values.put("clicks", clicks);
				values.put("latest", dateString);
				dbHelper.update(values, pos);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (c != null) {
			c.close();
			c = null;
		}
		if (dbHelper!=null){
			dbHelper.close();
			dbHelper = null;
		}
	}

	/*** ����ʱ��������״̬*/
	protected BroadcastReceiver PhoneListener = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			if (intent.getAction().equals(Intent.ACTION_ANSWER)) {
				TelephonyManager telephonymanager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
				switch (telephonymanager.getCallState()) {
				case TelephonyManager.CALL_STATE_RINGING:// ��������ʱ����ͣ���֣����������ԣ�ֻ�ǰ��������Ͷ���
					pause();
					break;
				case TelephonyManager.CALL_STATE_OFFHOOK:
					play();
					break;
				default:
					break;
				}
			}
		}
	};
	/** ����С���*/
	protected BroadcastReceiver appWidgetReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			if (intent.getAction().equals("com.app.playmusic")) {
				if (mp.isPlaying()) {
					pause();
					Intent pauseIntent = new Intent("com.app.pause");
					sendBroadcast(pauseIntent);
				} else {
					play();
					Intent playIntent = new Intent("com.app.play");
					sendBroadcast(playIntent);
				}
			} else if (intent.getAction().equals("com.app.nextone")) {
				nextOne();
				Intent playIntent = new Intent("com.app.play");
				sendBroadcast(playIntent);
			} else if (intent.getAction().equals("com.app.lastone")) {
				lastOne();
				Intent playIntent = new Intent("com.app.play");
				sendBroadcast(playIntent);
			} else if (intent.getAction().equals("com.app.startapp")) {
				Intent intent1 = new Intent("com.app.musictitle");
				intent1.putExtra("title", _title);
				sendBroadcast(intent1);
			}
		}
	};
	
}
