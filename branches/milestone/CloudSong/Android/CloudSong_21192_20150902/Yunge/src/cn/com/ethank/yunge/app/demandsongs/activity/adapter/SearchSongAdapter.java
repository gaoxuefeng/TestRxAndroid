package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.SinglerOnLine;


public class SearchSongAdapter extends BaseAdapter {

	private Context context;
	private List<SinglerOnLine> singlerOnLines;

	public SearchSongAdapter(Context context, List<SinglerOnLine> singlerOnLines) {
		this.context = context;
		this.singlerOnLines = singlerOnLines;
	}

	@Override
	public int getCount() {
		return singlerOnLines.size();
	}

	@Override
	public Object getItem(int position) {
		return singlerOnLines.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View view, ViewGroup arg2) {
		ViewHolder holder;
		if (view == null) {
			holder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.item_singers, null);
			holder.tv_singler_name = (TextView) view.findViewById(R.id.tv_singler_name);
			view.setTag(holder);
		} else {
			holder = (ViewHolder) view.getTag();
		}
		holder.tv_singler_name.setText(singlerOnLines.get(position).getSingerName());
		return view;
	}

	public void setList(List<SinglerOnLine> singlerOnLines) {
		this.singlerOnLines = singlerOnLines;
		notifyDataSetChanged();
	}

	class ViewHolder {
		TextView tv_singler_name;
	}
}
