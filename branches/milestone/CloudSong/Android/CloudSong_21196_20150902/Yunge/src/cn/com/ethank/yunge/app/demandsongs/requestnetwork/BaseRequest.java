package cn.com.ethank.yunge.app.demandsongs.requestnetwork;

import java.util.Map;

/*
 *  Subclass this to create an API request
 */
public abstract class BaseRequest {
	
	public abstract void start(RequestCallBack requestCallBack);

	public interface RequestCallBack {
		public void onLoaderFinish(Map<String, ?> map);

		public void onLoaderFail();
	}

}
