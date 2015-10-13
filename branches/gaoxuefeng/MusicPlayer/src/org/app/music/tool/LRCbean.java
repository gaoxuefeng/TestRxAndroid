package org.app.music.tool;

/** 歌词实体*/
public class LRCbean {
	private int beginTime = 0;//开始时间

	public int getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(int beginTime) {
		this.beginTime = beginTime;
	}

	public int getLineTime() {
		return lineTime;
	}

	public void setLineTime(int lineTime) {
		this.lineTime = lineTime;
	}

	public String getLrcBody() {
		return lrcBody;
	}

	public void setLrcBody(String lrcBody) {
		this.lrcBody = lrcBody;
	}

	private int lineTime = 0;
	private String lrcBody = null;//歌词实体

}
