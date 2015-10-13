package com.example.yungelight;

public class ContronBean {
	private String modeCode;
	private String modeName;
	private String modeBackCode;
	private String modequeryCode;

	public String getModeCode() {
		if(modeCode==null){
			return "";
		}
		return modeCode;
	}

	public void setModeCode(String modeCode) {
		
		this.modeCode = modeCode;
	}

	public String getModeName() {
		if(modeName==null){
			return "";
		}
		return modeName;
	}

	public void setModeName(String modeName) {
		this.modeName = modeName;
	}

	public String getModeBackCode() {
		return modeBackCode;
	}

	public void setModeBackCode(String modeBackCode) {
		this.modeBackCode = modeBackCode;
	}

	public String getModequeryCode() {
		if(modequeryCode==null){
			return "";
		}
		return modequeryCode;
	}

	public void setModequeryCode(String modequeryCode) {
		this.modequeryCode = modequeryCode;
	}
}
