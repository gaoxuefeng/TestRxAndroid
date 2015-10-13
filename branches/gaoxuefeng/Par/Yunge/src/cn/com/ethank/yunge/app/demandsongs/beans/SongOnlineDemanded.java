package cn.com.ethank.yunge.app.demandsongs.beans;

/**
 * 已点歌曲Bean
 * 
 * @author Gao Xuefeng
 * 
 */
public class SongOnlineDemanded {
	private int roomSongId; // 歌曲编号
	private String userName; // 点歌人名字
	private String headUrl; // 头像
	private SongOnline song;// 歌曲Bean

	public String getUserName() {
		if(userName==null){
			return "未知用户";
		}
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getHeadUrl() {
		if(headUrl==null){
			return "";
		}
		return headUrl;
	}

	public void setHeadUrl(String headUrl) {
		this.headUrl = headUrl;
	}

	public int getRoomSongId() {
		return roomSongId;
	}

	public void setRoomSongId(int roomSongId) {
		this.roomSongId = roomSongId;
	}

	public SongOnline getSong() {
		if (song == null) {
			return new SongOnline();
		}
		return song;
	}

	public void setSong(SongOnline song) {
		this.song = song;
	}

}
