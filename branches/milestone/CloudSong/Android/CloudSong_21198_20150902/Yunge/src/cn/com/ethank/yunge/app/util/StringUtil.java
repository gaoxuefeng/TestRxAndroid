package cn.com.ethank.yunge.app.util;

import android.text.Editable;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextWatcher;
import android.widget.EditText;

public final class StringUtil {

	public enum CharType {
		DELIMITER, // 非字母截止字符，例如，．）（　等等　（ 包含U0000-U0080）
		NUM, // 2字节数字１２３４
		LETTER, // gb2312中的，例如:ＡＢＣ，2字节字符同时包含 1字节能表示的 basic latin and latin-1
				// OTHER,// 其他字符
		CHINESE, // 中文字
		OTHER, SPECIAL, JAPANESE; // ④类似于这种编码
	}

	public interface EditTextCallBack {
		void after(String result);
	}

	static int len = 0;

	public static void setEditContentlimit(final EditTextCallBack editTextCallBack, final EditText editText) {

		editText.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
				// TODO Auto-generated method stub
			}

			@Override
			public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
				// TODO Auto-generated method stub
				len = textLenth(arg0.toString());
				if (len > 20) {
					editText.setFilters(new InputFilter[] { new InputFilter() {
						@Override
						public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
							return "";
						}
					} });
				} else {
					editText.setFilters(new InputFilter[] { new InputFilter() {
						@Override
						public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
							StringBuffer sb = new StringBuffer();
							char[] q = source.toString().toCharArray();
							int newlen = 0;
							for (int i = 0; i < q.length; i++) {
								CharType ct = checkType(q[i]);
								switch (ct) {
								case CHINESE:
									newlen = newlen + 2;
									break;
								default:
									newlen = newlen + 1;
									break;
								}
								if (newlen > (20 - textLenth(dest.toString()))) {
									break;
								} else {
									sb.append(q[i]);
								}
							}
							return sb.toString();
						}
					} });
				}
			}

			@Override
			public void afterTextChanged(Editable arg0) {
				editTextCallBack.after(arg0.toString());
			}
		});
	}

	public static CharType checkType(char c) {
		CharType ct = null;
		// 中文，编码区间0x4e00-0x9fbb
		if ((c >= 0x4e00) && (c <= 0x9fbb)) {
			ct = CharType.CHINESE;
		} else if ((c >= '①') && (c <= '⑨')) {
			ct = CharType.SPECIAL;
		} else if (((c >= 0x3040) && (c <= 0x309F)) || ((c >= 0x30A0) && (c <= 0x30FF))) {
			ct = CharType.JAPANESE;
		}

		// Halfwidth and Fullwidth Forms， 编码区间0xff00-0xffef
		else if ((c >= 0xff00) && (c <= 0xffef)) {
			// 2字节英文字
			if (((c >= 0xff21) && (c <= 0xff3a)) || ((c >= 0xff41) && (c <= 0xff5a))) {
				ct = CharType.LETTER;
			}
			// 2字节数字
			else if ((c >= 0xff10) && (c <= 0xff19)) {
				ct = CharType.NUM;
			}
			// 其他字符，可以认为是标点符号
			else
				ct = CharType.DELIMITER;
		}
		// basic latin，编码区间 0000-007f
		else if ((c >= 0x0021) && (c <= 0x007e)) {
			// 1字节数字
			if ((c >= 0x0030) && (c <= 0x0039)) {
				ct = CharType.NUM;
			}
			// 1字节字符
			else if (((c >= 0x0041) && (c <= 0x005a)) || ((c >= 0x0061) && (c <= 0x007a))) {
				ct = CharType.LETTER;
			}
			// 其他字符，可以认为是标点符号
			else
				ct = CharType.DELIMITER;
		}
		// latin-1，编码区间0080-00ff
		else if ((c >= 0x00a1) && (c <= 0x00ff)) {
			if ((c >= 0x00c0) && (c <= 0x00ff)) {
				ct = CharType.LETTER;
			} else
				ct = CharType.DELIMITER;
		} else
			ct = CharType.OTHER;
		return ct;
	}

	public static int textLenth(String content) {
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
