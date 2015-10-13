package cn.com.ethank.yunge.app.catering.utils;

import java.text.DecimalFormat;

public class SubZeroAndDot {
	/**
	 * 使用java正则表达式去掉多余的.与0
	 * 
	 * @param s
	 * @return
	 */
	public static String subZeroAndDot(String s) {

		// 先四舍五入取小数点后两位
		float scale = Float.parseFloat(s);
		DecimalFormat fnum = new DecimalFormat("##0.00");
		String dd = fnum.format(scale);

		// 去掉小数点最后无效的0
		if (dd.indexOf(".") > 0) {
			dd = dd.replaceAll("0+?$", "");// 去掉多余的0
			dd = dd.replaceAll("[.]$", "");// 如最后一位是.则去掉
		}
		return dd;
	}

}
