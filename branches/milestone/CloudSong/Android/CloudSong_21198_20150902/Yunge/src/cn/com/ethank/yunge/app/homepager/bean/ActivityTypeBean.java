package cn.com.ethank.yunge.app.homepager.bean;

import java.io.Serializable;

@SuppressWarnings("serial")
public class ActivityTypeBean implements Serializable {
	private String iconPath;
	private String name;
	private String requestUrl;
	private String activityType;

	public String getIconPath() {
		if (iconPath == null) {
			return "";
		}
		return iconPath;
	}

	public void setIconPath(String iconPath) {
		this.iconPath = iconPath;
	}

	public String getName() {
		if (name == null) {
			return "活动";
		}
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getRequestUrl() {
		if (requestUrl == null) {
			return "";
		}
		return requestUrl;
	}

	public void setRequestUrl(String requestUrl) {
		this.requestUrl = requestUrl;
	}

	public String getActivityType() {
		return activityType;
	}

	public void setActivityType(String activityType) {
		this.activityType = activityType;
	}

}
