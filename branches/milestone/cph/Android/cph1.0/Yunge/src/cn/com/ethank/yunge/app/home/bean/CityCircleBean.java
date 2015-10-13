package cn.com.ethank.yunge.app.home.bean;

import java.util.ArrayList;
import java.util.List;

public class CityCircleBean {
	private String district;
	private ArrayList<String> circleName;

	public String getDistrict() {
		if(district==null){
			return "";
		}
		return district;
	}

	public void setDistrict(String district) {
		this.district = district;
	}

	public List<String> getCircleName() {
		if(circleName==null){
			return new ArrayList<String>();
		}
		return circleName;
	}

	public void setCircleName(ArrayList<String> circleName) {
		this.circleName = circleName;
	}
}
