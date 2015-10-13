package cn.com.ethank.yunge.app.manoeuvre;

import java.io.Serializable;

import cn.com.ethank.yunge.R;

public class ShareBean implements Serializable {
	private String shareTitle;
	private String shareContent;
	private String shareUrl;
	private int shareImageResource;

	
	public String getShareTitle() {
		if (shareTitle == null) {
			return "";
		}
		return shareTitle;
	}

	public void setShareTitle(String shareTitle) {

		this.shareTitle = shareTitle;
	}

	public String getShareContent() {

		//shareContent = "小伙伴们，赶紧来参加@潮趴汇发起的“" + getShareTitle() + "”活动吧！Fashional Party， 你还在等什么，再不来你就OUT啦";
		return shareContent;
	}

	public void setShareContent(String shareContent) {
		this.shareContent = shareContent;
	}

	public String getShareUrl() {
		if (shareUrl == null) {
			return "";
		}
		return shareUrl;
	}

	public void setShareUrl(String shareUrl) {
		this.shareUrl = shareUrl;
	}

	public int getShareImageResource() {
		if (shareImageResource == 0) {
			return R.drawable.ic_launch;
		}
		return shareImageResource;
	}

	public void setShareImageResource(int shareImageResource) {
		this.shareImageResource = shareImageResource;
	}

}
