package com.coyotelib.core.util.coding;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import android.text.TextUtils;

import com.coyotelib.core.util.MD5Util;

public final class MD5 {
	private MD5() {
	}

	public static String encode(byte[] content) {
		try {
			MessageDigest digest = MessageDigest.getInstance("MD5");
			digest.update(content);
			return toHex(digest.digest());
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		}
	}

	private static String toHex(byte[] buf) {
		StringBuilder sBuilder = new StringBuilder(MD5Util.MD5LENGTH * 2);
		for (int i = 0; i < buf.length; i++) {
			int hi = buf[i] >> 4 & 0x0f;
			int lo = buf[i] & 0x0f;
			sBuilder.append((char) (hi > 9 ? (hi - 10 + 'a') : (hi + '0')));
			sBuilder.append((char) (lo > 9 ? (lo - 10 + 'a') : (lo + '0')));
		}
		return sBuilder.toString();
	}

	public boolean check(byte[] content, String md5) {
		if (TextUtils.isEmpty(md5))
			return false;
		return md5.equals(encode(content));
	}
}
