package com.coyotelib.core.util.coding;

import java.io.UnsupportedEncodingException;

public class Base64Coding extends AbstractCoding {

	@Override
	public byte[] encode(byte[] input) {
		String encodedStr = Base64.encode(input);
		if (encodedStr == null)
			return null;
		try {
			return encodedStr.getBytes(UTF8_CHARSET);
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}

	@Override
	public byte[] decode(byte[] input) {
		if (input == null)
			return null;
		try {
			return Base64.decode(new String(input, UTF8_CHARSET));
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}

	@Override
	public String encodeBytesToUTF8(byte[] input) {
		return Base64.encode(input);
	}

	@Override
	public byte[] decodeUTF8ToBytes(String encodedStr) {
		return Base64.decode(encodedStr);
	}
}
