package com.coyotelib.core.util.coding;

import java.io.UnsupportedEncodingException;

public abstract class AbstractCoding {
	protected static String UTF8_CHARSET = "utf-8";

	public abstract byte[] encode(byte[] input);

	public abstract byte[] decode(byte[] input);

	public final byte[] encodeUTF8ToBytes(String str) {
		try {
			return encode(str.getBytes(UTF8_CHARSET));
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}

	public final String encodeUTF8ToUTF8(String str) {
		try {
			byte[] encodedBytes = encodeUTF8ToBytes(str);
			if (encodedBytes == null)
				return null;
			return new String(encodedBytes, UTF8_CHARSET);
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}

	public String encodeBytesToUTF8(byte[] input) {
		byte[] encodedBytes = encode(input);
		if (encodedBytes == null)
			return null;
		try {
			return new String(encodedBytes, UTF8_CHARSET);
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}

	public byte[] decodeUTF8ToBytes(String encodedStr) {
		if (encodedStr == null)
			return null;
		try {
			return decode(encodedStr.getBytes(UTF8_CHARSET));
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}

	public final String decodeBytesToUTF8(byte[] input) {
		byte[] decodedBytes = decode(input);
		if (decodedBytes == null)
			return null;
		try {
			return new String(input, UTF8_CHARSET);
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}
}
