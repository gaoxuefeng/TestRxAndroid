package com.example.ducksdemo;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Random;
import java.util.UUID;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.Surface;
import android.view.WindowManager;
import android.widget.Toast;

public class ParamConstants {
	public static final String STORE_PATH = getSDCardPath() + "/DCIM/";

	public final static String sdcardPath = getSDCardPath() + File.separator + "techsailor";

	public final static String sdcardpath = sdcardPath + File.separator + "file";

	public final static String roomImg_path = sdcardPath + File.separator + "img";

	public final static String InspectorImg_path = getSDCardPath() + File.separator + "inspectorimg";

	public final static String roomRecord_path = sdcardPath + File.separator + "video";

	// public static final String errorUrl = "http://192.168.1.234:8081";
	public static final String errorUrl = "http://122.13.71.189";

	public final static String HOUSEQCPICPATH = getSDCardPath() + File.separator + "houseQC" + File.separator;

	// 提供一个静态方法，用于根据手机方向获得相机预览画面旋转的角度
	public static int getPreviewDegree(Activity activity) {
		// 获得手机的方向
		int rotation = activity.getWindowManager().getDefaultDisplay().getRotation();
		int degree = 0;
		// 根据手机的方向计算相机预览画面应该选择的角度
		switch (rotation) {
		case Surface.ROTATION_0:
			degree = 90;
			break;
		case Surface.ROTATION_90:
			degree = 0;
			break;
		case Surface.ROTATION_180:
			degree = 270;
			break;
		case Surface.ROTATION_270:
			degree = 180;
			break;
		}
		return degree;
	}

	/**
	 * 文件夹删除
	 * 
	 * @param file
	 */
	public static void fileDele(File file) {
		if (file.isFile()) {
			file.delete();
			return;
		}
		if (file.isDirectory()) {
			File[] childFiles = file.listFiles();
			if (childFiles == null || childFiles.length == 0) {
				file.delete();
				return;
			}

			for (int i = 0; i < childFiles.length; i++) {
				fileDele(childFiles[i]);
			}
			file.delete();
		}

	}

	// 判断是否有SDCard
	public static boolean isHadSDCard(Context c) {
		String sdStatus = Environment.getExternalStorageState();
		if (!sdStatus.equals(Environment.MEDIA_MOUNTED)) {// 检测SD卡是否可用
			Toast.makeText(c, "无SDCard！", 0).show();
			return false;
		} else {
			return true;
		}
	}

	// 检查网络
	public static boolean checkinternet(Context c) {
		ConnectivityManager mConnectivity;
		mConnectivity = (ConnectivityManager) c.getSystemService(Context.CONNECTIVITY_SERVICE);

		NetworkInfo info = mConnectivity.getActiveNetworkInfo();
		if (info == null || !info.isAvailable() || !info.isConnected())
			return false;
		else
			return true;
	}

