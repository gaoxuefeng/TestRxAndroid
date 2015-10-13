package org.app.music.adapter;

import java.io.FileDescriptor;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

import org.app.MusicBean;
import org.app.musicplayer.R;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

public class MusicListAdapter extends BaseAdapter {
	private Context mcontext;// 上下文
	private int pos=-1;
	private ArrayList<MusicBean> musicArrayBeans;
	public MusicListAdapter(Context context, ArrayList<MusicBean> musicArrayBeans) {
		mcontext = context;
		this.musicArrayBeans = musicArrayBeans;
	}
	@Override
	public int getCount() {
		return musicArrayBeans.size();
	}

	@Override
	public Object getItem(int position) {
		return position;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewholder = null;
		if (convertView == null) {
			viewholder = new ViewHolder();
			convertView = LayoutInflater.from(mcontext).inflate(R.layout.music_list_item, null);
			viewholder.images = (ImageView) convertView.findViewById(R.id.images_album);
			viewholder.music_names = (TextView) convertView.findViewById(R.id.musicname);
			viewholder.singers = (TextView) convertView.findViewById(R.id.singer);
			viewholder.times = (TextView) convertView.findViewById(R.id.time);
			viewholder.song_list_item_menu = (ImageButton) convertView.findViewById(R.id.ibtn_song_list_item_menu);
			convertView.setTag(viewholder);
		} else {
			viewholder = (ViewHolder) convertView.getTag();
		}
		MusicBean bean = musicArrayBeans.get(position);
		if (position==pos) {
			viewholder.images.setImageResource(R.drawable.isplaying);
		}else {
//			Bitmap bitmap = getArtwork(mcontext, bean.get_id(),bean.getAlbum_id(),true);
//			viewholder.images.setImageBitmap(bitmap);
		}
		viewholder.music_names.setText(bean.get_titles());
		viewholder.singers.setText(bean.get_artists());
		viewholder.times.setText(bean.get_times());
		return convertView;

	}
	public class ViewHolder {
		public ImageView images;
		public TextView music_names;
		public TextView singers;
		public TextView times;
		public ImageButton song_list_item_menu;
	}
	public void setItemIcon(int position){
		pos = position;
	}
	/**
	 * 时间的转换
	 */
	public String toTime(int time) {

		time /= 1000;
		int minute = time / 60;
		int second = time % 60;
		minute %= 60;
		/** 返回结果用string的format方法把时间转换成字符类型 **/
		return String.format("%02d:%02d", minute, second);
	}

	/**
	 * 以下是歌曲放的时候显示专辑图片。和列表不同,播放时图片要大。所以cam那个方法写合适的图片吧
	 */
	public static Bitmap getArtwork(Context context, long song_id,
			long album_id, boolean allowdefault) {
		if (album_id < 0) {

			if (song_id >= 0) {
				Bitmap bm = getArtworkFromFile(context, song_id, -1);
				if (bm != null) {
					return bm;
				}
			}
			if (allowdefault) {
				return getDefaultArtwork(context);
			}
			return null;
		}
		ContentResolver res = context.getContentResolver();
		Uri uri = ContentUris.withAppendedId(sArtworkUri, album_id);
		if (uri != null) {
			InputStream in = null;
			try {
				in = res.openInputStream(uri);
				BitmapFactory.Options options = new BitmapFactory.Options();
				/** 先指定原始大小 **/
				options.inSampleSize = 1;
				/** 只进行大小判断 **/
				options.inJustDecodeBounds = true;
				/** 调用此方法得到options得到图片的大小 **/
				BitmapFactory.decodeStream(in, null, options);
				/** 我们的目标是在你N pixel的画面上显示。 所以需要调用computeSampleSize得到图片缩放的比例 **/
				/** 这里的target为800是根据默认专辑图片大小决定的，800只是测试数字但是试验后发现完美的结合 **/
				options.inSampleSize = computeSampleSize(options, 30);
				/** 我们得到了缩放的比例，现在开始正式读入BitMap数据 **/
				options.inJustDecodeBounds = false;
				options.inDither = false;
				options.inPreferredConfig = Bitmap.Config.ARGB_8888;
				in = res.openInputStream(uri);
				return BitmapFactory.decodeStream(in, null, options);
			} catch (FileNotFoundException ex) {

				Bitmap bm = getArtworkFromFile(context, song_id, album_id);
				if (bm != null) {
					if (bm.getConfig() == null) {
						bm = bm.copy(Bitmap.Config.RGB_565, false);
						if (bm == null && allowdefault) {
							return getDefaultArtwork(context);
						}
					}
				} else if (allowdefault) {
					bm = getDefaultArtwork(context);
				}
				return bm;
			} finally {
				try {
					if (in != null) {
						in.close();
					}
				} catch (IOException ex) {
				}
			}
		}

		return null;
	}

	private static Bitmap getArtworkFromFile(Context context, long songid,
			long albumid) {
		Bitmap bm = null;
		if (albumid < 0 && songid < 0) {
			throw new IllegalArgumentException(
					"Must specify an album or a song id");
		}
		try {

			BitmapFactory.Options options = new BitmapFactory.Options();

			FileDescriptor fd = null;
			if (albumid < 0) {
				Uri uri = Uri.parse("content://media/external/audio/media/"
						+ songid + "/albumart");
				ParcelFileDescriptor pfd = context.getContentResolver()
						.openFileDescriptor(uri, "r");
				if (pfd != null) {
					fd = pfd.getFileDescriptor();
				}
			} else {
				Uri uri = ContentUris.withAppendedId(sArtworkUri, albumid);
				ParcelFileDescriptor pfd = context.getContentResolver()
						.openFileDescriptor(uri, "r");
				if (pfd != null) {
					fd = pfd.getFileDescriptor();
				}
			}
			options.inSampleSize = 1;
			// 只进行大小判断
			options.inJustDecodeBounds = true;
			// 调用此方法得到options得到图片的大小
			BitmapFactory.decodeFileDescriptor(fd, null, options);
			// 我们的目标是在800pixel的画面上显示。
			// 所以需要调用computeSampleSize得到图片缩放的比例
			options.inSampleSize = 500;
			// OK,我们得到了缩放的比例，现在开始正式读入BitMap数据
			options.inJustDecodeBounds = false;
			options.inDither = false;
			options.inPreferredConfig = Bitmap.Config.ARGB_8888;

			// 根据options参数，减少所需要的内存
			bm = BitmapFactory.decodeFileDescriptor(fd, null, options);
		} catch (FileNotFoundException ex) {

		}

		return bm;
	}

	/** 这个函数会对图片的大小进行判断，并得到合适的缩放比例，比如2即1/2,3即1/3 **/
	static int computeSampleSize(BitmapFactory.Options options, int target) {
		int w = options.outWidth;
		int h = options.outHeight;
		int candidateW = w / target;
		int candidateH = h / target;
		int candidate = Math.max(candidateW, candidateH);
		if (candidate == 0)
			return 1;
		if (candidate > 1) {
			if ((w > target) && (w / candidate) < target)
				candidate -= 1;
		}
		if (candidate > 1) {
			if ((h > target) && (h / candidate) < target)
				candidate -= 1;
		}
		return candidate;
	}

	private static Bitmap getDefaultArtwork(Context context) {
		BitmapFactory.Options opts = new BitmapFactory.Options();
		opts.inPreferredConfig = Bitmap.Config.RGB_565;
		return BitmapFactory.decodeStream(context.getResources().openRawResource(R.drawable.music), null, opts);
	}

	private static final Uri sArtworkUri = Uri.parse("content://media/external/audio/albumart");

}
