package cn.com.ethank.yunge.app.demandsongs.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class SingerTypeBean implements Serializable {
	// 显示的名字
	private String singerTypeName;
	// 类型id用来掉接口
	private int singerTypeId;

	public String getSingerTypeName() {
		return singerTypeName;
	}

	public void setSingerTypeName(String singerTypeName) {
		this.singerTypeName = singerTypeName;
	}

	public int getSingerTypeId() {
		return singerTypeId;
	}

	public void setSingerTypeId(int singerTypeId) {
		this.singerTypeId = singerTypeId;
	}
}
