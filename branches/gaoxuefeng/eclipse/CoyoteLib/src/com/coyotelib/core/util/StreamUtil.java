package com.coyotelib.core.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

public class StreamUtil {

	private static final int BUFFER_SIZE = 4 * 1024;

	public static InputStream rawInputStreamForFile(String filePath) {
		try {
			return new FileInputStream(new File(filePath));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}

	public static void close(Closeable stream) {
		if (stream == null)
			return;
		try {
			stream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static byte[] inputStreamToBytes(InputStream stream) {
		if (stream == null)
			return null;
		ByteArrayOutputStream bos = null;
		try {
			bos = new ByteArrayOutputStream();
			int count = 0;
			byte tmpData[] = new byte[BUFFER_SIZE];
			while ((count = stream.read(tmpData, 0, BUFFER_SIZE)) > 0) {
				bos.write(tmpData, 0, count);
			}
			return bos.toByteArray();
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		} finally {
			close(stream);
			close(bos);
		}
	}

	public static InputStream bytesToInputStream(byte[] bytes) {
		if (bytes == null)
			return null;
		return new ByteArrayInputStream(bytes);
	}
}
