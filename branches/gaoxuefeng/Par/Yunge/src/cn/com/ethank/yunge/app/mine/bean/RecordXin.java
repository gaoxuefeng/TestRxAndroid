package cn.com.ethank.yunge.app.mine.bean;

public class RecordXin {
	private int duration;// 时长
	private String musicName;// 音乐名称
	private long recordTime;// 录音时间	
	private String recordUrl;//录音的路径
	public int getDuration() {
		return duration;
	}
	public void setDuration(int duration) {
		this.duration = duration;
	}
	public String getMusicName() {
		return musicName;
	}
	public void setMusicName(String musicName) {
		this.musicName = musicName;
	}
	public long getRecordTime() {
		return recordTime;
	}
	public void setRecordTime(long recordTime) {
		this.recordTime = recordTime;
	}
	public String getRecordUrl() {
		return recordUrl;
	}
	public void setRecordUrl(String recordUrl) {
		this.recordUrl = recordUrl;
	}

	
}
