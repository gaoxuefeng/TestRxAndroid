package cn.com.ethank.yunge.app.mine.bean;

public class UserInfo {
	private int code;
	private String message;
	private Data data;

	// "code":0,
	// "data":{"myrooms":[], "token":"2a80ac0608bdaf846e8662b6d7f37c27",
	// "userInfo":{"gender":"男","nickName":"lvhh","phoneNum":"13810273833"} }
	public Data getData() {
		return data;
	}

	public void setData(Data data) {
		this.data = data;
	}

	public class Data {
		private String token;
		private User userInfo;
		private String myrooms;

		public void setMyrooms(String myrooms) {
			this.myrooms = myrooms;
		}

		public String getMyrooms() {
			return myrooms;
		}

		public String getToken() {
			return token;
		}

		public void setToken(String token) {
			this.token = token;
		}

		public User getUserInfo() {
			return userInfo;
		}

		public void setUserInfo(User userInfo) {
			this.userInfo = userInfo;
		}

		public class User {

			// "userInfo":{"gender":"男","nickName":"lvhh","phoneNum":"13810273833"}
			private String nickName;
			private String email;
			private String phoneNum;
			private String userid;
			private String username;

			private String gender;
			private String weiboId;
			private String wechatId;
			private String headUrl;
			private int age;
			private String bloodType;
			private String constellation;
			private String loveSingers;
			private String whatIsUp;
			private String loveSongs;

			public String getLoveSongs() {
				if (loveSingers == null) {
					return "";
				}
				return loveSongs;
			}

			public void setLoveSongs(String loveSongs) {
				this.loveSongs = loveSongs;
			}

			public String getWhatIsUp() {
				if (whatIsUp == null) {
					return "";
				}
				return whatIsUp;
			}

			public void setWhatIsUp(String whatIsUp) {
				this.whatIsUp = whatIsUp;
			}

			public int getAge() {
				return age;
			}

			public void setAge(int age) {
				this.age = age;
			}

			public String getBloodType() {
				if (bloodType == null) {
					return "";
				}
				return bloodType;
			}

			public void setBloodType(String bloodType) {
				this.bloodType = bloodType;
			}

			public String getConstellation() {
				if (constellation == null) {
					return "";
				}
				return constellation;
			}

			public void setConstellation(String constellation) {
				this.constellation = constellation;
			}

			public String getLoveSingers() {
				if (loveSingers == null) {
					return "";
				}
				return loveSingers;
			}

			public void setLoveSingers(String loveSingers) {
				this.loveSingers = loveSingers;
			}

			public String getWechatId() {
				if (wechatId == null) {
					return "";
				}
				return wechatId;
			}

			public void setWechatId(String wechatId) {
				this.wechatId = wechatId;
			}

			public String getWeiboId() {
				if (weiboId == null) {
					return "";
				}
				return weiboId;
			}

			public void setWeiboId(String weiboId) {
				this.weiboId = weiboId;
			}

			public String getHeadUrl() {
				if (headUrl == null) {
					return "";
				}
				return headUrl;
			}

			public void setHeadUrl(String headUrl) {
				this.headUrl = headUrl;
			}

			public String getGender() {
				if (gender == null) {
					return "";
				}
				return gender;
			}

			public void setGender(String gender) {
				this.gender = gender;
			}

			public String getEmail() {
				if (email == null) {
					return "";
				}
				return email;
			}

			public void setEmail(String email) {
				this.email = email;
			}

			public String getNickName() {
				if (nickName == null) {
					return "";
				}
				return nickName;
			}

			public void setNickName(String nickName) {
				this.nickName = nickName;
			}

			public String getPhoneNum() {
				if (phoneNum == null) {
					return "";
				}
				return phoneNum;
			}

			public void setPhoneNum(String phoneNum) {
				this.phoneNum = phoneNum;
			}

			public String getUserid() {
				if (userid == null) {
					return "";
				}
				return userid;
			}

			public void setUserid(String userid) {
				this.userid = userid;
			}

			public String getUsername() {
				if (username == null) {
					return "";
				}
				return username;
			}

			public void setUsername(String username) {
				this.username = username;
			}
		}
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		if (message == null) {
			return "";
		}
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
