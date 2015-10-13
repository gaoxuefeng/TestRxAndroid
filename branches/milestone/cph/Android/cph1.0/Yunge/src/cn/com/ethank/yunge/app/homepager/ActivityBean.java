package cn.com.ethank.yunge.app.homepager;

import java.io.Serializable;

public class ActivityBean implements Serializable {
	private String activityId;
	private String activityImageUrl;
	private String activityPraiseCount;
	private String activityTag;
	private String activityTheme;
	private String activityTime;
	private String cityName;
	private String companyImageUrl;
	private String htmlUrl;

	public String getHtmlUrl() {
		if (htmlUrl == null || htmlUrl.isEmpty()) {

			htmlUrl = "http://www.baidu.com";
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
