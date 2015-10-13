package cn.com.ethank.yunge.pad.bean;
/**
 * 
 * @author ping
 *
 */
public class RoomBean {
	//包厢二维码
	private String imageUrl;
	//每个包厢对应的token
	private String token;

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

}
