package cn.com.ethank.yunge.app.catering.adapter;

import java.util.List;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.bean.TypeContentItem;
import cn.com.ethank.yunge.app.catering.utils.ConstantsUtils;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;

public class ShoppingListAdapter extends BaseAdapter {

	Context context;
	List<TypeContentItem> list = null;
	RefreshUiInterface refreshUiInterface;

	public ShoppingListAdapter(Context context, List<TypeContentItem> list, RefreshUiInterface refreshUiInterface) {
		super();
		this.context = context;
		this.list = list;
		this.refreshUiInterface = refreshUiInterface;
	}

	public void setList(List<TypeContentItem> list) {
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

	ViewHolder holder;

	@Override
	public View getView(int arg0, View arg1, ViewGroup arg2) {
		// TODO Auto-generated method stub
		if (arg1 == null) {
			holder = new ViewHolder();
			arg1 = LayoutInflater.from(context).inflate(R.layout.adapter_shoppinglist, null);
			holder.tv_typeName_id = (TextView) arg1.findViewById(R.id.tv_typeName_id);
			holder.tv_price_id = (TextView) arg1.findViewById(R.id.tv_price_id);
			holder.tv_reduce_id = (TextView) arg1.findViewById(R.id.tv_reduce_id);
			holder.tv_num_id = (TextView) arg1.findViewById(R.id.tv_num_id);
			holder.tv_add_id = (TextView) arg1.findViewById(R.id.tv_add_id);
			arg1.setTag(holder);
		} else {
			holder = (ViewHolder) arg1.getTag();
		}

		TypeContentItem item = list.get(arg0);

		holder.tv_typeName_id.setText(item.getInfoitem().getGName());
		holder.tv_price_id.setText("¥ " + item.getInfoitem().getGPrice());
		holder.tv_num_id.setText(String.valueOf(item.getAddNum()));

		Bundle bun = new Bundle();
		bun.putInt("position", item.getPosition());
		bun.putInt("sign", arg0);
		holder.tv_add_id.setTag(bun);
		holder.tv_add_id.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				Bundle bundle = (Bundle) arg0.getTag();

				int position = (Integer) bundle.getInt("position");
				int sign = (Integer) bundle.getInt("sign");

				TypeContentItem typebean = (TypeContentItem) ConstantsUtils.TYPECONTENT_LIST.get(position);
				int oldsum = typebean.getAddNum();
				ConstantsUtils.TYPECONTENT_LIST.get(typebean.getPosition()).setAddNum(oldsum + 1);
				list.get(sign).setAddNum(oldsum + 1);

				notifyDataSetChanged();
				refreshUiInterface.refreshUi(null);
			}
		});
		holder.tv_reduce_id.setTag(bun);
		holder.tv_reduce_id.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				Bundle bundle = (Bundle) arg0.getTag();

				int position = (Integer) bundle.getInt("position");
				int sign = (Integer) bundle.getInt("sign");

				TypeContentItem typebean = (TypeContentItem) ConstantsUtils.TYPECONTENT_LIST.get(position);
				int oldsum = typebean.getAddNum();
				if (oldsum == 1) {
					list.get(sign).setAddNum(0);
					list.remove(sign);
					setList(list);
					ConstantsUtils.TYPECONTENT_LIST.get(typebean.getPosition()).setAddNum(0);
				} else {
					list.get(sign).setAddNum(oldsum - 1);
					ConstantsUtils.TYPECONTENT_LIST.get(typebean.getPosition()).setAddNum(oldsum - 1);
				}

				notifyDataSetChanged();
				refreshUiInterface.refreshUi(null);
			}
		});

		return arg1;
	}

	class ViewHolder {
		TextView tv_typeName_id, tv_price_id, tv_reduce_id, tv_num_id, tv_add_id;
	}

}
