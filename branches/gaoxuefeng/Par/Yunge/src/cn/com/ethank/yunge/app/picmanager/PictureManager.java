package cn.com.ethank.yunge.app.picmanager;

import java.io.IOException;
import java.lang.ref.WeakReference;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.widget.ImageView;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.startup.BaseApplication;

import com.coyotelib.core.network.HttpService;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.BackgroundTask;
import com.coyotelib.core.threading.IThreadingService;
import com.coyotelib.core.util.coding.MD5;
import com.coyotelib.core.util.coding.PlainCoding;
import com.coyotelib.core.util.file.FileUtil;
import com.coyotelib.core.util.file.Path;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.DisplayImageOptions.Builder;
import com.nostra13.universalimageloader.core.ImageLoader;

/**
 * 传进来的view不能设置tag,切记
 * 
 * @author dddd
 * 
 */
public class PictureManager {

	private static final String LOGO_DIR = Path.appendedString(CoyoteSystem.getCurrent().getDataRootDirectory(), "menulogo");

	private static final String PERMANENT_DIR = Path.appendedString(CoyoteSystem.getCurrent().getDataRootDirectory(), "permanent");

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


	// public Bitmap getmenuLogo(final View view, final String url, boolean
	// isPermanent, OnPictureDownloadFinished opf, final int defaultImgResource)
	// {
	// Bitmap result = null;
	// try {
	// if (view == null) {
	// return null;
	// }
	// if (TextUtils.isEmpty(url)) {
	// setDefaultResource(view, defaultImgResource);
	// return null;
	// }
	//
	// PicItem item = menuLogoMap.get(url);
	//
	// if (item != null) {
	// if (item.status == TYPE_DOWNLOADED) {
	// if (item.logo == null || item.logo.get() == null) {
	// result = loadLogoPic(url, isPermanent);
	// item.logo = new WeakReference<Bitmap>(result);
	// } else {
	// result = item.logo.get();
	// }
	// }
	// } else {
	// // 不同先设为默认图片
	// setDefaultResource(view, defaultImgResource);
	// item = new PicItem();
	// menuLogoMap.put(url, item);
	// if (merchantLogoAlreadyExist(url, isPermanent) && (result =
	// loadLogoPic(url, isPermanent)) != null) {
	// item.logo = new WeakReference<Bitmap>(result);
	// item.status = TYPE_DOWNLOADED;
	// } else {
	// getPicDownloadExecutor().execute(new DownloadMenuLogoTask(url,
	// isPermanent, opf, new RequestCallBack() {
	//
	// @Override
	// public void onLoaderFinish(Map<String, ?> map) {
	// try {
	// if (map != null && map.containsKey("data")) {
	// Bitmap bitmap = (Bitmap) map.get("data");
	// if (view != null && bitmap != null) {
	// setBitmapResource(view, bitmap);
	// }
	// }
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// }
	//
	// @Override
	// public void onLoaderFail() {
	// try {
	// if (view != null) {
	// setDefaultResource(view, defaultImgResource);
	// }
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// }
	// }));
	// }
	// }
	// if (result != null) {
	// setBitmapResource(view, result);
	// } else {
	// setDefaultResource(view, defaultImgResource);
	// }
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// return result;
	// }

//	public Bitmap getmenuLogo(View view, String url) {
//		return getmenuLogo(view, url, false);
//
//	}
//
//	public Bitmap getmenuLogo(View view, String url, boolean isPermanent) {
//		return getmenuLogo(view, url, isPermanent, 0);
//	}
//
//	public Bitmap getmenuLogo(View view, String url, boolean isPermanent, int defaultImgResource) {
//		return getmenuLogo(view, url, isPermanent, null, defaultImgResource);
//	}
//
//	public Bitmap getmenuLogo(View view, String url, int defaultImgResource) {
//		return getmenuLogo(view, url, false, null, defaultImgResource);
//	}
//
//	public Bitmap getmenuLogo(final View view, final String url, boolean isPermanent, OnPictureDownloadFinished opf, final int defaultImgResource) {
//		if (defaultImgResource != 0) {
//			BaseApplication.getInstance().initPhotoLoad(defaultImgResource);
//			  
//			BaseApplication.bitmapUtils.display(view, url, defaultImgResource);
//		} else {
//			BaseApplication.bitmapUtils.display(view, url);
//		}
//
//		return null;
//
//	}

