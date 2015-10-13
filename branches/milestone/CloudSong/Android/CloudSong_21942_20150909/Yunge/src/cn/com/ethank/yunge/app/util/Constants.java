package cn.com.ethank.yunge.app.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.startup.BaseApplication;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.coyotelib.app.ui.util.UICommonUtil;

/**
 * Created by dddd on 2015/5/8.
 */
public class Constants {
	public static double latitude = 0;
	public static double longitude = 0;
	public static ActivityBean activityBeanitem = null;
	public static final String NEXT_SONG_UPDATE_RECEIVE = "nextsongupdate";
	public static final String DESCRIPTOR = "com.umeng.share";
	public static final String MESSAGE_RECEIVED_ACTION = "cn.com.ethank.yunge.MESSAGE_RECEIVED_ACTION";
	public static final String UNBIND_RECEIVED_ACTION = "cn.com.ethank.yunge.UNBIND_RECEIVED_ACTION";// 解绑房间广播
	public static final String EXITROOM_RECEIVED_ACTION = "cn.com.ethank.yunge.EXITROOM_RECEIVED_ACTION";// 退出房间关闭所有房间
	// 已点未唱
	public static final String CHANGE_VIEWPAGERPOSITION = "cn.com.ethank.yunge.CHANGE_MAINTAB_VIEWPAGER_POSITION";// 切换首页
																													// tab
	public static final String UNSINGED_SONG_RECEIVED_ACTION = "cn.com.ethank.yunge.CHANGE_UNSINGED_SONG_ACTION";// 歌曲已点未唱改变广播
	public static final String BIND_RECEIVED_ACTION = "cn.com.ethank.yunge.BIND_RECEIVED_ACTION";// 绑定房间广播
	public static final String KEY_TITLE = "title";
	public static final String KEY_MESSAGE = "message";
	public static final String KEY_EXTRAS = "extras";
	public static final String SINGER_ACTION = "singer";
	private static boolean clickAble = true;
	public static final String REQUEST_NEWSONG_HOTSONG_LIST = "search/button/newsong.json";// 新歌热榜//
	public static final String REQUEST_TOP_6_SINGER_LIST = "search/singer/recommend.json";// 获取歌手列表前6个歌手
	public static final String REQUEST_LANGUAGE_SONG_LIST = "search/song/language.json";// 根据语言获取歌曲列表
	public static final String REQUEST_ACTIVITY_BY_TYPE_LIST = "activity/get.json";// 根据type获取活动列表全国,精品

	public static final int LOGIN_REQUEST_CODE_TOMAIN = 100; // 返回到指定的页面
	public static final int LOGIN_REQUEST_CODE_RETURN = 101;// 返回到原来页面
	/**
	 * 微信分享账号
	 */
	public static final String wxAppId = "wx0975dfb9e6a3d9f1";// 微信id
	public static final String wxAppSecrxt = "19ea70ea651daa2a0c88a9180a119ef4";// 微信密码
	/**
	 * QQ分享账号
	 */
	public static final String qqAppId = "1104563078";// qqid
	public static final String qqAppSecrxt = "M9mZnpH8RuxYn3uD";// qq密码
	// 支付宝回调地址

	// public static final String ALIPAYUrl =
	// "http://yungepay.ethank.com.cn/ethank-yungepay/yunpay/";
	public static final String ALIPAYUrl = "http://testyungepay.ethank.com.cn/ethank-yungepay/yunpay/";

