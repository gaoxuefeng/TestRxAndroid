package cn.com.ethank.yunge.app.home.bean;

import java.util.ArrayList;
import java.util.List;

public class CityCircleBean {
	private String district;
	private ArrayList<String> circleName;

	public String getDistrict() {
		if (district == null) {
			return "";
		}
		return district;
	}

	public void setDistrict(String district) {
		if (district != null && circleName != null && !circleName.contains("全城") && !circleName.contains("全县") && !circleName.contains("全区")
				&& !district.isEmpty()) {
			String firstCircleName = "";
			if (getDistrict().endsWith("县")) {
				firstCircleName = "全县";
			} else {
				firstCircleName = "全区";
			}
			circleName.add(0, firstCircleName);
		}
		this.district = district;
	}

	public List<String> getCircleName() {
		if (circleName == null) {
			return new ArrayList<String>();
		}
		return circleName;
	}

	public void setCircleName(ArrayList<String> circleName) {
		String firstCircleName = "";
		if (circleName != null && !circleName.contains("全城") && !circleName.contains("全县") && !circleName.contains("全区") && !getDistrict().isEmpty()) {
			if (getDistrict().endsWith("区")) {
				firstCircleName = "全区";
			} else if (getDistrict().endsWith("县")) {
				firstCircleName = "全县";
			}
			circleName.add(0, firstCircleName);
		}

		this.circleName = circleName;
	}
}
