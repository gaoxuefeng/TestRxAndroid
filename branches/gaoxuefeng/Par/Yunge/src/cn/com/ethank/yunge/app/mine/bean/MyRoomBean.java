package cn.com.ethank.yunge.app.mine.bean;

import java.util.ArrayList;
import java.util.List;

import cn.com.ethank.yunge.app.room.bean.BoxDetail;

public class MyRoomBean {
	int code;
	List<BoxDetail> data=new ArrayList<BoxDetail>();
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public List<BoxDetail> getData() {
		return data;
	}
	public void setData(List<BoxDetail> data) {
		this.data = data;
	}
	
}
