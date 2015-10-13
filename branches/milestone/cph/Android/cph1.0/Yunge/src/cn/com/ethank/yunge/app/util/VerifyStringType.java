package cn.com.ethank.yunge.app.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class VerifyStringType {

	public static boolean isMobileNO(String mobiles) {
		if (mobiles == null) {
			return false;
		}
		Pattern p = Pattern.compile("^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$");
		Matcher m = p.matcher(mobiles);

		return m.matches();
	}

	// 判断email格式是否正确
	public static boolean isEmail(String email) {
		String str = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
		Pattern p = Pattern.compile(str);
		Matcher m = p.matcher(email);

		return m.matches();
	}

	public static boolean isAToZ(String string) {
		String str = "^([A-Z])$";
		Pattern p = Pattern.compile(str);
		Matcher m = p.matcher(string);

		return m.matches();
	}

	// 判断是否全是数字
	public static boolean isNumeric(String str) {
		Pattern pattern = Pattern.compile("[0-9]*");
		Matcher isNum = pattern.matcher(str);
		if (!isNum.matches()) {
			return false;
		}
		return true;

	}

	// 是不是float或数字
	public static boolean isFloatOrNum(String str) {
		try {
			if (str == null) {
				return false;
			}
			return str.matches("^[-+]?(([0-9]+)([.]([0-9]+))?|([.]([0-9]+))?)$");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;

	}
}
