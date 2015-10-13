package cn.com.ethank.yunge.pad.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.pad.BaseApplication;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.bean.SongOnline;
import cn.com.ethank.yunge.pad.bean.SongOnlineDemanded;
import cn.com.ethank.yunge.pad.requsetnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.pad.requsetnetwork.RequestChangeSongPosition;
import cn.com.ethank.yunge.pad.utils.Constants;
import cn.com.ethank.yunge.pad.utils.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.pad.utils.SharePreferencesUtil;
import cn.com.ethank.yunge.pad.utils.ToastUtil;

/**
 * 已点歌曲Adapter
 * 
 * @author Gao Xuefeng
 * 
 */
@SuppressLint("NewApi")
public class DemandedSongAdapter extends BaseAdapter {

	private Context context;
	private List<SongOnlineDemanded> songOnLines;
	private int selectPosition = -1;

	public DemandedSongAdapter(Context context, List<SongOnlineDemanded> songOnLines) {
		this.context = context;
		this.songOnLines = songOnLines;
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
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_demanded_song, null);
			holder.tv_music_singler = (TextView) convertView.findViewById(R.id.tv_music_singler);
			holder.iv_single = (ImageView) convertView.findViewById(R.id.iv_single);
			holder.tv_music_name = (TextView) convertView.findViewById(R.id.tv_music_name);
			holder.tv_song_to_delete = (TextView) convertView.findViewById(R.id.tv_song_to_delete);
			holder.tv_song_to_top = (TextView) convertView.findViewById(R.id.tv_song_to_top);
			holder.iv_demand_song = (ImageView) convertView.findViewById(R.id.iv_demand_song);
			holder.ll_select_song = (LinearLayout) convertView.findViewById(R.id.ll_select_song);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		if (position == selectPosition) {
			holder.ll_select_song.setVisibility(View.VISIBLE);
			holder.iv_demand_song.setImageResource(R.drawable.song_up_btn);
		} else {
			holder.ll_select_song.setVisibility(View.GONE);
			holder.iv_demand_song.setImageResource(R.drawable.song_down_btn);
		}
		if (position == 0) {
			// 第一个位置可以切歌
			holder.tv_song_to_top.setCompoundDrawablesWithIntrinsicBounds(R.drawable.song_change_song_icon, 0, 0, 0);
			holder.tv_song_to_top.setText("切歌");
		} else {
			// 其他的置顶
			holder.tv_song_to_top.setCompoundDrawablesWithIntrinsicBounds(R.drawable.song_top_icon, 0, 0, 0);
			holder.tv_song_to_top.setText("置顶歌曲");
		}
		BaseApplication.bitmapUtils.display(holder.iv_single, songBean.getSongPhoto(), R.drawable.song_default_head);

		holder.tv_music_name.setText(songBean.getSongName());
		holder.tv_music_singler.setText((songBean.getLanguage().isEmpty() ? songBean.getLanguage() : (songBean.getLanguage() + "-"))
				+ songBean.getSinggerName() + "");

		convertView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (selectPosition == position) {
					selectPosition = -1;
					notifyDataSetChanged();
				} else {
					selectPosition = position;
					notifyDataSetChanged();
				}
			}
		});
		holder.tv_song_to_delete.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				changeSongPosition(position, 1);// 删除
				// 发送广播更新已点的数据
				Intent intent = new Intent("ALREADY_DEMAND_REDUCE");
				context.sendBroadcast(intent);
			}
		});
		holder.tv_song_to_top.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				changeSongPosition(position, 0);

			}
		});
		return convertView;
	}

	public interface OnTopOnclickListner {
		void onTopOnclick();
	}

	/**
	 * operationType 0置顶,1删除
	 * 
	 * @param position
	 * @param operationType
	 */
	private void changeSongPosition(final int position, final int operationType) {
		try {
			// token=2&roomNum=201&roomSongId=5&operationType=0
			HashMap<String, String> hashMap = new HashMap<String, String>();
			// hashMap.put("roomNum",
			// SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.roomNum));
			hashMap.put("roomNum", SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.roomNum));
			hashMap.put("token", Constants.getToken());
			hashMap.put("roomSongId", songOnLines.get(position).getRoomSongId() + "");
			hashMap.put("operationType", operationType + "");
			RequestChangeSongPosition changeSongPosition = new RequestChangeSongPosition(context, hashMap);
			changeSongPosition.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
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
						songOnLines.add(0, onlineDemanded);
						selectPosition = 0;

						ToastUtil.show("置顶成功");

					} else {
						songOnLines.remove(onlineDemanded);
						selectPosition = -1;
						notifyDataSetChanged();
						ToastUtil.show("删除成功");
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
		if (songOnLines.size() == 0) {
			selectPosition = -1;
		}

		notifyDataSetChanged();
	}

	public class ViewHolder {
		public ImageView iv_single;
		public TextView tv_song_to_top;
		public TextView tv_song_to_delete;
		public LinearLayout ll_select_song;
		public ImageView iv_demand_song;
		public TextView tv_music_name;
		public TextView tv_music_singler;
	}
}
