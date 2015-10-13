package cn.com.ethank.yunge.app.discover.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

import android.app.Service;
import android.content.Intent;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.os.Binder;
import android.os.IBinder;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

public class AudioService extends Service {
	private MediaPlayer mediaPlayer;
	private BindService audioBindService;
	private String musicurl;
	public static final String ACTION_PREPARED = "ACTION_PREPARED";// 准备完成发送的广播
	public static final String ACTION_COMPLETION = "ACTION_COMPLETION";// 准备完成发送的广播
	public static final int MODE_RANDOM = 0;// 随机播放
	public static final int MODE_SINGLE_REPEAT = 1;// 单曲循环
	public static final int MODE_ALL_REPEAT = 2;// 循环播放
	private int playMode = MODE_RANDOM;// 默认是随机播放
	public static int currentPosition = 0;
	private ArrayList<String> musicUrlList;

	@Override
	public IBinder onBind(Intent intent) {
		return audioBindService;
	}

	@Override
	public boolean onUnbind(Intent intent) {
		// TODO Auto-generated method stub
		return super.onUnbind(intent);
	}

	@Override
	public void onCreate() {
		super.onCreate();
		audioBindService = new BindService();
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		if (intent != null) {
			// 音乐路径
			musicUrlList = intent.getStringArrayListExtra("musicUrl");
			musicurl = intent.getStringExtra("musicurl");
			// ToastUtil.show(musicurl);
			audioBindService.playAudio();
		}

		return START_STICKY;
	}

	public class BindService extends Binder {

		private Random random;
		private int randomnumber;

		/**
		 * 播放音乐
		 */
		public void playAudio() {
			if (mediaPlayer != null) {
				mediaPlayer.release();
				mediaPlayer = null;
			}
			mediaPlayer = new MediaPlayer();
			try {
				// 取出第一个位置的
				mediaPlayer.setDataSource(musicUrlList.get(currentPosition));
				mediaPlayer.setOnPreparedListener(new MyOnPreListener());
				mediaPlayer.setOnCompletionListener(new MyOnCompletionListener());
				mediaPlayer.prepareAsync();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (SecurityException e) {
				e.printStackTrace();
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}

		}

		/**
		 * 获取时长
		 * 
		 * @return
		 */
		public long getDuration() {
			return mediaPlayer == null ? 0 : mediaPlayer.getDuration();
		}

		/**
		 * 获取当前进度
		 * 
		 * @return
		 */
		public long getCurrentPosition() {
			return mediaPlayer == null ? 0 : mediaPlayer.getCurrentPosition();
		}

		/**
		 * 暂停
		 */
		public void pause() {
			if (mediaPlayer != null) {
				mediaPlayer.pause();
			}
			// stopForeground(true);//移除通知
		}

		/**
		 * 判断是否正在播放
		 * 
		 * @return
		 */
		public boolean isPlaying() {
			return mediaPlayer == null ? false : mediaPlayer.isPlaying();
		}

		/**
		 * 开始播放
		 */
		public void start() {
			if (mediaPlayer != null) {
				mediaPlayer.start();
			}
		}

		public void seekto(int progress) {
			if (mediaPlayer != null) {
				mediaPlayer.seekTo(progress);
			}
		}

		public void playNext() {
			if (currentPosition < (musicUrlList.size() - 1)) {
				currentPosition++;
				playAudio();
			}
		}

		/**
		 * 切换3种播放模式
		 */
		public void switchPlayMode() {
			switch (playMode) {
			case MODE_RANDOM:// 如果是顺序播放就变为单曲循环
				playMode = MODE_SINGLE_REPEAT;
				break;
			case MODE_SINGLE_REPEAT:// 如果是单曲循环就变为循环播放
				playMode = MODE_ALL_REPEAT;
				break;
			case MODE_ALL_REPEAT:// 如果是循环播放就变为随机播放
				playMode = MODE_RANDOM;
				// TODO
				break;
			}
			savePlayMode();
		}

		public int getPlayMode() {
			return playMode;
		}

		/**
		 * 随机播放
		 */
		public void playRandom() {
			random = new Random();
			randomnumber = random.nextInt(musicUrlList.size());
			compareRandomNumber();

		}

		private void compareRandomNumber() {
			if (currentPosition == randomnumber) {

				randomnumber = random.nextInt(musicUrlList.size());
				compareRandomNumber();
			}
			currentPosition = randomnumber;
			playAudio();
		}

	}

	/**
	 * 保存当前的播放模式
	 */
	private void savePlayMode() {
		SharePreferencesUtil.saveIntData(SharePreferenceKeyUtil.playMode, playMode);
	}

	/**
	 * 从SharedPreferences中获取保存的播放模式
	 * 
	 * @return
	 */
	private int getPlayModeFromSp() {
		return SharePreferencesUtil.getIntData(SharePreferenceKeyUtil.playMode);
	}

	/**
	 * 准备完成监听
	 * 
	 * @author ping
	 * 
	 */
	class MyOnPreListener implements OnPreparedListener {

		@Override
		public void onPrepared(MediaPlayer mp) {
			mediaPlayer.start();
			notifyPre();
		}
	}

	/**
	 * 结束监听
	 * 
	 * @author ping
	 * 
	 */
	class MyOnCompletionListener implements OnCompletionListener {

		@Override
		public void onCompletion(MediaPlayer mp) {
			notifyCompletion();
			autoPlayByPlayMode();
		}
	}

	/**
	 * 通知准备就绪
	 */
	private void notifyPre() {
		Intent intent = new Intent(ACTION_PREPARED);
		sendBroadcast(intent);

	}

	/**
	 * 结束通知
	 */
	public void notifyCompletion() {
		// audioBindService.playAudio();
		Intent intent = new Intent(ACTION_COMPLETION);
		intent.putExtra("currentPosition", musicUrlList.get(currentPosition));
		sendBroadcast(intent);
	}

	private void autoPlayByPlayMode() {
		switch (playMode) {
		case MODE_RANDOM:
			// 随机播放？？？？
			audioBindService.playRandom();
			break;
		case MODE_SINGLE_REPEAT:
			audioBindService.playAudio();
			break;
		case MODE_ALL_REPEAT:
			// 如果是最后一首，播完则从第一首重新开始播放
			if (currentPosition == (musicUrlList.size() - 1)) {
				currentPosition = 0;
				audioBindService.playAudio();
			} else {
				audioBindService.playNext();
			}
			break;
		}
	}
}