	// public static final String hostUrlCloud =
	// "http://yunge.ethank.com.cn/ethank-yunge-deploy/";// 服务器
	public static final String hostUrlCloud = "http://testyunge.ethank.com.cn/ethank-yunge-deploy/";// 服务器
	public static final String querytime = "ktvorder/querytime.json"; // 查询包房
	public static final String genorder = "ktvorder/genorder.json"; // 预定
	public static final String cancelOrder = "ktvorder/cancleOrder.json"; // --预定取消--
	public static final String orderDetail = "orderDetail.json"; // --ktv预定订单详情--
	public static final String ktvorderDetail = "ktvorder/ktvorderDetail.json"; // --ktv预定订单详情--
	public static final String dingkDetail = "goods/goodsorderDetail.json"; // --酒水订单详情--
	public static final String getOrders = "ktvorder/getorders.json"; // 查询订单列表
	public static final String myRecord = "my/record.json"; // --我的录音
	public static final String savePic = "login/savePic.json"; // 上传用户头像
	public static final String myBox = "my/box/get.json"; // --我的房间
	public static final String boxDetail = "my/box/detail.json"; // 获取房间详情
	public static final String myRoom = "my/room/get.json"; // --我的房间
	public static final String THIRD_PARTY_LOGIN = "login/threePart.json"; // 第三方登陆
	public static final String BOUND_PHONE = "login/binding.json"; // 绑定手机
	public static final String GET_PWD = "login/dynamicLogin.json"; // 忘记密码
	public static final String MODIFYPWD = "login/modifypw.json"; // 修改密码
	public static final String QUERYINFO = "login/queryinfo.json"; // 查询用户信息
	public static final String REGISTER = "login/register.json"; // 注册
	public static final String GET_SMS = "Sms/getSms.json"; // 获取验证码
	public static final String PROFILE = "login/profile.json"; // 完善个人资料
	public static final String GENQRCODE = "banding/genQRCode.json"; // --生产二维码，绑定房间
	public static final String GET_CHECK_SMS = "Sms/checkSms.json"; // 检验验证码
	public static final String PHONE_LOGIN = "login/login.json"; // 手机号登陆
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
	public static final String REQUEST_DEMANDED_SONG_HISTORY = "my/song/history/get.json";// 获取点唱历史
	public static final String REQUEST_DEMAND_SONG = "roomsong/addRoomSong.json";// 点歌
	public static final String REQUEST_MOVE_OR_DELETE_SONG = "roomsong/changeRSong.json";// 置顶或删除歌曲operationType
	public static final String REQUEST_CITI_CIRCLE = "ktvorder/getCircle.json";// 根据城市获取商圈
	public static final String REQUEST_ACTIVITY_PRAISE = "activity/praise/add.json";// 活动点赞跟取消点赞
	public static final String REQUEST_ACTIVITY_TAGS = "activity/tag/get.json";// 获取活动标签tag
	public static final String REQUEST_ACTIVITYS_BY_TAGS = "activity/get.json";// 根据活动标签tag获取活动
	public static final String REQUEST_ACTIVITYS_CITYS = "activity/city/get.json";// 获取活动城市列表
	public static final String REQUEST_ACTIVITYS_RECOMMEND = "home/recommend/get.json";// 获取首页推荐活动
	public static final String JOIN_PEOPLE = "my/join/people/get.json"; // --获取参与人
	public static final String REQUEST_HOMEPAGER_PICS = "home/top/image/get.json"; // 获取首页轮播图
	public static final String REQUEST_DISCOVER_PICS = "discovery/querySpecial.json"; // 获取发现专题轮播图
	public static final String REQUEST_NAVIGATION_LIST = "home/navigation/get.json"; // 获取首页横向滑动的活动列表
	// 0:置顶，1：删除
	public static final String REQUEST_UNSINGED_SONG = "roomsong/unsinged.json";// 已点未唱歌曲列表
	public static final String REQUEST_UI_THEME_LIST = "ui/theme.json";// 获取推荐专题列表
	public static final String REQUEST_UI_THEME_SONG_LIST = "search/song/theme.json";// 获取推荐专题列表
	public static final String REQUEST_SONG_TYPE_LIST = "song/songtype.json";// 获取歌曲分类,点击button分类后的动作
	public static final String REQUEST_SONG_LIST_BY_TYPE = "search/song/byType.json";// 根据歌曲分类获取歌曲
	public static final String REQUEST_DISCOVER_LIST_BY_SUBJECT = "discovery/querySpecialList.json";// 根据专题获取发现列表
	// public static final String GETALLCARTINGLIST = getKTVIP() +
	// "goods/getall.json";// 获取所有餐点列表
	public static final String GETWEIXINPREPAYID = hostUrlCloud + "ktvorder/genPreOrder.json";// 生成微信订单号
	// public static final String GETCARTINGORDERID = getKTVIP() +
	// "goods/genorder.json";// 下单接口,对应“餐点酒水”的“立即下单”
	public static final String SEARCH_KTV = "ktvorder/searchktv.json";// 获取首页的KTV列表
	public static final String GETDISCOVERLIST = hostUrlCloud + "discovery/get.json";// 获取发现列表
	public static final String GETMUSICINFO = hostUrlCloud + "discovery/play.json";// 播放界面信息获取地址
	public static final String GETMUSPRAISE = hostUrlCloud + "discovery/praise/add.json";// 播放界面点赞地址

	public static final String ADDINFO = "roomdynamic/add.json"; // 发送房间动态（KTV服务器）
	public static final String GETINFO = "roomdynamic/getnew.json"; // 获取房间动态（ktv服务器）
	public static final String SENDINFO = "feedbackmessage/getinfo.json"; // 意见反馈
	//
	public static List<String> demandedSongIdList = new ArrayList<String>();
	public static List<String> headUrlList = GetImageUrl.reqImgList();
	public static List<String> actitityPraisedList = new ArrayList<String>();
	private static long currentTime;
	public static String orderId;

