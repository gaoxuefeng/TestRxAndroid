package com.coyotelib.core.util.coding;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

import com.coyotelib.core.util.StreamUtil;

final class Zip {
	private Zip() {
	}

	public static byte[] zip(byte[] content) {
		if (content == null)
			return null;

		ByteArrayOutputStream bos = null;
		try {
			bos = new ByteArrayOutputStream();
			BufferedOutputStream out = new BufferedOutputStream(
					new GZIPOutputStream(bos));

			out.write(content);
			out.flush();
			out.close();
			return bos.toByteArray();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			StreamUtil.close(bos);
		}
		return null;
	}

	static InputStream getUnzippedInputStream(InputStream input) {
		if (input == null)
			return null;
		try {
			return new GZIPInputStream(input);
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
}
