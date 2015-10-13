package cn.com.ethank.yunge.app.homepager;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import cn.com.ethank.yunge.R;
import cn.jpush.android.util.ac;

public class HomePagerListAdapter extends BaseAdapter {

	private List<ActivityBean> arrayList;
	private Context context;

	public HomePagerListAdapter(Context context, List<ActivityBean> arrayList) {
		this.context = context;

		for (int i = 0; i < arrayList.size(); i++) {
			arrayList.get(i).setBgTag(new Random().nextInt(5));// 0-4
		}
		this.arrayList = arrayList;
	}

	public void setList(List<ActivityBean> arrayList) {
		for (int i = 0; i < arrayList.size(); i++) {
			arrayList.get(i).setBgTag(new Random().nextInt(5));// 0-4
		}
		this.arrayList = arrayList;
		notifyDataSetChanged();
	}

	@Override
	public int getCount() {
		if (arrayList.size() % 5 == 0) {
			int size = (arrayList.size() * 2 / 5);
			return size;
		} else {
			int size = (arrayList.size() * 2 / 5) + ((arrayList.size() % 5) > 3 ? 2 : 1);
			return size;
		}

	}

	@Override
	public Object getItem(int position) {
		ArrayList<ActivityBean> itemList = new ArrayList<ActivityBean>();

		if (position % 2 == 0) {// 0,2,4
			// 3个的
			for (int i = 0; i < 3; i++) {
				int itemPosition = i + position * 5 / 2;
				if (arrayList.size() > itemPosition) {

					itemList.add(arrayList.get(itemPosition));
				}

			}

		} else {
			// 两个的
			for (int i = 0; i < 2; i++) {
				int itemPosition = i + 3 + (position - 1) * 5 / 2;
				if (arrayList.size() > itemPosition) {
					itemList.add(arrayList.get(itemPosition));
				}
			}

		}

		return itemList;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@SuppressWarnings("unchecked")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ListViewHolder listViewHolder = null;
		if (convertView == null) {
			listViewHolder = new ListViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.home_grid_view, null);
			listViewHolder.mgv_home_item = (GridView) convertView.findViewById(R.id.mgv_home_item);
			listViewHolder.mgv_home_item.setNumColumns(position % 2 == 0 ? 3 : 2);
			listViewHolder.childGridViewAdapter = new ChildGridViewAdapter(context, (ArrayList<ActivityBean>) getItem(position), position);
			listViewHolder.mgv_home_item.setAdapter(listViewHolder.childGridViewAdapter);
			convertView.setTag(listViewHolder);
		} else {
			listViewHolder = (ListViewHolder) convertView.getTag();
			listViewHolder.mgv_home_item.setNumColumns(position % 2 == 0 ? 3 : 2);
			listViewHolder.childGridViewAdapter.setList((ArrayList<ActivityBean>) getItem(position), position);
		}
		// 填充数据

		return convertView;
	}

	class ListViewHolder {

		public ChildGridViewAdapter childGridViewAdapter;
		public GridView mgv_home_item;

	}
}
