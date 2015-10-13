package org.app.musicplayer;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.app.MusicBean;
import org.app.music.adapter.MenuAdapter;
import org.app.music.adapter.MusicListAdapter;
import org.app.music.service.MusicService;
import org.app.music.tool.Contsant;
import org.app.music.tool.Menu;
import org.app.music.tool.Setting;
import org.app.music.tool.XfDialog;

import android.content.ContentValues;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Color;
import android.graphics.Typeface;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.provider.MediaStore;
import android.text.method.DigitsKeyListener;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnCreateContextMenuListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

/**
 * 进入程序时，直接进入音乐列表，这里主要功能包括了 1.自动扫描音乐并显示列表里 2.支持MP3,M4A格式 3.支持换肤 4.定时关闭 5.夜间+日间模式
 * 6.查看音乐详细信息 7.设定一音乐为来电铃声/通知/警告铃声
 * 最最主要的是依靠MediaStore这个大类。负责搜集所有音乐的信息,读音乐信息也是用它读取的。
 * 音乐信息正确写法是MediaStore.Audio.Media.XXXX.但是你要漂亮首先要自定义适配器(Adapter)。
 * 在相应的界面定义一个方法，还有就是定义三个变量(id,title,artits)分别代表歌的id，歌的标题，艺术家，先实例化后循环获取它们各自的索引列。
 * 这次我取消了扫描功能
 * 
 * @author 涙星
 */
