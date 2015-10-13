package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.SingerTypeBean;

/**
 * Created by dddd on 2015/4/28.
 */
public class SinglerTypeAdapter extends BaseAdapter {
	private Context context;
	private ArrayList<SingerTypeBean> singerTypeList;

	public SinglerTypeAdapter(Context context, ArrayList<SingerTypeBean> singerTypeList) {

		this.context = context;
		this.singerTypeList = singerTypeList;
	}

	@Override
	public int getCount() {
		return singerTypeList.size();
	}

	@Override
	public Object getItem(int i) {
		return singerTypeList.get(i);
	}

	@Override
	public long getItemId(int i) {
		return i;
	}

	@SuppressLint("ViewHolder")
	@Override
	public View getView(int position, View view, ViewGroup viewGroup) {
		// 不复用
		ViewHolder viewHolder = new ViewHolder();
		view = LayoutInflater.from(context).inflate(R.layout.item_singler_type, null);
		viewHolder.tv_singler_type = (TextView) view.findViewById(R.id.tv_singler_type);
		viewHolder.tv_bottom = (TextView) view.findViewById(R.id.tv_bottom);
		viewHolder.tv_bottom_line = (TextView) view.findViewById(R.id.tv_bottom_line);
		
		view.setTag(viewHolder);

		if (position % 3 == 0) {
			// 上
			viewHolder.tv_singler_type.getBackground().setLevel(0);
			viewHolder.tv_bottom.setVisibility(View.GONE);
			viewHolder.tv_bottom_line.setVisibility(View.VISIBLE);
		} else if (position % 3 == 1) {
			// 中
			viewHolder.tv_singler_type.getBackground().setLevel(1);
			viewHolder.tv_bottom.setVisibility(View.GONE);
			viewHolder.tv_bottom_line.setVisibility(View.VISIBLE);
		} else {
			// 下
			viewHolder.tv_singler_type.getBackground().setLevel(2);
			viewHolder.tv_bottom.setVisibility(View.VISIBLE);
			viewHolder.tv_bottom_line.setVisibility(View.GONE);
		}

		viewHolder.tv_singler_type.setText(singerTypeList.get(position).getSingerTypeName());

		return view;
	}

	class ViewHolder {

		public TextView tv_bottom;
		TextView tv_singler_type;
		TextView tv_bottom_line;
	}

}
