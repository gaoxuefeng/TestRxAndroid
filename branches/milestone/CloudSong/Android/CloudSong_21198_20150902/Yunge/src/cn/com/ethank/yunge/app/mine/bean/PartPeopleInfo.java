package cn.com.ethank.yunge.app.mine.bean;

import java.util.List;

public class PartPeopleInfo {
	private int code;
	private List<People> data;

	public class People {
		private Long joinTimeStamp;
		private Long serverTimeStamp;
		private String userGender;
		private String userIcon;
		private String userName;
		private String userPhoneNum;

		public Long getJoinTimeStamp() {
			return joinTimeStamp;
		}

		public void setJoinTimeStamp(Long joinTimeStamp) {
			this.joinTimeStamp = joinTimeStamp;
		}

		public Long getServerTimeStamp() {
			return serverTimeStamp;
		}

		public void setServerTimeStamp(Long serverTimeStamp) {
			this.serverTimeStamp = serverTimeStamp;
		}

		public String getUserGender() {
			return userGender;
		}

		public void setUserGender(String userGender) {
			this.userGender = userGender;
		}

		public String getUserIcon() {
			return userIcon;
		}

		public void setUserIcon(String userIcon) {
			this.userIcon = userIcon;
		}

		public String getUserName() {
			return userName;
		}

		public void setUserName(String userName) {
			this.userName = userName;
		}

		public String getUserPhoneNum() {
			return userPhoneNum;
		}

		public void setUserPhoneNum(String userPhoneNum) {
			this.userPhoneNum = userPhoneNum;
		}

	}

	private String message;

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public List<People> getData() {
		return data;
	}

	public void setData(List<People> data) {
		this.data = data;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
