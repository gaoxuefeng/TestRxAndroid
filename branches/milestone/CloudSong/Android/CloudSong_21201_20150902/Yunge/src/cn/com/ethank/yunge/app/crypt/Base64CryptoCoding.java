package cn.com.ethank.yunge.app.crypt;

import android.util.Log;

import com.coyotelib.core.util.coding.AbstractCoding;
import com.coyotelib.core.util.coding.Base64Coding;

public class Base64CryptoCoding extends AbstractCoding {
	private Base64Coding mBase64 = new Base64Coding();
	private CryptoCoding mCrypto = new CryptoCoding();

	@Override
	public byte[] encode(byte[] input) {
		long currenTime = System.currentTimeMillis();
		Log.i("encode加密", "开始加密" + Thread.currentThread().getId());
		byte[] result = mBase64.encode(mCrypto.encode(input));
		Log.i("encode加密", "加密结束" + "费时:" + (System.currentTimeMillis() - currenTime) + "-线程:" + Thread.currentThread().getId());
		return result;
	}

	public String encode(String utf8Str) {
		byte[] utf8Bytes = encodeUTF8ToBytes(utf8Str);
		if (utf8Bytes == null)
			return null;
		long currenTime = System.currentTimeMillis();
		Log.i("encode加密", "开始加密" + Thread.currentThread().getId());
		byte[] result = mBase64.encode(mCrypto.encode(utf8Bytes));
		Log.i("encode加密", "加密结束" + "费时:" + (System.currentTimeMillis() - currenTime) + "-线程:" + Thread.currentThread().getId());
		return mBase64.encodeBytesToUTF8(result);
	}

	@Override
	public byte[] decode(byte[] input) {
		long currenTime = System.currentTimeMillis();
		Log.i("encode解密", "开始解密" + Thread.currentThread().getId());
		byte[] result = mCrypto.decode(mBase64.decode(input));
		Log.i("encode解密", "解密结束" + "费时:" + (System.currentTimeMillis() - currenTime) + "-线程:" + Thread.currentThread().getId());
		return result;
	}

}
