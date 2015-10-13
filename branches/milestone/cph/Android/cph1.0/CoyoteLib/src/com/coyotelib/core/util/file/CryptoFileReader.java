package com.coyotelib.core.util.file;

import java.io.InputStream;

import com.coyotelib.core.util.StreamUtil;
import com.coyotelib.core.util.coding.CryptoCoding;

public class CryptoFileReader extends WrappedFileReader {

	private CryptoCoding mCryptoCoding = new CryptoCoding();
	
	public CryptoFileReader(FileReader toBeWrappedReader) {
		super(toBeWrappedReader);
	}

	@Override
	protected InputStream wrappedInputStream(InputStream stream) {
		return StreamUtil.bytesToInputStream(mCryptoCoding.decode(StreamUtil.inputStreamToBytes(stream)));
	}
	
	// optimized reading
	@Override
	public byte[] readBytes(InputStream stream) {
		byte[] input = FileUtil.readBytes(mInternalReader
				.readAsInputStream(stream));
		return mCryptoCoding.decode(input);
	}

}
