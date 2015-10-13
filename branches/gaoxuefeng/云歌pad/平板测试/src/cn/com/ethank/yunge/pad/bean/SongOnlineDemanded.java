package cn.com.ethank.yunge.pad.bean;


/**
 * 已点歌曲Bean
 * 
 * @author Gao Xuefeng
 * 
 */
public class SongOnlineDemanded {
	private int roomSongId; // 歌曲编号
	private SongOnline song;// 歌曲Bean

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
