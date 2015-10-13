package cn.com.ethank.yunge.app.util;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Environment;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;
import android.widget.Toast;

/**
 * 包含设备处理方法的工具类
 * 
 * @author yzw
 * @version 1.0.0 2015-04-12
 * @since 1.6
 */
public class DeviceUtil {

	public static final int SDK_VERSION_1_5 = 3;

	public static final int SDK_VERSION_1_6 = 4;

	public static final int SDK_VERSION_2_0 = 5;

	public static final int SDK_VERSION_2_0_1 = 6;

	public static final int SDK_VERSION_2_1 = 7;

	public static final int SDK_VERSION_2_2 = 8;

	public static final int SDK_VERSION_2_3 = 9;

	public static final int SDK_VERSION_2_3_3 = 10;

	public static final int SDK_VERSION_3_0 = 11;

	public static final int SDK_VERSION_4_0 = 14;

	public static final int SDK_VERSION_4_0_3 = 15;

	/**
	 * 获得设备型号
	 * 
	 * @return
	 */
	public static String getDeviceModel() {
		return makeSafe(Build.MODEL);
	}

	public static String getDeviceName() {
		return makeSafe(Build.DEVICE);
	}

	/**
	 * 获得设备的固件版本号
	 */
	public static String getReleaseVersion() {
		return makeSafe(Build.VERSION.RELEASE);
	}

	public static String makeSafe(String s) {
		return (s == null) ? "" : s;
	}

	/**
	 * 获得国际移动设备身份码
	 * 
	 * @param context
	 * @return
	 */
	public static String getIMEI(Context context) {
		return ((TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE)).getDeviceId();
	}

	/**
	 * 获得MSISDN
	 * <p/>
	 * 修改记录： 2012-11-20 litingchang 调用getLine1Number()360会弹出获取手机号码的提示，故注释掉。
	 * 
	 * @param context
	 * @return 没有使用
	 */
	// public static String getMSISDN(Context context) {
	// // if(context==null)
	// // return "NoNumber";
	// // String
	// //
	// msisdn=((TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE)).getLine1Number();
	// // if(msisdn==null)
	// // return "NoNumber";
	// // return (msisdn.equals("")?"NoNumber":Hash.EncoderByMd5(msisdn));
	// return "";
	// }

	/**
	 * 获得国际移动用户识别码
	 * 
	 * @param context
	 * @return
	 */
	public static String getIMSI(Context context) {
		return ((TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE)).getSubscriberId();
	}

	/**
	 * 获得设备的屏幕尺寸对象
	 */
	public static Display getDeviceDisplay(Context context) {
		return ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
	}

	/**
	 * 获得设备的屏幕宽
	 */
	public static int getDeviceWidth(Context context) {
		Display display = getDeviceDisplay(context);
		return display.getWidth();
	}

	/**
	 * 获得设备的屏幕长
	 */
	public static int getDeviceHeight(Context context) {
		Display display = getDeviceDisplay(context);
		return display.getHeight();
	}

	/**
	 * 获得设备屏幕矩形区域范围
	 * 
	 * @param context
	 * @return
	 */
	public static Rect getScreenRect(Context context) {
		Display display = getDeviceDisplay(context);
		return new Rect(0, 0, getDeviceWidth(context), getDeviceHeight(context));
	}

	/**
	 * 获得设备屏幕像素
	 */
	public static float getScreenDensity(Context context) {
		DisplayMetrics metrics = context.getApplicationContext().getResources().getDisplayMetrics();
		return metrics.density;
	}

	public static int getScreenDensityDpi(Context context) {
		DisplayMetrics metrics = context.getApplicationContext().getResources().getDisplayMetrics();
		return (int) (metrics.density * 160);
	}

	/**
	 * 获得系统版本
	 */
	public static String getSDKVersionString() {
		return Build.VERSION.SDK;
	}

