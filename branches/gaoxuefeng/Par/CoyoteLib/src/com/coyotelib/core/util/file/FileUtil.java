package com.coyotelib.core.util.file;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import android.content.Context;
import android.text.TextUtils;

import com.coyotelib.core.util.StreamUtil;

public final class FileUtil {

	public static byte[] readBytes(InputStream stream) {
		return StreamUtil.inputStreamToBytes(stream);
	}

	public static String readUTF8String(InputStream stream) {
		byte[] buff = readBytes(stream);
		if (buff == null)
			return null;
		try {
			return new String(buff, "utf-8");
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}

	public static byte[] readBytes(String filePath) {
		if (TextUtils.isEmpty(filePath))
			return null;

		BufferedInputStream bis = null;
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(new File(filePath));
			bis = new BufferedInputStream(fis);
			return readBytes(bis);
		} catch (FileNotFoundException e) {
			e.printStackTrace();

		} finally {
			StreamUtil.close(bis);
			StreamUtil.close(fis);
		}
		return null;
	}

	public static String readString(String filePath, String encode) {
		byte[] bytes = readBytes(filePath);
		if (bytes == null)
			return null;
		try {
			return new String(bytes, encode);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
	}

	public static String readUTF8String(String filePath) {
		return readString(filePath, "utf-8");
	}

	public static boolean createDirs(String dirPath) {
		File folder = new File(dirPath);
		if (!(folder.exists()) && !(folder.isDirectory())) {
			return folder.mkdirs();
		}
		return false;
	}

	public static boolean deleteFile(String filePath) {
		File localfile = new File(filePath);
		if (localfile.exists() && localfile.isFile()) {
			return localfile.delete();
		}
		return false;
	}

	public static void deleteFolder(String folderPath) {
		File localFolder = new File(folderPath);
		if (localFolder.isDirectory()) {
			String[] childrenStrings = localFolder.list();
			int length = childrenStrings.length;
			for (int i = 0; i < length; i++) {
				File temp = new File(localFolder, childrenStrings[i]);
				if (temp.isDirectory()) {
					deleteFolder(temp.getName());
				} else {
					temp.delete();
				}
			}
			localFolder.delete();
		}
	}

	public static boolean renameFolder(String oldFolderPath,
			String newFolderPath) {
		return renamePath(oldFolderPath, newFolderPath, true);
	}

	public static boolean renameFile(String oldFilePath, String newFilePath) {
		return renamePath(oldFilePath, newFilePath, false);
	}

	private static boolean renamePath(String oldPath, String newPath,
			boolean isDir) {
		if (oldPath == null || newPath == null)
			return false;
		File localFile = new File(oldPath);
		File newFile = new File(newPath);
		if (localFile.exists()
				&& (isDir ? localFile.isDirectory() : localFile.isFile())) {
			if (newFile.exists()
					&& (isDir ? newFile.isDirectory() : newFile.isFile()))

				if (isDir) {
					deleteFolder(newPath);
				} else {
					newFile.delete();
				}
			return localFile.renameTo(newFile);
		}
		return false;
	}

	private static boolean checkPath(String path, boolean checkDir) {
		if (path == null)
			return false;
		File localFile = new File(path);
		if (!localFile.exists()) {
			return false;
		}
		return checkDir ? localFile.isDirectory() : localFile.isFile();
	}

	public static boolean isFileExist(String filePath) {
		return checkPath(filePath, false);
	}

	public static boolean isFolderExist(String filePath) {
		return checkPath(filePath, true);
	}

	public static boolean writeUTF8String(String filePath, String str) {
		if (TextUtils.isEmpty(str))
			return true;
		try {
			return writeBytes(filePath, str.getBytes("utf-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return false;
		}
	}

	public static boolean writeBytes(String filePath, byte[] bytes) {
		if (bytes == null || bytes.length == 0 || TextUtils.isEmpty(filePath)) {
			return false;
		}
		FileOutputStream fos = null;
		try {
			File file = new File(filePath);
			if (!file.exists()) {
				createDirs(file.getParent());
			}
			fos = new FileOutputStream(file);
			fos.write(bytes);
			return true;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			StreamUtil.close(fos);
		}
		return false;
	}

	public static boolean appendBytes(String filePath, byte[] bytes, int length)
			throws IOException {
		if (bytes == null || bytes.length == 0 || TextUtils.isEmpty(filePath)) {
			return false;
		}
		FileOutputStream fos = null;
		Exception ee = null;
		try {
			File file = new File(filePath);
			if (!file.exists()) {
				return false;
			}
			fos = new FileOutputStream(file, true);
			fos.write(bytes, 0, length);
			return true;
		} catch (FileNotFoundException e) {
			ee = e;
			e.printStackTrace();
		} catch (IOException e) {
			ee = e;
			e.printStackTrace();
		} finally {
			StreamUtil.close(fos);
			if (ee != null) {
				throw new IOException(ee.getMessage());
			}
		}
		return false;
	}

	public static boolean createFile(String fileName) {
		File file = new File(fileName);
		if (!(file.exists())) {
			try {
				return file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return false;
	}

	public static boolean isFileExist(Context context, String fileName) {
		String[] fileNameArray = context.fileList();
		for (String f : fileNameArray) {
			if (f.equals(fileName)) {
				return true;
			}
		}
		return false;
	}

	public static boolean isNewThan(String firstFileName, String secondFileName) {
		File file1 = new File(firstFileName);
		File file2 = new File(secondFileName);
		if (file1.exists() && file2.exists()) {
			return file1.lastModified() > file2.lastModified();
		}
		return false;
	}
}
