package cn.com.ethank.yunge.pad.bean.mainthemebean;

import java.io.Serializable;

@SuppressWarnings("serial")
public class ThemeChildBean implements Serializable {
	// id string
	// imageUrl string
	// name
	private String themeId;
	private String imageUrl;
	private String listTypeName;

	public String getThemeId() {
		if (themeId == null) {
			return "";
		}
		return themeId;
	}

	public void setThemeId(String type) {
		this.themeId = type;
	}

	public String getImageUrl() {
		if (imageUrl == null) {
			return "";
		}
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getListTypeName() {
		if (listTypeName == null) {
			return "";
		}
		return listTypeName;
	}

	public void setListTypeName(String listTypeName) {
		this.listTypeName = listTypeName;
	}
}
