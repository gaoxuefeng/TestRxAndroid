package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.MusicStyleBean;
import cn.com.ethank.yunge.app.demandsongs.beans.TypeThreeBean;
import cn.com.ethank.yunge.app.startup.BaseApplication;

/**
 * Created by dddd on 2015/4/28.
 */
public class MusicStyleAdapter extends BaseAdapter {
	private ArrayList<MusicStyleBean> musicStyleList;
	private Context context;

	public MusicStyleAdapter(Context context,
			ArrayList<MusicStyleBean> musicStyleList) {

		this.context = context;
		this.musicStyleList = musicStyleList;
	}

	@Override
	public int getCount() {

		return musicStyleList.size();
	}

	@Override
	public Object getItem(int i) {
		return musicStyleList.get(i);
	}

	@Override
	public long getItemId(int i) {

		return i;
	}

	@Override
	public View getView(int position, View view, ViewGroup viewGroup) {
		ViewHolder viewHolder;
		MusicStyleBean musicStyleBean = musicStyleList.get(position);
		List<TypeThreeBean> mythreeSong = musicStyleBean.getThreeSong();
		if (view == null) {
			viewHolder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(
					R.layout.item_music_style, null);
			viewHolder.tv_music_style = (TextView) view
					.findViewById(R.id.tv_music_style);
			viewHolder.tv_music_type_one = (TextView) view
					.findViewById(R.id.tv_music_type_one);
			viewHolder.tv_music_type_two = (TextView) view
					.findViewById(R.id.tv_music_type_two);
			viewHolder.tv_music_type_three = (TextView) view
					.findViewById(R.id.tv_music_type_three);
			viewHolder.iv_music_style = (ImageView) view
					.findViewById(R.id.iv_music_style);
			viewHolder.ll_music_type = (LinearLayout) view
					.findViewById(R.id.ll_music_type);
			viewHolder.tv_1 = (TextView) view.findViewById(R.id.tv_1);
			viewHolder.tv_2 = (TextView) view.findViewById(R.id.tv_2);
			viewHolder.tv_3 = (TextView) view.findViewById(R.id.tv_3);
			view.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) view.getTag();
		}
		viewHolder.tv_music_style.setText(musicStyleBean.getListTypeName());
		BaseApplication.bitmapUtils.display(viewHolder.iv_music_style,
				musicStyleBean.getImageSrc());

		if (mythreeSong.size() == 3) {
			viewHolder.tv_music_type_one.setText(mythreeSong.get(0)
					.getSongName());
			viewHolder.tv_music_type_two.setText(mythreeSong.get(1)
					.getSongName());
			viewHolder.tv_music_type_three.setText(mythreeSong.get(2)
					.getSongName());
		} else if (mythreeSong.size() == 2) {
			viewHolder.tv_music_type_one.setText(mythreeSong.get(0)
					.getSongName());
			viewHolder.tv_music_type_two.setText(mythreeSong.get(1)
					.getSongName());
			viewHolder.tv_3.setVisibility(View.GONE);

		} else if (mythreeSong.size() == 1) {
			viewHolder.tv_music_type_one.setText(mythreeSong.get(0)
					.getSongName());
			viewHolder.tv_3.setVisibility(View.GONE);
			viewHolder.tv_2.setVisibility(View.GONE);
		} else if (mythreeSong.size() == 0) {
			viewHolder.tv_3.setVisibility(View.GONE);
			viewHolder.tv_2.setVisibility(View.GONE);
			viewHolder.tv_1.setVisibility(View.GONE);
		}
		return view;
	}

	class ViewHolder {

		LinearLayout ll_music_type;
		TextView tv_music_style, tv_music_type_one, tv_music_type_two,
				tv_music_type_three, tv_1, tv_2, tv_3;
		public ImageView iv_music_style;

		// TextView tv_music_style;
		// public ImageView iv_music_style;
	}

	public void setList(ArrayList<MusicStyleBean> musicStyleList) {
		this.musicStyleList = musicStyleList;
		notifyDataSetChanged();
	}

}
