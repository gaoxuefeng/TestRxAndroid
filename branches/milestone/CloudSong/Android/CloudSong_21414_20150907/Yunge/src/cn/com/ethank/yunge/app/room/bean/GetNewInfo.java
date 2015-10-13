package cn.com.ethank.yunge.app.room.bean;

import java.util.List;

public class GetNewInfo {
	private int code;
	private List<New> data;
	
	public class New{
		private String headUrl;
		private String msgContent;
		private int msgId;
		private int msgType;
		private String userName;
		public String getHeadUrl() {
			return headUrl;
		}
		public void setHeadUrl(String headUrl) {
			this.headUrl = headUrl;
		}
		public String getMsgContent() {
			return msgContent;
		}
		public void setMsgContent(String msgContent) {
			this.msgContent = msgContent;
		}
		public int getMsgId() {
			return msgId;
		}
		public void setMsgId(int msgId) {
			this.msgId = msgId;
		}
		public int getMsgType() {
			return msgType;
		}
		public void setMsgType(int msgType) {
			this.msgType = msgType;
		}
		public String getUserName() {
			return userName;
		}
		public void setUserName(String userName) {
			this.userName = userName;
		}
		
		
	}
	private String message;
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	
	public List<New> getData() {
		return data;
	}
	public void setData(List<New> data) {
		this.data = data;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
}