	@SuppressWarnings("deprecation")
	private void setBitmapResource(View view, Bitmap bitmap) {
		if (view == null) {
			return;
		}
		if (bitmap != null) {
			try {
				if (view instanceof ImageView) {
					((ImageView) view).setImageBitmap(bitmap);
				} else {
					view.setBackgroundDrawable((new BitmapDrawable(view.getContext().getResources(), bitmap)));
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			if (view instanceof ImageView) {
				((ImageView) view).setImageDrawable(new ColorDrawable(Color.parseColor("#00000000")));
			} else {
				view.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#00000000")));
			}
		}
	}

	@SuppressWarnings("deprecation")
	private void setDefaultResource(View view, int defaultImgResource) {
		if (view == null) {
			return;
		}
		if (defaultImgResource != 0) {
			try {
				if (view instanceof ImageView) {
					((ImageView) view).setImageResource(defaultImgResource);
				} else {
					view.setBackgroundResource(defaultImgResource);
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			// defaultImgResource == 0
			if (view instanceof ImageView) {
				((ImageView) view).setImageDrawable(new ColorDrawable(Color.parseColor("#00000000")));
			} else {
				view.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#00000000")));
			}
		}

	}

	private boolean merchantLogoAlreadyExist(String url, boolean isPermanent) {
		return FileUtil.isFileExist(getLogoPath(url, isPermanent));
	}

	public interface OnPictureDownloadFinished {
		void notifyPictureDownloaded();
	}

	private synchronized void saveMenuLogo(String url, byte[] data, boolean isPermanent) {
		FileUtil.createDirs(isPermanent ? PERMANENT_DIR : LOGO_DIR);
		FileUtil.writeBytes(getLogoPath(url, isPermanent), data);
	}

	private synchronized Bitmap loadLogoPic(String url, boolean isPermanent) {
		String path = getLogoPath(url, isPermanent);
		return loadPic(path);
	}

	private String getLogoPath(String url, boolean isPermanent) {
		return Path.appendedString(isPermanent ? PERMANENT_DIR : LOGO_DIR, MD5.encode(url.getBytes()));
	}

	private class DownloadMenuLogoTask extends BackgroundTask<PicItem> {

		private String url;
		private boolean isPermanent;
		private OnPictureDownloadFinished opf;
		private View view;
		private RequestCallBack requestCallBack;

		public DownloadMenuLogoTask(String url, boolean isPermanent, OnPictureDownloadFinished opf) {
			this.url = url;
			this.isPermanent = isPermanent;
			this.opf = opf;
		}

		public DownloadMenuLogoTask(String url, boolean isPermanent, OnPictureDownloadFinished opf, RequestCallBack requestCallBack) {
			this.url = url;
			this.isPermanent = isPermanent;
			this.opf = opf;
			this.requestCallBack = requestCallBack;
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
		protected void onCompletion(PicItem result, Throwable exception, boolean cancelled) {
			try {
				if (requestCallBack == null) {
					if (result == null || cancelled)
						return;
					if (result.status == TYPE_DOWNLOADED) {
						if (opf != null) {
							opf.notifyPictureDownloaded();
						}
					}
				} else {
					if (result == null || cancelled) {
						requestCallBack.onLoaderFail();

						return;
					} else {

						Bitmap bitmap = loadLogoPic(url, false);
						HashMap<String, Bitmap> hashMap = new HashMap<String, Bitmap>();
						if (bitmap != null) {
							hashMap.put("data", bitmap);
							requestCallBack.onLoaderFinish(hashMap);
						} else {
							requestCallBack.onLoaderFail();
						}

					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}

	public void deleteTempPics() {
		cancelPicDownload();
		menuLogoMap.clear();
		String backupFolder = String.format("%s%s", LOGO_DIR, String.valueOf(System.currentTimeMillis()));
		FileUtil.renameFolder(LOGO_DIR, backupFolder);
		((IThreadingService) CoyoteSystem.getCurrent().getService(IThreadingService.class)).runBackgroundTask(new DeleteFolderTask(backupFolder));
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
		HttpService hs = (HttpService) CoyoteSystem.getCurrent().getService(HttpService.class);
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
