package cn.com.ethank.yunge.app.util;

import java.io.StringReader;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;

import net.sourceforge.simcpux.Constants;
import net.sourceforge.simcpux.MD5;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.xmlpull.v1.XmlPullParser;

import android.util.Log;
import android.util.Xml;
import android.widget.TextView;

import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;

/**
 * call WEIXINpay sdk pay. 调用SDK支付
 * 
 */

public class PayOrderWeiXinUtils {

	PayReq req;
	public IWXAPI msgApi = null;
	TextView show;
	Map<String, String> resultunifiedorder;
	StringBuffer sb;

	public String orderid;
	public String Prepayid;
	public String money;
	public static boolean isFromKTVBox = false;// true表示是从房间下单界面进入，false表示是从餐点酒水支付界面进入

	public PayOrderWeiXinUtils(IWXAPI msgApi, boolean isFromKTVBox, String orderid, String Prepayid, String money) {
		super();
		this.msgApi = msgApi;
		this.orderid = orderid;
		this.Prepayid = Prepayid;
		this.money = money;
		this.isFromKTVBox = isFromKTVBox;

		// 回调的地方使用
		cn.com.ethank.yunge.app.util.Constants.orderId = this.orderid;

		req = new PayReq();
		sb = new StringBuffer();
	}

	public void payOrder() {
		// 生成签名参数
		genPayReq();
	}

	/**
	 * check whether the device has authentication alipay account.
	 * 查询终端设备是否存在支付宝认证账户
	 */

	private void genPayReq() {
		req.appId = Constants.APP_ID;
		req.partnerId = Constants.MCH_ID;
		req.prepayId = Prepayid;
		req.packageValue = "Sign=WXPay";
		req.nonceStr = genNonceStr();
		req.timeStamp = String.valueOf(genTimeStamp());

		// req.transaction = buildTransaction("text"); //
		// transaction字段用于唯一标识一个请求

		List<NameValuePair> signParams = new LinkedList<NameValuePair>();
		signParams.add(new BasicNameValuePair("appid", req.appId));
		signParams.add(new BasicNameValuePair("noncestr", req.nonceStr));
		signParams.add(new BasicNameValuePair("package", req.packageValue));
		signParams.add(new BasicNameValuePair("partnerid", req.partnerId));
		signParams.add(new BasicNameValuePair("prepayid", req.prepayId));
		signParams.add(new BasicNameValuePair("timestamp", req.timeStamp));

		req.sign = genAppSign(signParams);

		boolean isregisterSec = msgApi.registerApp(Constants.APP_ID);
		Log.d("orion", "微信注册:" + isregisterSec);

		// Post给服务器
		boolean isSendSec = msgApi.sendReq(req);
		Log.d("orion", "微信支付:" + isSendSec);

		// sb.append("sign\n" + req.sign + "\n\n");
		// show.setText(sb.toString());
	}

	private String genNonceStr() {
		Random random = new Random();
		return MD5.getMessageDigest(String.valueOf(random.nextInt(10000)).getBytes());
	}

	private long genTimeStamp() {
		return System.currentTimeMillis() / 1000;
	}

	private String genAppSign(List<NameValuePair> params) {
		StringBuilder sb = new StringBuilder();

		for (int i = 0; i < params.size(); i++) {
			sb.append(params.get(i).getName());
			sb.append('=');
			sb.append(params.get(i).getValue());
			sb.append('&');
		}
		sb.append("key=");
		sb.append(Constants.API_KEY);

		this.sb.append("sign str\n" + sb.toString() + "\n\n");
		String appSign = MD5.getMessageDigest(sb.toString().getBytes()).toUpperCase();
		Log.e("orion", appSign);
		return appSign;
	}

	String noncestrid = "";

	public Map<String, String> decodeXml(String content) {

		try {
			Map<String, String> xml = new HashMap<String, String>();
			XmlPullParser parser = Xml.newPullParser();
			parser.setInput(new StringReader(content));
			int event = parser.getEventType();
			while (event != XmlPullParser.END_DOCUMENT) {

				String nodeName = parser.getName();
				switch (event) {
				case XmlPullParser.START_DOCUMENT:
					break;
				case XmlPullParser.START_TAG:
					if ("xml".equals(nodeName) == false) {
						// 实例化student对象
						xml.put(nodeName, parser.nextText());
					}
					break;
				case XmlPullParser.END_TAG:
					break;
				}
				event = parser.next();
			}
			return xml;
		} catch (Exception e) {
			Log.e("orion", e.toString());
		}
		return null;
	}

}
