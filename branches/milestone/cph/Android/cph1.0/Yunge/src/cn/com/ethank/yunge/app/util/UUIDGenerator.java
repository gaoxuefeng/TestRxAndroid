package cn.com.ethank.yunge.app.util;

import java.util.UUID;

public class UUIDGenerator {
	public UUIDGenerator() {

	}

	/**
	 * 生成一个uuid
	 * 
	 * @return
	 */
	public static String getUUID() {
		UUID uuid = UUID.randomUUID();
		String str = uuid.toString();
		String temp = str.replaceAll("-", "");
		return temp;
	}
}
