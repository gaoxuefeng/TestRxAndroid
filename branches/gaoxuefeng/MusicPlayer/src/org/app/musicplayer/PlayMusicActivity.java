package org.app.musicplayer;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.Iterator;
import java.util.TreeMap;

import org.app.music.tool.Contsant;
import org.app.music.tool.ImageUtil;
import org.app.music.tool.LRCbean;
import org.app.music.tool.Setting;
import org.app.music.tool.XfDialog;

import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.provider.MediaStore;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;
import android.widget.Toast;
/**
 * 播放音乐界面。
 *主要思路是:
 * 点击列表任意音乐后跳转到这里。我也以前说过接收音乐名，歌手应该是定义三个变量(id,title,artits)分别代表歌的id，歌的标题，艺术家。
 * 定义完然后接收它们。进度条以及下面时间是用Handler将时间发送给服务。
 * 在后台MusicService里使用handler消息机制，不停的向前台发送广播，广播里面的数据是当前mp播放的时间点，前台接收到广播后获得播放时间点来更新进度条。
 * 两边时间的中间是歌词。歌词编码格式是UTF-8。读歌词用IO流形式。但也要注意一点。歌名和歌词必须在同一目录下方能执行，歌词务必改UTF-8否则就是乱码。
 * 另外增加了专辑图片倒影，滑动下可以显示歌词。歌词路径根据实际情况需要修改
 * @author 涙星
 */
