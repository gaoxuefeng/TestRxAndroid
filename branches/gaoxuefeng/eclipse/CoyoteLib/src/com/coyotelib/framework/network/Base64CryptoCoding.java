package com.coyotelib.framework.network;

import com.coyotelib.core.util.coding.AbstractCoding;
import com.coyotelib.core.util.coding.Base64Coding;

public class Base64CryptoCoding extends AbstractCoding {
	private Base64Coding mBase64 = new Base64Coding();
//	private CryptoCoding mCrypto = new CryptoCoding();

	@Override
	public byte[] encode(byte[] input) {
		return mBase64.encode(/*mCrypto.encode(*/input/*)*/);
	}

	@Override
	public byte[] decode(byte[] input) {
		return /*mCrypto.decode(*/mBase64.decode(input)/*)*/;
	}

}