	public static String getHeadUrl() {

		if (headUrlList == null || headUrlList.size() == 0) {
			headUrlList = imageUrl();
		}
		if (headUrlList != null && headUrlList.size() != 0) {
			Random random = new Random();
			int a = random.nextInt(headUrlList.size() - 1);
			return headUrlList.get(a);
		}
		return null;
	}

	// 超市界面内网请求地址
	public static String getCartingUrl(String ip, boolean isorder) {
		String address = "http://" + ip + "/ethank-KTVCenter-deploy/goods/";
		if (isorder) {
			address += "genorder.json";// 下单接口,对应“餐点酒水”的“立即下单”
		} else {
			address += "getall.json";// 获取所有餐点列表
		}
		return address;
	}

	// 超市界面外网请求地址
	public static String getCartingUrl(boolean isOrder) {
		String address = hostUrlCloud + "goods/";
		if (isOrder) {
			address += "genorder.json";
		} else {
			address += "getall.json";
		}
		return address;
	}

	public static String getKTVIP() {
		if (Constants.getBoxInfo().getKtvIP() != null) {
			return "http://" + Constants.getBoxInfo().getKtvIP() + "/ethank-KTVCenter-deploy/";
		}

		return "";

	}

	public static Boolean isStarting() {

		// if (LoadingActivity.myRooms != null && Constants.getReserveBoxId() !=
		// null) {
		// for (int i = 0; i < LoadingActivity.myRooms.size(); i++) {
		// if
		// (LoadingActivity.myRooms.get(i).getReserveBoxId().equals(Constants.getReserveBoxId()))
		// {
		// BoxDetail myRoom = LoadingActivity.myRooms.get(i);

		return Constants.getBoxInfo().isStarting();

	}

	public static String getBoxContronUrl() {
		if (getBoxIP() == null || getBoxIP().isEmpty()) {
			return "http://" + Constants.getBoxInfo().getBoxIP() + "/controller/";
		} else {
			return "http://" + getBoxIP() + "/controller/";
		}

	}

	public static String getBoxInteractUrl() {
		return "http://" + getBoxIP() + "/interaction/";

	}

