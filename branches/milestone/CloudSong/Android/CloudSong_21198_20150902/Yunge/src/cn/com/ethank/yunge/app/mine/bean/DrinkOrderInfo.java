package cn.com.ethank.yunge.app.mine.bean;

import java.util.List;

public class DrinkOrderInfo {
	private int code;
	private Data data;
	
	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public Data getData() {
		return data;
	}

	public void setData(Data data) {
		this.data = data;
	}

	public class Data{
		private String KTVName;
		private String address;
		private List<DrinkInfo> goodsList;
		private int orderTime;
		private int payState;
		private String phoneNum;
		private String sumPrice;
		private String useName;
		
		
		public class DrinkInfo{
			private String gName;
			private Double gPrice;
			private String gUnit;
			private int num;
			public String getGname() {
				return gName;
			}
			public void setGname(String gName) {
				this.gName = gName;
			}

			public Double getGprice() {
				return gPrice;
			}
			public void setGprice(Double gPrice) {
				this.gPrice = gPrice;
			}
			public String getGunit() {
				return gUnit;
			}
			public void setGunit(String gUnit) {
				this.gUnit = gUnit;
			}
			public int getNum() {
				return num;
			}
			public void setNum(int num) {
				this.num = num;
			}
			
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
		public List<DrinkInfo> getGoodsList() {
			return goodsList;
		}
		public void setGoodsList(List<DrinkInfo> goodsList) {
			this.goodsList = goodsList;
		}
		public int getOrderTime() {
			return orderTime;
		}
		public void setOrderTime(int orderTime) {
			this.orderTime = orderTime;
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
		public String getSumPrice() {
			return sumPrice;
		}
		public void setSumPrice(String sumPrice) {
			this.sumPrice = sumPrice;
		}
		public String getUseName() {
			return useName;
		}
		public void setUseName(String useName) {
			this.useName = useName;
		}
	}
	
	
	
}
