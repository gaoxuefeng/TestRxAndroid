package cn.com.ethank.yunge.app.discover.bean;

import java.util.List;

public class MusicBroadInfo {
	private String avatarUrl;// 头像地址
	private List<PraiseAvatarUrl> praiseAvatarUrls;// 赞头像集合
	private int praiseCount;
	private String signature;
	private String songName;
	private String userName;

	public String getAvatarUrl() {
		return avatarUrl;
	}

	public void setAvatarUrl(String avatarUrl) {
		this.avatarUrl = avatarUrl;
	}

	public List<PraiseAvatarUrl> getPraiseAvatarUrls() {
		return praiseAvatarUrls;
	}

	public void setPraiseAvatarUrls(List<PraiseAvatarUrl> praiseAvatarUrls) {
		this.praiseAvatarUrls = praiseAvatarUrls;
	}

	public int getPraiseCount() {
		return praiseCount;
	}

	public void setPraiseCount(int praiseCount) {
		this.praiseCount = praiseCount;
	}

	public String getSignature() {
		return signature;
	}

	public void setSignature(String signature) {
		this.signature = signature;
	}

	public String getSongName() {
		return songName;
	}

	public void setSongName(String songName) {
		this.songName = songName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public class PraiseAvatarUrl {
		String praiseAvatarUrl;

		public String getPraiseAvatarUrl() {
			return praiseAvatarUrl;
		}

		public void setPraiseAvatarUrl(String praiseAvatarUrl) {
			this.praiseAvatarUrl = praiseAvatarUrl;
		}
	}

}
