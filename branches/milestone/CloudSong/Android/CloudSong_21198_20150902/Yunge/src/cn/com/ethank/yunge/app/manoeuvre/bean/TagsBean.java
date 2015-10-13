package cn.com.ethank.yunge.app.manoeuvre.bean;

import java.io.Serializable;

@SuppressWarnings("serial")
public class TagsBean implements Serializable {

	private int tagId;
	private String tagName;

	public int getTagId() {
		return tagId;
	}

	public void setTagId(int tagId) {
		this.tagId = tagId;
	}

	public String getTagName() {
		if (tagName == null || tagName.isEmpty()) {
			return "全部";
		}
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}
}
