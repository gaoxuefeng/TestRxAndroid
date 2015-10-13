package cn.com.ethank.yunge.app.demandsongs.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class SinglerOnLine implements Serializable {
	// "headPhoto": "/1.png",
	// "id": "15598",
	// "name": "李林平",
	// "pinyin": "LLP",
	// "type": 1

	private String singerImageUrl;
	private int singerId;
	private String singerName;

	public String getSingerImageUrl() {
		if (singerImageUrl == null) {
			return "";
		}
		return singerImageUrl;
	}

	public void setSingerImageUrl(String headPhoto) {
		this.singerImageUrl = headPhoto;
	}

	public int getSingerId() {
		return singerId;
	}

	public void setSingerId(int id) {
		this.singerId = id;
	}

	public String getSingerName() {
		if (singerName == null) {
			return "";
		}
		return singerName;
	}

	public void setSingerName(String name) {
		this.singerName = name;
	}

}
