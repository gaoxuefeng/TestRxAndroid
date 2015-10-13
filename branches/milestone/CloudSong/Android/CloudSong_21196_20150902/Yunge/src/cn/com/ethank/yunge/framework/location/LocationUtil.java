package cn.com.ethank.yunge.framework.location;

import java.util.List;
import java.util.Vector;
import java.util.concurrent.atomic.AtomicReference;

import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;
import android.provider.Settings;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.util.TimeUtil;

public class LocationUtil {
	private LocationManager locationManager;
	private LocationClient mLocationClient;
	private AtomicReference<LocationInfo> mLocationInfo = new AtomicReference<LocationInfo>(new LocationInfo());
	private BDLocationListener myLocationListener;
	private boolean mHasGps = false;
	private boolean mHasNetwork = false;

	private Vector<OnCityFindListener> mHandlers = new Vector<OnCityFindListener>();

	private ISettingService mSettingSvc;

	public static final String SEARCH_LAST_CITY = "SEARCH_LAST_CITY";

	private static final LocationUtil INST = new LocationUtil();

	public static LocationUtil getInst() {
		return INST;
	}

	private boolean isGPSEnabled() {
		if (locationManager == null) {
			return false;
		}
		try {
			if (mHasGps && mHasNetwork) {
				if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) && !locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
					return false;
				}
			} else if (mHasNetwork && !locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
				return false;
			} else if (mHasGps && !locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	private void checkProvider() {
		try {
			List<String> providerList = locationManager.getAllProviders();
			for (String str : providerList) {
				if (LocationManager.GPS_PROVIDER.equals(str)) {
					mHasGps = true;
				}
				if (LocationManager.NETWORK_PROVIDER.equals(str)) {
					mHasNetwork = true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static boolean isLocationUnavailable(LocationInfo locInfo, long effectivePeridMillis) {
		if (locInfo == null || (Math.abs(locInfo.getLatitude()) < 0.1 && Math.abs(locInfo.getLongitude()) < 0.1)) {
			return true;
		} else {
			if (System.currentTimeMillis() - locInfo.getTime() > effectivePeridMillis) {
				return true;
			} else {
				return false;
			}
		}
	}

	public boolean needOpenGps() {
		if (isLocationUnavailable(this.getLocation(), TimeUtil.ONE_DAY_MILLIS)) {
			if (isGPSEnabled()) {
				return false;
			} else {
				return true;
			}
		} else {
			return false;
		}
	}

	public synchronized void startLocateCity(OnCityFindListener handler) {
		if (mLocationClient == null) {
			return;
		}
		if (handler != null && !mHandlers.contains(handler)) {
			mHandlers.add(handler);
			this.start();
		}
	}

	public synchronized void stopLocateCity(OnCityFindListener handler) {
		if (handler != null) {
			mHandlers.remove(handler);
		}
	}

	public boolean openGPS(Context context) {
		try {
			context.startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	public class MyLocationListener implements BDLocationListener {

		@Override
		public void onReceiveLocation(final BDLocation location) {
			LocationInfo newLocInfo = null;
			if (location != null) {
				newLocInfo = new LocationInfo(location.getLatitude(), location.getLongitude(), formateCity(location.getCity()), System.currentTimeMillis());
				mLocationInfo.set(newLocInfo);
				mLocationClient.stop();
			}

			for (OnCityFindListener handler : mHandlers) {
				try {
					handler.cityFindAction(newLocInfo);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			mHandlers.clear();
		}

	}

	private LocationUtil() {
		try {
			Context appContext = CoyoteSystem.getCurrent().getAppContext();
			locationManager = (LocationManager) appContext.getSystemService(Context.LOCATION_SERVICE);
			mLocationClient = new LocationClient(appContext);
			myLocationListener = new MyLocationListener();
			mLocationClient.registerLocationListener(myLocationListener);
			mSettingSvc = (ISettingService) CoyoteSystem.getCurrent().getService(ISettingService.class);
			LocationClientOption option = new LocationClientOption();
			option.setOpenGps(true);
			option.setAddrType("all");
			option.setCoorType("gcj02");
			option.setScanSpan(5000);
			// option.disableCache(true);
			// option.setPoiNumber(3);
			// option.setPoiDistance(1000);
			// option.setPoiExtraInfo(true);
			mLocationClient.setLocOption(option);
			checkProvider();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private String formateCity(String city) {
		if (city != null && city.length() > 1) {
			city = city.substring(0, city.length() - 1);
		}
		return city;
	}

	public void start() {
		if (mLocationClient == null) {
			return;
		}
		if (!mLocationClient.isStarted()) {
			mLocationClient.start();
			mLocationClient.requestLocation();
		}
	}

	public void stop() {
		if (mLocationClient == null) {
			return;
		}
		if (mLocationClient.isStarted()) {
			mLocationClient.stop();
		}
	}

	private LocationInfo getLocation() {
		return mLocationInfo.get();
	}

	public String getSavedCity() {
		if (mSettingSvc == null) {
			return "";
		}
		return mSettingSvc.getString(SEARCH_LAST_CITY, "北京");
	}

	public void setSavedCity(String cityName) {
		if (mSettingSvc == null) {
			return;
		}
		mSettingSvc.setString(SEARCH_LAST_CITY, cityName);
	}
}
