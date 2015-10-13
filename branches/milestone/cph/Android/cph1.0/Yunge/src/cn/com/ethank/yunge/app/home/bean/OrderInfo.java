package cn.com.ethank.yunge.app.home.bean;

public class OrderInfo {
	private int code;
	private String message;
	private Order data;

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Order getData() {
		return data;
	}

	public void setData(Order data) {
		this.data = data;
	}

	public class Order {
		private String address;
		private String boxTypeName;
		private String day;
		private String duration;
		private String hour;
		private String nickName;
		private String phoneNum;
		private String price;
		private String reserveBoxId;
		private String roomNum;
		private String shopName;
		private String theme;

		private String serveNowTime;
		private String reserveDayOfWeek;
		private String rbEndTime;
		private String rbStartTime;

		
		private int payState;
		
		public int getPayState() {
			return payState;
		}

		public void setPayState(int payState) {
			this.payState = payState;
		}

		public String getServeNowTime() {
			return serveNowTime;
		}

		public void setServeNowTime(String serveNowTime) {
			if (serveNowTime == null || serveNowTime.equals("null") || serveNowTime.isEmpty()) {
				serveNowTime = "0";
			}
			this.serveNowTime = serveNowTime;
		}

		public String getReserveDayOfWeek() {
			return reserveDayOfWeek;
		}

		public void setReserveDayOfWeek(String reserveDayOfWeek) {
			this.reserveDayOfWeek = reserveDayOfWeek;
		}

		public String getRbEndTime() {
			return rbEndTime;
		}

		public void setRbEndTime(String rbEndTime) {
			if (rbEndTime == null || rbEndTime.equals("null") || rbEndTime.isEmpty()) {
				rbEndTime = "0";
			}
			this.rbEndTime = rbEndTime;
		}

		public String getRbStartTime() {
			return rbStartTime;
		}

		public void setRbStartTime(String rbStartTime) {
			if (rbStartTime == null || rbStartTime.equals("null") || rbStartTime.isEmpty()) {
				rbStartTime = "0";
			}
			this.rbStartTime = rbStartTime;
		}

		public String getAddress() {
			return address;
		}

		public void setAddress(String address) {
			this.address = address;
		}

		public String getBoxTypeName() {
			return boxTypeName;
		}

		public void setBoxTypeName(String boxTypeName) {
			this.boxTypeName = boxTypeName;
		}

		public String getDay() {
			return day;
		}

		public void setDay(String day) {
			this.day = day;
		}

		public String getDuration() {
			return duration;
		}

		public void setDuration(String duration) {
			this.duration = duration;
		}

		public String getHour() {
			return hour;
		}

		public void setHour(String hour) {
			this.hour = hour;
		}

		public String getNickName() {
			return nickName;
		}

		public void setNickName(String nickName) {
			this.nickName = nickName;
		}

		public String getPhoneNum() {
			return phoneNum;
		}

		public void setPhoneNum(String phoneNum) {
			this.phoneNum = phoneNum;
		}

		public String getPrice() {
			return price;
		}

		public void setPrice(String price) {
			this.price = price;
		}

		public String getReserveBoxId() {
			return reserveBoxId;
		}

		public void setReserveBoxId(String reserveBoxId) {
			this.reserveBoxId = reserveBoxId;
		}

		public String getRoomNum() {
			return roomNum;
		}

		public void setRoomNum(String roomNum) {
			this.roomNum = roomNum;
		}

		public String getShopName() {
			return shopName;
		}

		public void setShopName(String shopName) {
			this.shopName = shopName;
		}

		public String getTheme() {
			return theme;
		}

		public void setTheme(String theme) {
			this.theme = theme;
		}

	}
}