	public static int getSDKVersionInt() {
		try {
			return Integer.valueOf(Build.VERSION.SDK);
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获得android_id
	 * 
	 * @param context
	 * @return
	 */
	public static String getAndroidId(Context context) {
		return Secure.getString(context.getContentResolver(), Secure.ANDROID_ID);
	}

	/**
	 * 获得deviceId
	 * 
	 * @param context
	 * @return
	 */
	public static String getDeviceId(Context context) {
		return getIMEI(context);
	}

	/**
	 * 获得屏幕尺寸
	 * 
	 * @param context
	 * @return
	 */
	public static String getResolution(Context context) {
		Rect rect = getScreenRect(context);
		return rect.right + "x" + rect.bottom;
	}

	public static String getSerialNumber() {
		String serialNumber = "";

		try {
			Class<?> c = Class.forName("android.os.SystemProperties");
			Method get = c.getMethod("get", String.class);
			serialNumber = (String) get.invoke(c, "ro.serialno");

			if (serialNumber.equals("")) {
				serialNumber = "?";
			}
		} catch (Exception e) {
			if (serialNumber.equals("")) {
				serialNumber = "?";
			}
		}

		return serialNumber;
	}

	public static String getABI() {
		String abi = "";
		try {
			abi = Build.CPU_ABI;
		} catch (Error err) { // Possible throw NoSuchFiledError here

		} catch (Exception e) {

		}
		return abi;
	}

	@TargetApi(8)
	public static String getABI2() {
		String abi2 = "";
		try {
			abi2 = Build.CPU_ABI2;
		} catch (Error err) { // Possible throw NoSuchFiledError here

		} catch (Exception e) {

		}
		return abi2;
	}

	@TargetApi(8)
	public static String getHardware() {
		if (Build.VERSION.SDK_INT < 8)
			return "";
		return Build.HARDWARE;
	}

	/**
	 * 获取wifi mac地址
	 * 
	 * @return wifi mac地址(xx:xx:xx:xx:xx)
	 */
	public static String getLocalMacAddress(Context context) {
		WifiManager wifi = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
		WifiInfo info = wifi.getConnectionInfo();

		return info == null ? "unknown" : info.getMacAddress();
	}

	public static int convertDipToPx(Context context, int dip) {
		float scale = context.getResources().getDisplayMetrics().density;
		return (int) (dip * scale + 0.5f * (dip >= 0 ? 1 : -1));
	}

	public static int convertPxToSp(Context context, float pxValue) {
		return (int) (pxValue / context.getResources().getDisplayMetrics().scaledDensity + 0.5f);
	}

	/**
	 * 获取手机号码
	 */
	public static String getPhoneNumber(Context context) {
		TelephonyManager manager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
		String phoneNum = manager.getLine1Number();
		return phoneNum == null ? "null" : phoneNum;
	}

	public static int getStatusBarHeight(Activity activity) {
		int result = 0;
		Rect frame = new Rect();
		activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
		result = frame.top;
		if (result <= 0) {
			Class<?> c = null;
			Object obj = null;
			Field field = null;
			int x = 0;
			try {
				c = Class.forName("com.android.internal.R$dimen");
				obj = c.newInstance();
				field = c.getField("status_bar_height");
				x = Integer.parseInt(field.get(obj).toString());
				result = activity.getResources().getDimensionPixelSize(x);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}

		return result;
	}

	/**
	 * 获取当前网络连接的类型信息
	 */
	public static int getConnectedType(Context context) {
		if (context != null) {
			ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
			NetworkInfo mNetworkInfo = mConnectivityManager.getActiveNetworkInfo();
			if (mNetworkInfo != null && mNetworkInfo.isAvailable()) {
				return mNetworkInfo.getType();
			}
		}
		return -1;
	}

	/**
	 * 获取当前是否联网
	 */
	public static boolean isMobileConnected(Context context) {
		if (context != null) {
			ConnectivityManager mConnectivity;
			mConnectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

			NetworkInfo info = mConnectivity.getActiveNetworkInfo();
			if (info == null || !info.isAvailable() || !info.isConnected())
				return false;
			else
				return true;
		}
		return false;
	}

	/**
	 * 判断是否有SDCard
	 */
	public static boolean isHadSDCard(Context c) {
		String sdStatus = Environment.getExternalStorageState();
		if (!sdStatus.equals(Environment.MEDIA_MOUNTED)) {// 检测SD卡是否可用
			Toast.makeText(c, "无SDCard！", Toast.LENGTH_SHORT).show();
			return false;
		} else {
			return true;
		}
	}

	/**
	 * 获取SDCard路径
	 */
	public static String getSDCardPath() {
		String cmd = "cat /proc/mounts";
		Runtime run = Runtime.getRuntime();// 返回与当前 Java 应用程序相关的运行时对象
		try {
			Process p = run.exec(cmd);// 启动另一个进程来执行命令
			BufferedInputStream in = new BufferedInputStream(p.getInputStream());
			BufferedReader inBr = new BufferedReader(new InputStreamReader(in));

			String lineStr;
			while ((lineStr = inBr.readLine()) != null) {
				// 获得命令执行后在控制台的输出信息
				if (lineStr.contains("sdcard") && lineStr.contains(".android_secure")) {
					String[] strArray = lineStr.split(" ");
					if (strArray != null && strArray.length >= 5) {
						String result = strArray[1].replace("/.android_secure", "");
						return result;
					}
				}
				// 检查命令是否执行失败。
				if (p.waitFor() != 0 && p.exitValue() == 1) {
					// p.exitValue()==0表示正常结束，1：非正常结束
				}
			}
			inBr.close();
			in.close();
		} catch (Exception e) {
			return Environment.getExternalStorageDirectory().getPath();
		}
		return Environment.getExternalStorageDirectory().getPath();
	}

	/**
	 * 判断是否为平板
	 * 
	 * 注意使用时需要在程序入口处调用ispadDrider方法， 此后其他地方使用时只需要获取ispad变量值即可
	 * 
	 * @return
	 */
	public static boolean ispad = false;

	public static void ispadDrider(Context ctx) {
		ispad = (ctx.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE;

	}

}
