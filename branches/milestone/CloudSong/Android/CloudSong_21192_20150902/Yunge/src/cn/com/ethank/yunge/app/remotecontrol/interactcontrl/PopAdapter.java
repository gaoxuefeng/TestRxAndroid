package cn.com.ethank.yunge.app.remotecontrol.interactcontrl;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.util.ToastUtil;

public class PopAdapter extends BaseAdapter {

	private Context context;
	private ArrayList<String> stringList;
	private OnItemClickLiistener itemClickLiistener;

	public PopAdapter(Context context, ArrayList<String> stringList, OnItemClickLiistener itemClickLiistener) {
		this.context = context;
		this.stringList = stringList;
		this.itemClickLiistener = itemClickLiistener;
	}

	@Override
	public int getCount() {
		return stringList.size();
	}

	@Override
	public Object getItem(int position) {
		return stringList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public interface OnItemClickLiistener {
		void OnItemClick(int position);
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		ViewHolder holder;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_string_list, null);
			holder.tv_string = (TextView) convertView.findViewById(R.id.tv_string);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.tv_string.setText(stringList.get(position));
		convertView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (itemClickLiistener != null) {
					itemClickLiistener.OnItemClick(position);
				}
				// ToastUtil.show("点击了" + position);

			}
		});
		return convertView;
	}

	class ViewHolder {

		public TextView tv_string;

	}
}
