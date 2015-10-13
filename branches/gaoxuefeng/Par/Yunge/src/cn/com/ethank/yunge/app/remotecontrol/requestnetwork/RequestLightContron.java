package cn.com.ethank.yunge.app.remotecontrol.requestnetwork;

import java.io.IOException;

import android.content.Context;
import android.text.TextUtils;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.ResoloveResult;
import cn.com.ethank.yunge.app.remotecontrol.bean.ContronBean;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSONObject;
import com.coyotelib.core.threading.BackgroundTask;

/**
 * 遥控控制
 * 
 * @author dddd
 * 
 */
public class RequestLightContron extends BaseRequest {

	private Context context;
	private ContronBean contronBean;
	String serverHost = "192.168.101.198";
	int serverSendPort = 8089;

	public RequestLightContron(Context context, ContronBean contronBean) {
		this.context = context;
		this.contronBean = contronBean;

	}

	@Override
	public void start(final RequestCallBack requestCallBack) {
		new BackgroundTask<String>() {

			@Override
			protected String doWork() throws Exception {
				byte[] sendbyte = StringCodeToByte(contronBean.getModeCode());
				String result = sendByUdp(sendbyte);
				return result;
			}

			@Override
			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				super.onCompletion(result, exception, cancelled);
				boolean success = resloveResult(requestCallBack, result);
				if (!success) {
					requestCallBack.onLoaderFail();
				} else {
					requestCallBack.onLoaderFinish(null);
				}
			}

			private boolean resloveResult(final RequestCallBack requestCallBack, String result) {
				if (TextUtils.isEmpty(result)) {
					ToastUtil.show("设置失败");
				} else {
					ToastUtil.show("设置成功");
				}

				return false;
			}
		}.run();

	}

	private byte[] StringCodeToByte(String bb) {
		final byte[] a = new byte[bb.length() / 2];
		for (int i = 0; i < a.length; i++) {
			a[i] = (byte) (Integer.parseInt(bb.substring(2 * i, 2 * i + 2), 16));
		}
		return a;
	}

	private String sendByUdp(byte[]... params) throws Exception, IOException {
		UdpClientSocket client = new UdpClientSocket(8091);
		int serverPort = 8089;
		client.send(serverHost, serverPort, params[0]);
		String info = client.receive(serverHost, serverPort);
		if (info != null) {
			System.out.println("服务端回应数据：" + info);

		} else {
			info = "";
		}
		return info;

	}
}
