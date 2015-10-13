package cn.com.ethank.yunge.app.demandsongs.activity.searchsong;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestDemandSong;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.remotecontrol.MipcaActivityCapture;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.MyImageLoader;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

public class SearchSongOnlineAdapter extends BaseAdapter {

	private Context context;
	private List<SongOnline> songOnLines;

	public SearchSongOnlineAdapter(Context context, List<SongOnline> songOnLines) {
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
		ViewHolder holder;
		SongOnline songBean = songOnLines.get(position);
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_song, null);
			holder.tv_music_singler = (TextView) convertView.findViewById(R.id.tv_music_singler);
			holder.tv_music_name = (TextView) convertView.findViewById(R.id.tv_music_name);
			holder.tv_demand_song = (TextView) convertView.findViewById(R.id.tv_demand_song);
			holder.iv_single = (ImageView) convertView.findViewById(R.id.iv_single);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		MyImageLoader.displayImage(holder.iv_single, songBean.getSongPhoto(), R.drawable.default_head_icon);

		holder.tv_music_name.setText(songBean.getSongName());
		holder.tv_music_singler.setText((songBean.getLanguage().isEmpty() ? songBean.getLanguage() : (songBean.getLanguage() + "-"))
				+ songBean.getSinggerName() + "");

		holder.tv_demand_song.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				if (Constants.isBinded()) {
					// 是否已经绑定房间,已经绑定直接点歌
					// token=2&reserveBoxId=201&songId=3
					HashMap<String, String> hashMap = new HashMap<String, String>();
					hashMap.put("token", Constants.getToken());
					hashMap.put("reserveBoxId", SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.reserveBoxId));
					hashMap.put("songId", songOnLines.get(position).getSongId() + "");
					RequestDemandSong requestDemandSong = new RequestDemandSong(context, hashMap);
					requestDemandSong.start(new RequestCallBack() {

						@Override
						public void onLoaderFinish(Map<String, ?> map) {
							// 已经在底层处理过了

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
						Intent intent = new Intent(context, LoginActivity.class);
						context.startActivity(intent);
					} else {
						Intent intent = new Intent(context, MipcaActivityCapture.class);
						context.startActivity(intent);
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

	class ViewHolder {
		public ImageView iv_single;
		public TextView tv_demand_song;
		public TextView tv_music_name;
		public TextView tv_music_singler;
	}
}
