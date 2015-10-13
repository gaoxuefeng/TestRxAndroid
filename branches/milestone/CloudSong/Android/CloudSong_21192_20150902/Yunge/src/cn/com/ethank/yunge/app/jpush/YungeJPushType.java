package cn.com.ethank.yunge.app.jpush;

public enum YungeJPushType {

	// 房间动态,开房,切歌,清理房间
	roomDynamic, roomOpen, changeSong, clearRoom, addSong, otherType;
	private final static String roomDynamicAction = "cn.com.ethank.yunge.ROOMDYNAMIC_ACTION";
	private final static String roomOpenAction = "cn.com.ethank.yunge.ROOMOPEN_ACTION";
	private final static String changeSongAction = "cn.com.ethank.yunge.ROOMCHANGESONG_ACTION";
	private final static String clearRoomAction = "cn.com.ethank.yunge.ROOMCLEAR_ACTION";
	private final static String addSongAction = "cn.com.ethank.yunge.ROOMADDSONG_ACTION";

	public static YungeJPushType getPushType(String yunge) {

		if (yunge.equals("roomDynamic")) {
			return roomDynamic;
		} else if (yunge.equals("roomOpen")) {
			return roomOpen;
		} else if (yunge.equals("changeSong")) {
			return changeSong;
		} else if (yunge.equals("clearRoom")) {
			return clearRoom;
		} else if (yunge.equals("addSong")) {
			return addSong;
		} else if (yunge.equals("otherType")) {
			return otherType;
		}
		return otherType;

	}

	/**
	 * 获取响应jpush类型的Action
	 * 
	 * @param jPushType
	 */
	public static String getAction(YungeJPushType jPushType) {
		switch (jPushType) {
		case roomDynamic:
			return roomDynamicAction;
		case roomOpen:
			return roomOpenAction;
		case changeSong:

			return changeSongAction;
		case clearRoom:
			return clearRoomAction;
		case addSong:
			return addSongAction;
		case otherType:
			return "";

		}
		return "";

	}
}