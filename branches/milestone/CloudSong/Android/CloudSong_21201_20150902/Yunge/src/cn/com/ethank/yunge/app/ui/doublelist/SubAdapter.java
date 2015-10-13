package cn.com.ethank.yunge.app.ui.doublelist;

import java.util.ArrayList;
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

public class SubAdapter extends BaseAdapter {

	private Context context;
	private List<String> arrayList;
	private CityCircleBean cityCircleBean;
	private String selectCityName = "";

	public SubAdapter(Context context, ArrayList<String> arrayList) {
		this.context = context;
		this.arrayList = arrayList;
		selectCityName = "全城";
	}

	@Override
	public int getCount() {
		return arrayList.size();
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public void setSelectData(String cityName) {
		selectCityName = cityName;
		notifyDataSetChanged();
	}

	public String getMastTabName(int position) {
		if (cityCircleBean.getCircleName() == null) {
			return (String) getItem(position);
		} else {

			return cityCircleBean.getDistrict();
		}

	}

	@Override
	public Object getItem(int position) {
		return arrayList.get(position);
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder = null;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.sublistitem, null);
			viewHolder.tv_subname = (TextView) convertView.findViewById(R.id.tv_subname);
			viewHolder.view_bottom_line = (View) convertView.findViewById(R.id.view_bottom_line);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		viewHolder.tv_subname.setText(arrayList.get(position));
		if (selectCityName.equals(arrayList.get(position))||(selectCityName.equals(cityCircleBean.getDistrict())&&position==0)) {
			viewHolder.view_bottom_line.setBackgroundColor(Color.parseColor("#C7438D"));
			viewHolder.tv_subname.setTextColor(Color.parseColor("#C7438D"));

		} else {
			viewHolder.view_bottom_line.setBackgroundColor(Color.parseColor("#0AFFFFFF"));
			viewHolder.tv_subname.setTextColor(Color.parseColor("#84868D"));
		}
		return convertView;
	}

	class ViewHolder {

		public View view_bottom_line;
		public TextView tv_subname;

	}

	public void setData(CityCircleBean cityCircleBean) {
		this.cityCircleBean = cityCircleBean;
		this.arrayList = cityCircleBean.getCircleName();
		notifyDataSetChanged();
	}

}
