package cn.com.ethank.yunge.test;

import java.util.List;

import cn.com.ethank.yunge.app.demandsongs.beans.SinglerOnLine;

public class Singer {
	private long id; // 歌曲编号
	private String name; // 歌曲名
	private List<SinglerOnLine> singers; // 歌手名，可能为多
	private String type; // 类型
	private String songPhoto; // 图片url 可能为null
	private String singerPhoto; // 歌手 url 如果为多个歌手，随机给一个
	private String language; // 语种
	private String mvPath; // mv地址

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
		return songPhoto;
	}

	public void setSongPhoto(String songPhoto) {
		this.songPhoto = songPhoto;
	}

	public String getSingerPhoto() {
		return singerPhoto;
	}

	public void setSingerPhoto(String singerPhoto) {
		this.singerPhoto = singerPhoto;
	}

	public String getLanguage() {
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
