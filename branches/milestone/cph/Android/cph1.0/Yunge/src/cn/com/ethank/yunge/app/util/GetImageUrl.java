package cn.com.ethank.yunge.app.util;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

public class GetImageUrl {
	// private static String[] imgSites = { "http://image.baidu.com/",
	// "http://www.22mm.cc/", "http://www.moko.cc/",
	// "http://eladies.sina.com.cn/photo/", "http://www.youzi4.com/" };
	static List<String> picList = new ArrayList<String>();
	private static ArrayList<String> pics;

	public static List<String> reqImgList() {
		// for (String url : imgSites) {
		// loadImgList(url);
		// }
		loadImgList("http://image.baidu.com/i?ct=201326592&cl=2&lm=-1&nc=1&ie=utf-8&tn=baiduimage&ipn=r&ps=1&pv=&fm=rs2&word=华语女歌手&ofr=女歌手");
		return picList;
	}

	private static void loadImgList(String url) {
		new HttpUtils().send(HttpRequest.HttpMethod.GET, url, new RequestCallBack<String>() {
			@Override
			public void onSuccess(ResponseInfo<String> responseInfo) {
				picList.addAll(getImgSrcList(responseInfo.result));

			}

			@Override
			public void onFailure(HttpException error, String msg) {

			}
		});
	}

	/**
	 * 得到网页中图片的地址
	 */
	private static List<String> getImgSrcList(String htmlStr) {
		if (pics == null || pics.size() == 0) {
			pics = new ArrayList<String>();
		} else {
			return pics;
		}

		String regEx_img = "<img.*?src=\"http://(.*?).jpg\""; // 图片链接地址
		Pattern p_image = Pattern.compile(regEx_img, Pattern.CASE_INSENSITIVE);
		Matcher m_image = p_image.matcher(htmlStr);
		while (m_image.find()) {
			String src = m_image.group(1);
			if (src.length() < 100) {
				if (!pics.contains("http://" + src + ".jpg")) {
					pics.add("http://" + src + ".jpg");
				}

			}
		}
		return pics;
	}

}
