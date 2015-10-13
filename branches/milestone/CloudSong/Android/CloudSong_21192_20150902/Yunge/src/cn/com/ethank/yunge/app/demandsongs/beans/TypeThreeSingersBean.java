package cn.com.ethank.yunge.app.demandsongs.beans;

import java.io.Serializable;

public class TypeThreeSingersBean implements Serializable {
	private int singerId;
	private String singerImageUrl;
	private String singerName;
	public int getSingerId() {
		return singerId;
	}
	public void setSingerId(int singerId) {
		this.singerId = singerId;
	}
	public String getSingerImageUrl() {
		return singerImageUrl;
	}
	public void setSingerImageUrl(String singerImageUrl) {
		this.singerImageUrl = singerImageUrl;
	}
	public String getSingerName() {
		return singerName;
	}
	public void setSingerName(String singerName) {
		this.singerName = singerName;
	}
	
}
