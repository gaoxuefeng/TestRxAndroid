package com.coyotelib.core.util.file;

import java.io.BufferedInputStream;
import java.io.InputStream;

public class PlainFileReader extends FileReader {
	@Override
	public InputStream readAsInputStream(InputStream stream) {
		return new BufferedInputStream(stream);
	}
}
