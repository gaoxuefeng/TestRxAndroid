package cn.com.ethank.yunge.app.util;

import java.util.HashMap;

import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.startup.BaseApplication;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.LocationClientOption.LocationMode;
import com.coyotelib.core.threading.BackgroundTask;

public class RequestLoactionCity extends BaseRequest {

	private BackgroundTask<Object> backgroundTask;
	private LocationClient mLocationClient;
	private MyLocationListener mMyLocationListener;
	private RequestCallBack requestCallBack;

	@Override
	public void start(RequestCallBack requestCallBack) {

		this.requestCallBack = requestCallBack;
		this.backgroundTask = new BackgroundTask<Object>() {

			@Override
			protected Object doWork() throws Exception {
				return "";
			}

			@Override
			protected void onCompletion(Object result, Throwable exception, boolean cancelled) {
				super.onCompletion(result, exception, cancelled);
				mLocationClient = new LocationClient(BaseApplication.getInstance());
				LocationClientOption option = new LocationClientOption();
				option.setLocationMode(LocationMode.Hight_Accuracy);// 设置定位模式
				option.setCoorType("gcj02");// 返回的定位结果是百度经纬度，默认值gcj02
				option.setScanSpan(10000);// 设置发起定位请求的间隔时间为5000ms
				option.setIsNeedAddress(true);// 返回的定位结果包含地址信息
				mLocationClient.setLocOption(option);
				mMyLocationListener = new MyLocationListener();
				mLocationClient.registerLocationListener(mMyLocationListener);
				mLocationClient.start();
				mLocationClient.requestLocation();
			}

		};
		backgroundTask.run();

	}

	/**
	 * 实现实位回调监听
	 */
	public class MyLocationListener implements BDLocationListener {

		@Override
		public void onReceiveLocation(BDLocation location) {
			try {
				mLocationClient.unRegisterLocationListener(this);
				mLocationClient.stop();
			} catch (Exception e) {
				e.printStackTrace();
			}

			String locationStr = "";
			String province = location.getProvince();// 省
			String city = location.getCity();// 城市
			String district = location.getDistrict();// 区,县
			String street = location.getStreet();// 街道
			double latitude = location.getLatitude();// 经纬度
			double longitude = location.getLongitude();// 经纬度
			location.getAddrStr();
			if (city != null && city.contains("市")) {
				city = city.replaceAll("市", "");
				Constants.locationCity = city;
				Constants.latitude = latitude;
				Constants.longitude = longitude;
			} else {
				if (city == null) {
					city = "北京";
				}
			}
			if (!backgroundTask.isCancelled() && requestCallBack != null) {
				HashMap<String, String> hashMap = new HashMap<String, String>();
				hashMap.put("data", city);
				requestCallBack.onLoaderFinish(hashMap);

			} else if (requestCallBack != null) {
				requestCallBack.onLoaderFail();
			}

		}

	}

	public void cancel() {
		try {
			if (backgroundTask != null && !backgroundTask.isCancelled()) {
				backgroundTask.cancel(true);

			}
			if (mLocationClient != null && mMyLocationListener != null) {
				mLocationClient.unRegisterLocationListener(mMyLocationListener);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
