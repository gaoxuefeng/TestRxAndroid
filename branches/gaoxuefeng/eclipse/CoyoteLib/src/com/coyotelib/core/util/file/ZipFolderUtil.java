package com.coyotelib.core.util.file;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import com.coyotelib.core.util.StreamUtil;

public class ZipFolderUtil {

	public static boolean zipToFolder(String filePath, String destFolder) {
		PlainFileReader pfr = new PlainFileReader();
		byte[] content = pfr.readBytes(filePath);
		InputStream in = new ByteArrayInputStream(content);
		return zipToFolder(in, destFolder);
	}

	public static boolean zipToFolder(InputStream in, String destFolder) {
		boolean result = false;
		FileUtil.createDirs(destFolder);
		int BUFFER = 4096;
		String strEntry;
		String subFileName;
		ZipInputStream zis = null;
		BufferedOutputStream dest = null;

		try {
			zis = new ZipInputStream(new BufferedInputStream(in));
			ZipEntry entry;
			int entryCount = 0;
			while ((entry = zis.getNextEntry()) != null) {
				++entryCount;
				int count;
				byte data[] = new byte[BUFFER];
				subFileName = entry.getName();
				strEntry = Path.appendedString(destFolder, subFileName);
				FileOutputStream fos = new FileOutputStream(new File(strEntry));
				dest = new BufferedOutputStream(fos, BUFFER);
				while ((count = zis.read(data, 0, BUFFER)) != -1) {
					dest.write(data, 0, count);
				}
				dest.flush();
				dest.close();
			}
			result = entryCount > 0;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			StreamUtil.close(zis);
			StreamUtil.close(in);
		}
		return result;
	}

}
