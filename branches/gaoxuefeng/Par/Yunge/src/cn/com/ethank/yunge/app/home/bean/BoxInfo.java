package cn.com.ethank.yunge.app.home.bean;

import java.util.List;

import u.aly.da;

public class BoxInfo {

	private int code;
	private Data data;
	private String message;

	public Data getData() {
		if(data == null){
			data = new Data();
		}
		return data;
	}

	public void setData(Data data) {
		this.data = data;
	}

	public class Data {
		private String day;
		private String duration;
		private String hour;
		private List<Box> roomQueryList;

		public String getDay() {
			if (day == null) {
				return "";
			}
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

		public List<Box> getRoomQueryList() {
			return roomQueryList;
		}

		public void setRoomQueryList(List<Box> roomQueryList) {
			this.roomQueryList = roomQueryList;
		}

		public class Box {

			private String boxTypeChoice; // --房间类型--
			private int boxTypeId;
			private String boxTypeName;

			private boolean boxTypeState;
			private String durationTime;
			private double price;
			private String reserveTime;

			public double getPrice() {
				return price;
			}

			public void setPrice(double price) {
				this.price = price;
			}

			public String getBoxTypeChoice() {
				return boxTypeChoice;
			}

			public void setBoxTypeChoice(String boxTypeChoice) {
				this.boxTypeChoice = boxTypeChoice;
			}

			public int getBoxTypeId() {
				return boxTypeId;
			}

			public void setBoxTypeId(int boxTypeId) {
				this.boxTypeId = boxTypeId;
			}

			public String getBoxTypeName() {
				return boxTypeName;
			}

			public void setBoxTypeName(String boxTypeName) {
				this.boxTypeName = boxTypeName;
			}

			public boolean isBoxTypeState() {
				return boxTypeState;
			}

			public void setBoxTypeState(boolean boxTypeState) {
				this.boxTypeState = boxTypeState;
			}

			public String getDurationTime() {
				return durationTime;
			}

			public void setDurationTime(String durationTime) {
				this.durationTime = durationTime;
			}

			public String getReserveTime() {
				return reserveTime;
			}

			public void setReserveTime(String reserveTime) {
				this.reserveTime = reserveTime;
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
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
