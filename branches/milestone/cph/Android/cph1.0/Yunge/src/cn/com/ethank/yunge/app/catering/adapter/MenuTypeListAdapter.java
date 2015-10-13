package cn.com.ethank.yunge.app.catering.adapter;

import java.util.List;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

public class MenuTypeListAdapter extends BaseAdapter {

	Context context;
	List<String> list;

	public MenuTypeListAdapter(Context context, List<String> list) {
		super();
		this.context = context;
		this.list = list;
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return list.size();
	}

	@Override
	public Object getItem(int arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long getItemId(int arg0) {
		// TODO Auto-generated method stub
		return 0;
	}

	public int getTouchViewSign() {
		return touchViewSign;
	}

	public void setTouchViewSign(int touchViewSign) {
		this.touchViewSign = touchViewSign;
	}

	ViewHolder holder;
	int touchViewSign = 0;

	@Override
	public View getView(int arg0, View arg1, ViewGroup arg2) {
		// TODO Auto-generated method stub
		if (arg1 == null) {
			holder = new ViewHolder();
			arg1 = LayoutInflater.from(context).inflate(R.layout.adapter_menutypelist, null);
			holder.tv_typename_id = (TextView) arg1.findViewById(R.id.tv_typename_id);
			arg1.setTag(holder);
		} else {
			holder = (ViewHolder) arg1.getTag();
		}

		if (touchViewSign == arg0) {
			holder.tv_typename_id.setTextColor(Color.parseColor("#f2f2f2"));
			holder.tv_typename_id.setBackgroundColor(Color.parseColor("#84265f"));
		} else {
			holder.tv_typename_id.setBackgroundColor(Color.TRANSPARENT);
			holder.tv_typename_id.setTextColor(Color.parseColor("#3e3f48"));
		}

		holder.tv_typename_id.setText(list.get(arg0).toString());
		holder.tv_typename_id.setTag(arg0);
		// holder.tv_typename_id.setOnClickListener(new tvTouch());

		return arg1;
	}

	// class tvTouch implements OnClickListener {
	// @Override
	// public void onClick(View arg0) {
	// // TODO Auto-generated method stub
	// touchViewSign = (Integer) arg0.getTag();
	// notifyDataSetChanged();
	// }
	// }

	class ViewHolder {
		TextView tv_typename_id;
	}

}
