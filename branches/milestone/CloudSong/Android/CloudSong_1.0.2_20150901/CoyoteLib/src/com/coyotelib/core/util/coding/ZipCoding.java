package com.coyotelib.core.util.coding;

import com.coyotelib.core.jni.Native;

public class ZipCoding extends AbstractCoding {

	@Override
	public byte[] encode(byte[] input) {
		return Zip.zip(input);
	}

	@Override
	public byte[] decode(byte[] input) {
		return Native.unzip(input);
	}

}
