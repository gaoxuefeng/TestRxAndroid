package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.Cube;
import in.srain.cube.image.ImageLoader;

import java.util.List;

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
import cn.com.ethank.yunge.app.demandsongs.activity.SongListSearchBySingerActivity;
import cn.com.ethank.yunge.app.demandsongs.beans.SinglerOnLine;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.imageloader.MyImageLoader;
import cn.com.ethank.yunge.app.startup.BaseApplication;

import com.coyotelib.app.ui.util.UICommonUtil;

/**
 * Created by dddd on 2015/4/28.
 */
public class SingersOnlineGridAdapter extends BaseAdapter {
	private Context context;
	private List<SinglerOnLine> singlerList;
	private ImageLoader imageLoader;

	public SingersOnlineGridAdapter(Context context, List<SinglerOnLine> singlerList) {
		this.context = context;
		this.singlerList = singlerList;
		 imageLoader = ImageLoaderUtil.CreatImageLoader(context,  R.drawable.sing_default_head, true);
	}

	@Override
	public int getCount() {

		return singlerList.size();
	}

	@Override
	public Object getItem(int i) {
		return singlerList.get(i);
	}

	@Override
	public long getItemId(int i) {

		return i;
	}

	@Override
	public View getView(int i, View view, ViewGroup viewGroup) {
		ViewHolder viewHolder;
		final SinglerOnLine singlerBean = singlerList.get(i);
		if (view == null) {
			viewHolder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.item_singers, null);
			viewHolder.iv_single = (CubeImageView) view.findViewById(R.id.iv_single);
			viewHolder.tv_singler_name = (TextView) view.findViewById(R.id.tv_singler_name);
			int screenWidth = UICommonUtil.getScreenWidthPixels(context);

			int screenHeight = UICommonUtil.getScreenHeightPixels(context);
			view.setTag(viewHolder);

		} else {
			viewHolder = (ViewHolder) view.getTag();
		}
		viewHolder.tv_singler_name.setText(singlerBean.getSingerName());
		viewHolder.iv_single.loadImage(imageLoader, singlerBean.getSingerImageUrl());
		view.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(context, SongListSearchBySingerActivity.class);
				intent.putExtra("className", singlerBean.getSingerName());
				intent.putExtra("singlerBean", singlerBean);
				context.startActivity(intent);
			}
		});
		return view;
	}

	class ViewHolder {
		TextView tv_singler_name;
		CubeImageView iv_single;
	}

	public void setList(List<SinglerOnLine> singlerOnLines) {
		this.singlerList = singlerOnLines;
		notifyDataSetChanged();
	}
}
