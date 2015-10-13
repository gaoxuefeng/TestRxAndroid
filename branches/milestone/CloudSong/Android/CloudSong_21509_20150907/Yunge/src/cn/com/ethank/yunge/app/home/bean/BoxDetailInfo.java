package cn.com.ethank.yunge.app.home.bean;

import cn.com.ethank.yunge.app.room.bean.BoxDetail;

public class BoxDetailInfo {
	private int code;
	private BoxDetail data;

	public BoxDetail getData() {
		/*if (data == null) {
			return new BoxDetail();
		}*/
		return data;
	}

	public void setData(BoxDetail data) {
		this.data = data;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

}
