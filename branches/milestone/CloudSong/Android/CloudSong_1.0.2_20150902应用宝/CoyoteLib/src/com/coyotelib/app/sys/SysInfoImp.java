package com.coyotelib.app.sys;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;

import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.sys.SysInfo;
import com.coyotelib.core.util.coding.Base64Coding;
import com.coyotelib.core.util.coding.MD5;

public class SysInfoImp extends SysInfo {

	private Context mContext;
	private ISettingService mSetting;
	private String PLATFORM;
	private String ROM_INFO;
	private String APP_VERSION;
	private String VERSION_DECOR;
	private String mAndroidID;

	public SysInfoImp(Context context, ISettingService setting,
			int displayVersionID) {
		mContext = context;
		mSetting = setting;
		PLATFORM = "android";
		ROM_INFO = makeRomInfo();
		APP_VERSION = getAppVersion(mContext);
		VERSION_DECOR = getVersionDecor(displayVersionID);
		mAndroidID = formatAndroidID(context);
	}

	@Override
	public String getFullVersionString() {
		return APP_VERSION;
	}

	@Override
	public String getIMEI() {
		return getIMEI(mContext);
	}
	
	@Override
	public String getIMSI() {
		return getIMSI(mContext);
	}

	@Override
	public String getPlatform() {
		return PLATFORM;
	}

	@Override
	public String getRomInfo() {
		return ROM_INFO;
	}

	@Override
	public String getVersionDecor() {
		return VERSION_DECOR;
	}

	private static String getIMEI(Context ctx) {
		TelephonyManager tm = (TelephonyManager) ctx
				.getSystemService(Context.TELEPHONY_SERVICE);
		String imei = tm.getDeviceId(); // deviceID
		if (TextUtils.isEmpty(imei) || isZero(imei)) {
			String mac = getMacAddress(ctx);
			if (!TextUtils.isEmpty(mac)) {
				imei = MD5.encode(mac.getBytes());
			}
		}
		return imei;
	}

	private static String getMacAddress(Context ctx) {
		try {
			WifiManager wifi = (WifiManager) ctx
					.getSystemService(Context.WIFI_SERVICE);
			WifiInfo info = wifi.getConnectionInfo();
			return info.getMacAddress();
		} catch (Exception e) {
			return null;
		}
	}

	// 判断字符串全零
	private static boolean isZero(String value) {
		try {
			int result = Integer.parseInt(value);
			return result == 0;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	private static String getIMSI(Context ctx) {
		TelephonyManager tm = (TelephonyManager) ctx
				.getSystemService(Context.TELEPHONY_SERVICE);
		return tm.getSubscriberId();
	}

	private static String makeRomInfo() {
		try {
			final String brand = Build.BRAND; // 手机厂家
			final String model = Build.MODEL; // 手机型号
			final String version = Build.VERSION.RELEASE;// Firmware/OS 版本号
			String result = brand.replaceAll(" ", "")+"_"+model.replaceAll(" ", "") + "_" + version;
			return new Base64Coding().encodeUTF8ToUTF8(result);
		} catch (Exception e) {
			return "unknown";
		}
	}

	private static String getAppVersion(Context context) {
		String versionName = "";
		try {
			PackageManager pm = context.getPackageManager();
			PackageInfo pi = pm.getPackageInfo(context.getPackageName(), 0);
			versionName = pi.versionName;
			if (TextUtils.isEmpty(versionName)) {
				return "...";
			}
			return versionName.trim();
		} catch (Exception e) {
			return "...";
		}
	}

	private String getVersionDecor(int displayedVersionID) {
		return "正式版";
//		try {
//			String displayName = FileUtil.readUTF8String(mContext
//					.getResources().openRawResource(displayedVersionID));
//			if (TextUtils.isEmpty(displayName)) {
//				displayName = "正式版";
//			}
//			return displayName.trim();
//		} catch (Exception e) {
//			e.printStackTrace();
//			return "正式版";
//		}
	}

	private static String formatAndroidID(Context context) {
		try {
			return Settings.Secure.getString(context.getContentResolver(),
					Settings.Secure.ANDROID_ID);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	@Override
	public synchronized String getAndroidID() {
		if (!TextUtils.isEmpty(mAndroidID)) {
			return mAndroidID;
		}

		mAndroidID = formatAndroidID(mContext);
		return mAndroidID;
	}

	@Override
	public String getAppVersionName() {
		
		try {
			PackageManager pm = mContext.getPackageManager();
			PackageInfo packInfo = pm.getPackageInfo(mContext.getPackageName(), 0);
			String versionName = packInfo.versionName;
			if(versionName!=null){
				return versionName;
			}
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return "";
	}

	@Override
	public int getAppVersionCode() {
		int versionCode=0;
		try {
			PackageManager pm = mContext.getPackageManager();
			PackageInfo packInfo = pm.getPackageInfo(mContext.getPackageName(), 0);
			 versionCode = packInfo.versionCode;
			
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return versionCode;
	}
}
