package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.List;

import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.maintheme.ThemeChildBean;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.util.Constants;
import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;

/**
 * 专题推荐的Adapter
 * 
 * @author Gao Xuefeng
 * 
 */
public class MainThemeAdapter extends BaseAdapter {
	private List<ThemeChildBean> musicThemeList;
	private Context context;
	private ImageLoader imageLoader;

	public MainThemeAdapter(Context context, List<ThemeChildBean> musicThemeList) {

		this.context = context;
		this.musicThemeList = musicThemeList;
		imageLoader = ImageLoaderUtil.CreatImageLoader(context, R.drawable.schedule_ktv_default_bg);
	}

	@Override
	public int getCount() {

		return musicThemeList.size();
	}

	@Override
	public Object getItem(int i) {
		return musicThemeList.get(i);
	}

	@Override
	public long getItemId(int i) {

		return i;
	}

	@Override
	public View getView(int position, View view, ViewGroup viewGroup) {
		ViewHolder viewHolder;
		ThemeChildBean musicThemeBean = musicThemeList.get(position);
		if (view == null) {
			viewHolder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.item_music_theme, null);
			viewHolder.tv_music_theme = (TextView) view.findViewById(R.id.tv_music_theme);
			viewHolder.iv_music_theme = (CubeImageView) view.findViewById(R.id.iv_music_theme);
			Constants.setLayoutSize(viewHolder.iv_music_theme, -1, 166);
			view.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) view.getTag();
		}
		viewHolder.tv_music_theme.setText(musicThemeBean.getListTypeName());
		viewHolder.iv_music_theme.loadImage(imageLoader, musicThemeBean.getImageUrl());
		return view;
	}

	class ViewHolder {

		TextView tv_music_theme;
		public CubeImageView iv_music_theme;
	}

	public void setList(List<ThemeChildBean> musicThemeList) {
		this.musicThemeList = musicThemeList;
		notifyDataSetChanged();

	}

}
