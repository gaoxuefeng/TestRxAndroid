package com.coyotelib.core.util.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import com.coyotelib.core.util.StreamUtil;

public abstract class FileReader {
	public abstract InputStream readAsInputStream(InputStream stream);

	public byte[] readBytes(InputStream stream) {
		if (stream == null) {
			return null;
		}
		InputStream wrappedIs = readAsInputStream(stream);
		if (wrappedIs == null)
			return null;
		return FileUtil.readBytes(wrappedIs);
	}

	public final byte[] readBytes(String filePath) {
		InputStream fis = null;
		InputStream resutIs = null;
		try {
			File f = new File(filePath);
			if (!f.exists())
				return null;
			fis = new FileInputStream(f);
			return readBytes(fis);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			StreamUtil.close(resutIs);
			StreamUtil.close(fis);
			return null;
		}
	}

	public final String readUTF8String(String path) {
		byte[] tmp = readBytes(path);
		if (tmp == null || tmp.length == 0)
			return null;
		try {
			return new String(tmp, "utf-8");
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}

	public final String readUTF8String(InputStream stream) {
		byte[] tmp = readBytes(stream);
		if (tmp == null || tmp.length == 0)
			return null;
		try {
			return new String(tmp, "utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
	}
}
