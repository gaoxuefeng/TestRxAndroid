package cn.com.ethank.yunge.app.mine.bean;

import java.util.ArrayList;
import java.util.List;

import cn.com.ethank.yunge.app.room.bean.BoxDetail;

public class RoomUserInfo {
	private String code;
	private String message;

	private Data data;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Data getData() {
		return data;
	}

	public void setData(Data data) {
		this.data = data;
	}

	public class Data {
		private List<BoxDetail> myRooms;
		private UserInfo userInfo;

		public List<BoxDetail> getMyRooms() {
			if (myRooms == null) {
				myRooms = new ArrayList<BoxDetail>();
			}
			return myRooms;
		}

		public void setMyRooms(List<BoxDetail> myRooms) {
			this.myRooms = myRooms;
		}

		public UserInfo getUserInfo() {
			return userInfo;
		}

		public void setUserInfo(UserInfo userInfo) {
			this.userInfo = userInfo;
		}

		public class UserInfo {
			private String age;
			private String bloodType;
			private String constellation;
			private String gender;
			private String headUrl;
			private String nickname;
			private String phoneNum;

			public String getAge() {
				return age;
			}

			public void setAge(String age) {
				this.age = age;
			}

			public String getBloodType() {
				return bloodType;
			}

			public void setBloodType(String bloodType) {
				this.bloodType = bloodType;
			}

			public String getConstellation() {
				return constellation;
			}

			public void setConstellation(String constellation) {
				this.constellation = constellation;
			}

			public String getGender() {
				return gender;
			}

			public void setGender(String gender) {
				this.gender = gender;
			}

			public String getHeadUrl() {
				return headUrl;
			}

			public void setHeadUrl(String headUrl) {
				this.headUrl = headUrl;
			}

			public String getNickname() {
				return nickname;
			}

			public void setNickname(String nickname) {
				this.nickname = nickname;
			}

			public String getPhoneNum() {
				return phoneNum;
			}

			public void setPhoneNum(String phoneNum) {
				this.phoneNum = phoneNum;
			}

		}
	}
}
