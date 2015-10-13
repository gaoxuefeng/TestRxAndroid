package cn.com.ethank.yunge.app.ui.doublelist;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Color;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

public class OrderByAdapter extends BaseAdapter {

	private Context context;
	private ArrayList<String> orderbyList;
	private int selectPosition = 0;

	public OrderByAdapter(Context context, ArrayList<String> orderbyList) {
		this.context = context;
		this.orderbyList = orderbyList;
	}

	@Override
	public int getCount() {
		return orderbyList.size();
	}

	@Override
	public Object getItem(int position) {
		return orderbyList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = LayoutInflater.from(context).inflate(R.layout.item_orderby, null);

		}
		TextView tv_orderby = (TextView) convertView.findViewById(R.id.tv_orderby);
		TextView tv_bottom_color = (TextView) convertView.findViewById(R.id.tv_bottom_color);
		tv_orderby.setText(orderbyList.get(position));
		if (selectPosition == position) {
			tv_bottom_color.setBackgroundColor(Color.parseColor("#C7438D"));
			tv_orderby.setTextColor(Color.parseColor("#C7438D"));

		} else {
			tv_bottom_color.setBackgroundColor(Color.parseColor("#151417"));
			tv_orderby.setTextColor(Color.parseColor("#84868D"));
		}
		return convertView;
	}

	public void setSelectPosition(int position) {
		this.selectPosition = position;
		notifyDataSetChanged();
	}

	public int getSelectPosition() {
		return selectPosition + 1;
		// 1.:智能排序 2.：离我最近；3：人气最高；4：全网最低
	}
}
