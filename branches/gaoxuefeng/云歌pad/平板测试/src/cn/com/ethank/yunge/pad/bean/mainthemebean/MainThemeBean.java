package cn.com.ethank.yunge.pad.bean.mainthemebean;

import java.util.ArrayList;

public class MainThemeBean {
	private int version;
	private ArrayList<ThemeChildBean> theme;

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public ArrayList<ThemeChildBean> getTheme() {
		if (theme == null) {
			return new ArrayList<ThemeChildBean>();
		}
		return theme;
	}

	public void setTheme(ArrayList<ThemeChildBean> theme) {
		this.theme = theme;
	}

}
