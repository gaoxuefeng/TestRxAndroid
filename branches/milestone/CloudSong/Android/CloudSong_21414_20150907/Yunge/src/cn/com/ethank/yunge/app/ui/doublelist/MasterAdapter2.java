package cn.com.ethank.yunge.app.ui.doublelist;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

public class MasterAdapter2 extends BaseAdapter {

	private int selectedPosition = -1;
	private ArrayList<Pair<String, String[]>> list;
	private Context context;

	public MasterAdapter2(Context context, ArrayList<Pair<String, String[]>> nearbyList) {
		this.context = context;
		this.list = nearbyList;
	}

	public void setSelectedPosition(int position) {
		selectedPosition = position;
		notifyDataSetChanged();
	}

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@SuppressLint("InflateParams")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		Pair<String, String[]> pair = list.get(position);
		ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.masterlistitem, null);
			viewHolder.masterName = (TextView) convertView.findViewById(R.id.tv_mastername);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		if (selectedPosition != -1) {
			if (list.get(selectedPosition).first.equals(pair.first)) {
				viewHolder.masterName.setBackgroundColor(Color.parseColor("#1C1C20"));
			} else {
				viewHolder.masterName.setBackgroundColor(Color.parseColor("#151417"));
			}
		}
		viewHolder.masterName.setText(pair.first);

		return convertView;
	}

	class ViewHolder {

		public TextView masterName;

	}

	void setList(ArrayList<Pair<String, String[]>> nearbyList) {
		this.list = nearbyList;
		notifyDataSetChanged();
	}
}
