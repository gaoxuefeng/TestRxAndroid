package cn.com.ethank.yunge.app.home.bean;

public class Order {
	private int code;
	private Data data;
	
	public class Data{
		private String KTVName;
		private String address;
		private String nickName;
		private int payState;
		private String phoneNum;
		private String price;
		private Long rbEndTime;
		private Long rbStartTime;
		private String reserveBoxId;
		private String reserveGoodsId;//酒水订单
		private String roomNum;
		private String theme;
		public String getReserveGoodsId() {
			return reserveGoodsId;
		}
		public void setReserveGoodsId(String reserveGoodsId) {
			this.reserveGoodsId = reserveGoodsId;
		}
		public String getKTVName() {
			return KTVName;
		}
		public void setKTVName(String kTVName) {
			KTVName = kTVName;
		}
		public String getAddress() {
			return address;
		}
		public void setAddress(String address) {
			this.address = address;
		}
		public String getNickName() {
			return nickName;
		}
		public void setNickName(String nickName) {
			this.nickName = nickName;
		}
		public int getPayState() {
			return payState;
		}
		public void setPayState(int payState) {
			this.payState = payState;
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
		public Long getRbEndTime() {
			return rbEndTime;
		}
		public void setRbEndTime(Long rbEndTime) {
			this.rbEndTime = rbEndTime;
		}
		public Long getRbStartTime() {
			return rbStartTime;
		}
		public void setRbStartTime(Long rbStartTime) {
			this.rbStartTime = rbStartTime;
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
		public String getTheme() {
			return theme;
		}
		public void setTheme(String theme) {
			this.theme = theme;
		}
		
		
	}
	
	private String message;
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public Data getData() {
		if(data == null){
			new Data();
		}
		return data;
	}
	public void setData(Data data) {
		this.data = data;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	
}
