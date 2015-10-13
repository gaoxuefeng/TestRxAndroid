package cn.com.ethank.yunge.pad.bean;

/**
 * Created by dddd on 2015/4/28.
 */
public class MusicBean {
    private String title;//歌曲名字
    private String singer;//歌手
    private String album;//唱片
    private String url;//图片地址
    private String language;//图片地址
    private long size;//
    private long time;//时间长度
    private long albumid;//唱片id
    private long songid;//
    private String musicName;

    public String getMusicName() {
        if (musicName == null) {
            return "";
        }
        return musicName;
    }

    public void setMusicName(String musicName) {
        this.musicName = musicName;
    }

    public String getLanguage() {
        if (language == null) {
            return "";
        }
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getTitle() {
        if (title == null) {
            return "";
        }
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSinger() {
        if (singer == null) {
            return "";
        }
        return singer;
    }

    public void setSinger(String singer) {
        this.singer = singer;
    }

    public String getAlbum() {
        return album;
    }

    public void setAlbum(String album) {
        this.album = album;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public long getSize() {
        return size;
    }

    public void setSize(long size) {
        this.size = size;
    }

    public long getTime() {
        return time;
    }

    public void setTime(long time) {
        this.time = time;
    }

    public long getAlbumid() {
        return albumid;
    }

    public void setAlbumid(long albumid) {
        this.albumid = albumid;
    }

    public long getSongid() {
        return songid;
    }

    public void setSongid(long songid) {
        this.songid = songid;
    }
}
