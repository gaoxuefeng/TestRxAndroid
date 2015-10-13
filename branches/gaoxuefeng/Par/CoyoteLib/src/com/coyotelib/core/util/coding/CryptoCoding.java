package com.coyotelib.core.util.coding;

import com.coyotelib.core.jni.Native;

public class CryptoCoding extends AbstractCoding{

	@Override
	public byte[] encode(byte[] input) {
		return Native.encryptCommon(input);
	}

	@Override
	public byte[] decode(byte[] input) {
		return Native.decryptCommon(input);
	}

}
