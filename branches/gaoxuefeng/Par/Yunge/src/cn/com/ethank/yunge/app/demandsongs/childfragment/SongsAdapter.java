package cn.com.ethank.yunge.app.demandsongs.childfragment;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.MusicBean;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.imageloader.MyImageLoader;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;

public class SongsAdapter extends BaseAdapter {

	private Context context;
	private List<MusicBean> musicList;
	private BaseTitleActivity.DemandClickCallBack demandClickCallBack;
	private ImageLoader imageLoader;

	public SongsAdapter(Context context, ArrayList<MusicBean> musicList, BaseTitleActivity.DemandClickCallBack demandClickCallBack) {
		this.context = context;
		this.musicList = musicList;
		this.demandClickCallBack = demandClickCallBack;
		imageLoader = ImageLoaderUtil.CreatImageLoader(context, R.drawable.sing_default_head, true);
	}

	@Override
	public int getCount() {

		return musicList.size();
	}

	@Override
	public Object getItem(int position) {
		return musicList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View convertView, final ViewGroup parent) {
		final ViewHolder viewHolder;
		MusicBean musicBean = musicList.get(position);
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_song, null);
			viewHolder.tv_music_singler = (TextView) convertView.findViewById(R.id.tv_music_singler);
			viewHolder.tv_music_name = (TextView) convertView.findViewById(R.id.tv_music_name);
			viewHolder.tv_demand_song = (TextView) convertView.findViewById(R.id.tv_demand_song);
			viewHolder.iv_single = (CubeImageView) convertView.findViewById(R.id.iv_single);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		viewHolder.tv_music_name.setText(musicBean.getTitle().toString());
		viewHolder.tv_music_singler.setText((musicBean.getLanguage().isEmpty() ? musicBean.getLanguage() : (musicBean.getLanguage() + "-"))
				+ musicBean.getSinger());
		viewHolder.tv_demand_song.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				demandClickCallBack.onClickListener(view, position, viewHolder);
			}
		});
		viewHolder.iv_single.loadImage(imageLoader, Constants.getHeadUrl());
		return convertView;
	}

	public class ViewHolder {

		public CubeImageView iv_single;
		public TextView tv_music_singler;
		public TextView tv_music_name;
		public TextView tv_demand_song;
	}

}
