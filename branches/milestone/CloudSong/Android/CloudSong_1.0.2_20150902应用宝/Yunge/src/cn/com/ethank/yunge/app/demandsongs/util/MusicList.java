package cn.com.ethank.yunge.app.demandsongs.util;

import java.util.ArrayList;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.provider.MediaStore;
import cn.com.ethank.yunge.app.demandsongs.beans.MusicBean;

public class MusicList {

    public static ArrayList<MusicBean> getMusicData(Context context) {

        ArrayList<MusicBean> musicList = new ArrayList<MusicBean>();
        ContentResolver cr = context.getContentResolver();
        if (cr != null) {
            // 获取所有歌曲
            Cursor cursor = cr.query(
                    MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, null, null,
                    null, MediaStore.Audio.Media.DEFAULT_SORT_ORDER);
            if (null == cursor) {
                return null;
            }
            if (cursor.moveToFirst()) {
                do {
                    MusicBean m = new MusicBean();
                    String title = cursor.getString(cursor
                            .getColumnIndex(MediaStore.Audio.Media.TITLE));
                    String singer = cursor.getString(cursor
                            .getColumnIndex(MediaStore.Audio.Media.ARTIST));
                    if ("<unknown>".equals(singer)) {
                        singer = "未知艺术家";
                    }
                    long albumId = cursor.getLong(cursor
                            .getColumnIndex(MediaStore.Audio.Media._ID));
                    String album = cursor.getString(cursor
                            .getColumnIndex(MediaStore.Audio.Media.ALBUM));
                    long size = cursor.getLong(cursor
                            .getColumnIndex(MediaStore.Audio.Media.SIZE));
                    long time = cursor.getLong(cursor
                            .getColumnIndex(MediaStore.Audio.Media.DURATION));
                    String url = cursor.getString(cursor
                            .getColumnIndex(MediaStore.Audio.Media.DATA));
                    String name = cursor
                            .getString(cursor
                                    .getColumnIndex(MediaStore.Audio.Media.DISPLAY_NAME));
                    String sbr = name.substring(name.length() - 3,
                            name.length());
                    if (sbr.equals("mp3") && (time >= 1000 && time <= 900000)) {
                        m.setTitle(title);
                        m.setSinger(singer);
                        m.setAlbum(album);
                        m.setSize(size);
                        m.setTime(time);
                        m.setUrl(url);
                        m.setMusicName(name);
                        m.setAlbumid(albumId);
                        musicList.add(m);
                    }
                } while (cursor.moveToNext());
            }
            if (cursor != null) {
                cursor.close();
            }
        }
        return musicList;
    }

}
