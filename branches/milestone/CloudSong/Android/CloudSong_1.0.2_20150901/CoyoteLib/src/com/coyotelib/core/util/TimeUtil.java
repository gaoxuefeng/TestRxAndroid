package com.coyotelib.core.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class TimeUtil {
	public static final int ONE_DAY_MILLIS = 24 * 60 * 60 * 1000;
	public static final int HALF_DAY_MILLIS = ONE_DAY_MILLIS / 2;
	public static final int TEN_SECOND_MILLIS = 10 * 1000;
	public static final int ONE_HOUR_MILLIS = 1000 * 60 * 60;

	public static Date getNextDayOf24(long timeMillis) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date(timeMillis));
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		cal.add(Calendar.DAY_OF_MONTH, 1);
		return cal.getTime();
	}

	public static java.util.Date long2date(long time) {
		java.util.Date dt = new Date(time);
		// 得到精确到秒的表示：08/31/2006 21:08:00
		return dt;
	}

	// "MM/dd HH:mm"
	public static String getTimeString(long date, String format) {
		SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.getDefault());
		Date dt = new Date(date);
		// 得到精确到秒的表示：08/31 21:08
		return sdf.format(dt);
	}

	public static int getYear(long date) {
		Date dt = long2date(date);
		return dt.getYear();
	}

	/*
	 * 格式化时间（1）23点~次日1点间：深夜11:15、深夜12:25 （2）2点~7点：凌晨6:18、凌晨2:15 （3）除此之外的时间不告之、
	 */
	public static String formatTime(long date) {
		Date dt = new Date(date);
		int hour = dt.getHours();
		if (hour >= 23 || hour < 1) {
			return "深夜";
		} else if (hour >= 1 && hour < 7) {
			return "凌晨";
		} else {
			return null;
		}
	}

	public static long stringToLong(String strTime, String formatType)
			throws ParseException {
		Date date = stringToDate(strTime, formatType); // String类型转成date类型
		if (date == null) {
			return 0;
		} else {
			long currentTime = dateToLong(date); // date类型转成long类型
			return currentTime;
		}
	}

	// string类型转换为date类型
	// strTime要转换的string类型的时间，formatType要转换的格式yyyy-MM-dd HH:mm:ss//yyyy年MM月dd日
	// HH时mm分ss秒，
	// strTime的时间格式必须要与formatType的时间格式相同
	public static Date stringToDate(String strTime, String formatType)
			throws ParseException {
		SimpleDateFormat formatter = new SimpleDateFormat(formatType,
				Locale.getDefault());
		Date date = null;
		date = formatter.parse(strTime);
		return date;
	}

	// date类型转换为long类型
	// date要转换的date类型的时间
	public static long dateToLong(Date date) {
		return date.getTime();
	}

	private Date mTodayZero;
	// private Date mBefore24Hours;
	private Date mYesterdayZero;
	private long mCurTime;

	public TimeUtil(long time) {
		mCurTime = time;

		mTodayZero = getTodayZero();
		mYesterdayZero = getYesterdayZero(mTodayZero);
	}

	private Date getYesterdayZero(Date time) {
		return new Date(time.getTime() - (long) 24 * 60 * 60 * 1000);
	}

	private Date getTodayZero() {
		// 获得今天时间
		Calendar c = Calendar.getInstance();
		// 将时，分，秒，毫秒设置为0
		c.set(Calendar.HOUR_OF_DAY, 0);
		c.set(Calendar.MINUTE, 0);
		c.set(Calendar.SECOND, 0);
		c.set(Calendar.MILLISECOND, 0);
		// 此处返回的为今天的零点的毫秒数
		Date date = new Date(c.getTimeInMillis());
		return date;
	}

	public String timeFormatForRecord(long time) {
		if (mCurTime < time) {
			return "[1秒前]";
		}
		Date value = new Date(time);

		if (value.before(mYesterdayZero)) {
			return getTimeString(time, "[MM月dd日 kk:mm]");
		} else if (value.before(mTodayZero)) {
			return getTimeString(time, "[昨天 kk:mm]");
		} else {
			return getTimeString(time, "[今天 kk:mm]");
		}
	}

	public static String FormatDuration(long duration) {
		if (duration < 60) {
			return Math.max(1, duration) + "秒";
		} else {
			long minute = duration / 60;
			long second = duration % 60;
			StringBuffer result = new StringBuffer();
			result.append(minute + "分");
			if (second > 0) {
				result.append(second + "秒");
			}
			return result.toString();
		}
	}

	public String timeFormat(long time) {
		if (mCurTime < time) {
			return "1秒前";
		}
		Date value = new Date(time);

		if (value.before(mYesterdayZero)) {
			return getTimeString(time, "MM月dd日");
		} else if (value.before(mTodayZero)) {
			return "昨天";
		} else {
			long values = mCurTime - time;
			values = values / 1000;
			if (values / (60 * 60) > 0) {
				return (values / (60 * 60)) + "小时前";
			} else if (values / (60) > 0) {
				return (values / 60) + "分钟前";
			} else {
				if (values <= 0)
					values = 1;
				return values + "秒前";
			}
		}
	}

	public String timeFormatSmsTimeLine(long time, boolean showYear) {
		Date value = new Date(time);
		if (showYear) {
			return getTimeString(time, "yyyy年M月d日 HH:mm");
		}
		if (value.before(mYesterdayZero)) {
			return getTimeString(time, "M月d日 HH:mm");
		} else if (value.before(mTodayZero)) {
			return String.format("%s %s", "昨天", getTimeString(time, "HH:mm"));
		} else {
			return getTimeString(time, "HH:mm");
		}
	}

	public String timeFormatCallRecord(long time) {
		if (mCurTime < time) {
			return "1秒前";
		}
		Date value = new Date(time);

		if (value.before(mYesterdayZero)) {
			return getTimeString(time, "M月d日");
		} else if (value.before(mTodayZero)) {
			return "昨天";
		} else {
			long values = mCurTime - time;
			values = values / 1000;
			if (values / (60 * 60) > 0) {
				return (values / (60 * 60)) + "小时前";
			} else if (values / (60) > 0) {
				return (values / 60) + "分钟前";
			} else {
				return values + "秒前";
			}
		}
	}

	public String formatWeiBoTime(long time) {
		long duration = mCurTime - time;

		// （1）1小时内（显示：XX分钟前）
		if (duration <= ONE_HOUR_MILLIS) {
			return duration / 60000 + "分钟前";
		}

		Date value = new Date(time);

		// （2）当日，超过1小时（显示：XX小时前）
		if (duration > ONE_HOUR_MILLIS && value.after(mTodayZero)) {
			return duration / ONE_HOUR_MILLIS + "小时前";
		}

		// （3）昨天，前天（显示：昨天，前天）
		if (value.before(mTodayZero) && value.after(mYesterdayZero)) {
			return "昨天";
		}
		Date beforeYestday = getYesterdayZero(mYesterdayZero);
		if (value.before(mYesterdayZero) && value.after(beforeYestday)) {
			return "前天";
		}

		long duration_day = duration / (ONE_HOUR_MILLIS * 24);

		// （4）3天前~15天前（显示3天前，4天前….）
		if (duration_day < 15) {
			return duration_day + "天前";
		}

		// （5）15天前（均显示半个月前）
		if (duration_day >= 15 && duration_day < 30) {
			return "半个月前";
		}

		long duration_month = duration_day / 30;
		if (duration_month < 6) {
			return duration_month + "个月前";
		}
		if (duration_month >= 6 && duration_month < 12) {
			return "半年前";
		}

		long duration_year = duration_month / 12;
		return duration_year + "年前";
	}
}
