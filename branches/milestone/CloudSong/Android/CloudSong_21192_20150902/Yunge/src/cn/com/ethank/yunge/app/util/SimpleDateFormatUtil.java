package cn.com.ethank.yunge.app.util;

import java.text.SimpleDateFormat;

public class SimpleDateFormatUtil {
	public static String getTime(int time){
		SimpleDateFormat format=new SimpleDateFormat("mm:ss");
		return format.format(time*1000);
	}
	public static String getDate(long time){
		SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
		return format.format(time);
	}
}
