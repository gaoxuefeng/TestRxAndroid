package com.coyotelib.core.util.coding;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

public class UrlCoding extends AbstractCoding {

	@Override
	public byte[] encode(byte[] input) {
		try {
			return URLEncoder.encode(new String(input, "utf-8"), "utf-8").getBytes();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public byte[] decode(byte[] input) {
		try {
			return URLDecoder.decode(new String(input, "utf-8"), "utf-8").getBytes();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
	}

}
