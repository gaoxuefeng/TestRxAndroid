package cn.com.ethank.yunge.app.mine.bean;

import java.util.List;

public class RecordInfo {
	private int code;
	private List<Record> data;

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public List<Record> getData() {
		return data;
	}

	public void setData(List<Record> data) {
		this.data = data;
	}

	public class Record {
		private int listenCount;
		private String musicName;
		private String musicPhotoUrl;
		private int praiseCount;

		public int getListenCount() {
			return listenCount;
		}

		public void setListenCount(int listenCount) {
			this.listenCount = listenCount;
		}

		public String getMusicName() {
			return musicName;
		}

		public void setMusicName(String musicName) {
			this.musicName = musicName;
		}

		public String getMusicPhotoUrl() {
			return musicPhotoUrl;
		}

		public void setMusicPhotoUrl(String musicPhotoUrl) {
			this.musicPhotoUrl = musicPhotoUrl;
		}

		public int getPraiseCount() {
			return praiseCount;
		}

		public void setPraiseCount(int praiseCount) {
			this.praiseCount = praiseCount;
		}

	}
}
