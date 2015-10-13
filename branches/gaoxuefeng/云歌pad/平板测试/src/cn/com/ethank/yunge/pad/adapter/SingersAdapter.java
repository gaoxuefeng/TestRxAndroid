package cn.com.ethank.yunge.pad.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.bean.SinglerBean;


/**
 * Created by dddd on 2015/4/28.
 */
public class SingersAdapter extends BaseAdapter {
	private Context context;
	private ArrayList<SinglerBean> singlerList;

	public SingersAdapter(Context context, ArrayList<SinglerBean> singlerList) {
		this.context = context;
		this.singlerList = singlerList;
	}

	@Override
	public int getCount() {

		return singlerList.size();
	}

	@Override
	public Object getItem(int i) {
		return singlerList.get(i);
	}

	@Override
	public long getItemId(int i) {

		return i;
	}

	@Override
	public View getView(int i, View view, ViewGroup viewGroup) {
		ViewHolder viewHolder;
		SinglerBean singlerBean = singlerList.get(i);
		if (view == null) {
			viewHolder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.item_singers, null);
			viewHolder.iv_single = (ImageView) view.findViewById(R.id.iv_single);
			viewHolder.tv_singler_name = (TextView) view.findViewById(R.id.tv_singler_name);
			view.setTag(viewHolder);

		} else {
			viewHolder = (ViewHolder) view.getTag();
		}
		viewHolder.tv_singler_name.setText(singlerBean.getSinglerName());

		return view;
	}

	class ViewHolder {
		TextView tv_singler_name;
		ImageView iv_single;
	}
}
