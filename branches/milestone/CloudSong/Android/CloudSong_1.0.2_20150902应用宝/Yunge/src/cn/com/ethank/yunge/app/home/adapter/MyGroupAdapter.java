package cn.com.ethank.yunge.app.home.adapter;

import cn.com.ethank.yunge.R;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

public class MyGroupAdapter extends BaseAdapter {

	Context context;
	public MyGroupAdapter(Context context) {
		this.context = context;
	}
	@Override
	public int getCount() {
		return 5;
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		return View.inflate(context, R.layout.item_group_buy, null);
	}

}
