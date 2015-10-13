package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import in.srain.cube.image.CubeImageView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.nostra13.universalimageloader.core.ImageLoader;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnlineDemanded;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestChangeSongPosition;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.imageloader.MyImageLoader;
import cn.com.ethank.yunge.app.jpush.YungeJPushType;
import cn.com.ethank.yunge.app.remotecontrol.ControlCode;
import cn.com.ethank.yunge.app.remotecontrol.requestnetwork.RequestBoxControl;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity.DemandClickCallBack;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.PowerImageView;

/**
 * 已点歌曲Adapter
 * 
 * @author Gao Xuefeng
 * 
 */
public class DemandedSongAdapter extends BaseAdapter {

	private Context context;
	private List<SongOnlineDemanded> songOnLines;
	private DemandClickCallBack demandClickCallBack;
	private in.srain.cube.image.ImageLoader imageLoader;

	public DemandedSongAdapter(Context context, List<SongOnlineDemanded> songOnLines, DemandClickCallBack demandClickCallBack) {
		this.context = context;
		this.songOnLines = songOnLines;
		this.demandClickCallBack = demandClickCallBack;
		imageLoader = ImageLoaderUtil.CreatImageLoader(context, R.drawable.sing_default_head, true);

	}

	@Override
	public int getCount() {
		return songOnLines.size();
	}

	@Override
	public Object getItem(int position) {
		return songOnLines.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup arg2) {
		final ViewHolder holder;
		SongOnline songBean = songOnLines.get(position).getSong();
		SongOnlineDemanded songOnlineDemanded = songOnLines.get(position);
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_demanded_song_new, null);
			holder.tv_user_name = (TextView) convertView.findViewById(R.id.tv_user_name);
			holder.tv_music_singler = (TextView) convertView.findViewById(R.id.tv_music_singler);
			holder.iv_single = (CubeImageView) convertView.findViewById(R.id.iv_single);
			holder.tv_music_name = (TextView) convertView.findViewById(R.id.tv_music_name);
			holder.iv_change_top_song = (ImageView) convertView.findViewById(R.id.iv_change_top_song);
			holder.piv_song_play = (PowerImageView) convertView.findViewById(R.id.piv_song_play);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		// 是否显示动画
		if (position == 0) {
			holder.iv_change_top_song.getBackground().setLevel(0);
			holder.piv_song_play.setVisibility(View.VISIBLE);
			holder.piv_song_play.setAutoPlay(true);
		} else {
			holder.piv_song_play.setVisibility(View.GONE);
			holder.piv_song_play.setAutoPlay(false);
			holder.iv_change_top_song.getBackground().setLevel(1);
		}
		holder.iv_single.loadImage(imageLoader, songBean.getSongPhoto());

		holder.tv_user_name.setText(songOnlineDemanded.getUserName());
		holder.tv_music_name.setText(songBean.getSongName());
		holder.tv_music_singler.setText((songBean.getLanguage().isEmpty() ? songBean.getLanguage() : (songBean.getLanguage() + "-"))
				+ songBean.getSinggerName() + "");

		holder.iv_change_top_song.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (position == 0) {
					// 切歌
					changeSong();
				} else {
					// 置顶
					changeSongPosition(position, 0);
				}

			}
		});
		return convertView;
	}

	/**
	 * 切歌
	 */
	protected void changeSong() {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("boxToken", ControlCode.getBoxToken());
		hashMap.put("controlType", ControlCode.change_song_code);
		RequestBoxControl requestBoxControl = new RequestBoxControl(context, hashMap);
		requestBoxControl.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				ToastUtil.show("切歌成功");
				// 发一条广播,重新请求列表,切歌后
				Intent sendIntent = new Intent();
				sendIntent.setAction(YungeJPushType.getAction(YungeJPushType.changeSong));
				context.sendBroadcast(sendIntent);
			}

			@Override
			public void onLoaderFail() {
				ToastUtil.show("切歌失败");
			}
		});

	}

	/**
	 * operationType 0置顶,1删除
	 * 
	 * @param position
	 * @param operationType
	 */
	private void changeSongPosition(final int position, final int operationType) {
		try {
			// token=2&reserveBoxId=201&roomSongId=5&operationType=0
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("reserveBoxId", SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.reserveBoxId));
			hashMap.put("token", Constants.getToken());
			hashMap.put("roomSongId", songOnLines.get(position).getRoomSongId() + "");
			hashMap.put("operationType", operationType + "");
			RequestChangeSongPosition changeSongPosition = new RequestChangeSongPosition(context, hashMap);
			changeSongPosition.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					try {
						if (songOnLines != null && songOnLines.size() > position) {
							// 操作成功
							SongOnlineDemanded onlineDemanded = songOnLines.get(position);
							if (operationType == 0) {
								// 置顶
								if (position == 0) {
									return;
								}
								if (songOnLines.contains(onlineDemanded)) {
									songOnLines.remove(onlineDemanded);
								}
								songOnLines.add(1, onlineDemanded);
								notifyDataSetChanged();
								ToastUtil.show("置顶成功");

							} else {
								songOnLines.remove(onlineDemanded);
								notifyDataSetChanged();
								ToastUtil.show("删除成功");
							}
						}

					} catch (Exception e) {
						e.printStackTrace();
					}

				}

				@Override
				public void onLoaderFail() {
					ToastUtil.show("歌曲操作失败");

				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 刷新数据
	 * 
	 * @param songOnLines
	 */
	public void setList(List<SongOnlineDemanded> songOnLines) {
		this.songOnLines = songOnLines;
		notifyDataSetChanged();
	}

	public class ViewHolder {
		public TextView tv_user_name;
		public PowerImageView piv_song_play;
		public ImageView iv_change_top_song;
		public CubeImageView iv_single;
		public TextView tv_music_name;
		public TextView tv_music_singler;
	}

}
