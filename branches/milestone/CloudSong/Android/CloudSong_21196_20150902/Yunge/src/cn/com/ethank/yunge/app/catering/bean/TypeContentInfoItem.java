package cn.com.ethank.yunge.app.catering.bean;

import cn.com.ethank.yunge.app.catering.utils.SubZeroAndDot;

public class TypeContentInfoItem {

	private int goodsId;

	private String gType;

	private String gPinyin;

	private String gCode;

	private String gName;

	private String gUnit;

	private String imgurl;

	private String gPrice;

	public int getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(int goodsId) {
		this.goodsId = goodsId;
	}

	public String getGType() {
		return gType;
	}

	public void setGType(String gType) {
		this.gType = gType;
	}

	public String getGPinyin() {
		return gPinyin;
	}

	public void setGPinyin(String gPinyin) {
		this.gPinyin = gPinyin;
	}

	public String getGCode() {
		return gCode;
	}

	public void setGCode(String gCode) {
		this.gCode = gCode;
	}

	public String getGName() {
		return gName;
	}

	public void setGName(String gName) {
		this.gName = gName;
	}

	public String getGUnit() {
		return gUnit;
	}

	public void setGUnit(String gUnit) {
		this.gUnit = gUnit;
	}

	public String getImgurl() {
		return imgurl;
	}

	public void setImgurl(String imgurl) {
		this.imgurl = imgurl;
	}

	public String getGPrice() {
		return gPrice;
	}

	public void setGPrice(String gPrice) {
		// 正则去掉小数点后的无效数字0
		String sumprice = SubZeroAndDot.subZeroAndDot(String.valueOf(gPrice));
		this.gPrice = sumprice;
	}

}
