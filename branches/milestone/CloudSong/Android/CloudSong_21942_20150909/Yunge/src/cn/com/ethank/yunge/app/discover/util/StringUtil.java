package cn.com.ethank.yunge.app.discover.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class StringUtil {
	/**
	 * 将long类型的时间转为01:22:33格式
	 * @param duration
	 * @return
	 */
	public static String formatVideoDuration(long duration){
		int HOUR = 60 * 60 * 1000;//1小时所占的毫秒
		int MINUTE = 60 * 1000;//1分钟所占的毫秒
		int SECOND = 1000;//1秒钟
		
		//1.算出多少小时，然后拿剩余的时间去算分钟
		int hour = (int) (duration/HOUR);//得到多少小时
		long remainTime = duration%HOUR;//算完小时后剩余的时间
		//2.算分钟，然后拿剩余的时间去算秒
		int minute = (int) (remainTime/MINUTE);//得到多少分钟
		remainTime = remainTime%MINUTE;//得到算完分钟后剩余的时间
		//3.算秒
		int second = (int) (remainTime/SECOND);//得到多少秒
		
		if(hour==0){
			//说明不足1小时,只有2:33
			return String.format("%02d:%02d", minute,second);
		}else {
			return String.format("%02d:%02d:%02d", hour,minute,second);
		}
	}
	
	/**
	 * 格式化系统时间
	 * @return
	 */
	public static String formatSystemTime(){
		SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
		return format.format(new Date());
	}
	
	/**
	 * 将歌曲.mp3的名字去掉.mp3
	 * @param name
	 * @return
	 */
	public static String formatAudioName(String name){
		int lastDotIndex = name.lastIndexOf(".");
		return name.substring(0, lastDotIndex);
	}
}
