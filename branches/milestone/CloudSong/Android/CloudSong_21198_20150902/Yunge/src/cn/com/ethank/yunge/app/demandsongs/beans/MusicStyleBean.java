package cn.com.ethank.yunge.app.demandsongs.beans;

import java.io.Serializable;
import java.util.List;

/**
 * 歌曲分类
 * Created by dddd on 2015/4/28.
 */
@SuppressWarnings("serial")
public class MusicStyleBean implements Serializable{
	private int type;
	private String imageSrc;
	private String listTypeName;
	private List<TypeThreeBean> threeSong;

	public int getType() {
		return type;
	}

	public List<TypeThreeBean> getThreeSong() {
		return threeSong;
	}

	public void setThreeSong(List<TypeThreeBean> threeSong) {
		this.threeSong = threeSong;
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
