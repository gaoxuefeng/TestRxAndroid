package cn.com.ethank.yunge.app.util;

import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;

public class SignUtils {

	private static final String ALGORITHM = "RSA";

	private static final String SIGN_ALGORITHMS = "SHA1WithRSA";

	private static final String DEFAULT_CHARSET = "UTF-8";

	public static String sign(String content, String privateKey) {
		try {
			byte b[] = Base64.decode(privateKey);
			// byte b[] = privateKey.getBytes();
			PKCS8EncodedKeySpec priPKCS8 = new PKCS8EncodedKeySpec(b);

			// KeyFactory keyf = KeyFactory.getInstance(ALGORITHM);
			KeyFactory keyf = KeyFactory.getInstance(ALGORITHM, "BC");

			PrivateKey priKey = keyf.generatePrivate(priPKCS8);

			java.security.Signature signature = java.security.Signature.getInstance(SIGN_ALGORITHMS);

			signature.initSign(priKey);
			signature.update(content.getBytes(DEFAULT_CHARSET));

			byte[] signed = signature.sign();

			return Base64.encode(signed);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

}
