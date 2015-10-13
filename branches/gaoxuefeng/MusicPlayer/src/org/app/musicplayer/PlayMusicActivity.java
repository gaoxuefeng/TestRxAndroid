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
 * �������ֽ��档
 *��Ҫ˼·��:
 * ����б��������ֺ���ת�������Ҳ��ǰ˵������������������Ӧ���Ƕ�����������(id,title,artits)�ֱ������id����ı��⣬�����ҡ�
 * ������Ȼ��������ǡ��������Լ�����ʱ������Handler��ʱ�䷢�͸�����
 * �ں�̨MusicService��ʹ��handler��Ϣ���ƣ���ͣ����ǰ̨���͹㲥���㲥����������ǵ�ǰmp���ŵ�ʱ��㣬ǰ̨���յ��㲥���ò���ʱ��������½�������
 * ����ʱ����м��Ǹ�ʡ���ʱ����ʽ��UTF-8���������IO����ʽ����ҲҪע��һ�㡣�����͸�ʱ�����ͬһĿ¼�·���ִ�У������ظ�UTF-8����������롣
 * ����������ר��ͼƬ��Ӱ�������¿�����ʾ��ʡ����·������ʵ�������Ҫ�޸�
 * @author ����
 */
public class PlayMusicActivity extends BaseActivity  {
	private RelativeLayout ll_player_voice;
	private RelativeLayout music_all;
	private int[] _ids;// ��ʱ����id
	private String[] _artists;// ������
	private String[] _titles;// ����
	private TextView musicnames;// ������
	private TextView artisting;// ������
	private ImageButton play_btn;// ���Ű�ť
	private ImageButton last_btn;// ��һ��
	private ImageButton next_btn;// ��һ��
	private TextView playtimes = null;// �Ѳ���ʱ��
	private TextView durationTime = null;// ����ʱ��
	private SeekBar seekbar;// ������
	private SeekBar sp_player_voice;//��������
	private int position;// ����һ��λ�ã����ڶ�λ�û�����б�����
	private int currentPosition;// ��ǰ����λ��
	private int duration;// ��ʱ��
	private TextView lrcTextview;// ���
    private ImageView album;// ר��
	private ImageView iv_player_ablum_reflection;//ר����Ӱ
	private ImageButton LoopBtn = null;// ѭ��
	private ImageButton RandomBtm = null;// ���
	private ImageButton ibtn_player_list;
	private ImageButton ibtn_player_control_menu;
	private static final String MUSIC_CURRENT = "com.app.currentTime";// Action��״̬
	private static final String MUSIC_DURATION = "com.app.duration";
	private static final String MUSIC_NEXT = "com.app.next";
	private static final String MUSIC_UPDATE = "com.app.update";
	private static final int PLAY = 1;// ���岥��״̬
	private static final int PAUSE = 2;// ��ͣ״̬
	private static final int STOP = 3;// ֹͣ
	private static final int PROGRESS_CHANGE = 4;// �������ı�
	private static final int STATE_PLAY = 1;// ����״̬��Ϊ1
	private static final int STATE_PAUSE = 2;// ����״̬��Ϊ2
	public static final int LOOP_NONE = 0;//��ѭ��
	public static final int LOOP_ONE = 1;//����ѭ��
	public static final int LOOP_ALL = 2;//ȫ��ѭ��
	public static int loop_flag = LOOP_NONE;
	public static boolean random_flag = false;
	public static int[] randomIDs = null;
	public static int randomNum = 0;
	private int flag;// ���
	private Cursor cursor;// �α�
	private TreeMap<Integer, LRCbean> lrc_map = new TreeMap<Integer, LRCbean>();// Treemap����
	private AudioManager am;
	private int maxVolume;// �������
	private int currentVolume;// ��ǰ����
	private ImageButton ibtn_player_voice;//���Ͻǵ�����ͼ��
	private Toast toast;//��ʾ��Ϣ
	private Context context;//�����ġ������Ҫ��
    // ���������ʾ�����ض���
	private Animation showVoicePanelAnimation;
	private Animation hiddenVoicePanelAnimation;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.player_music);
		// �������Ҹ����ؼ�ID�������Ϥ�ģ��ʲ�����
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

		// ��ȡϵͳ��������
		am = (AudioManager)getSystemService(Context.AUDIO_SERVICE);
		// ��ȡϵͳ���ֵ�ǰ����
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
      * ��ʾ���Ű�ť��������
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
					// ��������
					am.setStreamVolume(AudioManager.STREAM_MUSIC,
							progress, 0);
				}

			}
		});
		
	}
	/**
	 * ˳�򲥷�
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
					toast=Contsant.showMessage(toast, PlayMusicActivity.this,"��ѡ��˳��������");
					break;
				case LOOP_ALL:
					loop_flag = LOOP_NONE;
					LoopBtn.setBackgroundResource(R.drawable.player_btn_player_mode_circlelist);
					toast=Contsant.showMessage(toast, PlayMusicActivity.this, "��ѡ��ȫ��ѭ������");
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
	 * ���������
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
				   toast=Contsant.showMessage(toast, PlayMusicActivity.this, "��ѡ������������");
			}else {
				random_flag=false;
				RandomBtm.setBackgroundResource(R.drawable.player_btn_player_mode_circleone);
				toast=Contsant.showMessage(toast, PlayMusicActivity.this, "��ѡ����ǰ�˳�򲥷�");
			}
				
			}
		});
		
	}
	/**
	 * �ڲ��Ų������ȰѲ��Ű�ť��ɾ������background����Ϊ͸����Ȼ���ڴ�����Ӱ�ť
	 */
	public void play() {
		flag = PLAY;
		play_btn.setImageResource(R.drawable.player_btn_player_pause);
		Intent intent = new Intent();
		intent.setAction("com.app.media.MUSIC_SERVICE");
		intent.putExtra("op", PLAY);// ����񴫵�����
		startService(intent);
		
	}
	/**
	 * ��ͣ
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
	 * ��һ��
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
	 * �������ı��¼�
	 */
	private void seekbar_change(int progress) {
		Intent intent = new Intent();
		intent.setAction("com.app.media.MUSIC_SERVICE");
		intent.putExtra("op", PROGRESS_CHANGE);
		intent.putExtra("progress", progress);
		startService(intent);
		
	}
	/**
	 * ��һ��
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
	  /**�ҵ����λ��**/
		public static int findRandomSound(int end) {
			int ret = -1;
			ret = (int) (Math.random() * end);
			while (havePlayed(ret, end)) {
				ret = (int) (Math.random() * end);
			}
			return ret;
		}
	  /**�Ƿ��ڲ���**/
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
		 * ֹͣ��������
		 */
		private void stop() {
			Intent isplay = new Intent("notifi.update");
			sendBroadcast(isplay);// �����̨֧��
			unregisterReceiver(musicReceiver);
			Intent intent = new Intent();
			intent.setAction("com.app.media.MUSIC_SERVICE");
			intent.putExtra("op", STOP);
			startService(intent);

		}
		

		@Override
		protected void onResume() {
			super.onResume();
			// ����Ƥ������
			Setting setting = new Setting(this, false);
			music_all.setBackgroundResource(setting.getCurrentSkinResId());
			Intent intent = this.getIntent();//���������б������
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
		 * �����治�ɼ�ʱ�򣬷�ע��Ĺ㲥
		 */
		@Override
		protected void onStop() {
			super.onStop();
			unregisterReceiver(musicReceiver);
		}
		/**
		 * ��ʼ��
		 */
		private void setup() {
			loadclip();
			init();
			ReadSDLrc();

		}
		/**
		 * �ڶ�����ʾ���֣���������������ͨ�������Ǳ߽��չ�����
		 */
		private void loadclip() {
			seekbar.setProgress(0);
			/**���ø�����**/
			if (_titles[position].length() > 15)
				musicnames.setText(_titles[position].substring(0, 12) + "...");// ���ø�����
			else
				musicnames.setText(_titles[position]);

			/**������������**/ 
			if (_artists[position].equals("<unknown>"))
				artisting.setText("δ֪������");
			else
				artisting.setText(_artists[position]);
			Intent intent = new Intent();
			intent.putExtra("_ids", _ids);
			intent.putExtra("_titles", _titles);
			intent.putExtra("_artists", _artists);
			intent.putExtra("position", position);
		    intent.setAction("com.app.media.MUSIC_SERVICE");// �������action���ͷ���
			startService(intent);
			
		}
		/**
		 * ��ʼ��
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
		 * Ϊ���ֶ�ȡ��ʣ����һ��һ�з�ʽ��������ǿ���OK��ȫ���������š�
		 */
		private void ReadSDLrc() {
			/**�������ڵĸ�ʾ���ҪString����ĵ�4������-��ʾ�ļ�����**/
			cursor = getContentResolver().query(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,           
					        new String[] { MediaStore.Audio.Media.TITLE,
							MediaStore.Audio.Media.DURATION,
							MediaStore.Audio.Media.ARTIST,
							MediaStore.Audio.Media.ALBUM,
							MediaStore.Audio.Media.DISPLAY_NAME,
							MediaStore.Audio.Media.ALBUM_ID }, "_id=?",new String[] { _ids[position] + "" }, null);
			cursor.moveToFirst();// ���α�������һλ
			Bitmap bm = getArtwork(this, _ids[position], cursor.getInt(5), true);
			/**�л�����ʱ��ר��ͼƬ����͸��Ч��**/
			Animation albumanim=AnimationUtils.loadAnimation(context, R.anim.album_replace);
			/**��ʼ���Ŷ���Ч��**/
			album.startAnimation(albumanim);
			album.setImageBitmap(bm);
			/**Ϊר��ͼƬ��ӵ�Ӱ,������������е�Ч��**/
			iv_player_ablum_reflection.setImageBitmap(ImageUtil.createReflectionBitmapForSingle(bm));
			/**�α궨λ��DISPLAY_NAME**/
			String name = cursor.getString(4);
			/**sd�����������ֽ�ȡ�ַ��ܲ��ҵ�����λ��,�ⲽ��Ҫ��û��дһֱ��ʾ����ļ��޷���ʾ,˳��˵����ͬ�ֻ��ͺ�SD���в�ͬ��·����**/
			read("/sdcard/music/" + name.substring(0, name.indexOf(".")) + ".lrc");
			/** �ڵ���ʱ���Ȱ���������д��������ʱ���ڿ���̨��ӡ���������֣���ô�ɴ��жϸ���û����.ֻ��û�л�ȡλ��**/
			System.out.println(cursor.getString(4));
			
		}
		/**�ں�̨MusicService��ʹ��handler��Ϣ���ƣ���ͣ����ǰ̨���͹㲥���㲥����������ǵ�ǰmp���ŵ�ʱ��㣬
		 * ǰ̨���յ��㲥���ò���ʱ��������½�����,����������������һЩ��˵��Ȼ������ʵ�֡����ǻ��Ǿ��ÿ������̲߳���**/
		protected BroadcastReceiver musicReceiver = new BroadcastReceiver() {

			public void onReceive(Context context, Intent intent) {
				String action = intent.getAction();
				if (action.equals(MUSIC_CURRENT)) {
					currentPosition = intent.getExtras().getInt("currentTime");// ��õ�ǰ����λ��
					playtimes.setText(toTime(currentPosition));
					seekbar.setProgress(currentPosition);// ���ý�����
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
		 * ����ʱ��ת��
		 */
		public String toTime(int time) {

			time /= 1000;
			int minute = time / 60;
			int second = time % 60;
			minute %= 60;
			return String.format("%02d:%02d", minute, second);
		}
		/**
		 * ��ȡ��ʵķ���������IO����һ��һ�е���ʾ
		 */
		private void read(String path) {
			lrc_map.clear();
			TreeMap<Integer, LRCbean> lrc_read = new TreeMap<Integer, LRCbean>();
			String data = "";
			BufferedReader br = null;
			File file = new File(path);
			System.out.println(path);
			/**���û�и�ʣ�����û�и����ʾ**/
			if (!file.exists()) {
				Animation lrcanim=AnimationUtils.loadAnimation(context, R.anim.album_replace);
				lrcTextview.setText(R.string.no_lrc_messenge);
				lrcTextview.startAnimation(lrcanim);
				return;
			}
			FileInputStream stream = null;
			try {
				stream = new FileInputStream(file);
				br = new BufferedReader(new InputStreamReader(stream, "UTF-8"));//�ǵø��һ��Ҫ����UTF-8�������ʱ���ֱ������ม�
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			try {
				while ((data = br.readLine()) != null) {
					if (data.length() > 6) {
						if (data.charAt(3) == ':' && data.charAt(6) == '.') {// �Ӹ�����Ŀ�ʼ
							data = data.replace("[", "");
							data = data.replace("]", "@");
							data = data.replace(".", ":");
							String lrc[] = data.split("@");
							String lrcContent = null;
							if (lrc.length == 2) {
								lrcContent = lrc[lrc.length - 1];// ���
							} else {
								lrcContent = "";
							}

							for (int i = 0; i < lrc.length - 1; i++) {
								String lrcTime[] = lrc[0].split(":");

								int m = Integer.parseInt(lrcTime[0]);// ��
								int s = Integer.parseInt(lrcTime[1]);// ��
								int ms = Integer.parseInt(lrcTime[2]);// ����

								int begintime = (m * 60 + s) * 1000 + ms;// ת���ɺ���
								LRCbean lrcbean = new LRCbean();
								lrcbean.setBeginTime(begintime);// ���ø�ʿ�ʼʱ��
								lrcbean.setLrcBody(lrcContent);// ���ø�ʵ�����
								lrc_read.put(begintime, lrcbean);

							}

						}
					}
				}
				stream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			// ����ÿ������Ҫ��ʱ��
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
		 * �����Ǹ����ŵ�ʱ����ʾר��ͼƬ�����б�ͬ,����ʱͼƬҪ������cam�Ǹ�����д���ʵ�ͼƬ��
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
					/**��ָ��ԭʼ��С**/
					options.inSampleSize = 1;
					/** ֻ���д�С�ж�**/
					options.inJustDecodeBounds = true;
					/**���ô˷����õ�options�õ�ͼƬ�Ĵ�С**/
					BitmapFactory.decodeStream(in, null, options);
					/**���ǵ�Ŀ��������N pixel�Ļ�������ʾ�� ������Ҫ����computeSampleSize�õ�ͼƬ���ŵı���**/
					/**�����targetΪ800�Ǹ���Ĭ��ר��ͼƬ��С�����ģ�800ֻ�ǲ������ֵ���������������Ľ��**/
					options.inSampleSize = computeSampleSize(options, 600);
					/**���ǵõ������ŵı��������ڿ�ʼ��ʽ����BitMap����**/
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
				// ֻ���д�С�ж�
				options.inJustDecodeBounds = true;
				// ���ô˷����õ�options�õ�ͼƬ�Ĵ�С
				BitmapFactory.decodeFileDescriptor(fd, null, options);
				// ���ǵ�Ŀ������800pixel�Ļ�������ʾ��
				// ������Ҫ����computeSampleSize�õ�ͼƬ���ŵı���
				options.inSampleSize = 100;
				// OK,���ǵõ������ŵı��������ڿ�ʼ��ʽ����BitMap����
				options.inJustDecodeBounds = false;
				options.inDither = false;
				options.inPreferredConfig = Bitmap.Config.ARGB_8888;

				// ����options��������������Ҫ���ڴ�
				bm = BitmapFactory.decodeFileDescriptor(fd, null, options);
			} catch (FileNotFoundException ex) {

			}

			return bm;
		}

		/**����������ͼƬ�Ĵ�С�����жϣ����õ����ʵ����ű���������2��1/2,3��1/3**/
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
		 * ��ʱΪ����������С
		 */
		private OnSeekBarChangeListener seekBarChangeListener = new OnSeekBarChangeListener() {

			@Override
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				if (seekBar.getId() == R.id.sb_player_voice) {
					// ��������
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
		 * Сͼ��ļ����¼�
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
		// ���������ʾ������
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
		 * �ص�������С����
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
		 * ���·��ؼ��¼�
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
					String[] menustring = new String[] { "�������", "��ע���ǵ�̨" };
					ListView menulist = new ListView(PlayMusicActivity.this);
					menulist.setCacheColorHint(Color.TRANSPARENT);
					menulist.setDividerHeight(1);
					menulist.setAdapter(new ArrayAdapter<String>(PlayMusicActivity.this,R.layout.dialog_menu_item, R.id.text1, menustring));
					menulist.setLayoutParams(new LayoutParams(Contsant.getScreen(PlayMusicActivity.this)[0] / 2,LayoutParams.WRAP_CONTENT));

					final XfDialog xfdialog = new XfDialog.Builder(PlayMusicActivity.this).setTitle("ϵͳ����:").setView(menulist).create();
					xfdialog.show();
					break;
				}
				
			}
			
		};	

}
