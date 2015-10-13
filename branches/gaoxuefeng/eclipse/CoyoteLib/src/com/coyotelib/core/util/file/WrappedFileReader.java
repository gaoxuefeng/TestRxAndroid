package com.coyotelib.core.util.file;

import java.io.InputStream;

public abstract class WrappedFileReader extends FileReader {
	protected FileReader mInternalReader;

	public WrappedFileReader(FileReader toBeWrappedReader) {
		mInternalReader = toBeWrappedReader;
	}

	@Override
	public final InputStream readAsInputStream(InputStream stream) {
		InputStream internalStream = mInternalReader.readAsInputStream(stream);
		if (internalStream == null)
			return null;
		return wrappedInputStream(internalStream);
	}

	protected abstract InputStream wrappedInputStream(InputStream stream);
}
