package cn.com.ethank.yunge.app.catering.bean;

import java.io.Serializable;

public class TypeContentItem implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// 每个条目的具体属性
	private TypeContentInfoItem infoitem;

	// 每个条目在缓存中的具体标记
	private int position;

	// 每个条目添加的数量
	private int addNum;

	public TypeContentInfoItem getInfoitem() {
		return infoitem;
	}

	public void setInfoitem(TypeContentInfoItem infoitem) {
		this.infoitem = infoitem;
	}

	public int getPosition() {
		return position;
	}

	public void setPosition(int position) {
		this.position = position;
	}

	public int getAddNum() {
		return addNum;
	}

	public void setAddNum(int addNum) {
		this.addNum = addNum;
	}

}
