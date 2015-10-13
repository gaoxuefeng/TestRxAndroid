package com.coyotelib.core.util.coding;

public class PlainCoding extends AbstractCoding {

	@Override
	public byte[] encode(byte[] input) {
		return input;
	}

	@Override
	public byte[] decode(byte[] input) {
		return input;
	}

}
