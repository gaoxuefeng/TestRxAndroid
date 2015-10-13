package cn.com.ethank.yunge.pad.utils;

import android.annotation.SuppressLint;

/**
 * Created by dddd on 2015/5/8.
 */
public class Constants {
	public static final String DESCRIPTOR = "com.umeng.share";
	public static final String MESSAGE_RECEIVED_ACTION = "cn.com.ethank.yunge.MESSAGE_RECEIVED_ACTION";
	public static final String KEY_TITLE = "title";
	public static final String KEY_MESSAGE = "message";
	public static final String SINGER_ACTION = "singer";
	public static final String KEY_EXTRAS = "extras";
	public static final String REQUEST_NEWSONG_HOTSONG_LIST = "search/button/newsong.json";// 新歌热榜//
	public static final String REQUEST_TOP_6_SINGER_LIST = "search/singer/recommend.json";// 获取歌手列表前6个歌手
	public static final String REQUEST_LANGUAGE_SONG_LIST = "search/song/language.json";// 根据语言获取歌曲列表

	public static final int LOGIN_REQUEST_CODE_TOMAIN = 100; // 返回到指定的页面
	public static final int LOGIN_REQUEST_CODE_RETURN = 101;// 返回到原来页面
	public static final String hostUrl = "http://192.168.1.226:9000/ethank-KTVCenter-deploy/";
	public static final String THIRD_PARTY_LOGIN = "login/threePart.json";   // 第三方登陆
	public static final String BOUND_PHONE = "login/binding.json";  // 绑定手机
	public static final String REGISTER = "login/register.json";  // 注册
	public static final String GET_SMS = "Sms/getSms.json";  // 获取验证码
	public static final String GET_CHECK_SMS =	"Sms/checkSms.json"; // 检验验证码
	public static final String PHONE_LOGIN = "login/login.json";  // 手机号登陆
	public static final String searchUrl = "search/all";
	public static final String REQUEST_SONG_URL_BY_KEY = "search/song/key.json";
	public static final String REQUEST_SINGER_URL_BY_KEY = "search/singer/key.json";
	public static final String REQUEST_SINGER_URL = "search/singer/all.json";
	public static final String REQUEST_SINGER_BY_TYPE_URL = "search/singer/singerType.json";// 按类型搜索歌手
	public static final String REQUEST_SONG_BY_TYPE_URL = "search/song/type.json";// 按类型搜索歌手
	public static final String REQUEST_SONG_BY_SINGER_ID_URL = "search/song/singer.json";// 按歌手ID搜歌曲
	public static final String REQUEST_SONG_SING_TOGETHER_URL = "search/button/singtogether.json";// 大家都在唱歌曲接口
	public static final String REQUEST_CONNECT_BANDING_URL = "banding/registered.json";// 链接包房
	public static final String REQUEST_DEMANDED_SONG_BY_ROOM_URL = "roomsong/getRoomSong.json";// 获取已点和已唱歌曲
	public static final String REQUEST_DEMAND_SONG = "roomsong/addRoomSong.json";// 点歌
	public static final String REQUEST_MOVE_OR_DELETE_SONG = "roomsong/changeRSong.json";// 置顶或删除歌曲operationType	0:置顶，1：删除
	public static final String REQUEST_UI_THEME_LIST = "ui/theme.json";//获取推荐专题列表
	public static final String REQUEST_UI_THEME_SONG_LIST = "search/song/theme.json";//获取推荐专题列表
	public static final String REQUEST_SONG_TYPE_LIST = "song/songtype.json";// 获取歌曲分类,点击button分类后的动作
	public static final String REQUEST_SONG_LIST_BY_TYPE = "search/song/byType.json";// 根据歌曲分类获取歌曲
	public static final String boxUrl = "http://192.168.1.171:8080/controller/";//请求盒子
	public static final String TWO_DIMENSIONAL_CODE = "http://192.168.1.226:9000/ethank-KTVCenter-deploy/banding/genQRCode.json";//手机点歌二维码界面
	public static String boxIp = "192.168.1.171";//测试接口 
	public static final String GETALLCARTINGLIST = hostUrl + "goods/getall.json";// 获取所有餐点列表
	public static final String GETCARTINGORDERID = hostUrl + "goods/genorder.json";// 下单接口,对应“餐点酒水”的“立即下单”
	public static final String GETPAYTWODIMENSION = hostUrl + "business/genpayqr.json";// 生成支付二维码

	public static String getToken() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token);

	}

	@SuppressLint("NewApi")
	public static boolean getLoginState() {
		if (!getToken().isEmpty()) {
			return true;
		} else {
			return false;
		}

	}
	/**
	 * 如果链接包厢则用host2; 如果没连则用host1
	 * 
	 * @return
	 */
	public static String getBetterHost() {
		if (isBinded()) {
			return hostUrl;
		}
		return hostUrl;

	}

	/**
	 * 是否绑定包厢,同时已经验证了登陆状态
	 * 
	 * @return
	 */
	public static boolean isBinded() {
		if (!getLoginState()) {
			return false;
		}
		if (SharePreferencesUtil.getBooleanData("isBinded")) {
			return true;
		} else {
			return false;
		}

	}

	public static void setBinded(boolean isBinded) {
		SharePreferencesUtil.saveBooleanData("isBinded", isBinded);

	}
}