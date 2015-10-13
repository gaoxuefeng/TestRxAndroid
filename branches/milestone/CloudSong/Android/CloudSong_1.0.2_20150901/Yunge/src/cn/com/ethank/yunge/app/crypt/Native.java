package cn.com.ethank.yunge.app.crypt;


import java.io.UnsupportedEncodingException;

public final class Native {
	static {
		try {
			System.loadLibrary("ETHANKENCRYPT");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public static byte[] decryptCommon(String cipherText) {
		
		return decryptCommon(stringToBytes(cipherText));
	}

	public static byte[] encryptCommon(String clearText) {
		
		return encryptCommon(stringToBytes(clearText));
	}

	public static byte[] decryptCommon(byte[] bytes) {
		if (bytes == null)
			return null;
		int len = bytes.length;
		if (len % 16 != 0) {
			len = len - len % 16 + 16;
		}
		byte[] content = new byte[len];
		System.arraycopy(bytes, 0, content, 0, bytes.length);
		return decrypt(content, len);
	}

	public static byte[] encryptCommon(byte[] clearBytes) {
		if (clearBytes == null)
			return null;
		int len = clearBytes.length;
		if (len % 16 != 0) {
			len = len - len % 16 + 16;
		}
		byte[] content = new byte[len];
		System.arraycopy(clearBytes, 0, content, 0, clearBytes.length);
		return encrypt(content, len);

	}


	private static native byte[] encrypt(byte[] clear, int len);

	private static native byte[] decrypt(byte[] cipher, int len);

	private static byte[] stringToBytes(String aes) {
		try {
			return aes.getBytes("utf-8");
		} catch (UnsupportedEncodingException e) {
			return null;
		}
	}
}
