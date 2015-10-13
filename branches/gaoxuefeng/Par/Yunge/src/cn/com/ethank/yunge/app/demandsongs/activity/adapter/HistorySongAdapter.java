package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnline;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnlineDemanded;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestDemandSong;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.imageloader.MyImageLoader;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.remotecontrol.MipcaActivityCapture;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity.DemandClickCallBack;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

public class HistorySongAdapter extends BaseAdapter {

	private Context context;
	private List<SongOnline> songOnLines;
	private DemandClickCallBack demandClickCallBack;
	private ImageLoader imageLoader;

	public HistorySongAdapter(Context context, List<SongOnline> songOnLines, DemandClickCallBack demandClickCallBack) {
		this.context = context;
		this.songOnLines = songOnLines;
		this.demandClickCallBack = demandClickCallBack;
		imageLoader = ImageLoaderUtil.CreatImageLoader(context, R.drawable.default_head_icon, true);
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

		final SongOnline songBean = songOnLines.get(position) == null ? new SongOnline() : songOnLines.get(position);

		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_song, null);
			holder.rl_item_song = (RelativeLayout) convertView.findViewById(R.id.rl_item_song);
			// Constants.setLayoutSize(holder.rl_item_song, -1, 120);
			holder.tv_music_singler = (TextView) convertView.findViewById(R.id.tv_music_singler);
			holder.iv_single = (CubeImageView) convertView.findViewById(R.id.iv_single);
			holder.tv_music_name = (TextView) convertView.findViewById(R.id.tv_music_name);
			holder.tv_demand_song = (TextView) convertView.findViewById(R.id.tv_demand_song);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		holder.tv_music_name.setText(songBean.getSongName());
		holder.tv_music_singler.setText((songBean.getLanguage().isEmpty() ? songBean.getLanguage() : (songBean.getLanguage() + "-"))
				+ songBean.getSinggerName() + "");
		holder.iv_single.loadImage(imageLoader, songBean.getSongPhoto());
		holder.tv_demand_song.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if (Constants.isBinded()) {
					// 是否已经绑定房间,已经绑定直接点歌
					// token=2&reserveBoxId=201&songId=3
					HashMap<String, String> hashMap = new HashMap<String, String>();
					hashMap.put("token", Constants.getToken());
					hashMap.put("reserveBoxId", Constants.getReserveBoxId());
					hashMap.put("songId", songBean.getSongId() + "");
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

	public class ViewHolder {
		public RelativeLayout rl_item_song;
		public CubeImageView iv_single;
		public TextView tv_demand_song;
		public TextView tv_music_name;
		public TextView tv_music_singler;
	}
}