	public static String getOrderInfo() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.orderInfo);
	}

	public static String getBoxIP() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.boxIp);

	}

	public static String getPreBoxId() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.preBoxId);
	}

	public static String getScanBoxId() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.scanBoxId);
	}

	public static String getReserveBoxId() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.reserveBoxId);
	}

	public static String getImageUrl() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.imageUrl);
	}

	public static BoxDetail getBoxInfo() {
		try {
			String result = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.boxInfo);
			if (result != null && !result.isEmpty()) {
				return JSON.parseObject(result, BoxDetail.class);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new BoxDetail();

	}

	private static List<String> imageUrl() {
		return GetImageUrl.reqImgList();
	}

	public static String getToken() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.token);
	}

	public static UserInfo getUserInfo() {
		// {"code":0,
		// "data":{"myrooms":[],
		// "token":"2a80ac0608bdaf846e8662b6d7f37c27",
		// "userInfo":{"gender":"男","nickName":"lvhh","phoneNum":"13810273833"}}}
		String result = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result);
		UserInfo userInfo = null;
		if (!TextUtils.isEmpty(result) && ((Object) result) instanceof JSONObject) {
			userInfo = JSON.parseObject(result.toString(), UserInfo.class);
		}
		if (userInfo == null) {
			userInfo = new UserInfo();
		}
		return userInfo;

	}

	public static String getLoginResult() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result);
	}

	public static String getMine() {
		return SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.mine);
	}

	public static boolean getLoginState() {
		if (!getToken().isEmpty()) {
			return true;
		} else {
			return false;
		}

	}

	/**
	 * 是否绑定房间,同时已经验证了登陆状态
	 * 
	 * @return
	 */
	public static boolean isBinded() {
		if (!getLoginState()) {
			return false;
		}
		if (SharePreferencesUtil.getBooleanData(SharePreferenceKeyUtil.isBinded)) {
			return true;
		} else {
			return false;
		}

	}

	public static void setBinded(boolean isBinded) {
		if (!isBinded) {
			// 已经绑定并解绑,发解绑广播
			SharePreferencesUtil.saveBooleanData(SharePreferenceKeyUtil.isBinded, isBinded);
			Intent unBindIntent = new Intent(Constants.UNBIND_RECEIVED_ACTION);
			BaseApplication.getInstance().sendBroadcast(unBindIntent);
		} else if (isBinded) {
			// 未绑定,开始绑定
			SharePreferencesUtil.saveBooleanData(SharePreferenceKeyUtil.isBinded, isBinded);
			Intent bindIntent = new Intent(Constants.BIND_RECEIVED_ACTION);
			BaseApplication.getInstance().sendBroadcast(bindIntent);
		}
	}

	/**
	 * 如果链接房间则用host2; 如果没连则用host1
	 * 
	 * @return
	 */
	// public static String getBetterHost() {
	// if (isBinded()) {
	// return getKTVIP();
	// }
	// return hostUrlCloud;
	//
	// }

	public static void setLayoutSize(View view, int designWidth, int designHeight) {
		if (view.getParent() == null) {
			return;
		}
		LayoutParams layoutParams = view.getLayoutParams();
		int screenWidth = UICommonUtil.getScreenWidthPixels(BaseApplication.getInstance());
		if (designWidth > 0) {
			layoutParams.width = (int) (screenWidth * ((float) designWidth / 640));
		}
		if (designHeight > 0) {
			layoutParams.height = (int) (screenWidth * ((float) designHeight / 640));
		}
		view.setLayoutParams(layoutParams);
	}

	public static void setUnClickAble() {
		Constants.setClickAble(false);
		currentTime = System.currentTimeMillis();
		Constants.handler.sendMessageDelayed(Message.obtain(handler, 0, currentTime), 200);
	}

	// 长时间不能点击
	public static void setLongUnClickAble() {
		Constants.setClickAble(false);
		currentTime = System.currentTimeMillis();
		Constants.handler.sendMessageDelayed(Message.obtain(handler, 0, currentTime), 400);
	}

	public static boolean isClickAble() {
		return clickAble;
	}

	private static void setClickAble(boolean clickAble) {
		Constants.clickAble = clickAble;
	}

	// 商户PID
	public static final String PARTNER = "2088711341640795";
	// 商户收款账号
	public static final String SELLER = "cwb@thankyou99.com";
	// 商户私钥，pkcs8格式
	public static final String RSA_PRIVATE = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAN4vctMoNBN+R5RPlHu6T6s1Q7zQ5jKVAruhlw99o2RMu/HMgLlpJ5sJ21D3jaNwZB/1q+GkS/Gz+y2Fiy2FcemDXM05N5hls6Qz+V2AACS/yJRUGlqTOAHPrbV/432e0JS6CnHe+sZzrBpKjjvBGTm3l9r2/YNU3Lyw0uslsuIvAgMBAAECgYBkCDTIQLeBdz8+1L1jHzSzPl3q6ppZd6EtXMkoHkar56hOauYhk+hS8xMc1veb+AP8J51lD5VpksCpdBB/RC9OPerXm/KOECwUZV71UIZHj806bGYqoxSlAmc5LkTkcaSWr2RbSwwOjsa4ewUBHW9MEBm9j8pTH4oOuBjtBFCjcQJBAPn7a1Z0kl3tGhclzZWzFKrWIkJFKpwskaG70GyAPd+/Ughv8qgvSAzSIX2qBY5vNw9lXgGIbiGrlkHRGjWypksCQQDjiLlwbOdK/10a8MuGdXVd+fl9tSDkbol4XgnidAo6FkXD6ymM5zV/QVRI06gGnsDGcbSy5P91ZgVKCD6GRpUtAkEA9IMmd3coX3T2ayPP1hhHI961vcp3pjC19dOGR0qcuskhTR1q5XTx7ZBvr8HpE2vXGFkXPTqcNpTmMNR95X4rxwJAHjgKaOQN0+gWdX2FilYPQGvytr9Xnv8PQu06YtkGgrByk5Kn8g7DDCOhDgsORdLPx4tSdG/1faIPEcYGh87YAQJANmLPhHC4KGG4rsgjixskAMnvveMsb8TWrpGcwQ4e5+Yvs8e1HpIxM6k8cuR5YCUd2kCWpgy3y/EsadxM5e7tRQ==";

	// 支付宝公钥
	// public static final String RSA_PUBLIC =
	// "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCDkyM7NkZ98R+pOdzCnRSl6nl34AJ2eiq3Z7te Xsdef54jYcLka4b0dJMpPLPTUSzom3hntFiva9Jby9JnVgS+oafFirympVNbsvpH/34hHXnUtlxd g7b6S74MyhDMzA+dV9knUdDkp6/V6VdwN/cMSMWMCKyF/m9mx13VRnV1RwIDAQAB";

	public static final int SDK_PAY_FLAG = 1;

	public static final int SDK_CHECK_FLAG = 2;

	public static final int SIGN_NO_LOGIN = 2;
	static Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			if ((Long) msg.obj == currentTime) {
				setClickAble(true);
			}

		};
	};
	public static String locationCity = "";// 定位城市
}