package cn.com.ethank.yunge.app.mine.bean;

import java.util.List;

public class AllOrderInfo {
	private int code;
	private List<AllBoxInfo> Data;
	
	
	public class AllBoxInfo {
		private String KTVName;
		private int orderType;
		private int payState;
		private Long rbEndTime;
		private Long rbStartTime;
		private String reserveBoxId;
		private String reserveGoodsId;
		private String sumPrice;
		private List<Good> goodsList;
	

		public class Good{
			private String gName;
			private int gPrice;
			private String gUnit;
			private int num;
			public String getgName() {
				return gName;
			}
			public void setGName(String gName) {
				this.gName = gName;
			}
			public int getgPrice() {
				return gPrice;
			}
			public void setGPrice(int gPrice) {
				this.gPrice = gPrice;
			}
			public String getgUnit() {
				return gUnit;
			}
			public void setgUnit(String gUnit) {
				this.gUnit = gUnit;
			}
			public int getNum() {
				return num;
			}
			public void setNum(int num) {
				this.num = num;
			}
			
		}
		
		public String getReserveGoodsId() {
			return reserveGoodsId;
		}

		public void setReserveGoodsId(String reserveGoodsId) {
			this.reserveGoodsId = reserveGoodsId;
		}

		public String getSumPrice() {
			return sumPrice;
		}

		public void setSumPrice(String sumPrice) {
			this.sumPrice = sumPrice;
		}

		public List<Good> getGoodsList() {
			return goodsList;
		}

		public void setGoodsList(List<Good> goodsList) {
			this.goodsList = goodsList;
		}

		public String getKTVName() {
			return KTVName;
		}

		public void setKTVName(String kTVName) {
			KTVName = kTVName;
		}

		public int getOrderType() {
			return orderType;
		}

		public void setOrderType(int orderType) {
			this.orderType = orderType;
		}

		public int getPayState() {
			return payState;
		}

		public void setPayState(int payState) {
			this.payState = payState;
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

	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public List<AllBoxInfo> getData() {
		return Data;
	}

	public void setData(List<AllBoxInfo> data) {
		Data = data;
	}

}
