package cn.com.ethank.yunge.app.jpush;

import java.io.Serializable;

public class JPushBean implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String reserveBoxId;
	private String yunge;// 歌曲操作类型
	private String nextSong;
	private String singing;
	private String singingId;

	public String getReserveBoxId() {
		if (reserveBoxId == null) {
			return "";
		}
		return reserveBoxId;
	}

	public void setReserveBoxId(String reserveBoxId) {
		this.reserveBoxId = reserveBoxId;
	}

	public String getYunge() {
		if (yunge == null) {
			return "";
		}
		return yunge;
	}

	public void setYunge(String yunge) {
		this.yunge = yunge;
	}

	public String getNextSong() {
		if (nextSong == null) {
			return "";
		}
		return nextSong;
	}

	public void setNextSong(String nextSong) {
		this.nextSong = nextSong;
	}

	public String getSinging() {
		if (singing == null) {
			return "";
		}
		return singing;
	}

	public void setSinging(String singing) {
		this.singing = singing;
	}

	public String getSingingId() {
		if (singingId == null) {
			return "";
		}
		return singingId;
	}

	public void setSingingId(String singingId) {
		this.singingId = singingId;
	}

	public YungeJPushType getType() {
		return YungeJPushType.getPushType(getYunge());

	}

	
}
