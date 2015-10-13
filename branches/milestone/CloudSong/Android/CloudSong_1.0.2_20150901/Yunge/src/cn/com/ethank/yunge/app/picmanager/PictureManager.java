package cn.com.ethank.yunge.app.picmanager;

import java.io.IOException;
import java.lang.ref.WeakReference;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;

import com.coyotelib.core.network.HttpService;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.BackgroundTask;
import com.coyotelib.core.threading.IThreadingService;
import com.coyotelib.core.util.coding.MD5;
import com.coyotelib.core.util.coding.PlainCoding;
import com.coyotelib.core.util.file.FileUtil;
import com.coyotelib.core.util.file.Path;

public class PictureManager {

	private static final String LOGO_DIR = Path.appendedString(CoyoteSystem
			.getCurrent().getDataRootDirectory(), "menulogo");

	private static final String PERMANENT_DIR = Path.appendedString(
			CoyoteSystem.getCurrent().getDataRootDirectory(), "permanent");

	private ExecutorService mPicDownloadExecutor;

	public PictureManager() {

	}

	private static final int TYPE_DOWNLOADING = 1;
	private static final int TYPE_DOWNLOADED = 5;
	private static final int TYPE_DOWNLOAD_FAIL = 10;

	private ExecutorService getPicDownloadExecutor() {
		if (mPicDownloadExecutor == null) {
			mPicDownloadExecutor = Executors.newCachedThreadPool();
		}
		return mPicDownloadExecutor;
	}

	private void cancelPicDownload() {
		if (mPicDownloadExecutor != null) {
			mPicDownloadExecutor.shutdown();
			mPicDownloadExecutor = null;
		}
	}

	public static class PicItem {
		private int status = TYPE_DOWNLOADING;
		private WeakReference<Bitmap> logo = null;

		public int getStatus() {
			return status;
		}

		public WeakReference<Bitmap> getReference() {
			return logo;
		}

		public PicItem() {
			status = TYPE_DOWNLOADING;
		}
	}

	private Map<String, PicItem> menuLogoMap = new ConcurrentHashMap<String, PicItem>();

	public Bitmap getmenuLogo(String url, boolean isPermanent, OnPictureDownloadFinished opf) {
		if (TextUtils.isEmpty(url)) {
			return null;
		}
		PicItem item = menuLogoMap.get(url);
		Bitmap result = null;
		if (item != null) {
			if (item.status == TYPE_DOWNLOADED) {
				if (item.logo == null || item.logo.get() == null) {
					result = loadLogoPic(url, isPermanent);
					item.logo = new WeakReference<Bitmap>(result);
				} else {
					result = item.logo.get();
				}
			}
		} else {
			item = new PicItem();
			menuLogoMap.put(url, item);
			if (merchantLogoAlreadyExist(url, isPermanent)
					&& (result = loadLogoPic(url, isPermanent)) != null) {
				item.logo = new WeakReference<Bitmap>(result);
				item.status = TYPE_DOWNLOADED;
			} else {
				getPicDownloadExecutor().execute(
						new DownloadMenuLogoTask(url, isPermanent, opf));
			}
		}

		return result;
	}

	private boolean merchantLogoAlreadyExist(String url, boolean isPermanent) {
		return FileUtil.isFileExist(getLogoPath(url, isPermanent));
	}

	public interface OnPictureDownloadFinished {
		void notifyPictureDownloaded();
	}


	private synchronized void saveMenuLogo(String url, byte[] data,
			boolean isPermanent) {
		FileUtil.createDirs(isPermanent ? PERMANENT_DIR : LOGO_DIR);
		FileUtil.writeBytes(getLogoPath(url, isPermanent), data);
	}

	private synchronized Bitmap loadLogoPic(String url, boolean isPermanent) {
		String path = getLogoPath(url, isPermanent);
		return loadPic(path);
	}

	private String getLogoPath(String url, boolean isPermanent) {
		return Path.appendedString(isPermanent ? PERMANENT_DIR : LOGO_DIR,
				MD5.encode(url.getBytes()));
	}

	private class DownloadMenuLogoTask extends
			BackgroundTask<PicItem> {

		private String url;
		private boolean isPermanent;
		private OnPictureDownloadFinished opf;


		public DownloadMenuLogoTask(String url, boolean isPermanent, OnPictureDownloadFinished opf) {
			this.url = url;
			this.isPermanent = isPermanent;
			this.opf = opf;
		}

		@Override
		protected PicItem doWork() throws Exception {
			PicItem item = menuLogoMap.get(url);
			byte[] data = downloadBytes(url);
			if (item != null) {
				if (data != null && data.length != 0) {
					item.status = TYPE_DOWNLOADED;
					saveMenuLogo(url, data, isPermanent);
				} else {
					item.status = TYPE_DOWNLOAD_FAIL;
				}
			}
			return item;
		}

		@Override
		protected void onCompletion(PicItem result, Throwable exception,
				boolean cancelled) {
			if (result == null || cancelled)
				return;
			if (result.status == TYPE_DOWNLOADED) {
				if (opf != null) {
					opf.notifyPictureDownloaded();
				}
			}
		}
	}

	public void deleteTempPics() {
		cancelPicDownload();
		menuLogoMap.clear();
		String backupFolder = String.format("%s%s", LOGO_DIR,
				String.valueOf(System.currentTimeMillis()));
		FileUtil.renameFolder(LOGO_DIR, backupFolder);
		((IThreadingService) CoyoteSystem.getCurrent().getService(
				IThreadingService.class))
				.runBackgroundTask(new DeleteFolderTask(backupFolder));
	}

	private class DeleteFolderTask extends BackgroundTask<Void> {

		private String folderToDelete;

		public DeleteFolderTask(String folderToDelete) {
			this.folderToDelete = folderToDelete;
			setIsOnewayTask(true);
		}

		@Override
		protected Void doWork() throws Exception {
			FileUtil.deleteFolder(folderToDelete);
			return null;
		}
	}

	private Bitmap loadPic(String path) {
		Bitmap result = null;
		if (FileUtil.isFileExist(path)) {
			result = BitmapFactory.decodeFile(path);
		}
		return result;
	}

	private byte[] downloadBytes(String url) {
		HttpService hs = (HttpService) CoyoteSystem.getCurrent().getService(
				HttpService.class);
		byte[] data = null;
		try {
			data = hs.fetchBytesByGet(new URI(url), new PlainCoding());
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
		return data;
	}
}

