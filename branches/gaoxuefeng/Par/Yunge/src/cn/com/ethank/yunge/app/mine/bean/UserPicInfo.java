package cn.com.ethank.yunge.app.mine.bean;

public class UserPicInfo {
	private int code;
	private Data data;
	private String message;

	public class Data {
		private String imageUrl;

		public String getImageUrl() {
			if(imageUrl == null){
				return "";
			}
			return imageUrl;
		}

		public void setImageUrl(String imageUrl) {
			this.imageUrl = imageUrl;
		}

	}

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

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
