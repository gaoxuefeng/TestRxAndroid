package cn.com.ethank.yunge.framework.location;

public final class LocationInfo {
	private double mLatitude = 0.0;
	private double mLongitude = 0.0;
	private String mCityName = "";
	private long mLocationTimeMillis = 0;

	public LocationInfo(double latitude, double longitude, String cityName,
			long locationTimeMillis) {
		mLatitude = latitude;
		mLongitude = longitude;
		mCityName = cityName;
		mLocationTimeMillis = locationTimeMillis;
	}
	
	public LocationInfo(String cityName) {
		this(0.0, 0.0, cityName, 0);
	}

	public LocationInfo() {
	}

	public void setLatitude(double latitude) {
		this.mLatitude = latitude;
	}
	
	public void setLongitude(double longitude) {
		this.mLongitude = longitude;
	}
	
	public double getLatitude() {
		return mLatitude;
	}

	public double getLongitude() {
		return mLongitude;
	}

	public String getCityName() {
		return mCityName == null ? "" : mCityName;
	}

	public void setCityName(String cityName) {
		this.mCityName = cityName;
	}
	
	public long getTime() {
		return mLocationTimeMillis;
	}
	
	@Override
	public String toString(){
		return String.format("(%s)[%f, %f]",  getCityName(), getLatitude(), getLongitude());
	}

}
