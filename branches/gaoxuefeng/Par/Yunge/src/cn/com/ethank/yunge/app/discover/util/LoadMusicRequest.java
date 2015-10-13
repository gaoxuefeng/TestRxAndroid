package cn.com.ethank.yunge.app.discover.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import android.os.AsyncTask;
import android.os.Environment;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;

public class LoadMusicRequest {

	private String sdCardpath;
	private String fileName;
	private String musicUrl;
	private RefreshUiInterface refreshUiInterface;

	public LoadMusicRequest(String sdCardpath, String fileName, String musicUrl, RefreshUiInterface refreshUiInterface) {
		super();
		this.sdCardpath = sdCardpath;
		this.fileName = fileName;
		this.musicUrl = musicUrl;
		this.refreshUiInterface = refreshUiInterface;
	}

	public void loadData() {
		new AsyncTask<Void, Void, Boolean>() {
			@Override
			protected Boolean doInBackground(Void... arg0) {
				// TODO Auto-generated method stub
				try {
					// InputStream iStream =
					// context.getAssets().open("bjbj.mp3");
					InputStream iStream = returnBitMap(musicUrl);
					if (iStream == null) {
						return false;
					}
					String status = Environment.getExternalStorageState();
					if (status.equals(Environment.MEDIA_MOUNTED)) {
						File f = new File(sdCardpath);
						if (!f.exists()) {
							f.mkdirs();
						}

						File childfile = new File(f.getAbsolutePath() + File.separator + fileName);
						if (childfile.exists()) {
							childfile.delete();
						}
						childfile.createNewFile();

						FileOutputStream output = null;
						try {
							int len = -1;
							output = new FileOutputStream(childfile);
							byte bf[] = new byte[1024];

							while ((len = iStream.read(bf)) != -1) {
								output.write(bf, 0, len);
							}
						} catch (Exception e) {
							e.printStackTrace();
							return false;
						} finally {
							try {
								output.flush();
								output.close();
								iStream.close();
							} catch (Exception e2) {
								e2.printStackTrace();
								return false;
							}
						}
					}
					return true;
				} catch (Exception e) {
					e.printStackTrace();
					return false;
				}
			}

			@Override
			protected void onPostExecute(Boolean result) {
				super.onPostExecute(result);
				refreshUiInterface.refreshUi(result);
			}
		}.execute();
	}

	public static InputStream returnBitMap(String path) {
		URL url = null;
		InputStream is = null;
		try {
			url = new URL(path);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
		try {
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();// 利用HttpURLConnection对象,我们可以从网络中获取网页数据.
			conn.setDoInput(true);
			conn.connect();
			is = conn.getInputStream(); // 得到网络返回的输入流

		} catch (IOException e) {
			e.printStackTrace();
		}
		return is;
	}

}
