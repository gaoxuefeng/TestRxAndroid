package cn.com.ethank.yunge.pad.bean;

import java.io.Serializable;

public class LanguageBean implements Serializable {
	private String languageName;
	private String type;

	public String getLanguageName() {
		if (languageName == null) {
			return "";
		}
		return languageName;

	}

	public void setLanguageName(String languageName) {
		this.languageName = languageName;
	}

	public String getType() {
		if (languageName == null) {
			return "";
		}
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

}
