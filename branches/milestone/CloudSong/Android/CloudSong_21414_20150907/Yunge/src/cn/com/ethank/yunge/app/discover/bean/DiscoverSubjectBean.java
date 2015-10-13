package cn.com.ethank.yunge.app.discover.bean;

import java.io.Serializable;

public class DiscoverSubjectBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int listenCount;
	private String period;// 第几期
	private int praiseCount;
	private String specialId;// 专题ID
	private String specialImgPath;// 图片路径
	private String specialName;// 专题名字

	public int getListenCount() {
		return listenCount;
	}

	public void setListenCount(int listenCount) {
		this.listenCount = listenCount;
	}

	public String getPeriod() {
		if (period == null) {
			return "";
		}
		return period;
	}

	public void setPeriod(String period) {
		this.period = period;
	}

	public int getPraiseCount() {
		return praiseCount;
	}

	public void setPraiseCount(int praiseCount) {
		this.praiseCount = praiseCount;
	}

	public String getSpecialId() {
		if (specialId == null) {
			return "";
		}
		return specialId;
	}

	public void setSpecialId(String specialId) {
		this.specialId = specialId;
	}

	public String getSpecialImgPath() {
		if (specialImgPath == null) {
			return "";
		}
		return specialImgPath;
	}

	public void setSpecialImgPath(String specialImgPath) {
		this.specialImgPath = specialImgPath;
	}

	public String getSpecialName() {
		if (specialName == null) {
			return "";
		}
		return specialName;
	}

	public String getTitlelName() {
		if (!getSpecialName().isEmpty() && !getPeriod().isEmpty()) {
			return getSpecialName() + "-" + getPeriod();
		} else if (!getSpecialName().isEmpty()) {
			return getSpecialName();
		} else {
			return "发现专题";
		}

	}

	public void setSpecialName(String specialName) {
		this.specialName = specialName;
	}

}
