package cn.com.ethank.yunge.app.homepager.bean;

import java.io.Serializable;

import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.VerifyStringType;

import android.R.color;

public class ActivityBean implements Serializable {

	// [{"activityIcon"
	// +"":"http://image.ethank.com.cn/d4/46/a2a0837bdbfadbf71d176cb426e8.png",
	// "activityId":2,
	// "activityImageUrl":"http://image.ethank.com.cn/2f/84/49fb06c3b543838e31d42f559cdd.png",
	// "activityPraiseCount":10000,
	// "activityTag":"主题",
	// "activityTheme":"幸运大抽奖",
	// "activityTime":"2015年8月27日",
	// "address":"幸运大抽奖活动",
	// "cityName":"全国",
	// "colorCode":"19b7b5",
	// "companyImageUrl":"http://image.ethank.com.cn/null","" +
	// "distance":0,
	// "htmlUrl":"http://testyunge.ethank.com.cn/ethank-yunge-deploy/luckydraw/html/luckdraw.html",
	// "kTVName":" ",
	// "lat":"",
	// "lng":"",
	// "shareTitle":"小伙伴们，赶紧来参加@潮趴汇发起的“欢乐大抽奖”活动吧，"
	// +"Fashional Party， 你还在等什么，再不来你就OUT啦！",
	// "shareUrl":"http://yunge.ethank.com.cn/ethank-yunge-deploy/luckydraw/html/share.html"
	// "typeImageUrl":"http://image.ethank.com.cn/cb/b5/c72e55d52134ce1ce44d7054a663.png"
	// "uidpass":1},

	private String activityIcon;
	private String activityId;
	private String colorCode;// 标签背景颜色值
	private String activityImageUrl;
	private String activityPraiseCount;
	private String activityTag;
	private String activityTheme;
	private String activityTime;
	private String cityName;
	private String companyImageUrl;
	private String htmlUrl;
	private String kTVName;
	private String typeImageUrl;
	private long distance;
	private int uidpass;// 0没有Token,1有token

	private String shareTitle;
	private String shareUrl;

	public String getShareTitle() {
		return shareTitle;
	}

	public void setShareTitle(String shareTitle) {
		this.shareTitle = shareTitle;
	}

	public String getShareUrl() {
		return shareUrl;
	}

	public void setShareUrl(String shareUrl) {
		this.shareUrl = shareUrl;
	}

	public String getActivityIcon() {
		return activityIcon;
	}

	public void setActivityIcon(String activityIcon) {
		this.activityIcon = activityIcon;
	}

	public void setKTVName(String kTVName) {
		this.kTVName = kTVName;
	}

	public String getKTVName() {
		return kTVName;
	}

	public int getUidpass() {
		return uidpass;
	}

	public void setUidpass(int uidpass) {
		this.uidpass = uidpass;
	}

	public long getDistance() {
		return distance;
	}

	public void setDistance(long distance) {
		this.distance = distance;
	}

	public String getTypeImageUrl() {
		if (typeImageUrl == null) {
			return "";
		}
		return typeImageUrl;
	}

	public void setTypeImageUrl(String typeImageUrl) {
		this.typeImageUrl = typeImageUrl;
	}

	// 新加
	private String address;

	public String getColorCode() {
		if (colorCode == null || colorCode.length() != 6) {
			colorCode = "804DA8";
		}
		return "#" + colorCode;
	}

	public void setColorCode(String colorCode) {
		this.colorCode = colorCode;
	}

	public String getAddress() {
		if (address == null) {
			return "";
		}
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getHtmlUrl() {
		if (htmlUrl == null || htmlUrl.isEmpty()) {

			return "";
		}
		if (!htmlUrl.contains("http://")) {
			htmlUrl = "http://" + htmlUrl;
		}
		return htmlUrl;
	}

	public void setHtmlUrl(String htmlUrl) {
		this.htmlUrl = htmlUrl;
	}

	private int bgTag = 0;

	public int getBgTag() {
		return bgTag;
	}

	public void setBgTag(int bgTag) {
		this.bgTag = bgTag;
	}

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	public String getActivityImageUrl() {
		if (activityImageUrl == null) {
			return "";
		}
		return activityImageUrl;
	}

	public void setActivityImageUrl(String activityImageUrl) {

		this.activityImageUrl = activityImageUrl;
	}

	// 临时的
	public void setImageUrl(String imageUrl) {
		if (imageUrl != null) {
			this.activityImageUrl = imageUrl;
		}

	}

	public String getActivityPraiseCount() {
		if (activityPraiseCount == null) {
			return "0";
		}
		return activityPraiseCount;
	}

	public void setActivityPraiseCount(String activityPraiseCount) {
		this.activityPraiseCount = activityPraiseCount;
	}

	public String getActivityTag() {
		if (activityTag == null) {
			return "";
		}
		return activityTag;
	}

	public void setActivityTag(String activityTag) {
		this.activityTag = activityTag;
	}

	public String getActivityTheme() {
		if (activityTheme == null) {
			return "";
		}
		return activityTheme;
	}

	public void setActivityTheme(String activityTheme) {
		this.activityTheme = activityTheme;
	}

	// 临时的,以后会去掉
	public void setTheme(String theme) {
		if (theme != null && !theme.isEmpty()) {
			this.activityTheme = theme;
		}

	}

	public String getActivityTime() {
		if (activityTime == null) {
			return "";
		}
		return activityTime;
	}

	public void setActivityTime(String activityTime) {
		this.activityTime = activityTime;
	}

	public String getCityName() {
		if (cityName == null || cityName.isEmpty()) {
			return "全国";
		}
		return cityName;
	}

	public String getShowCityName() {
		if (cityName == null || cityName.isEmpty()) {
			return "全国";
		}
		if (Constants.locationCity != null && cityName.equals(Constants.locationCity)) {
			if (getDistance() != 0 && getDistance() <= 5000) {
				return "附近";
			}
		}
		return cityName;
	}

	public void setCityName(String cityName) {
		this.cityName = cityName;
	}

	public String getCompanyImageUrl() {
		if (companyImageUrl == null) {
			return "";
		}
		return companyImageUrl;
	}

	public void setCompanyImageUrl(String companyImageUrl) {
		this.companyImageUrl = companyImageUrl;
	}

}
