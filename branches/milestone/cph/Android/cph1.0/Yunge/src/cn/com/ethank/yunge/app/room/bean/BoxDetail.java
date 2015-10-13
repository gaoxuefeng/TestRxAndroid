package cn.com.ethank.yunge.app.room.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class BoxDetail implements Comparable<BoxDetail>, Serializable {
	private String ktvName;// 门店名称
	private String address;
	private List<String> avatarUrls;
	private String nickName;
	private String roomName;
	private Long startTime;
	private int payState;
	private String phoneNum;
	private String price;
	private Long rbEndTime;
	private String reserveBoxId;
	private Long serviceDate;
	private String discribe;// 描述
	private int joinCount;// 参与人数
	private String reservationAvatarUrl;// 预定人头像
	private String reservationName;// 预定人名称
	private double lat;
	private double lng;
	private String boxIP;
	private String boxToken;
	private String ktvIP;
	private boolean isFromLocal;// 是否来自扫描二维码

	public Long getStartTime() {
		if (startTime == null) {
			return 0L;
		}
		return startTime;
	}

	public void setStartTime(Long startTime) {
		if (startTime != null && startTime != 0) {
			this.startTime = startTime;
		}

	}

	public void setRbStartTime(Long rbStartTime) {
		if (rbStartTime != null && rbStartTime != 0) {
			this.startTime = rbStartTime;
		}

	}

	public String getRoomName() {
		if (roomName == null) {
			return "";
		}
		return roomName;
	}

	public void setRoomName(String roomName) {
		if (roomName != null) {
			this.roomName = roomName;
		}

	}

	public void setRoomNum(String roomNum) {
		if (roomNum != null) {
			this.roomName = roomNum;
		}

	}

	public void setServerTimeStamp(Long serverTimeStamp) {
		if (serverTimeStamp != null && serverTimeStamp != 0) {
			this.serviceDate = serverTimeStamp;
		}

	}

	public Long getServiceDate() {
		return serviceDate;
	}

	public void setServiceDate(Long serviceDate) {
		if (serviceDate != null && serviceDate != 0) {
			this.serviceDate = serviceDate;
		}

	}

	public String getKtvName() {
		if (ktvName == null) {
			return "";
		}
		return ktvName;
	}

	public void setKtvName(String ktvName) {
		this.ktvName = ktvName;
	}

	public String getAddress() {
		if (address == null) {
			return "";
		}
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public List<String> getAvatarUrls() {
		if (avatarUrls == null) {
			return new ArrayList<String>();
		}
		return avatarUrls;
	}

	public void setAvatarUrls(List<String> avatarUrls) {
		this.avatarUrls = avatarUrls;
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

	public int getPayState() {
		return payState;
	}

	public void setPayState(int payState) {
		this.payState = payState;
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

	public String getPrice() {
		if (price == null) {
			return "";
		}
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public Long getRbEndTime() {
		if (rbEndTime == null) {
			return 0L;
		} else {
			return rbEndTime;
		}

	}

	public void setRbEndTime(Long rbEndTime) {
		this.rbEndTime = rbEndTime;
	}

	public String getReserveBoxId() {
		if (reserveBoxId == null) {
			return "";
		}
		return reserveBoxId;
	}

	public void setReserveBoxId(String reserveBoxId) {
		this.reserveBoxId = reserveBoxId;
	}

	public String getDiscribe() {
		if (discribe == null) {
			return "";
		}
		return discribe;
	}

	public void setDiscribe(String discribe) {
		this.discribe = discribe;
	}

	public int getJoinCount() {

		return joinCount;
	}

	public void setJoinCount(int joinCount) {
		this.joinCount = joinCount;
	}

	public String getReservationAvatarUrl() {
		if (reservationAvatarUrl == null) {
			return "";
		}
		return reservationAvatarUrl;
	}

	public void setReservationAvatarUrl(String reservationAvatarUrl) {
		this.reservationAvatarUrl = reservationAvatarUrl;
	}

	public String getReservationName() {
		if (reservationName == null) {
			return "";
		}
		return reservationName;
	}

	public void setReservationName(String reservationName) {
		this.reservationName = reservationName;
	}

	public double getLat() {
		return lat;
	}

	public void setLat(double lat) {
		this.lat = lat;
	}

	public double getLng() {
		return lng;
	}

	public void setLng(double lng) {
		this.lng = lng;
	}

	public boolean isStarting() {
		if (isFromLocal) {
			return true;
		} else {
			return (System.currentTimeMillis() >= getStartTime() * 1000);
		}

	}

	public String getBoxIP() {
		if (boxIP == null) {
			return "";
		}
		return boxIP;
	}

	public void setBoxIP(String boxIP) {
		this.boxIP = boxIP;
	}

	public String getBoxToken() {
		if (boxToken == null) {
			return "";
		}
		return boxToken;
	}

	public void setBoxToken(String boxToken) {
		this.boxToken = boxToken;
	}

	public String getKtvIP() {
		if (ktvIP == null) {
			return "";
		}
		return ktvIP;
	}

	public void setKtvIP(String ktvIP) {
		this.ktvIP = ktvIP;
	}

	public boolean isFromLocal() {
		return isFromLocal;
	}

	public void setFromLocal(boolean isFromLocal) {
		this.isFromLocal = isFromLocal;
	}

	@Override
	public int compareTo(BoxDetail another) {
		return this.getStartTime().compareTo(another.getStartTime());
	}

}
