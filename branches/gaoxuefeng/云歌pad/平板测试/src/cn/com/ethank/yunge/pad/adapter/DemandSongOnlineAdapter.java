package cn.com.ethank.yunge.pad.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.pad.BaseApplication;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.bean.SongOnline;
import cn.com.ethank.yunge.pad.requsetnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.pad.requsetnetwork.RequestDemandSong;
import cn.com.ethank.yunge.pad.utils.SharePreferencesUtil;

@SuppressLint("NewApi")
public class DemandSongOnlineAdapter extends BaseAdapter {

	private Context context;
	private List<SongOnline> songOnLines;
	private ImageView iv_single;

	public DemandSongOnlineAdapter(Context context, List<SongOnline> songOnLines) {
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
		final SongOnline songBean = songOnLines.get(position);
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_song_xin, null);
			holder.tv_music_singler = (TextView) convertView.findViewById(R.id.tv_music_singler);
			holder.tv_music_name = (TextView) convertView.findViewById(R.id.tv_music_name);
			holder.tv_demand_song = (TextView) convertView.findViewById(R.id.tv_demand_song);
			holder.iv_single = (ImageView) convertView.findViewById(R.id.iv_single);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.tv_music_name.setText(songBean.getSongName());
		holder.tv_music_singler.setText((songBean.getLanguage().isEmpty() ? songBean.getLanguage() : (songBean.getLanguage() + "-"))
				+ songBean.getSinggerName() + "");
		BaseApplication.bitmapUtils.display(holder.iv_single, songBean.getSongPhoto(), R.drawable.song_default_head);
		if(songBean.isDemand()){
			//是否点歌
			holder.tv_demand_song.setBackgroundResource(R.drawable.song_add_btn_s);
		}else{
			holder.tv_demand_song.setBackgroundResource(R.drawable.song_add_btn);
		}
		holder.tv_demand_song.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				//发送广播更新已点的数据
				Intent intent_haha =new Intent("ALREADY_DEMAND");
				context.sendBroadcast(intent_haha);
				holder.tv_demand_song.setBackgroundResource(R.drawable.song_add_btn_s);
				songBean.setDemand(true);
				// 是否已经绑定房间,已经绑定直接点歌
				// token=2&roomNum=201&songId=3
				HashMap<String, String> hashMap = new HashMap<String, String>();
//				hashMap.put("token", Constants.getToken());
				hashMap.put("token", SharePreferencesUtil.getStringData("token"));
				hashMap.put("roomNum",SharePreferencesUtil.getStringData("roomNum") );
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

			
			}
		});
		return convertView;
	}

	public void setList(List<SongOnline> songOnLines) {
		this.songOnLines = songOnLines;
		notifyDataSetChanged();
	}

	public class ViewHolder {
		public TextView tv_demand_song;
		public TextView tv_music_name;
		public TextView tv_music_singler;
		public ImageView iv_single;
	}
}
