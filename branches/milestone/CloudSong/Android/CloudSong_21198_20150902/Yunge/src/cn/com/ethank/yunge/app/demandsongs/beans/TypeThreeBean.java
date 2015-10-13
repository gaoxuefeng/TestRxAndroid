package cn.com.ethank.yunge.app.demandsongs.beans;

import java.io.Serializable;
import java.util.List;

public class TypeThreeBean implements Serializable {
	private List<TypeThreeSingersBean> singers;
	private String songName;
	private String language;
	private int songId;
	public List<TypeThreeSingersBean> getSingers() {
		return singers;
	}
	public void setSingers(List<TypeThreeSingersBean> singers) {
		this.singers = singers;
	}
	public String getSongName() {
		return songName;
	}
	public void setSongName(String songName) {
		this.songName = songName;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public int getSongId() {
		return songId;
	}
	public void setSongId(int songId) {
		this.songId = songId;
	}
	
		
}
