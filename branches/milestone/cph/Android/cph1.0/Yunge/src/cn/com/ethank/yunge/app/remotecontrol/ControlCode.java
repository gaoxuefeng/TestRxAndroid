package cn.com.ethank.yunge.app.remotecontrol;

public class ControlCode {
	// 切歌控制
	public static String boxToken = "123";
	public static final String change_song_code = "101";// 切歌
	public static final String accompnaiment_all_code = "102";// 原／伴唱
	public static final String mute_code = "103";// 静音／取消静音
	public static final String accompaniment_minus_code = "105";// 伴奏音-
	public static final String accompaniment_plus_code = "104";// 伴奏音+
	public static final String play_pause_code = "106";// 暂停,播放
	public static final String play_again_code = "107";// 重唱

	// public static final String change_song_code = "107";//继续播放
	/**
	 * 盒子交互类型
	 */
	// 文字
	public static final int INTERACTION_WITH_TEXT = 101;

	// 表情
	public static final int INTERACTION_WITH_EMOJI = 102;

	// 图片
	public static final int INTERACTION_WITH_IMAGE = 103;

	/**
	 * 
	 * @return
	 */
	public static String getBoxToken() {

		return boxToken;

	}

	/**
	 * 
	 * @return
	 */
	public static void setBoxToken(String boxToken) {

		ControlCode.boxToken = boxToken;

	}
}
