package com.example.yungelight;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;

/**
 * 使用JavaSocket编写发送TCP请求的工具类
 * 
 */
public class TCPUtil {
	private TCPUtil() {
	}

	/**
	 * 
	 * @return localPort--本地绑定的端口,reqData--请求报文,respData--响应报文,respDataHex--
	 *         远程主机响应的原始字节的十六进制表示
	 */
	public static Map<String, String> sendTCPRequest(String IP, String port, String reqData, String reqCharset, byte[] reqByte) {
		Map<String, String> respMap = new HashMap<String, String>();
		OutputStream out = null; // 写
		InputStream in = null; // 读
		String localPort = null; // 本地绑定的端口(java socket, client,
									// /127.0.0.1:50804 => /127.0.0.1:9901)
		String respData = null; // 响应报文
		String respDataHex = null; // 远程主机响应的原始字节的十六进制表示
		Socket socket = new Socket(); // 客户机
		try {
			socket.setTcpNoDelay(true);
			socket.setReuseAddress(true);
			socket.setSoTimeout(5000);
			socket.setSoLinger(true, 5);
			socket.setSendBufferSize(1024);
			socket.setReceiveBufferSize(1024);
			socket.setKeepAlive(true);
			socket.connect(new InetSocketAddress(IP, Integer.parseInt(port)), 5000);
			localPort = String.valueOf(socket.getLocalPort());
			/**
			 * 发送HTTP请求
			 */
			out = socket.getOutputStream();
			// out.write(reqData.getBytes(reqCharset));
			out.write(reqByte);
			/**
			 * 接收HTTP响应
			 */
			in = socket.getInputStream();
			ByteArrayOutputStream bytesOut = new ByteArrayOutputStream();
			byte[] buffer = new byte[512];
			int len = -1;
			while ((len = in.read(buffer)) != -1) {
				bytesOut.write(buffer, 0, len);
			}
			/**
			 * 解码HTTP响应的完整报文
			 */
			respData = bytesOut.toString(reqCharset);
			respDataHex = formatToHexStringWithASCII(bytesOut.toByteArray());
		} catch (Exception e) {
 			System.out.println("与[" + IP + ":" + port + "]通信遇到异常,堆栈信息如下");
			e.printStackTrace();
		} finally {
			if (null != socket && socket.isConnected() && !socket.isClosed()) {
				try {
					socket.close();
				} catch (IOException e) {
					System.out.println("关闭客户机Socket时发生异常,堆栈信息如下");
					e.printStackTrace();
				}
			}
		}
		respMap.put("localPort", localPort);
		respMap.put("reqData", reqData);
		respMap.put("respData", respData);
		respMap.put("respDataHex", respDataHex);
		return respMap;
	}

	/**
	 * 通过ASCII码将十进制的字节数组格式化为十六进制字符串
	 * 
	 * @see 该方法会将字节数组中的所有字节均格式化为字符串
	 * @see 使用说明详见<code>formatToHexStringWithASCII(byte[], int, int)</code>方法
	 */
	private static String formatToHexStringWithASCII(byte[] data) {
		return formatToHexStringWithASCII(data, 0, data.length);
	}

	/**
	 * 通过ASCII码将十进制的字节数组格式化为十六进制字符串
	 * 
	 * @see 该方法常用于字符串的十六进制打印,打印时左侧为十六进制数值,右侧为对应的字符串原文
	 * @see 在构造右侧的字符串原文时,该方法内部使用的是平台的默认字符集,来解码byte[]数组
	 * @see 该方法在将字节转为十六进制时,默认使用的是<code>java.util.Locale.getDefault()</code>
	 * @see 详见String.format(String, Object...)方法和new String(byte[], int,
	 *      int)构造方法
	 * @param data
	 *            十进制的字节数组
	 * @param offset
	 *            数组下标,标记从数组的第几个字节开始格式化输出
	 * @param length
	 *            格式长度,其不得大于数组长度,否则抛出java.lang.ArrayIndexOutOfBoundsException
	 * @return 格式化后的十六进制字符串
	 */
	private static String formatToHexStringWithASCII(byte[] data, int offset, int length) {
		int end = offset + length;
		StringBuilder sb = new StringBuilder();
		StringBuilder sb2 = new StringBuilder();
		sb.append("\r\n------------------------------------------------------------------------");
		boolean chineseCutFlag = false;
		for (int i = offset; i < end; i += 16) {
			sb.append(String.format("\r\n%04X: ", i - offset)); // X或x表示将结果格式化为十六进制整数
			sb2.setLength(0);
			for (int j = i; j < i + 16; j++) {
				if (j < end) {
					byte b = data[j];
					if (b >= 0) { // ENG ASCII
						sb.append(String.format("%02X ", b));
						if (b < 32 || b > 126) { // 不可见字符
							sb2.append(" ");
						} else {
							sb2.append((char) b);
						}
					} else { // CHA ASCII
						if (j == i + 15) { // 汉字前半个字节
							sb.append(String.format("%02X ", data[j]));
							chineseCutFlag = true;
							String s = new String(data, j, 2);
							sb2.append(s);
						} else if (j == i && chineseCutFlag) { // 后半个字节
							sb.append(String.format("%02X ", data[j]));
							chineseCutFlag = false;
							String s = new String(data, j, 1);
							sb2.append(s);
						} else {
							sb.append(String.format("%02X %02X ", data[j], data[j + 1]));
							String s = new String(data, j, 2);
							sb2.append(s);
							j++;
						}
					}
				} else {
					sb.append("   ");
				}
			}
			sb.append("| ");
			sb.append(sb2.toString());
		}
		sb.append("\r\n------------------------------------------------------------------------");
		return sb.toString();
	}
}