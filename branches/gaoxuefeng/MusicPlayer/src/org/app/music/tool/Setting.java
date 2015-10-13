package org.app.music.tool;

import org.app.musicplayer.R;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

public class Setting {
	/**
	 * SD卡下载歌曲目录
	 * */
	public static final String DOWNLOAD_MUSIC_DIRECTORY="/Music/download_music/";
	/**
	 * SD卡下载歌词目录
	 * */
	public static final String DOWNLOAD_LYRIC_DIRECTORY="/Music/download_lyric/";
	/**
	 * SD卡下载专辑图片目录
	 * */
	public static final String DOWNLOAD_ALBUM_DIRECTORY="/Music/download_album/";
	/**
	 * SD卡下载歌手图片目录
	 * */
	public static final String DOWNLOAD_ARTIST_DIRECTORY="/Music/download_artist/";
	/**
	 * 系统设置的保存的文件名
	 * */
	public static final String PREFERENCE_NAME = "org.app.music.settings";
	public static final String KEY_SKINID = "skin_id";
	private SharedPreferences settingPreference;
	public static final String KEY_AUTO_SLEEP="sleep";//定时关闭时间
	public static final String KEY_BRIGHTNESS="brightness";//屏幕模式->1:正常模式 0:夜间模式
	public static final float KEY_DARKNESS=0.1f;//夜间模式值level
	/**
	 * 皮肤资源的ID数组
	 * */
	public static final int[] SKIN_RESOURCES = { R.drawable.main_bg01,
			R.drawable.main_bg02, R.drawable.main_bg03, R.drawable.main_bg04,
			R.drawable.main_bg05, R.drawable.main_bg06 ,R.drawable.bg_media_library};

	public Setting(Context context,boolean isWrite) {
		settingPreference = context.getSharedPreferences(PREFERENCE_NAME,isWrite?Context.MODE_WORLD_READABLE:Context.MODE_WORLD_WRITEABLE);
	}
	/**
	 * 获取数据
	 * */
	public String getValue(String key){
		return settingPreference.getString(key, null);
	}
	/**
	 * 获取皮肤资源ID
	 * */
	public int getCurrentSkinResId() {
		int skinIndex = settingPreference.getInt(KEY_SKINID, 0);
		if (skinIndex >= SKIN_RESOURCES.length) {
			skinIndex = 0;
		}
		return SKIN_RESOURCES[skinIndex];
	}

	/**
	 * 获取皮肤Id
	 * */
	public int getCurrentSkinId(){
		int skinIndex = settingPreference.getInt(KEY_SKINID, 0);
		if (skinIndex >= SKIN_RESOURCES.length) {
			skinIndex = 0;
		}
		return skinIndex;
	}
	
	/**
	 * 设置皮肤资源ID
	 * */
	public void setCurrentSkinResId(int skinIndex) {
		Editor it = settingPreference.edit();
		it.putInt(KEY_SKINID, skinIndex);
		it.commit();
	}
	
	/**
	 * 设置键值
	 * */
	public void setValue(String key,String value){
		Editor it = settingPreference.edit();
		it.putString(key, value);
		it.commit();
	}
	
}
