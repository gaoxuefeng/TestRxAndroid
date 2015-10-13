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
 * �������ʱ��ֱ�ӽ��������б�������Ҫ���ܰ����� 1.�Զ�ɨ�����ֲ���ʾ�б��� 2.֧��MP3,M4A��ʽ 3.֧�ֻ��� 4.��ʱ�ر� 5.ҹ��+�ռ�ģʽ
 * 6.�鿴������ϸ��Ϣ 7.�趨һ����Ϊ��������/֪ͨ/��������
 * ������Ҫ��������MediaStore������ࡣ�����Ѽ��������ֵ���Ϣ,��������ϢҲ��������ȡ�ġ�
 * ������Ϣ��ȷд����MediaStore.Audio.Media.XXXX.������ҪƯ������Ҫ�Զ���������(Adapter)��
 * ����Ӧ�Ľ��涨��һ�����������о��Ƕ�����������(id,title,artits)�ֱ������id����ı��⣬�����ң���ʵ������ѭ����ȡ���Ǹ��Ե������С�
 * �����ȡ����ɨ�蹦��
 * 
 * @author ����
 */
public class MusicListActivity extends BaseActivity {
	/*** �����б� **/
	private ListView listview;
	private ArrayList<MusicBean> musicArrayBeans = new ArrayList<MusicBean>();
	private Menu xmenu;// �Զ���˵�
	private int num;// numȷ��һ����ʶ
	private int c;// ͬ��
	private LayoutInflater inflater;// װ�ز���
	private LayoutParams params;
	private Toast toast;// ��ʾ
	/** ������ʶ���� **/
	public static final int Ringtone = 0;
	public static final int Alarm = 1;
	public static final int Notification = 2;
	private TextView timers;// ��ʾ����ʱ������
	private Timers timer;// ����ʱ�ڲ�����
	private ImageButton plays_btn;
	private int position;
	MusicListAdapter adapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.music_list);
		/** ѡ���������¼� ***/
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
		// ����Ƥ������
		Setting setting = new Setting(this, false);
		listview.setBackgroundResource(setting.getCurrentSkinResId());// ������ֻ����listview��Ƥ�����ѡ�
	}

	/**
	 * ��ʾMP3��Ϣ,����_ids���������������ļ���_ID������ȷ������Ҫ������һ�׸�����_titles�����������������ʾ�ڲ��Ž��棬
	 * ��_path��������ļ���·����ɾ���ļ�ʱ���õ�����
	 */
	private void ShowMp3List() {
		// ���α����ý����ϸ��Ϣ
		Cursor cursor = this.getContentResolver().query(
				MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
				new String[] { MediaStore.Audio.Media.TITLE,// ���⣬�α��0��ȡ
						MediaStore.Audio.Media.DURATION,// ����ʱ��,1
						MediaStore.Audio.Media.ARTIST,// ������,2
						MediaStore.Audio.Media._ID,// id,3
						MediaStore.Audio.Media.DISPLAY_NAME,// ��ʾ����,4
						MediaStore.Audio.Media.DATA,// ���ݣ�5
						MediaStore.Audio.Media.ALBUM_ID,// ר������ID,6
						MediaStore.Audio.Media.ALBUM,// ר��,7
						MediaStore.Audio.Media.SIZE }, null, null,
				MediaStore.Audio.Media.ARTIST);// ��С,8
		/**
		 * �ж��α��Ƿ�Ϊ�գ���Щ�ط���ʹû������Ҳ�ᱨ�쳣�������α겻�ȶ������в����ͳ�����,��Σ�����û�û�����ֵĻ���
		 * �������Ը�֪�û�û���������û���ӽ�ȥ
		 */
		if (cursor != null && cursor.getCount() == 0) {
			final XfDialog xfdialog = new XfDialog.Builder(
					MusicListActivity.this).setTitle("��ʾ:")
					.setMessage("����ֻ�δ�ҵ�����,���������")
					.setPositiveButton("ȷ��", null).create();
			xfdialog.show();
			return;

		}
		/** ���α��Ƶ���һλ **/
		while (cursor.moveToNext()) {
			MusicBean bean = new MusicBean();
			int ids = cursor.getInt(3);
			String titles = cursor.getString(0);
			String artists = cursor.getString(2);
			String path = cursor.getString(5).substring(4);
			/**************** ������Ϊ�ṩ������ϸ��Ϣ�����ɵ� ***************************/
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
			// С��60�벻���
			if (cursor.getInt(1) > 60000) {
				musicArrayBeans.add(bean);
			}

		}
		/** �ֱ𽫸�����������ʵ���� **/

		/**
		 * �����ȡ·���ĸ�ʽ��_path[i]=c.geString,Ϊʲô��ôд������ΪMediaStore.Audio.Media.
		 * DATA�Ĺ�ϵ
		 * �õ������ݸ�ʽΪ/mnt/sdcard/[���ļ�����/]�����ļ�������������Ҫ�õ�����/sdcard/[���ļ�����]�����ļ���
		 */
	
		listview.setAdapter(new MusicListAdapter(this, musicArrayBeans));

	}

	/**
	 * ʱ���ת��
	 */
	public String toTime(int time) {

		time /= 1000;
		int minute = time / 60;
		int second = time % 60;
		minute %= 60;
		/** ���ؽ����string��format������ʱ��ת�����ַ����� **/
		return String.format("%02d:%02d", minute, second);
	}

	/** �����б���Ӽ����������֮�󲥷����� */
	public class MusicListOnClickListener implements OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> arg0, View view, int position,
				long id) {
			playMusic(position);

		}

	}

	/**
	 * ����Listview�󵯳��˵�
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
	 * ��ʼ���˵�
	 */
	private void LoadMenu() {
		xmenu = new Menu(this);
		List<int[]> data1 = new ArrayList<int[]>();
		data1.add(new int[] { R.drawable.btn_menu_skin, R.string.skin_settings });
		data1.add(new int[] { R.drawable.btn_menu_exit, R.string.menu_exit_txt });

		xmenu.addItem("����", data1, new MenuAdapter.ItemListener() {

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
		if (brightness != null && brightness.equals("0")) {// ҹ��ģʽ
			data2.add(new int[] { R.drawable.btn_menu_brightness,
					R.string.brightness_title });
		} else {
			data2.add(new int[] { R.drawable.btn_menu_darkness,
					R.string.darkness_title });
		}
		xmenu.addItem("����", data2, new MenuAdapter.ItemListener() {

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
		xmenu.addItem("����", data3, new MenuAdapter.ItemListener() {
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
	 * ����Position��������
	 */
	public void playMusic(int position) {
		Intent intent = new Intent(MusicListActivity.this,
				PlayMusicActivity.class);
		intent.putExtra("musicBean", musicArrayBeans.get(position));
		startActivity(intent);
	}

	/**
	 * ��д�˵�����
	 */
	@Override
	public boolean onCreateOptionsMenu(android.view.Menu menu) {
		menu.add("menu");
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public boolean onMenuOpened(int featureId, android.view.Menu menu) {
		/** �˵���������ʾ������1�Ǹò����ܵ�ID���ڶ���λ�ã��������ĸ���XY���� **/
		xmenu.showAtLocation(findViewById(R.id.rl_parent_cotent),
				Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
		/** �������true�Ļ��ͻ���ʾϵͳ�Դ��Ĳ˵�����֮����false�Ļ�����ʾ�Լ�д�ġ� **/
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
	 * �û������б���߰�ס���ұߵĵ������η������¼�
	 */
	private void SongItemDialog() {
		String[] menustring = new String[] { "���Ŵ�����", "��������Ϊ����", "�鿴�ø�������" };
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
	 * ��������
	 */
	private void SetRing() {
		RadioGroup rg_ring = new RadioGroup(MusicListActivity.this);
		rg_ring.setLayoutParams(params);
		final RadioButton rbtn_ringtones = new RadioButton(
				MusicListActivity.this);
		rbtn_ringtones.setText("��������");
		rg_ring.addView(rbtn_ringtones, params);
		final RadioButton rbtn_alarms = new RadioButton(MusicListActivity.this);
		rbtn_alarms.setText("��������");
		rg_ring.addView(rbtn_alarms, params);
		final RadioButton rbtn_notifications = new RadioButton(
				MusicListActivity.this);
		rbtn_notifications.setText("֪ͨ����");
		rg_ring.addView(rbtn_notifications, params);
		new XfDialog.Builder(MusicListActivity.this).setTitle("��������")
				.setView(rg_ring)
				.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
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

				}).setNegativeButton("ȡ��", null).show();
	}

	/**
	 * ������������
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
		toast = Contsant.showMessage(toast, MusicListActivity.this, "�������������ɹ�");
		System.out.println("setMyRingtone()-----����");

	}

	/**
	 * ������ʾ��
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
		Toast.makeText(getApplicationContext(), "����֪ͨ�����ɹ���", Toast.LENGTH_SHORT)
				.show();
		System.out.println("�����ҵ�֪ͨ��:-----��ʾ��");
	}

	/**
	 * ����������
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
		Toast.makeText(getApplicationContext(), "�������������ɹ���", Toast.LENGTH_SHORT)
				.show();
		System.out.println("setMyNOTIFICATION------������");
	}

	/**
	 * ��ʾ������ϸ��Ϣ
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
	 * ���߷���
	 */
	private void Sleep() {
		final EditText edtext = new EditText(this);
		edtext.setText("5");// ���ó�ʼֵ
		edtext.setKeyListener(new DigitsKeyListener(false, true));
		edtext.setGravity(Gravity.CENTER_HORIZONTAL);// ���ð���λ��
		edtext.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));// ��������
		edtext.setTextColor(Color.BLUE);// ������ɫ
		edtext.setSelection(edtext.length());// ����ѡ��λ��
		edtext.selectAll();// ȫ��ѡ��
		new XfDialog.Builder(MusicListActivity.this).setTitle("������ʱ��")
				.setView(edtext)
				.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
						dialog.cancel();
						/** �������С��2���ߵ���0���֪�û� **/
						if (edtext.length() <= 2 && edtext.length() != 0) {
							if (".".equals(edtext.getText().toString())) {
								toast = Contsant.showMessage(toast,
										MusicListActivity.this,
										"�������������������λ����.");
							} else {
								final String time = edtext.getText().toString();
								long Money = Integer.parseInt(time);
								long cX = Money * 60000;
								timer = new Timers(cX, 1000);
								timer.start();// ����ʱ��ʼ
								toast = Contsant.showMessage(toast,
										MusicListActivity.this, "����ģʽ����!��"
												+ String.valueOf(time)
												+ "���Ӻ�رճ���!");
								timers.setVisibility(View.INVISIBLE);
								timers.setVisibility(View.VISIBLE);
								timers.setText(String.valueOf(time));
							}

						} else {
							Toast.makeText(MusicListActivity.this, "�����뼸����",
									Toast.LENGTH_SHORT).show();
						}

					}
				}).setNegativeButton(R.string.cancel, null).show();

	}

	/**
	 * ����һ������ʱ
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
			// �������������9 ˵������2λ����,����ֱ�����롣����С�ڵ���9 �Ǿ���1λ��������ǰ���һ��0
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
	 * �˳����򷽷�
	 */
	private void exit() {
		Intent mediaServer = new Intent(MusicListActivity.this,
				MusicService.class);
		stopService(mediaServer);
		finish();
	}

	/**
	 * ������ť�����¼�
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
