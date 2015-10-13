package com.example.yungelight;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class ContronAdapter extends BaseAdapter {

	private ArrayList<ContronBean> contronBeans;
	private Context context;

	public ContronAdapter(Context context, ArrayList<ContronBean> contronBeans) {
		this.context = context;
		this.contronBeans = contronBeans;
	}

	@Override
	public int getCount() {
		return contronBeans.size();
	}

	@Override
	public Object getItem(int position) {
		return contronBeans.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_contron, null);
			viewHolder.tv_item_name = (TextView) convertView.findViewById(R.id.tv_item_name);
			viewHolder.tv_item_code = (TextView) convertView.findViewById(R.id.tv_item_code);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		ContronBean contronBean = contronBeans.get(position);
		viewHolder.tv_item_code.setText(contronBean.getModeCode());
		viewHolder.tv_item_name.setText(contronBean.getModeName());
		return convertView;
	}

	class ViewHolder {
		private TextView tv_item_name;
		private TextView tv_item_code;
	}
}
