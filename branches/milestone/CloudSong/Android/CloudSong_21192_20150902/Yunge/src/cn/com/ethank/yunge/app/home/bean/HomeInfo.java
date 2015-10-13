package cn.com.ethank.yunge.app.home.bean;

import java.io.Serializable;

import android.renderscript.Script.KernelID;

import cn.com.ethank.yunge.app.util.VerifyStringType;

/**
 * 首页面
 * 
 * @author ping
 * 
 */
public class HomeInfo implements Serializable {

	// 有这个参数是公司自营id
	private String BLDKTVId;

	// KTV名称
	private String KTVName;
	// 地址 目前不返回
	private String address;
	// 团促卡惠
	private int discountIconMeg;// 二进制
	// 折扣
	private String discountMeg;
	// 距离
	private double distance;
	// KTV图片
	private String imageUrl;
	// 商户电话
	private String phoneNum;
	// 人均消费
	private int price;
	// 评分
	private double rating;
	// 大众点评商户URL
	private String shopUrl;
	// 文字说明
	private String message;
	// 商圈名称
	private String circleName;

	// --开始时间
	private String businessHoursStart;

	// --结束时间
	private String businessHoursEnd;

	private String[] imageUrlList;
	private double lat;
	private double lng;

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

	public String getBusinessHoursStart() {
		if (businessHoursStart == null) {
			return "";
		}
		return businessHoursStart;
	}

	public void setBusinessHoursStart(String businessHoursStart) {
		this.businessHoursStart = businessHoursStart;
	}

	public String getBusinessHoursEnd() {
		if (businessHoursEnd == null) {
			return "";
		}
		return businessHoursEnd;
	}

	public void setBusinessHoursEnd(String businessHoursEnd) {
		this.businessHoursEnd = businessHoursEnd;
	}

	public String[] getImageUrlList() {
		if (imageUrlList == null) {
			return new String[] {};
		}
		return imageUrlList;
	}

	public void setImageUrlList(String[] imageUrlList) {
		this.imageUrlList = imageUrlList;
	}

	// 是否有折扣
	public boolean hasDiscountMeg() {
		try {
			if (discountMeg != null && VerifyStringType.isNumeric(discountMeg)) {
				float discount = Float.parseFloat(discountMeg);
				if (discount > 0 && discount < 10) {
					return true;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean isLocalData() {
		if (BLDKTVId != null && !BLDKTVId.isEmpty()) {
			return true;
		} else {
			return false;
		}
	}

	public String getBLDKTVId() {
		if (BLDKTVId == null) {
			return "";
		}
		return BLDKTVId;
	}

	public void setBLDKTVId(String bLDKTVId) {

		BLDKTVId = bLDKTVId;
	}

	public String getCircleName() {
		if (circleName == null) {
			return "";
		}
		return circleName;
	}

	public void setCircleName(String circleName) {
		this.circleName = circleName;
	}

	public String getKTVName() {
		if (KTVName == null || KTVName.isEmpty()) {
			return "潮趴汇";
		}
		return KTVName;
	}

	public void setKTVName(String kTVName) {
		KTVName = kTVName;
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

	public int getDiscountIconMeg() {
		return discountIconMeg;
	}

	public int[] getDiscountIconArray() {
		int a = Integer.parseInt(Integer.toBinaryString(getDiscountIconMeg()));

		int[] b = new int[] { 0, 0, 0, 0 };// 团促卡惠团是最低位,惠是最高位
		try {

			if (a >= 1000) {
				b[3] = 1;
			}
			if ((a % 1000) >= 100) {
				b[2] = 1;
			}

			if ((a % 100) >= 10) {
				b[1] = 1;
			}
			if ((a % 10) >= 1) {
				b[0] = 1;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return b;
	}

	public void setDiscountIconMeg(int discountIconMeg) {
		this.discountIconMeg = discountIconMeg;
	}

	public String getDiscountMeg() {
		if (discountMeg == null) {
			return "";
		}
		return discountMeg;
	}

	public void setDiscountMeg(String discountMeg) {
		this.discountMeg = discountMeg;
	}

	public double getDistance() {
		return distance;
	}

	public void setDistance(double distance) {
		this.distance = distance;
	}

	public String getImageUrl() {
		if (imageUrl == null) {
			return "";
		}
		return imageUrl;
	}

	public void setImageUrl(String iamgeUrl) {
		this.imageUrl = iamgeUrl;
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

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	public String getShopUrl() {
		if (shopUrl == null) {
			return "http://www.baidu.com";// 为空跳到Baidu
		}
		return shopUrl;
	}

	public void setShopUrl(String shopUrl) {
		this.shopUrl = shopUrl;
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
