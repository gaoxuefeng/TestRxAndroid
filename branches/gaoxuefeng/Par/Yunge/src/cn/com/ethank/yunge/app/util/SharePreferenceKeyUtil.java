package cn.com.ethank.yunge.app.util;

/**
 * 这个类用来存放 SharedPreferences中的key值
 * 
 * @author dddd
 * 
 */
public class SharePreferenceKeyUtil {
	// String类型
	public static final String reserveBoxId = "reserveBoxId";
	public static final String preState = "preState"; // --预定状态
	public static final String token = "token";
	public static final String login_result = "login_result";
	public static final String phoneNum = "phoneNum";
	public static final String orderInfo = "orderInfo";
	public static final String mine = "mine";
	public static final String boxToken = "boxToken";
	public static String boxIp = "boxIp";
	public static final String groupBuy = "groupBuy";
	public static final String orderDetail = "orderDetail";
	public static final String dringorderDetail = "dringorderDetail";
	public static final String showName = "showName";
	public static final String imageUrl = "imageUrl"; // --头像--
	public static final String boxInfo = "boxInfo";// 房间信息
	public static final String preBoxId = "preBoxId"; // 预定房间的id
	public static final String scanBoxId = "scanBoxId"; // 扫码获取房间的id
	public static final String currentCity = "currentCity"; // 扫码获取房间的id
	// Boolean型
	public static final String isBinded = "isBinded";
	public static final String hasUpdate = "hasUpdate";

	// int型
	public static final String playMode = "playMode";
	public static final String boundCode = "boundCode";
	public static final String lastTimeBuildCode = "lastTimeBuildCode";// 保存当前板板信息,用来第一次启动的时候比较appCode
	// 保存点歌历史List,这个后面加reserveBoxId
	public static final String demandedList = "boundCode";
}
