package cn.com.ethank.yunge.pad.bean;

import java.io.Serializable;

/**
 * Created by dddd on 2015/4/28.
 */
public class MusicStyleBean implements Serializable {
	private int type;
	private String imageSrc;
	private String listTypeName;

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getImageSrc() {
		if (imageSrc == null) {
			return "";
		}
		return imageSrc;
	}

	public void setImageSrc(String imageSrc) {
		this.imageSrc = imageSrc;
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
