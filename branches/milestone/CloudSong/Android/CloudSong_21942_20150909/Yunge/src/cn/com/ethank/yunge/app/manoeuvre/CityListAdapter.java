package cn.com.ethank.yunge.app.manoeuvre;

import java.util.List;

import cn.com.ethank.yunge.R;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class CityListAdapter extends BaseAdapter {

	private Context context;
	private List<String> cityList;

	public CityListAdapter(Context context, List<String> cityList) {
		this.context = context;
		this.cityList = cityList;
	}

	@Override
	public int getCount() {
		return cityList.size();
	}

	@Override
	public Object getItem(int position) {
		return cityList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder = null;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_city_select, null);
			viewHolder.tv_city_item = (TextView) convertView.findViewById(R.id.tv_city_item);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		viewHolder.tv_city_item.setText(cityList.get(position));
		return convertView;
	}

	public void setList(List<String> cityList) {
		this.cityList = cityList;
		notifyDataSetChanged();

	}

	class ViewHolder {

		public TextView tv_city_item;

	}
}