	// 获取SDCard路径
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
				Log.i("CommonUtil:getSDCardPath", lineStr);
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
			Log.e("CommonUtil:getSDCardPath", e.toString());
			return Environment.getExternalStorageDirectory().getPath();
		}
		return Environment.getExternalStorageDirectory().getPath();
	}

	// 获取手机设备信息管理器
	public static final TelephonyManager getMobileinfo(Context c) {
		return (TelephonyManager) c.getSystemService(Context.TELEPHONY_SERVICE);
	}

	// 获取App包列表
	public static PackageInfo getMobilepackage(Context c) {
		try {
			return c.getPackageManager().getPackageInfo(c.getPackageName(), 0);
		} catch (NameNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}

	// 图片压缩
	public static Bitmap imgCompress(int wi, int hi, String imgPath) throws Exception {

		BitmapFactory.Options bfOptions = new BitmapFactory.Options();
		bfOptions.inSampleSize = 2; // 表示缩放原图的1/4大小
		bfOptions.inDither = false;
		bfOptions.inPurgeable = true;
		bfOptions.inJustDecodeBounds = false; // 表示允许开辟空间
		bfOptions.inTempStorage = new byte[1024 * 1024 * 2]; // 表示开辟2M的内存空间

		File file = new File(imgPath);
		FileInputStream fs = null;
		try {
			fs = new FileInputStream(file);

			Matrix matrix = new Matrix();
			if (fs != null) {
				// 计算缩放比例
				float scaleWidth = 1.0f;
				float scaleHeight = 1.0f;

				float fh = ((float) hi) / BitmapFactory.decodeFileDescriptor(fs.getFD(), null, bfOptions).getHeight();
				float fw = ((float) wi) / BitmapFactory.decodeFileDescriptor(fs.getFD(), null, bfOptions).getWidth();
				float aaa = fh > fw ? fw : fh;
				scaleWidth = scaleHeight = aaa;

				// if (BitmapFactory.decodeFileDescriptor(fs.getFD(), null,
				// bfOptions).getHeight() > 2000 ||
				// BitmapFactory.decodeFileDescriptor(fs.getFD(), null,
				// bfOptions).getWidth() > 2000)
				// {
				// scaleWidth = 0.25f;
				// scaleHeight = 0.25f;
				// }
				// else if (BitmapFactory.decodeFileDescriptor(fs.getFD(), null,
				// bfOptions).getHeight() > 1000 ||
				// BitmapFactory.decodeFileDescriptor(fs.getFD(), null,
				// bfOptions).getWidth() > 1000)
				// {
				// scaleWidth = 0.50f;
				// scaleHeight = 0.50f;
				// }

				// 取得想要缩放的matrix参数
				matrix.postScale(scaleWidth, scaleHeight);
				// 得到新的图片
				Bitmap bit = BitmapFactory.decodeFileDescriptor(fs.getFD(), null, bfOptions);
				int width = bit.getWidth();
				int heigth = bit.getHeight();
				Bitmap b1 = Bitmap.createBitmap(bit, 0, 0, width, heigth, matrix, true);
				try {
					if (!ParamConstants.isPicturePoint) {
						return ParamConstants.rotaingImageView(ParamConstants.readPictureDegree(imgPath), b1);
					} else {
						return b1;
					}
				} finally {
					if (b1 != null) {
						b1.recycle();
					}
					if (bit != null) {
						bit.recycle();
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (fs != null) {
				try {
					fs.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}

	// 获取UUID
	public static String getuuid() {
		return UUID.randomUUID().toString();
	}

	public static int getrandom() {
		return new Random().nextInt(100 * 1000);
	}

	/*
	 * 旋转图片
	 * 
	 * @param angle
	 * 
	 * @param bitmap
	 * 
	 * @return Bitmap
	 */
	public static Bitmap rotaingImageView(int angle, Bitmap bitmap) {
		// 旋转图片 动作
		Matrix matrix = new Matrix();
		;
		matrix.postRotate(angle);
		System.out.println("angle2=" + angle);
		// 创建新的图片
		Bitmap resizedBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
		return resizedBitmap;
	}

	/**
	 * 读取图片属性：旋转的角度
	 * 
	 * @param path
	 *            图片绝对路径
	 * @return degree旋转的角度
	 */
	public static int readPictureDegree(String path) {
		int degree = 0;
		try {
			ExifInterface exifInterface = new ExifInterface(path);
			int orientation = exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
			switch (orientation) {
			case ExifInterface.ORIENTATION_ROTATE_90:
				degree = 90;
				break;
			case ExifInterface.ORIENTATION_ROTATE_180:
				degree = 180;
				break;
			case ExifInterface.ORIENTATION_ROTATE_270:
				degree = 270;
				break;
			default:
				degree = 360;
				break;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return degree;
	}

	public static DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public static SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	// 判断是否对图片进行标记

	public static boolean isPicturePoint = false;

	// 判断是否有SDCard
	public static boolean isHasSDCard(Context c) {
		String sdStatus = Environment.getExternalStorageState();
		if (!sdStatus.equals(Environment.MEDIA_MOUNTED)) {// 检测SD卡是否可用
			Toast.makeText(c, "未检查到存储卡，请检查！", 1).show();
			return false;
		} else {
			return true;
		}
	}

	/**
	 * 判断是否为平板
	 * 
	 * @return
	 */
	public static boolean ispad = false;

	//
	// WindowManager wm = (WindowManager)
	// ctx.getSystemService(Context.WINDOW_SERVICE);
	// Display display = wm.getDefaultDisplay();
	// // 屏幕宽度
	// float screenWidth = display.getWidth();
	// // 屏幕高度
	// float screenHeight = display.getHeight();
	// DisplayMetrics dm = new DisplayMetrics();
	// display.getMetrics(dm);
	// double x = Math.pow(dm.widthPixels / dm.xdpi, 2);
	// double y = Math.pow(dm.heightPixels / dm.ydpi, 2);
	// // 屏幕尺寸
	// double screenInches = Math.sqrt(x + y);
	// // 大于6尺寸则为Pad
	// if (screenInches >= 7.0) {
	// return true;
	// }

	// }

	public static void ispadDrider(Context ctx) {
		ParamConstants.ispad = (ctx.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE;

	}

}
