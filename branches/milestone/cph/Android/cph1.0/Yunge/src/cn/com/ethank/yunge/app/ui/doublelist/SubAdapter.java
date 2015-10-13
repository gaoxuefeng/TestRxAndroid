package cn.com.ethank.yunge.app.ui.doublelist;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

public class SubAdapter extends BaseAdapter {

	private Context context;
	private List<String> arrayList;

	public SubAdapter(Context context, ArrayList<String> arrayList) {
		this.context = context;
		this.arrayList = arrayList;
	}

	@Override
	public int getCount() {
		return arrayList.size();
	}

	@Override
	public long getItemId(int position) {
		return position;
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
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		viewHolder.tv_subname.setText(arrayList.get(position));
		return convertView;
	}

	class ViewHolder {

		public TextView tv_subname;

	}

	public void setData(List<String> circleName) {
		this.arrayList = circleName;
		notifyDataSetChanged();
	}

}