public class PlayMusicActivity extends BaseActivity  {
	private RelativeLayout ll_player_voice;
	private RelativeLayout music_all;
	private int[] _ids;// 临时音乐id
	private String[] _artists;// 艺术家
	private String[] _titles;// 标题
	private TextView musicnames;// 音乐名
	private TextView artisting;// 艺术家
	private ImageButton play_btn;// 播放按钮
	private ImageButton last_btn;// 上一首
	private ImageButton next_btn;// 下一首
	private TextView playtimes = null;// 已播放时间
	private TextView durationTime = null;// 歌曲时间
	private SeekBar seekbar;// 进度条
	private SeekBar sp_player_voice;//调节音量
	private int position;// 定义一个位置，用于定位用户点击列表曲首
	private int currentPosition;// 当前播放位置
	private int duration;// 总时间
	private TextView lrcTextview;// 歌词
    private ImageView album;// 专辑
	private ImageView iv_player_ablum_reflection;//专辑倒影
	private ImageButton LoopBtn = null;// 循环
	private ImageButton RandomBtm = null;// 随机
	private ImageButton ibtn_player_list;
	private ImageButton ibtn_player_control_menu;
	private static final String MUSIC_CURRENT = "com.app.currentTime";// Action的状态
	private static final String MUSIC_DURATION = "com.app.duration";
	private static final String MUSIC_NEXT = "com.app.next";
	private static final String MUSIC_UPDATE = "com.app.update";
	private static final int PLAY = 1;// 定义播放状态
	private static final int PAUSE = 2;// 暂停状态
	private static final int STOP = 3;// 停止
	private static final int PROGRESS_CHANGE = 4;// 进度条改变
	private static final int STATE_PLAY = 1;// 播放状态设为1
	private static final int STATE_PAUSE = 2;// 播放状态设为2
	public static final int LOOP_NONE = 0;//不循环
	public static final int LOOP_ONE = 1;//单体循环
	public static final int LOOP_ALL = 2;//全部循环
	public static int loop_flag = LOOP_NONE;
	public static boolean random_flag = false;
	public static int[] randomIDs = null;
	public static int randomNum = 0;
	private int flag;// 标记
	private Cursor cursor;// 游标
	private TreeMap<Integer, LRCbean> lrc_map = new TreeMap<Integer, LRCbean>();// Treemap对象
	private AudioManager am;
	private int maxVolume;// 最大音量
	private int currentVolume;// 当前音量
	private ImageButton ibtn_player_voice;//右上角的音量图标
	private Toast toast;//提示消息
	private Context context;//上下文。这个重要！
    // 音量面板显示和隐藏动画
	private Animation showVoicePanelAnimation;
	private Animation hiddenVoicePanelAnimation;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.player_music);
		// 以下是找各个控件ID。大家熟悉的，故不解释
		ll_player_voice = (RelativeLayout) this.findViewById(R.id.ll_player_voice);
		music_all=(RelativeLayout) findViewById(R.id.playmusic_all);
		musicnames = (TextView) findViewById(R.id.tv_player_song_info);
		artisting = (TextView) findViewById(R.id.tv_player_singer_info);
		play_btn = (ImageButton) findViewById(R.id.ibtn_player_control_play);
		last_btn = (ImageButton) findViewById(R.id.ibtn_player_control_pre);
		next_btn = (ImageButton) findViewById(R.id.ibtn_player_control_next);
		ibtn_player_voice = (ImageButton)findViewById(R.id.ibtn_player_voice);
		iv_player_ablum_reflection = (ImageView)findViewById(R.id.iv_player_ablum_reflection);
		ibtn_player_voice.setOnClickListener(listener);
		playtimes = (TextView) findViewById(R.id.tv_player_playing_time);
		durationTime = (TextView) findViewById(R.id.tv_player_playering_duration);
		seekbar = (SeekBar) findViewById(R.id.sp_player_playprogress);
		lrcTextview = (TextView) findViewById(R.id.tv_player_lyric_info);
		album = (ImageView) findViewById(R.id.iv_player_ablum);
	    sp_player_voice=(SeekBar) findViewById(R.id.sb_player_voice);
	    sp_player_voice.setOnSeekBarChangeListener(seekBarChangeListener);
		am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
		maxVolume = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		currentVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC);
		context=this;
		showVoicePanelAnimation = AnimationUtils.loadAnimation(PlayMusicActivity.this, R.anim.push_up_in);
		hiddenVoicePanelAnimation = AnimationUtils.loadAnimation(PlayMusicActivity.this, R.anim.push_up_out);

		// 获取系统音乐音量
		am = (AudioManager)getSystemService(Context.AUDIO_SERVICE);
		// 获取系统音乐当前音量
		int currentVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC);
		ibtn_player_list = (ImageButton)findViewById(R.id.ibtn_player_list);
		ibtn_player_control_menu = (ImageButton) this.findViewById(R.id.ibtn_player_control_menu);
		ibtn_player_list.setOnClickListener(listeners);
		ibtn_player_control_menu.setOnClickListener(listeners);
		ShowPlayBtn();
		ShowLastBtn();
		ShowNextBtn();
		ShowSeekBar();
		//ShowLoop();
		//ShowRandom();
	}
     /**
      * 显示播放按钮并做监听
      */
	private void ShowPlayBtn() {
		play_btn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				switch (flag) {
				case STATE_PLAY:
					pause();
					break;

				case STATE_PAUSE:
					play();
					break;
				}

			}
		});
		
	}
	private void ShowLastBtn() {
		last_btn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				lastOne();
			}
		});
		
	}
	
	private void ShowNextBtn() {
		next_btn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				nextOne();

			}
		});
		
	}
	
	private void ShowSeekBar() {
		seekbar.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {

			@Override
			public void onStopTrackingTouch(SeekBar seekBar) {

			}

			@Override
			public void onStartTrackingTouch(SeekBar seekBar) {

			}

			@Override
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				if (fromUser) {
					seekbar_change(progress);
				}else if (seekBar.getId() == R.id.sb_player_voice) {
					// 设置音量
					am.setStreamVolume(AudioManager.STREAM_MUSIC,
							progress, 0);
				}

			}
		});
		
	}
	/**
	 * 顺序播放
	 */
	private void ShowLoop() {
		LoopBtn=(ImageButton)findViewById(R.id.ibtn_player_control_mode);
		LoopBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				switch (loop_flag) {
				case LOOP_NONE:
					loop_flag = LOOP_ONE;
					LoopBtn.setBackgroundResource(R.drawable.player_btn_player_mode_circleone);
					toast=Contsant.showMessage(toast, PlayMusicActivity.this,"你选择按顺序来播放");
					break;
				case LOOP_ALL:
					loop_flag = LOOP_NONE;
					LoopBtn.setBackgroundResource(R.drawable.player_btn_player_mode_circlelist);
					toast=Contsant.showMessage(toast, PlayMusicActivity.this, "你选择全部循环播放");
					break;
				case LOOP_ONE:
					loop_flag = LOOP_ALL;
					LoopBtn.setBackgroundResource(R.drawable.player_btn_player_mode_sequence);
					break;
				
				}
				
			}
		});
	}
	/**
	 * 按随机播放
	 */
	private void ShowRandom() {
		RandomBtm=(ImageButton)findViewById(R.id.ibtn_player_control_mode);
		RandomBtm.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
			   if (random_flag==false) {
				   for (int i = 0; i < _ids.length; i++) {
						randomIDs[i] = -1;
					}
				   random_flag=true;
				   RandomBtm.setBackgroundResource(R.drawable.player_btn_player_mode_random);
				   toast=Contsant.showMessage(toast, PlayMusicActivity.this, "你选择的是随机播放");
			}else {
				random_flag=false;
				RandomBtm.setBackgroundResource(R.drawable.player_btn_player_mode_circleone);
				toast=Contsant.showMessage(toast, PlayMusicActivity.this, "你选择的是按顺序播放");
			}
				
			}
		});
		
	}
	/**
	 * 在播放布局里先把播放按钮先删除并用background设置为透明。然后在代码添加按钮
	 */
	public void play() {
		flag = PLAY;
		play_btn.setImageResource(R.drawable.player_btn_player_pause);
		Intent intent = new Intent();
		intent.setAction("com.app.media.MUSIC_SERVICE");
		intent.putExtra("op", PLAY);// 向服务传递数据
		startService(intent);
		
	}
	/**
	 * 暂停
	 */
	public void pause() {
		flag = PAUSE;
		play_btn.setImageResource(R.drawable.player_btn_player_play);
		Intent intent = new Intent();
		intent.setAction("com.app.media.MUSIC_SERVICE");
		intent.putExtra("op", PAUSE);
		startService(intent);
		
	}
	/**
	 * 上一首
	 */
	private void lastOne() {
		if (_ids.length == 1 || loop_flag == LOOP_ONE) {
			position = position;
			Intent intent = new Intent();
			intent.setAction("com.app.media.MUSIC_SERVICE");
			intent.putExtra("length", 1);
			startService(intent);
			play();
			return;
		}
		if (random_flag == true) {
			if (randomNum < _ids.length - 1) {
				randomIDs[randomNum] = position;
				position = findRandomSound(_ids.length);
				randomNum++;

			} else {
				randomNum = 0;
				for (int i = 0; i < _ids.length; i++) {
					randomIDs[i] = -1;
				}
				randomIDs[randomNum] = position;
				position = findRandomSound(_ids.length);
				randomNum++;
			}
		} else {
			if (position == 0) {
				position = _ids.length - 1;
			} else if (position > 0) {
				position--;
			}
		}
		stop();
		setup();
		play();
		
	}
	/**
	 * 进度条改变事件
	 */
	private void seekbar_change(int progress) {
		Intent intent = new Intent();
		intent.setAction("com.app.media.MUSIC_SERVICE");
		intent.putExtra("op", PROGRESS_CHANGE);
		intent.putExtra("progress", progress);
		startService(intent);
		
	}
	/**
	 * 下一首
	 */
	public  void nextOne() {
		if (_ids.length == 1 || loop_flag == LOOP_ONE) {
			position = position;
			Intent intent = new Intent();
			intent.setAction("com.app.media.MUSIC_SERVICE");
			intent.putExtra("length", 1);
			startService(intent);
			play();
			return;

		}
		if (random_flag == true) {
			if (randomNum < _ids.length - 1) {
				randomIDs[randomNum] = position;
				position = findRandomSound(_ids.length);
				randomNum++;

			} else {
				randomNum = 0;
				for (int i = 0; i < _ids.length; i++) {
					randomIDs[i] = -1;
				}
				randomIDs[randomNum] = position;
				position = findRandomSound(_ids.length);
				randomNum++;
			}
		} else {
			if (position == _ids.length - 1) {
				position = 0;
			} else if (position < _ids.length - 1) {
				position++;
			}
		}
		stop();
		setup();
		play();
		
	}
	  /**找到随机位置**/
		public static int findRandomSound(int end) {
			int ret = -1;
			ret = (int) (Math.random() * end);
			while (havePlayed(ret, end)) {
				ret = (int) (Math.random() * end);
			}
			return ret;
		}
	  /**是否在播放**/
		public static boolean havePlayed(int position, int num) {
			boolean ret = false;

			for (int i = 0; i < num; i++) {
				if (position == randomIDs[i]) {
					ret = true;
					break;
				}
			}

			return ret;
		}

		/**
		 * 停止播放音乐
		 */
		private void stop() {
			Intent isplay = new Intent("notifi.update");
			sendBroadcast(isplay);// 发起后台支持
			unregisterReceiver(musicReceiver);
			Intent intent = new Intent();
			intent.setAction("com.app.media.MUSIC_SERVICE");
			intent.putExtra("op", STOP);
			startService(intent);

		}
		

		@Override
		protected void onResume() {
			super.onResume();
			// 设置皮肤背景
			Setting setting = new Setting(this, false);
			music_all.setBackgroundResource(setting.getCurrentSkinResId());
			Intent intent = this.getIntent();//接收来自列表的数据
			Bundle bundle = intent.getExtras();
			_ids = bundle.getIntArray("_ids");
			randomIDs = new int[_ids.length];
			position = bundle.getInt("position");
			_titles = bundle.getStringArray("_titles");
			_artists = bundle.getStringArray("_artists");
			setup();
			play();
			ShowLoop();
			ShowRandom();
		}
		/**
		 * 当界面不可见时候，反注册的广播
		 */
		@Override
		protected void onStop() {
			super.onStop();
			unregisterReceiver(musicReceiver);
		}
		/**
		 * 初始化
		 */
		private void setup() {
			loadclip();
			init();
			ReadSDLrc();

		}
		/**
		 * 在顶部显示歌手，歌名。这两个是通过服务那边接收过来的
		 */
		private void loadclip() {
			seekbar.setProgress(0);
			/**设置歌曲名**/
			if (_titles[position].length() > 15)
				musicnames.setText(_titles[position].substring(0, 12) + "...");// 设置歌曲名
			else
				musicnames.setText(_titles[position]);

			/**设置艺术家名**/ 
			if (_artists[position].equals("<unknown>"))
				artisting.setText("未知艺术家");
			else
				artisting.setText(_artists[position]);
			Intent intent = new Intent();
			intent.putExtra("_ids", _ids);
			intent.putExtra("_titles", _titles);
			intent.putExtra("_artists", _artists);
			intent.putExtra("position", position);
		    intent.setAction("com.app.media.MUSIC_SERVICE");// 给将这个action发送服务
			startService(intent);
			
		}
		/**
		 * 初始化
		 */
		private void init() {
			IntentFilter filter = new IntentFilter();
			filter.addAction(MUSIC_CURRENT);
			filter.addAction(MUSIC_DURATION);
			filter.addAction(MUSIC_NEXT);
			filter.addAction(MUSIC_UPDATE);
			filter.addAction("notifi.update");
			registerReceiver(musicReceiver, filter);
			
		}
		/**
		 * 为音乐读取歌词，歌词一行一行方式输出，但是卡拉OK完全做不出来着。
		 */
		private void ReadSDLrc() {
			/**我们现在的歌词就是要String数组的第4个参数-显示文件名字**/
			cursor = getContentResolver().query(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,           
					        new String[] { MediaStore.Audio.Media.TITLE,
							MediaStore.Audio.Media.DURATION,
							MediaStore.Audio.Media.ARTIST,
							MediaStore.Audio.Media.ALBUM,
							MediaStore.Audio.Media.DISPLAY_NAME,
							MediaStore.Audio.Media.ALBUM_ID }, "_id=?",new String[] { _ids[position] + "" }, null);
			cursor.moveToFirst();// 将游标移至第一位
			Bitmap bm = getArtwork(this, _ids[position], cursor.getInt(5), true);
			/**切换播放时候专辑图片出现透明效果**/
			Animation albumanim=AnimationUtils.loadAnimation(context, R.anim.album_replace);
			/**开始播放动画效果**/
			album.startAnimation(albumanim);
			album.setImageBitmap(bm);
			/**为专辑图片添加倒影,这样有种立体感的效果**/
			iv_player_ablum_reflection.setImageBitmap(ImageUtil.createReflectionBitmapForSingle(bm));
			/**游标定位到DISPLAY_NAME**/
			String name = cursor.getString(4);
			/**sd卡的音乐名字截取字符窜并找到它的位置,这步重要，没有写一直表示歌词文件无法显示,顺便说声不同手机型号SD卡有不同的路径。**/
			read("/sdcard/music/" + name.substring(0, name.indexOf(".")) + ".lrc");
			/** 在调试时我先把音乐名字写死，运行时候在控制台打印出音乐名字，那么由此判断歌名没问题.只是没有获取位置**/
			System.out.println(cursor.getString(4));
			
		}
		/**在后台MusicService里使用handler消息机制，不停的向前台发送广播，广播里面的数据是当前mp播放的时间点，
		 * 前台接收到广播后获得播放时间点来更新进度条,暂且先这样。但是一些人说虽然这样能实现。但是还是觉得开个子线程不错**/
		protected BroadcastReceiver musicReceiver = new BroadcastReceiver() {

			public void onReceive(Context context, Intent intent) {
				String action = intent.getAction();
				if (action.equals(MUSIC_CURRENT)) {
					currentPosition = intent.getExtras().getInt("currentTime");// 获得当前播放位置
					playtimes.setText(toTime(currentPosition));
					seekbar.setProgress(currentPosition);// 设置进度条
					Iterator<Integer> iterator = lrc_map.keySet().iterator();
					while (iterator.hasNext()) {
						Object o = iterator.next();
						LRCbean val = lrc_map.get(o);
						if (val != null) {

							if (currentPosition > val.getBeginTime()&& currentPosition < val.getBeginTime()+ val.getLineTime()) {
								lrcTextview.setText(val.getLrcBody());
								break;
							}
						}
					}
				} else if (action.equals(MUSIC_DURATION)) {
					duration = intent.getExtras().getInt("duration");
					seekbar.setMax(duration);
					durationTime.setText(toTime(duration));

				} else if (action.equals(MUSIC_NEXT)) {
					nextOne();
				} else if (action.equals(MUSIC_UPDATE)) {
					position = intent.getExtras().getInt("position");

					setup();
				}
			}
		};

		/**
		 * 播放时间转换
		 */
		public String toTime(int time) {

			time /= 1000;
			int minute = time / 60;
			int second = time % 60;
			minute %= 60;
			return String.format("%02d:%02d", minute, second);
		}
		/**
		 * 读取歌词的方法，采用IO方法一行一行的显示
		 */
		private void read(String path) {
			lrc_map.clear();
			TreeMap<Integer, LRCbean> lrc_read = new TreeMap<Integer, LRCbean>();
			String data = "";
			BufferedReader br = null;
			File file = new File(path);
			System.out.println(path);
			/**如果没有歌词，则用没有歌词显示**/
			if (!file.exists()) {
				Animation lrcanim=AnimationUtils.loadAnimation(context, R.anim.album_replace);
				lrcTextview.setText(R.string.no_lrc_messenge);
				lrcTextview.startAnimation(lrcanim);
				return;
			}
			FileInputStream stream = null;
			try {
				stream = new FileInputStream(file);
				br = new BufferedReader(new InputStreamReader(stream, "UTF-8"));//记得歌词一定要设置UTF-8，否则歌词编码直接乱码喔。
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			try {
				while ((data = br.readLine()) != null) {
					if (data.length() > 6) {
						if (data.charAt(3) == ':' && data.charAt(6) == '.') {// 从歌词正文开始
							data = data.replace("[", "");
							data = data.replace("]", "@");
							data = data.replace(".", ":");
							String lrc[] = data.split("@");
							String lrcContent = null;
							if (lrc.length == 2) {
								lrcContent = lrc[lrc.length - 1];// 歌词
							} else {
								lrcContent = "";
							}

							for (int i = 0; i < lrc.length - 1; i++) {
								String lrcTime[] = lrc[0].split(":");

								int m = Integer.parseInt(lrcTime[0]);// 分
								int s = Integer.parseInt(lrcTime[1]);// 秒
								int ms = Integer.parseInt(lrcTime[2]);// 毫秒

								int begintime = (m * 60 + s) * 1000 + ms;// 转换成毫秒
								LRCbean lrcbean = new LRCbean();
								lrcbean.setBeginTime(begintime);// 设置歌词开始时间
								lrcbean.setLrcBody(lrcContent);// 设置歌词的主体
								lrc_read.put(begintime, lrcbean);

							}

						}
					}
				}
				stream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			// 计算每句歌词需要的时间
			lrc_map.clear();
			data = "";
			Iterator<Integer> iterator = lrc_read.keySet().iterator();
			LRCbean oldval = null;
			int i = 0;

			while (iterator.hasNext()) {
				Object ob = iterator.next();
				LRCbean val = lrc_read.get(ob);
				if (oldval == null) {
					oldval = val;
				} else {
					LRCbean item1 = new LRCbean();
					item1 = oldval;
					item1.setLineTime(val.getBeginTime() - oldval.getBeginTime());
					lrc_map.put(new Integer(i), item1);
					i++;
					oldval = val;
				}
			}
		}
		/**
		 * 以下是歌曲放的时候显示专辑图片。和列表不同,播放时图片要大。所以cam那个方法写合适的图片吧
		 */
		public static Bitmap getArtwork(Context context, long song_id,
				long album_id, boolean allowdefault) {
			if (album_id < 0) {

				if (song_id >= 0) {
					Bitmap bm = getArtworkFromFile(context, song_id, -1);
					if (bm != null) {
						return bm;
					}
				}
				if (allowdefault) {
					return getDefaultArtwork(context);
				}
				return null;
			}
			ContentResolver res = context.getContentResolver();
			Uri uri = ContentUris.withAppendedId(sArtworkUri, album_id);
			if (uri != null) {
				InputStream in = null;
				try {
					in = res.openInputStream(uri);
					BitmapFactory.Options options = new BitmapFactory.Options();
					/**先指定原始大小**/
					options.inSampleSize = 1;
					/** 只进行大小判断**/
					options.inJustDecodeBounds = true;
					/**调用此方法得到options得到图片的大小**/
					BitmapFactory.decodeStream(in, null, options);
					/**我们的目标是在你N pixel的画面上显示。 所以需要调用computeSampleSize得到图片缩放的比例**/
					/**这里的target为800是根据默认专辑图片大小决定的，800只是测试数字但是试验后发现完美的结合**/
					options.inSampleSize = computeSampleSize(options, 600);
					/**我们得到了缩放的比例，现在开始正式读入BitMap数据**/
					options.inJustDecodeBounds = false;
					options.inDither = false;
					options.inPreferredConfig = Bitmap.Config.ARGB_8888;
					in = res.openInputStream(uri);
					return BitmapFactory.decodeStream(in, null, options);
				} catch (FileNotFoundException ex) {

					Bitmap bm = getArtworkFromFile(context, song_id, album_id);
					if (bm != null) {
						if (bm.getConfig() == null) {
							bm = bm.copy(Bitmap.Config.RGB_565, false);
							if (bm == null && allowdefault) {
								return getDefaultArtwork(context);
							}
						}
					} else if (allowdefault) {
						bm = getDefaultArtwork(context);
					}
					return bm;
				} finally {
					try {
						if (in != null) {
							in.close();
						}
					} catch (IOException ex) {
					}
				}
			}

			return null;
		}

		private static Bitmap getArtworkFromFile(Context context, long songid,
				long albumid) {
			Bitmap bm = null;
			if (albumid < 0 && songid < 0) {
				throw new IllegalArgumentException(
						"Must specify an album or a song id");
			}
			try {

				BitmapFactory.Options options = new BitmapFactory.Options();

				FileDescriptor fd = null;
				if (albumid < 0) {
					Uri uri = Uri.parse("content://media/external/audio/media/"
							+ songid + "/albumart");
					ParcelFileDescriptor pfd = context.getContentResolver()
							.openFileDescriptor(uri, "r");
					if (pfd != null) {
						fd = pfd.getFileDescriptor();
					}
				} else {
					Uri uri = ContentUris.withAppendedId(sArtworkUri, albumid);
					ParcelFileDescriptor pfd = context.getContentResolver()
							.openFileDescriptor(uri, "r");
					if (pfd != null) {
						fd = pfd.getFileDescriptor();
					}
				}
				options.inSampleSize = 1;
				// 只进行大小判断
				options.inJustDecodeBounds = true;
				// 调用此方法得到options得到图片的大小
				BitmapFactory.decodeFileDescriptor(fd, null, options);
				// 我们的目标是在800pixel的画面上显示。
				// 所以需要调用computeSampleSize得到图片缩放的比例
				options.inSampleSize = 100;
				// OK,我们得到了缩放的比例，现在开始正式读入BitMap数据
				options.inJustDecodeBounds = false;
				options.inDither = false;
				options.inPreferredConfig = Bitmap.Config.ARGB_8888;

				// 根据options参数，减少所需要的内存
				bm = BitmapFactory.decodeFileDescriptor(fd, null, options);
			} catch (FileNotFoundException ex) {

			}

			return bm;
		}

		/**这个函数会对图片的大小进行判断，并得到合适的缩放比例，比如2即1/2,3即1/3**/
		static int computeSampleSize(BitmapFactory.Options options, int target) {
			int w = options.outWidth;
			int h = options.outHeight;
			int candidateW = w / target;
			int candidateH = h / target;
			int candidate = Math.max(candidateW, candidateH);
			if (candidate == 0)
				return 1;
			if (candidate > 1) {
				if ((w > target) && (w / candidate) < target)
					candidate -= 1;
			}
			if (candidate > 1) {
				if ((h > target) && (h / candidate) < target)
					candidate -= 1;
			}
			return candidate;
		}

		private static Bitmap getDefaultArtwork(Context context) {
			BitmapFactory.Options opts = new BitmapFactory.Options();
			opts.inPreferredConfig = Bitmap.Config.RGB_565;
			return BitmapFactory.decodeStream(context.getResources()
					.openRawResource(R.drawable.default_album), null, opts);
		}

		private static final Uri sArtworkUri = Uri
				.parse("content://media/external/audio/albumart");
		/**
		 * 暂时为音量调整大小
		 */
		private OnSeekBarChangeListener seekBarChangeListener = new OnSeekBarChangeListener() {

			@Override
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				if (seekBar.getId() == R.id.sb_player_voice) {
					// 设置音量
					am.setStreamVolume(AudioManager.STREAM_MUSIC,
							progress, 0);
				}
				
			}

			@Override
			public void onStartTrackingTouch(SeekBar arg0) {
				
			}

			@Override
			public void onStopTrackingTouch(SeekBar arg0) {
				
			}
			
		};
		/**
		 * 小图标的监听事件
		 */
		private OnClickListener listener = new OnClickListener() {

			@Override
			public void onClick(View v) {
				switch (v.getId()) {
				case R.id.ibtn_player_voice:
					voicePanelAnimation();
					break;
				case R.id.ibtn_player_list:
					finish();
					break; 
				}
				
			}
			
		};
		// 音量面板显示和隐藏
		private void voicePanelAnimation() {
			if (ll_player_voice.getVisibility() == View.GONE) {
				ll_player_voice.startAnimation(showVoicePanelAnimation);
				ll_player_voice.setVisibility(View.VISIBLE);
			} else {
				ll_player_voice.startAnimation(hiddenVoicePanelAnimation);
				ll_player_voice.setVisibility(View.GONE);
			}
		}
		/**
		 * 回调音量大小函数
		 */
		@Override
		public boolean dispatchKeyEvent(KeyEvent event) {
			int action = event.getAction();
			int keyCode = event.getKeyCode();
			switch (keyCode) {
			case KeyEvent.KEYCODE_VOLUME_UP:
				if (action == KeyEvent.ACTION_UP) {
					if (currentVolume < maxVolume) {
						currentVolume = currentVolume + 1;
						am.setStreamVolume(AudioManager.STREAM_MUSIC,
								currentVolume, 0);
					} else {
						am.setStreamVolume(AudioManager.STREAM_MUSIC,
								currentVolume, 0);
					}
				}
				return false;
			case KeyEvent.KEYCODE_VOLUME_DOWN:
				if (action == KeyEvent.ACTION_UP) {
					if (currentVolume > 0) {
						currentVolume = currentVolume - 1;
						am.setStreamVolume(AudioManager.STREAM_MUSIC,
								currentVolume, 0);
					} else {
						am.setStreamVolume(AudioManager.STREAM_MUSIC,
								currentVolume, 0);
					}
				}
				return false;
			default:
				return super.dispatchKeyEvent(event);
			}
		}
		/**
		 * 按下返回键事件
		 */
		@Override
		public boolean onKeyDown(int keyCode, KeyEvent event) {
			if (keyCode == KeyEvent.KEYCODE_BACK) {
				Intent intent = new Intent(PlayMusicActivity.this,MainActivity.class);
				startActivity(intent);
				finish();
				finish();
			}
			return true;
		}
		private OnClickListener listeners = new OnClickListener(){

			@Override
			public void onClick(View view) {
				switch (view.getId()) {
				case R.id.ibtn_player_list:
					Intent intent=new Intent(PlayMusicActivity.this,MainActivity.class);
					startActivity(intent);
					finish();
					break;

				case R.id.ibtn_player_control_menu:
					String[] menustring = new String[] { "搜索歌词", "关注我们电台" };
					ListView menulist = new ListView(PlayMusicActivity.this);
					menulist.setCacheColorHint(Color.TRANSPARENT);
					menulist.setDividerHeight(1);
					menulist.setAdapter(new ArrayAdapter<String>(PlayMusicActivity.this,R.layout.dialog_menu_item, R.id.text1, menustring));
					menulist.setLayoutParams(new LayoutParams(Contsant.getScreen(PlayMusicActivity.this)[0] / 2,LayoutParams.WRAP_CONTENT));

					final XfDialog xfdialog = new XfDialog.Builder(PlayMusicActivity.this).setTitle("系统操作:").setView(menulist).create();
					xfdialog.show();
					break;
				}
				
			}
			
		};	

}
