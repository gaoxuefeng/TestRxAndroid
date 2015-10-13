package cn.com.ethank.yunge.app.ui.doublelist;

import java.util.List;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.bean.CityCircleBean;

public class MasterAdapter extends BaseAdapter {

	private int selectedPosition = 0;
	private List<CityCircleBean> list;
	private Context context;

	public MasterAdapter(Context context, List<CityCircleBean> nearbyList) {
		this.context = context;
		this.list = nearbyList;
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

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.masterlistitem, null);
			viewHolder.tv_mastername = (TextView) convertView.findViewById(R.id.tv_mastername);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		if (selectedPosition == position) {
			convertView.setBackgroundColor(Color.parseColor("#1C1C20"));
		} else {
			convertView.setBackgroundColor(Color.parseColor("#151417"));
		}
		// 显示区名
		viewHolder.tv_mastername.setText(list.get(position).getDistrict());
		return convertView;
	}

	public void setData(List<CityCircleBean> nearbyList) {
		this.list = nearbyList;
		selectedPosition = 0;
		notifyDataSetChanged();
	}

	class ViewHolder {

		public TextView tv_mastername;

	}

	public void setSelectedPosition(int position) {
		selectedPosition = position;
		notifyDataSetChanged();
	}
}
