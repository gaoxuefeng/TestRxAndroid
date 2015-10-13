package cn.com.ethank.yunge.app.catering.adapter;

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.bean.TypeContentItem;
import cn.com.ethank.yunge.app.catering.utils.SubZeroAndDot;

public class SubmitOrderListAdapter extends BaseAdapter {

	List<TypeContentItem> list;
	Context context;

	public SubmitOrderListAdapter(List<TypeContentItem> list, Context context) {
		super();
		this.list = list;
		this.context = context;
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

	ViewHolder holder;

	@Override
	public View getView(int arg0, View arg1, ViewGroup arg2) {
		// TODO Auto-generated method stub
		if (arg1 == null) {
			holder = new ViewHolder();
			arg1 = LayoutInflater.from(context).inflate(R.layout.adapter_submitorderlist, null);
			holder.iv_typeicon_id = (ImageView) arg1.findViewById(R.id.iv_typeicon_id);
			holder.tv_typeName_id = (TextView) arg1.findViewById(R.id.tv_typeName_id);
			holder.tv_typenum_id = (TextView) arg1.findViewById(R.id.tv_typenum_id);
			holder.tv_price_id = (TextView) arg1.findViewById(R.id.tv_price_id);
			arg1.setTag(holder);
		} else {
			holder = (ViewHolder) arg1.getTag();
		}

		TypeContentItem item = list.get(arg0);

		holder.tv_typeName_id.setText(item.getInfoitem().getGName());
		holder.tv_typenum_id.setText("x" + String.valueOf(item.getAddNum()));
		holder.tv_price_id.setText("¥ " + item.getInfoitem().getGPrice());

		return arg1;
	}

	class ViewHolder {
		ImageView iv_typeicon_id;
		TextView tv_typeName_id, tv_typenum_id, tv_price_id;
	}

}
