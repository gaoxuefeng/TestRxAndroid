package cn.com.ethank.yunge.app.util;

import cn.com.ethank.yunge.app.util.StringUtil.CharType;

public class GetTextLengh {
	public static  int textLenth(String content) {
		int length = 0;
		char[] q = content.toString().toCharArray();
		for (int i = 0; i < q.length; i++) {
			CharType ct = StringUtil.checkType(q[i]);
			switch (ct) {
			case CHINESE:
				length = length + 2;
				break;
			case OTHER:
			case SPECIAL:
			case JAPANESE:
			case NUM:
			case LETTER:
			case DELIMITER:
				length = length + 1;
				break;
			default:
				break;
			}
		}
		return length;
	}
}
