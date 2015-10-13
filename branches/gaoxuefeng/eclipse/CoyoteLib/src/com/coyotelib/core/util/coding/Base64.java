package com.coyotelib.core.util.coding;

import java.io.IOException;

final class Base64 {
	private Base64() {
	}

	/**
	 * This character array provides the alphabet map from RFC1521.
	 */
	private final static char ALPHABET[] = {
			// 0 1 2 3 4 5 6 7
			'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', // 0
			'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', // 1
			'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', // 2
			'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', // 3
			'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', // 4
			'o', 'p', 'q', 'r', 's', 't', 'u', 'v', // 5
			'w', 'x', 'y', 'z', '0', '1', '2', '3', // 6
			'4', '5', '6', '7', '8', '9', '+', '/' // 7
	};

	/**
	 * Decodes a 7 bit Base64 character into its binary value.
	 */
	private static int valueDecoding[] = new int[128];

	/**
	 * initializes the value decoding array from the character map
	 */
	static {
		for (int i = 0; i < valueDecoding.length; i++) {
			valueDecoding[i] = -1;
		}

		for (int i = 0; i < ALPHABET.length; i++) {
			valueDecoding[ALPHABET[i]] = i;
		}
	}

	/**
	 * Converts a byte array into a Base64 encoded string.
	 * 
	 * @param data
	 *            bytes to encode
	 * @param offset
	 *            which byte to start at
	 * @param length
	 *            how many bytes to encode; padding will be added if needed
	 * @return base64 encoding of data; 4 chars for every 3 bytes
	 */
	private static String encode(byte[] data, int offset, int length) {
		// 4 chars for 3 bytes, run input up to a multiple of 3
		final int encodedLen = (length + 2) / 3 * 4;
		char[] encoded = new char[encodedLen];

		for (int i = 0, r = 0; r < encodedLen; i += 3, r += 4) {
			encodeQuantum(data, offset + i, length - i, encoded, r);
		}
		return String.valueOf(encoded);
	}

	/**
	 * Encodes 1, 2, or 3 bytes of data as 4 Base64 chars.
	 * 
	 * @param in
	 *            buffer of bytes to encode
	 * @param inOffset
	 *            where the first byte to encode is
	 * @param len
	 *            how many bytes to encode
	 * @param out
	 *            buffer to put the output in
	 * @param outOffset
	 *            where in the output buffer to put the chars
	 */
	private static void encodeQuantum(byte in[], int inOffset, int len,
			char out[], int outOffset) {
		byte a = 0, b = 0, c = 0;

		a = in[inOffset];
		out[outOffset] = ALPHABET[(a >>> 2) & 0x3F];

		if (len > 2) {
			b = in[inOffset + 1];
			c = in[inOffset + 2];
			out[outOffset + 1] = ALPHABET[((a << 4) & 0x30) + ((b >>> 4) & 0xf)];
			out[outOffset + 2] = ALPHABET[((b << 2) & 0x3c) + ((c >>> 6) & 0x3)];
			out[outOffset + 3] = ALPHABET[c & 0x3F];
		} else if (len > 1) {
			b = in[inOffset + 1];
			out[outOffset + 1] = ALPHABET[((a << 4) & 0x30) + ((b >>> 4) & 0xf)];
			out[outOffset + 2] = ALPHABET[((b << 2) & 0x3c) + ((c >>> 6) & 0x3)];
			out[outOffset + 3] = '=';
		} else {
			out[outOffset + 1] = ALPHABET[((a << 4) & 0x30) + ((b >>> 4) & 0xf)];
			out[outOffset + 2] = '=';
			out[outOffset + 3] = '=';
		}
	}

	/**
	 * Converts an embedded Base64 encoded string to a byte array.
	 * 
	 * @param encoded
	 *            a String with Base64 data embedded in it
	 * @param offset
	 *            which char of the String to start at
	 * @param length
	 *            how many chars to decode; must be a multiple of 4
	 * @return decode binary data; 3 bytes for every 4 chars - minus padding
	 * @exception IOException
	 *                is thrown, if an I/O error occurs reading the data
	 */
	private static byte[] decode(String encoded, int offset, int length)
			throws IOException {
		// the input must be a multiple of 4
		if (length % 4 != 0) {
			throw new IOException("Base64 string length is not multiple of 4");
		}

		try {
			// 4 chars for 3 bytes, but there may have been pad bytes
			int decodedLen = length / 4 * 3;
			if (encoded.charAt(offset + length - 1) == '=') {
				decodedLen--;
				if (encoded.charAt(offset + length - 2) == '=') {
					decodedLen--;
				}
			}

			byte[] decoded = new byte[decodedLen];
			for (int i = 0, r = 0; i < length; i += 4, r += 3) {
				decodeQuantum(encoded.charAt(offset + i),
						encoded.charAt(offset + i + 1),
						encoded.charAt(offset + i + 2),
						encoded.charAt(offset + i + 3), decoded, r);
			}

			return decoded;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * Decode 4 Base64 chars as 1, 2, or 3 bytes of data.
	 * 
	 * @param in1
	 *            first char of quantum to decode
	 * @param in2
	 *            second char of quantum to decode
	 * @param in3
	 *            third char of quantum to decode
	 * @param in4
	 *            forth char of quantum to decode
	 * @param out
	 *            buffer to put the output in
	 * @param outOffset
	 *            where in the output buffer to put the bytes
	 */
	private static void decodeQuantum(char in1, char in2, char in3, char in4,
			byte[] out, int outOffset) throws IOException {
		int a = 0, b = 0, c = 0, d = 0;
		int pad = 0;

		a = valueDecoding[in1 & 127];
		b = valueDecoding[in2 & 127];

		if (in4 == '=') {
			pad++;
			if (in3 == '=') {
				pad++;
			} else {
				c = valueDecoding[in3 & 127];
			}
		} else {
			c = valueDecoding[in3 & 127];
			d = valueDecoding[in4 & 127];
		}

		if (a < 0 || b < 0 || c < 0 || d < 0) {
			throw new IOException("Invalid character in Base64 string");
		}

		// the first byte is the 6 bits of a and 2 bits of b
		out[outOffset] = (byte) (((a << 2) & 0xfc) | ((b >>> 4) & 3));

		if (pad < 2) {
			// the second byte is 4 bits of b and 4 bits of c
			out[outOffset + 1] = (byte) (((b << 4) & 0xf0) | ((c >>> 2) & 0xf));

			if (pad < 1) {
				// the third byte is 2 bits of c and 4 bits of d
				out[outOffset + 2] = (byte) (((c << 6) & 0xc0) | (d & 0x3f));
			}
		}
	}

	/**
	 * encode to base64 string
	 */
	public static String encode(byte[] value) {
		if (value == null)
			return null;
		return encode(value, 0, value.length);
	}

	/**
	 * Converts a Base64 encoded string to a byte array.
	 * 
	 * @param encoded
	 *            Base64 encoded data
	 * @return decode binary data; 3 bytes for every 4 chars - minus padding
	 * @exception IOException
	 *                is thrown, if an I/O error occurs reading the data
	 */
	public static byte[] decode(String encoded) {
		if (encoded == null)
			return null;

		try {
			return decode(encoded, 0, encoded.length());
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}

	}
}