public class MusicListActivity extends BaseActivity {
	/*** 音乐列表 **/
	private ListView listview;
	private ArrayList<MusicBean> musicArrayBeans = new ArrayList<MusicBean>();
	private Menu xmenu;// 自定义菜单
	private int num;// num确定一个标识
	private int c;// 同上
	private LayoutInflater inflater;// 装载布局
	private LayoutParams params;
	private Toast toast;// 提示
	/** 铃声标识常量 **/
	public static final int Ringtone = 0;
	public static final int Alarm = 1;
	public static final int Notification = 2;
	private TextView timers;// 显示倒计时的文字
	private Timers timer;// 倒计时内部对象
	private ImageButton plays_btn;
	private int position;
	MusicListAdapter adapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.music_list);
		/** 选择子项点击事件 ***/
		listview = (ListView) findViewById(R.id.local_music_list);
		listview.setOnItemClickListener(new MusicListOnClickListener());
		listview.setOnCreateContextMenuListener(new MusicListContextListener());
		timers = (TextView) findViewById(R.id.timer_clock);
		inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
		params = new LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.WRAP_CONTENT);
		plays_btn = (ImageButton) findViewById(R.id.plays_btn);
		plays_btn.setOnClickListener(listeners);
		LoadMenu();
		ShowMp3List();
	}

	@Override
	protected void onResume() {
		super.onResume();
		// 设置皮肤背景
		Setting setting = new Setting(this, false);
		listview.setBackgroundResource(setting.getCurrentSkinResId());// 这里我只设置listview的皮肤而已。
	}

	/**
	 * 显示MP3信息,其中_ids保存了所有音乐文件的_ID，用来确定到底要播放哪一首歌曲，_titles存放音乐名，用来显示在播放界面，
	 * 而_path存放音乐文件的路径（删除文件时会用到）。
	 */
	private void ShowMp3List() {
		// 用游标查找媒体详细信息
		Cursor cursor = this.getContentResolver().query(
				MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
				new String[] { MediaStore.Audio.Media.TITLE,// 标题，游标从0读取
						MediaStore.Audio.Media.DURATION,// 持续时间,1
						MediaStore.Audio.Media.ARTIST,// 艺术家,2
						MediaStore.Audio.Media._ID,// id,3
						MediaStore.Audio.Media.DISPLAY_NAME,// 显示名称,4
						MediaStore.Audio.Media.DATA,// 数据，5
						MediaStore.Audio.Media.ALBUM_ID,// 专辑名称ID,6
						MediaStore.Audio.Media.ALBUM,// 专辑,7
						MediaStore.Audio.Media.SIZE }, null, null,
				MediaStore.Audio.Media.ARTIST);// 大小,8
		/**
		 * 判断游标是否为空，有些地方即使没有音乐也会报异常。而且游标不稳定。稍有不慎就出错了,其次，如果用户没有音乐的话，
		 * 不妨可以告知用户没有音乐让用户添加进去
		 */
		if (cursor != null && cursor.getCount() == 0) {
			final XfDialog xfdialog = new XfDialog.Builder(
					MusicListActivity.this).setTitle("提示:")
					.setMessage("你的手机未找到音乐,请添加音乐")
					.setPositiveButton("确定", null).create();
			xfdialog.show();
			return;

		}
		/** 将游标移到第一位 **/
		while (cursor.moveToNext()) {
			MusicBean bean = new MusicBean();
			int ids = cursor.getInt(3);
			String titles = cursor.getString(0);
			String artists = cursor.getString(2);
			String path = cursor.getString(5).substring(4);
			/**************** 以下是为提供音乐详细信息而生成的 ***************************/
			String album = cursor.getString(7);
			String times = toTime(cursor.getInt(1));
			int sizes = cursor.getInt(8);
			int album_id = cursor.getInt(6);
			String displayname = cursor.getString(4);
			bean.set_id(ids);
			bean.set_titles(titles);
			bean.set_artists(artists);
			bean.set_path(path);
			bean.set_album(album);
			bean.set_times(times);
			bean.set_sizes(sizes);
			bean.set_displayname(displayname);
			bean.setAlbum_id(album_id);
			// 小于60秒不添加
			if (cursor.getInt(1) > 60000) {
				musicArrayBeans.add(bean);
			}

		}
		/** 分别将各个标题数组实例化 **/

		/**
		 * 这里获取路径的格式是_path[i]=c.geString,为什么这么写？是因为MediaStore.Audio.Media.
		 * DATA的关系
		 * 得到的内容格式为/mnt/sdcard/[子文件夹名/]音乐文件名，而我们想要得到的是/sdcard/[子文件夹名]音乐文件名
		 */
	
		listview.setAdapter(new MusicListAdapter(this, musicArrayBeans));

	}

	/**
	 * 时间的转换
	 */
	public String toTime(int time) {

		time /= 1000;
		int minute = time / 60;
		int second = time % 60;
		minute %= 60;
		/** 返回结果用string的format方法把时间转换成字符类型 **/
		return String.format("%02d:%02d", minute, second);
	}

	/** 音乐列表添加监听器，点击之后播放音乐 */
	public class MusicListOnClickListener implements OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> arg0, View view, int position,
				long id) {
			playMusic(position);

		}

	}

	/**
	 * 长按Listview后弹出菜单
	 */
	private class MusicListContextListener implements
			OnCreateContextMenuListener {

		@Override
		public void onCreateContextMenu(ContextMenu menu, View v,
				ContextMenuInfo info) {
			SongItemDialog();
			final AdapterView.AdapterContextMenuInfo menuInfo = (AdapterView.AdapterContextMenuInfo) info;
			num = menuInfo.position;

		}

	}

	/**
	 * 初始化菜单
	 */
	private void LoadMenu() {
		xmenu = new Menu(this);
		List<int[]> data1 = new ArrayList<int[]>();
		data1.add(new int[] { R.drawable.btn_menu_skin, R.string.skin_settings });
		data1.add(new int[] { R.drawable.btn_menu_exit, R.string.menu_exit_txt });

		xmenu.addItem("常用", data1, new MenuAdapter.ItemListener() {

			@Override
			public void onClickListener(int position, View view) {
				xmenu.cancel();
				if (position == 0) {
					Intent it = new Intent(MusicListActivity.this,
							SkinSettingActivity.class);
					startActivityForResult(it, 2);

				} else if (position == 1) {
					exit();

				}
			}
		});
		List<int[]> data2 = new ArrayList<int[]>();
		data2.add(new int[] { R.drawable.btn_menu_setting,
				R.string.menu_settings });
		data2.add(new int[] { R.drawable.btn_menu_sleep, R.string.menu_time_txt });
		Setting setting = new Setting(this, false);
		String brightness = setting.getValue(Setting.KEY_BRIGHTNESS);
		if (brightness != null && brightness.equals("0")) {// 夜间模式
			data2.add(new int[] { R.drawable.btn_menu_brightness,
					R.string.brightness_title });
		} else {
			data2.add(new int[] { R.drawable.btn_menu_darkness,
					R.string.darkness_title });
		}
		xmenu.addItem("工具", data2, new MenuAdapter.ItemListener() {

			@Override
			public void onClickListener(int position, View view) {
				xmenu.cancel();
				if (position == 0) {

				} else if (position == 1) {
					Sleep();
				} else if (position == 2) {
					setBrightness(view);
				}
			}
		});
		List<int[]> data3 = new ArrayList<int[]>();
		data3.add(new int[] { R.drawable.btn_menu_about, R.string.about_title });
		xmenu.addItem("帮助", data3, new MenuAdapter.ItemListener() {
			@Override
			public void onClickListener(int position, View view) {
				xmenu.cancel();
				Intent intent = new Intent(MusicListActivity.this,
						AboutActivity.class);
				startActivity(intent);

			}
		});
		xmenu.create();
	}

	/**
	 * 根据Position播放音乐
	 */
	public void playMusic(int position) {
		Intent intent = new Intent(MusicListActivity.this,
				PlayMusicActivity.class);
		intent.putExtra("musicBean", musicArrayBeans.get(position));
		startActivity(intent);
	}

	/**
	 * 复写菜单方法
	 */
	@Override
	public boolean onCreateOptionsMenu(android.view.Menu menu) {
		menu.add("menu");
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public boolean onMenuOpened(int featureId, android.view.Menu menu) {
		/** 菜单在哪里显示。参数1是该布局总的ID，第二个位置，第三，四个是XY坐标 **/
		xmenu.showAtLocation(findViewById(R.id.rl_parent_cotent),
				Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
		/** 如果返回true的话就会显示系统自带的菜单，反之返回false的话就显示自己写的。 **/
		return false;
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == 1 && resultCode == 1) {
			Setting setting = new Setting(this, false);
			this.getWindow().setBackgroundDrawableResource(
					setting.getCurrentSkinResId());
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
			new XfDialog.Builder(MusicListActivity.this)
					.setTitle(R.string.info)
					.setMessage(R.string.dialog_messenge)
					.setPositiveButton(R.string.confrim,
							new DialogInterface.OnClickListener() {

								@Override
								public void onClick(DialogInterface dialog,
										int which) {
									exit();

								}
							}).setNeutralButton(R.string.cancel, null).show();
			return false;
		}
		return false;
	}

	/**
	 * 用户长按列表或者按住最右边的倒三角形发生的事件
	 */
	private void SongItemDialog() {
		String[] menustring = new String[] { "播放此音乐", "将歌曲设为铃声", "查看该歌曲详情" };
		ListView menulist = new ListView(MusicListActivity.this);
		menulist.setCacheColorHint(Color.TRANSPARENT);
		menulist.setDividerHeight(1);
		menulist.setAdapter(new ArrayAdapter<String>(MusicListActivity.this,
				R.layout.dialog_menu_item, R.id.text1, menustring));
		menulist.setLayoutParams(new LayoutParams(Contsant
				.getScreen(MusicListActivity.this)[0] / 2,
				LayoutParams.WRAP_CONTENT));

		final XfDialog xfdialog = new XfDialog.Builder(MusicListActivity.this)
				.setTitle(R.string.opertion_file).setView(menulist).create();
		xfdialog.show();
		menulist.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				xfdialog.cancel();
				xfdialog.dismiss();
				if (position == 0) {
					playMusic(num);
				} else if (position == 1) {
					SetRing();
				} else if (position == 2) {
					ShowMusicInfo(num);
				}

			}
		});
	}

	/**
	 * 设置铃声
	 */
	private void SetRing() {
		RadioGroup rg_ring = new RadioGroup(MusicListActivity.this);
		rg_ring.setLayoutParams(params);
		final RadioButton rbtn_ringtones = new RadioButton(
				MusicListActivity.this);
		rbtn_ringtones.setText("来电铃声");
		rg_ring.addView(rbtn_ringtones, params);
		final RadioButton rbtn_alarms = new RadioButton(MusicListActivity.this);
		rbtn_alarms.setText("闹铃铃声");
		rg_ring.addView(rbtn_alarms, params);
		final RadioButton rbtn_notifications = new RadioButton(
				MusicListActivity.this);
		rbtn_notifications.setText("通知铃声");
		rg_ring.addView(rbtn_notifications, params);
		new XfDialog.Builder(MusicListActivity.this).setTitle("设置铃声")
				.setView(rg_ring)
				.setPositiveButton("确定", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						dialog.cancel();
						dialog.dismiss();
						if (rbtn_ringtones.isChecked()) {
							try {
								setRingtone(num);
							} catch (Exception e) {
								e.printStackTrace();
							}
						} else if (rbtn_alarms.isChecked()) {
							try {
								setAlarm(num);
							} catch (Exception e) {
								e.printStackTrace();
							}
						} else if (rbtn_notifications.isChecked()) {
							try {
								setNotification(num);
							} catch (Exception e) {
								e.printStackTrace();
							}
						}

					}

				}).setNegativeButton("取消", null).show();
	}

	/**
	 * 设置来电铃声
	 * 
	 * @param position
	 */
	private void setRingtone(int position) {
		MusicBean bean = musicArrayBeans.get(position);
		File sdfile = new File(bean.get_path());
		ContentValues values = new ContentValues();
		values.put(MediaStore.MediaColumns.DATA, sdfile.getAbsolutePath());
		values.put(MediaStore.MediaColumns.TITLE, sdfile.getName());
		values.put(MediaStore.MediaColumns.MIME_TYPE, "audio/*");
		values.put(MediaStore.Audio.Media.IS_RINGTONE, true);
		values.put(MediaStore.Audio.Media.IS_NOTIFICATION, false);
		values.put(MediaStore.Audio.Media.IS_ALARM, false);
		values.put(MediaStore.Audio.Media.IS_MUSIC, false);

		Uri uri = MediaStore.Audio.Media.getContentUriForPath(sdfile
				.getAbsolutePath());
		Uri newUri = this.getContentResolver().insert(uri, values);
		RingtoneManager.setActualDefaultRingtoneUri(this,
				RingtoneManager.TYPE_RINGTONE, newUri);
		toast = Contsant.showMessage(toast, MusicListActivity.this, "设置来电铃声成功");
		System.out.println("setMyRingtone()-----铃声");

	}

	/**
	 * 设置提示音
	 */
	public void setNotification(int position) {
		MusicBean bean = musicArrayBeans.get(position);
		File sdfile = new File(bean.get_path());
		ContentValues values = new ContentValues();
		values.put(MediaStore.MediaColumns.DATA, sdfile.getAbsolutePath());
		values.put(MediaStore.MediaColumns.TITLE, sdfile.getName());
		values.put(MediaStore.MediaColumns.MIME_TYPE, "audio/*");
		values.put(MediaStore.Audio.Media.IS_RINGTONE, false);
		values.put(MediaStore.Audio.Media.IS_NOTIFICATION, true);
		values.put(MediaStore.Audio.Media.IS_ALARM, false);
		values.put(MediaStore.Audio.Media.IS_MUSIC, false);

		Uri uri = MediaStore.Audio.Media.getContentUriForPath(sdfile
				.getAbsolutePath());
		Uri newUri = this.getContentResolver().insert(uri, values);

		RingtoneManager.setActualDefaultRingtoneUri(this,
				RingtoneManager.TYPE_NOTIFICATION, newUri);
		Toast.makeText(getApplicationContext(), "设置通知铃声成功！", Toast.LENGTH_SHORT)
				.show();
		System.out.println("设置我的通知音:-----提示音");
	}

	/**
	 * 设置闹铃音
	 * 
	 * @param position
	 */
	public void setAlarm(int position) {
		MusicBean bean = musicArrayBeans.get(position);
		File sdfile = new File(bean.get_path());
		ContentValues values = new ContentValues();
		values.put(MediaStore.MediaColumns.DATA, sdfile.getAbsolutePath());
		values.put(MediaStore.MediaColumns.TITLE, sdfile.getName());
		values.put(MediaStore.MediaColumns.MIME_TYPE, "audio/*");
		values.put(MediaStore.Audio.Media.IS_RINGTONE, false);
		values.put(MediaStore.Audio.Media.IS_NOTIFICATION, false);
		values.put(MediaStore.Audio.Media.IS_ALARM, true);
		values.put(MediaStore.Audio.Media.IS_MUSIC, false);

		Uri uri = MediaStore.Audio.Media.getContentUriForPath(sdfile
				.getAbsolutePath());
		Uri newUri = this.getContentResolver().insert(uri, values);
		RingtoneManager.setActualDefaultRingtoneUri(this,
				RingtoneManager.TYPE_ALARM, newUri);
		Toast.makeText(getApplicationContext(), "设置闹钟铃声成功！", Toast.LENGTH_SHORT)
				.show();
		System.out.println("setMyNOTIFICATION------闹铃音");
	}

	/**
	 * 显示音乐详细信息
	 */
	private void ShowMusicInfo(int location) {
		MusicBean bean = musicArrayBeans.get(num);
		View view = inflater.inflate(R.layout.song_detail, null);
		((TextView) view.findViewById(R.id.tv_song_title)).setText(bean
				.get_titles());
		((TextView) view.findViewById(R.id.tv_song_artist)).setText(bean
				.get_artists());
		((TextView) view.findViewById(R.id.tv_song_album)).setText(bean
				.get_album());
		((TextView) view.findViewById(R.id.tv_song_filepath)).setText(bean
				.get_path());
		((TextView) view.findViewById(R.id.tv_song_duration)).setText(bean
				.get_times());
		((TextView) view.findViewById(R.id.tv_song_format)).setText(Contsant
				.getSuffix(bean.get_displayname()));
		((TextView) view.findViewById(R.id.tv_song_size)).setText(Contsant
				.formatByteToMB(bean.get_sizes()) + "MB");
		new XfDialog.Builder(MusicListActivity.this)
				.setTitle(R.string.music_info)
				.setNeutralButton(R.string.confrim, null).setView(view)
				.create().show();
	}

	/**
	 * 休眠方法
	 */
	private void Sleep() {
		final EditText edtext = new EditText(this);
		edtext.setText("5");// 设置初始值
		edtext.setKeyListener(new DigitsKeyListener(false, true));
		edtext.setGravity(Gravity.CENTER_HORIZONTAL);// 设置摆设位置
		edtext.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));// 字体类型
		edtext.setTextColor(Color.BLUE);// 字体颜色
		edtext.setSelection(edtext.length());// 设置选择位置
		edtext.selectAll();// 全部选择
		new XfDialog.Builder(MusicListActivity.this).setTitle("请输入时间")
				.setView(edtext)
				.setPositiveButton("确定", new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
						dialog.cancel();
						/** 如果输入小于2或者等于0会告知用户 **/
						if (edtext.length() <= 2 && edtext.length() != 0) {
							if (".".equals(edtext.getText().toString())) {
								toast = Contsant.showMessage(toast,
										MusicListActivity.this,
										"输入错误，你至少输入两位数字.");
							} else {
								final String time = edtext.getText().toString();
								long Money = Integer.parseInt(time);
								long cX = Money * 60000;
								timer = new Timers(cX, 1000);
								timer.start();// 倒计时开始
								toast = Contsant.showMessage(toast,
										MusicListActivity.this, "休眠模式启动!于"
												+ String.valueOf(time)
												+ "分钟后关闭程序!");
								timers.setVisibility(View.INVISIBLE);
								timers.setVisibility(View.VISIBLE);
								timers.setText(String.valueOf(time));
							}

						} else {
							Toast.makeText(MusicListActivity.this, "请输入几分钟",
									Toast.LENGTH_SHORT).show();
						}

					}
				}).setNegativeButton(R.string.cancel, null).show();

	}

	/**
	 * 产生一个倒计时
	 */
	private class Timers extends CountDownTimer {

		public Timers(long millisInFuture, long countDownInterval) {
			super(millisInFuture, countDownInterval);
		}

		@Override
		public void onFinish() {
			if (c == 0) {
				exit();
				finish();
				onDestroy();
			} else {
				finish();
				onDestroy();
				android.os.Process.killProcess(android.os.Process.myPid());
			}
		}

		@Override
		public void onTick(long millisUntilFinished) {
			timers.setText("" + millisUntilFinished / 1000 / 60 + ":"
					+ millisUntilFinished / 1000 % 60);
			// 假如这个数大于9 说明就是2位数了,可以直接输入。假如小于等于9 那就是1位数。所以前面加一个0
			String abc = (millisUntilFinished / 1000 / 60) > 9 ? (millisUntilFinished / 1000 / 60)
					+ ""
					: "0" + (millisUntilFinished / 1000 / 60);
			String b = (millisUntilFinished / 1000 % 60) > 9 ? (millisUntilFinished / 1000 % 60)
					+ ""
					: "0" + (millisUntilFinished / 1000 % 60);
			timers.setText(abc + ":" + b);
			timers.setVisibility(View.GONE);
		}

	}

	/**
	 * 退出程序方法
	 */
	private void exit() {
		Intent mediaServer = new Intent(MusicListActivity.this,
				MusicService.class);
		stopService(mediaServer);
		finish();
	}

	/**
	 * 其他按钮监听事件
	 */
	private OnClickListener listeners = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.plays_btn:
				Intent intent = new Intent(MusicListActivity.this,
						PlayMusicActivity.class);
				intent.putExtra("musicArrayBeans", musicArrayBeans);
				intent.putExtra("position", position);
				startActivity(intent);
				finish();
				break;

			case R.id.ibtn_song_list_item_menu:
				SongItemDialog();
				break;
			}

		}

	};

}
