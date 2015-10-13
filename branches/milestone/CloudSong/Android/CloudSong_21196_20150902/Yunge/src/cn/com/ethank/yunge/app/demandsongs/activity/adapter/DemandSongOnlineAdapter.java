package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestDemandSong;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.remotecontrol.MipcaActivityCapture;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity.DemandClickCallBack;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

public class DemandSongOnlineAdapter extends BaseAdapter {

	private Activity activity;
	private List<SongOnline> songOnLines;
	private UnSingedSongChangeReceive songChangeReceive;
	private boolean isShowLastDivider=true;

	public DemandSongOnlineAdapter(Activity context, List<SongOnline> songOnLines, DemandClickCallBack demandClickCallBack) {
		this.activity = context;
		this.songOnLines = songOnLines;
		// 已点未唱歌曲改变后发广播改变当前显示歌曲
		registBroadCastReceive();
	}
	public DemandSongOnlineAdapter(Activity context, List<SongOnline> songOnLines,boolean isShowLastDivider, DemandClickCallBack demandClickCallBack) {
		this.activity = context;
		this.songOnLines = songOnLines;
		this.isShowLastDivider = isShowLastDivider;//是否显示最后的下划线
		// 已点未唱歌曲改变后发广播改变当前显示歌曲
		registBroadCastReceive();
	}

	public DemandSongOnlineAdapter(Activity context, List<SongOnline> songOnLines) {
		this.activity = context;
		this.songOnLines = songOnLines;
		// 已点未唱歌曲改变后发广播改变当前显示歌曲
		registBroadCastReceive();
	}

	private void registBroadCastReceive() {
		songChangeReceive = new UnSingedSongChangeReceive();
		IntentFilter filter = new IntentFilter();
		filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
		filter.addAction(Constants.UNSINGED_SONG_RECEIVED_ACTION);
		activity.registerReceiver(songChangeReceive, filter);
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
		final SongOnline songBean = songOnLines.get(position);
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(activity).inflate(R.layout.item_demand_song, null);
			holder.rl_item_song = (RelativeLayout) convertView.findViewById(R.id.rl_item_song);
			// Constants.setLayoutSize(holder.rl_item_song, -1, 120);
			holder.tv_music_singler = (TextView) convertView.findViewById(R.id.tv_music_singler);
			holder.tv_song_num = (TextView) convertView.findViewById(R.id.tv_song_num);
			holder.tv_music_name = (TextView) convertView.findViewById(R.id.tv_music_name);
			holder.tv_demand_song = (TextView) convertView.findViewById(R.id.tv_demand_song);
			holder.v_bottom_line = (View) convertView.findViewById(R.id.v_bottom_line);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		if (songBean == null) {
			return convertView;
		}
		if(!isShowLastDivider&&position==(getCount()-1)){
			holder.v_bottom_line.setVisibility(View.INVISIBLE);
		}else {
			holder.v_bottom_line.setVisibility(View.VISIBLE);
			
		}
		holder.tv_music_name.setText(songBean.getSongName());
		holder.tv_music_singler.setText((songBean.getLanguage().isEmpty() ? songBean.getLanguage() : (songBean.getLanguage() + "-"))
				+ songBean.getSinggerName() + "");
		// BaseApplication.bitmapUtils.display(holder.tv_song_num,
		// songBean.getSongPhoto(), R.drawable.default_head_icon);
		holder.tv_song_num.setText((position + 1) < 10 ? ("0" + (position + 1)) : (position + 1 + ""));
		if (Constants.demandedSongIdList.contains(songBean.getSongId() + "")) {
			holder.tv_demand_song.getBackground().setLevel(1);
			holder.tv_demand_song.setClickable(false);
		} else {
			holder.tv_demand_song.getBackground().setLevel(0);
			holder.tv_demand_song.setClickable(true);
		}

		holder.tv_demand_song.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				// 设置短时间内不可点击
				if (holder.tv_demand_song.getBackground().getLevel() == 1) {
					return;
				}
				if (!Constants.isClickAble()) {
					return;
				} else {
					Constants.setUnClickAble();
				}
				if (Constants.isBinded()) {
					// 是否已经绑定房间,已经绑定直接点歌
					// token=2&reserveBoxId=201&songId=3
					HashMap<String, String> hashMap = new HashMap<String, String>();
					hashMap.put("token", Constants.getToken());
					hashMap.put("reserveBoxId", SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.reserveBoxId));
					hashMap.put("songId", songOnLines.get(position).getSongId() + "");
					RequestDemandSong requestDemandSong = new RequestDemandSong(activity, hashMap);
					requestDemandSong.start(new RequestCallBack() {

						@Override
						public void onLoaderFinish(Map<String, ?> map) {
							// 已经在底层处理过了

							if (!Constants.demandedSongIdList.contains(songBean.getSongId() + ""))
								Constants.demandedSongIdList.add(songBean.getSongId() + "");
							holder.tv_demand_song.getBackground().setLevel(1);
							holder.tv_demand_song.setClickable(false);

						}

						@Override
						public void onLoaderFail() {
							// 已经在底层处理过了
						}
					});

				} else {
					// 没有绑定房间,去绑定房间
					if (!Constants.getLoginState()) {
						// 未登录
						Intent intent = new Intent(activity, LoginActivity.class);
						activity.startActivity(intent);
					} else {
						Intent intent = new Intent(activity, MipcaActivityCapture.class);
						activity.startActivity(intent);
					}

				}
				// demandClickCallBack.onClickListener(view, position, holder);
			}
		});
		return convertView;
	}

	public void setList(List<SongOnline> songOnLines) {
		this.songOnLines = songOnLines;
		notifyDataSetChanged();
	}

	public class ViewHolder {
		public View v_bottom_line;
		public RelativeLayout rl_item_song;
		public TextView tv_song_num;
		public TextView tv_demand_song;
		public TextView tv_music_name;
		public TextView tv_music_singler;
	}

	class UnSingedSongChangeReceive extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			try {
				if (intent.getAction().equals(Constants.UNSINGED_SONG_RECEIVED_ACTION)) {
					// ToastUtil.show("已点未唱列表改变");
					if (activity != null) {
						notifyDataSetChanged();
					} else {
						// 取消注册
						if (songChangeReceive != null) {
							context.unregisterReceiver(songChangeReceive);
						}

					}

				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}
}
