package com.example.yungelight;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity2 extends Activity {
	ArrayList<ContronBean> contronBeans = new ArrayList<ContronBean>();
	private ListView lv_contron_list;
	private ContronAdapter contronAdapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_2);
		initContronType();
		initView();
	}

	private byte[] StringCodeToByte(String bb) {
		final byte[] a = new byte[bb.length() / 2];
		for (int i = 0; i < a.length; i++) {
			a[i] = (byte) (Integer.parseInt(bb.substring(2 * i, 2 * i + 2), 16));
		}
		return a;
	}

	private void initView() {
		lv_contron_list = (ListView) findViewById(R.id.lv_contron_list);
		contronAdapter = new ContronAdapter(this, contronBeans);
		lv_contron_list.setAdapter(contronAdapter);
		lv_contron_list.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

				new AsyncTask<byte[], Integer, String>() {

					private String info = "";

					@Override
					protected String doInBackground(byte[]... params) {
						try {
							sendByUdp(params);
							// info = sendByTCP(params);
						} catch (Exception e) {
							e.printStackTrace();
						}
						return info;
					}

					private void sendByUdp(byte[]... params) throws Exception, IOException {
						UdpClientSocket client = new UdpClientSocket(8091);
						String serverHost = "192.168.1.197";
						// String serverHost = "192.168.1.78";
						int serverPort = 8089;
						client.send(serverHost, serverPort, params[0]);
						info = client.receive(serverHost, serverPort);
						System.out.println("服务端回应数据：" + info);
					}

					@SuppressWarnings("resource")
					private String sendByTCP(byte[]... params) throws Exception, IOException {
						String serverHost = "192.168.1.197";
						// String serverHost = "192.168.1.78";
						int serverPort = 8092;
						Socket socket = new Socket();
						SocketAddress address = new InetSocketAddress(serverHost, serverPort);
						byte[] resultbyte = null;
						String result = "";
						try {
							socket.connect(address, 3000);

							System.out.println("连接成功！");
							// 发送数据
							OutputStream socketOut = socket.getOutputStream();
							socketOut.write(params[0]);
							socketOut.flush();
							Thread.sleep(100, 0);
							// 接收响应结果
							InputStream socketInput = socket.getInputStream();
							resultbyte = input2byte(socketInput);
							if (resultbyte != null) {
								result = byte2String(resultbyte);
								System.out.println(contronBeans.get(position).getModeName() + result);
							} else {
								System.out.println("失败");
							}

						} catch (IOException e) {
							System.out.println("连接超时！");
							e.printStackTrace();
						}
						return result;
					}

					@SuppressLint("NewApi")
					@Override
					protected void onPostExecute(String result) {
						super.onPostExecute(result);
						if (result == null || result.isEmpty()) {
							Toast.makeText(MainActivity2.this, "设置失败", Toast.LENGTH_SHORT).show();
						} else {
							if (contronBeans.get(position).getModeCode().equals("FBF0C1")) {
								for (int i = 0; i < contronBeans.size(); i++) {
									if (result.contains(contronBeans.get(i).getModequeryCode())) {
										Toast.makeText(MainActivity2.this, "当前模式:" + contronBeans.get(i).getModeName(), Toast.LENGTH_SHORT).show();
										break;
									}
								}

							} else {
								// Toast.makeText(MainActivity2.this, result,
								// Toast.LENGTH_SHORT).show();
								Toast.makeText(MainActivity2.this, "设置成功:" + contronBeans.get(position).getModeName(), Toast.LENGTH_SHORT).show();

							}
							// Toast.makeText(MainActivity2.this, "返回:" +
							// result.toString(), Toast.LENGTH_SHORT).show();
						}

					}

				}.execute(StringCodeToByte(contronBeans.get(position).getModeCode()));
			}
		});

	}

	public static final byte[] input2byte(InputStream inStream) throws IOException {
		try {
			ByteArrayOutputStream swapStream = new ByteArrayOutputStream();
			byte[] buff = new byte[100];
			int rc = 0;
			while ((rc = inStream.read(buff, 0, 100)) > 0) {
				swapStream.write(buff, 0, rc);
			}
			byte[] in2b = swapStream.toByteArray();
			return in2b;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	@SuppressLint("DefaultLocale")
	private String byte2String(byte[] a) {
		int[] resultInt = new int[a.length];
		String resultStr = "";
		for (int i = 0; i < a.length; i++) {
			if (a[i] < 0) {
				resultInt[i] = 256 + a[i];
			} else {
				resultInt[i] = 0 + a[i];
			}
			String str16 = Integer.toHexString(resultInt[i]);
			if (str16.length() == 1) {
				str16 = "0".concat(str16);
			}
			resultStr = resultStr.concat(str16);
		}
		return resultStr.toUpperCase().trim();
	}

	private void initContronType() {
		contronBeans.clear();
		ContronBean
		// mode0
		contronBean = new ContronBean();
		contronBean.setModeCode("FB00C0");
		contronBean.setModeName("灯光默认");
		contronBean.setModeBackCode("FCA0");
		contronBean.setModequeryCode("FCD0");
		contronBeans.add(contronBean);
		// mode1
		contronBean = new ContronBean();
		contronBean.setModeCode("FB01C0");
		contronBean.setModeName("选秀");
		contronBean.setModeBackCode("FCA1");
		contronBean.setModequeryCode("FCD1");
		contronBeans.add(contronBean);
		// mode2
		contronBean = new ContronBean();
		contronBean.setModeCode("FB02C0");
		contronBean.setModeName("K歌-抒情");
		contronBean.setModeBackCode("FCA2");
		contronBean.setModequeryCode("FCD2");
		contronBeans.add(contronBean);
		// mode3
		contronBean = new ContronBean();
		contronBean.setModeCode("FB03C0");
		contronBean.setModeName("K歌");
		contronBean.setModeBackCode("FCA3");
		contronBean.setModequeryCode("FCD3");
		contronBeans.add(contronBean);
		// mode4
		contronBean = new ContronBean();
		contronBean.setModeCode("FB04C0");
		contronBean.setModeName("K歌-动感）");
		contronBean.setModeBackCode("FCA4");
		contronBean.setModequeryCode("FCD4");
		contronBeans.add(contronBean);
		// mode5
		contronBean = new ContronBean();
		contronBean.setModeCode("FB05C0");
		contronBean.setModeName("商务");
		contronBean.setModeBackCode("FCA5");
		contronBean.setModequeryCode("FCD5");
		contronBeans.add(contronBean);
		// mode6
		contronBean = new ContronBean();
		contronBean.setModeCode("FB06C0");
		contronBean.setModeName("（K歌-明亮");
		contronBean.setModeBackCode("FCA6");
		contronBean.setModequeryCode("FCD6");
		contronBeans.add(contronBean);
		// mode7
		contronBean = new ContronBean();
		contronBean.setModeCode("FB07C0");
		contronBean.setModeName("慢摇");
		contronBean.setModeBackCode("FCA7");
		contronBean.setModequeryCode("FCD7");
		contronBeans.add(contronBean);
		// mode8
		contronBean = new ContronBean();
		contronBean.setModeCode("FB08C0");
		contronBean.setModeName("K歌-柔和");
		contronBean.setModeBackCode("FCA8");
		contronBean.setModequeryCode("FCD8");
		contronBeans.add(contronBean);
		// mode9
		contronBean = new ContronBean();
		contronBean.setModeCode("FB09C0");
		contronBean.setModeName("清洁");
		contronBean.setModeBackCode("FCA9");
		contronBean.setModequeryCode("FCD9");
		contronBeans.add(contronBean);
		// mode10
		contronBean = new ContronBean();
		contronBean.setModeCode("FB0AC0");
		contronBean.setModeName("K歌-浪漫");
		contronBean.setModeBackCode("FCAA");
		contronBean.setModequeryCode("FCDA");
		contronBeans.add(contronBean);
		// mode11
		contronBean = new ContronBean();
		contronBean.setModeCode("FB0BC0");
		contronBean.setModeName("全关");
		contronBean.setModeBackCode("FCAB");
		contronBean.setModequeryCode("FCDB");
		contronBeans.add(contronBean);
		// mode12
		contronBean = new ContronBean();
		contronBean.setModeCode("FB0CC0");
		contronBean.setModeName("全开");
		contronBean.setModeBackCode("FCAC");
		contronBean.setModequeryCode("FCDC");
		contronBeans.add(contronBean);
		// mode13
		contronBean = new ContronBean();
		contronBean.setModeCode("FB0DC0");
		contronBean.setModeName("全开关");
		contronBean.setModeBackCode("FCAD");
		contronBean.setModequeryCode("FCDD");
		contronBeans.add(contronBean);
		// mode14
		contronBean = new ContronBean();
		contronBean.setModeCode("FB0EC0");
		contronBean.setModeName("开关（吊灯）");
		contronBean.setModeBackCode("FCAE");
		contronBean.setModequeryCode("FCDE");
		contronBeans.add(contronBean);
		// mode15
		contronBean = new ContronBean();
		contronBean.setModeCode("FB0FC0");
		contronBean.setModeName("开关（射灯）");
		contronBean.setModeBackCode("FCAF");
		contronBean.setModequeryCode("FCDF");
		contronBeans.add(contronBean);
		// mode16
		contronBean = new ContronBean();
		contronBean.setModeCode("FB10C0");
		contronBean.setModeName("开关（灯带");
		contronBean.setModeBackCode("FCB0");
		contronBean.setModequeryCode("FCE0");
		contronBeans.add(contronBean);
		// mode17
		contronBean = new ContronBean();
		contronBean.setModeCode("FB1AC0");
		contronBean.setModeName("自动");
		contronBean.setModeBackCode("FCBA");
		contronBean.setModequeryCode("FCEA");
		contronBeans.add(contronBean);
		// mode18查询所在模式
		contronBean = new ContronBean();
		contronBean.setModeCode("FBF0C1");
		contronBean.setModeName("当前所在模式查询");
		contronBeans.add(contronBean);
		// mode19全部模式状态查询
		contronBean = new ContronBean();
		contronBean.setModeCode("FBF1C1");
		contronBean.setModeName("全部模式状态查询");
		contronBeans.add(contronBean);
		// mode20全部模式状态查询
		contronBean = new ContronBean();
		contronBean.setModeCode("FBF2C1");
		contronBean.setModeName("查询灯光控制器型号");
		contronBeans.add(contronBean);
	}
}
