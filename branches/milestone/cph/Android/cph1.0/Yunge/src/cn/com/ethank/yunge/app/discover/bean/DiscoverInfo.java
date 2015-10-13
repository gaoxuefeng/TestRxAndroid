package cn.com.ethank.yunge.app.discover.bean;

public class DiscoverInfo {
	// {"avatarUrl":"http://192.168.1.226/82/7c/cb0eea8a706c4c34a16891f84e7b.png","discoverId":1,
	// "listenCount":12,"musicDuration":2,"musicName":"大海","musicPhotoUrl":"http://192.168.1.226/1.png",
	// "musicUrl":"http://192.168.1.226//yj.mp3","praiseCount":9,"songId":4,"userNickName":"小白"}
	private String avatarUrl;
	private int discoverId;
	private int listenCount;
	private int musicDuration;
	private String musicName;
	private String musicPhotoUrl;
	private String musicUrl;
	private int praiseCount;
	private int songId;
	private String userNickName;
	private String shareUrl;

	public String getAvatarUrl() {
		return avatarUrl;
	}

	public void setAvatarUrl(String avatarUrl) {
		this.avatarUrl = avatarUrl;
	}

	public int getDiscoverId() {
		return discoverId;
	}

	public void setDiscoverId(int discoverId) {
		this.discoverId = discoverId;
	}

	public int getListenCount() {
		return listenCount;
	}

	public void setListenCount(int listenCount) {
		this.listenCount = listenCount;
	}

	public int getMusicDuration() {
		return musicDuration;
	}

	public void setMusicDuration(int musicDuration) {
		this.musicDuration = musicDuration;
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

	public String getMusicUrl() {
		return musicUrl;
	}

	public void setMusicUrl(String musicUrl) {
		this.musicUrl = musicUrl;
	}

	public int getPraiseCount() {
		return praiseCount;
	}

	public void setPraiseCount(int praiseCount) {
		this.praiseCount = praiseCount;
	}

	public int getSongId() {
		return songId;
	}

	public void setSongId(int songId) {
		this.songId = songId;
	}

	public String getUserNickName() {
		return userNickName;
	}

	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
	}

	public String getShareUrl() {
		return shareUrl;
	}

	public void setShareUrl(String shareUrl) {
		this.shareUrl = shareUrl;
	}

}
