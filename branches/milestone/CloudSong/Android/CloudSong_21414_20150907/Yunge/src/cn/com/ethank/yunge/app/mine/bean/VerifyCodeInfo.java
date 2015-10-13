package cn.com.ethank.yunge.app.mine.bean;

/**
 * @author sunxiaokun 验证短信码返回bean
 */
public class VerifyCodeInfo {
	private int code;
	private String message;

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

}
