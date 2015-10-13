package cn.com.ethank.yunge.app.mine.bean;

import java.util.List;

public class SongInfo {
	private int code;
	private String message;
	private List<Song> data;

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public List<Song> getData() {
		return data;
	}

	public void setData(List<Song> data) {
		this.data = data;
	}

	public class Song {
		private String songIcon;
		private String songName;
		private String language;
		private String author;

		public String getSongIcon() {
			return songIcon;
		}

		public void setSongIcon(String songIcon) {
			this.songIcon = songIcon;
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

		public String getAuthor() {
			return author;
		}

		public void setAuthor(String author) {
			this.author = author;
		}

	}
}
