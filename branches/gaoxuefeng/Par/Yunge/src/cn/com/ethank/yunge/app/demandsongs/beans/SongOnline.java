package cn.com.ethank.yunge.app.demandsongs.beans;

import java.util.List;

public class SongOnline {
	private long songId; // 歌曲编号
	private String songName; // 歌曲名
	private List<SinglerOnLine> singers; // 歌手名，可能为多
	private String type; // 类型
	private String songPhoto; // 图片url 可能为null
	private String singerPhoto; // 歌手 url 如果为多个歌手，随机给一个
	private String language; // 语种
	private String mvPath; // mv地址

	public long getSongId() {
		return songId;
	}

	public void setSongId(long id) {
		this.songId = id;
	}

	public String getSongName() {
		if (songName == null) {
			return "";
		}
		return songName;
	}

	/**
	 * 获取第一个歌手名字
	 * 
	 * @return
	 */
	public String getSinggerName() {
		try {
			if (singers != null && singers.size() != 0) {
				return singers.get(0).getSingerName();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	/**
	 * 获取第一个歌手id
	 * 
	 * @return
	 */
	public int getSinggerId() {
		try {
			if (singers != null && singers.size() != 0) {
				return singers.get(0).getSingerId();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	public void setSongName(String name) {
		this.songName = name;
	}

	public List<SinglerOnLine> getSingers() {
		return singers;
	}

	public void setSingers(List<SinglerOnLine> singers) {
		this.singers = singers;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getSongPhoto() {
		if (singers != null && singers.size() != 0) {
			return singers.get(0).getSingerImageUrl();
		}

		return "";
	}

	public void setSongPhoto(String songPhoto) {
		this.songPhoto = songPhoto;
	}

	public String getSingerPhoto() {
		if (singers != null && singers.size() != 0) {
			return singers.get(0).getSingerImageUrl();
		}

		return "";
	}

	public void setSingerPhoto(String singerPhoto) {
		this.singerPhoto = singerPhoto;
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

	public String getMvPath() {
		return mvPath;
	}

	public void setMvPath(String mvPath) {
		this.mvPath = mvPath;
	}

}
