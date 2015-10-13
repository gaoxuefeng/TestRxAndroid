package cn.com.ethank.yunge.app.homepager.bean;

import java.io.Serializable;

public class AutoPlayPhotos implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String htmlUrl;
	private String id;
	private String imageUrl;
	private int uidpass;

	private String shareTitle;
	private String shareUrl;

	public String getShareTitle() {
		return shareTitle;
	}

	public void setShareTitle(String shareTitle) {
		this.shareTitle = shareTitle;
	}

	public String getShareUrl() {
		return shareUrl;
	}

	public void setShareUrl(String shareUrl) {
		this.shareUrl = shareUrl;
	}

	public int getUidpass() {
		return uidpass;
	}

	public void setUidpass(int uidpass) {
		this.uidpass = uidpass;
	}

	public String getHtmlUrl() {
		if (htmlUrl == null) {
			return "";
		}
		return htmlUrl;
	}

	public void setHtmlUrl(String htmlUrl) {
		this.htmlUrl = htmlUrl;
	}

	public String getId() {
		if (id == null) {
			return "0";
		}
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getImageUrl() {
		if (imageUrl == null) {
			return "";
		}
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

}
