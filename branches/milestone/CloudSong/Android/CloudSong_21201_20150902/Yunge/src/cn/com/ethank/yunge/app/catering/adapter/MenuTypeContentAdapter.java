package cn.com.ethank.yunge.app.catering.adapter;

import java.util.List;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.bean.TypeContentItem;
import cn.com.ethank.yunge.app.catering.utils.ConstantsUtils;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;

public class MenuTypeContentAdapter extends BaseAdapter {

	List<TypeContentItem> typeContentlist;
	Context context;
	RefreshUiInterface refreshUiInterface;

	public MenuTypeContentAdapter(List<TypeContentItem> typeContentlist, Context context, RefreshUiInterface refreshUiInterface) {
		super();
		this.typeContentlist = typeContentlist;
		this.context = context;
		this.refreshUiInterface = refreshUiInterface;
	}

	public void setTypeContentlist(List<TypeContentItem> typeContentlist) {
		this.typeContentlist = typeContentlist;
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return typeContentlist.size();
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
			arg1 = LayoutInflater.from(context).inflate(R.layout.adapter_typecontent, null);

			holder.tv_typeName_id = (TextView) arg1.findViewById(R.id.tv_typeName_id);
			holder.tv_price_id = (TextView) arg1.findViewById(R.id.tv_price_id);
			holder.tv_reduce_id = (TextView) arg1.findViewById(R.id.tv_reduce_id);
			holder.tv_num_id = (TextView) arg1.findViewById(R.id.tv_num_id);
			holder.tv_add_id = (TextView) arg1.findViewById(R.id.tv_add_id);
			holder.iv_typeicon_id = (ImageView) arg1.findViewById(R.id.iv_typeicon_id);

			arg1.setTag(holder);
		} else {
			holder = (ViewHolder) arg1.getTag();
		}

		TypeContentItem item = typeContentlist.get(arg0);

		holder.tv_typeName_id.setText(item.getInfoitem().getGName());
		holder.tv_price_id.setText("¥ " + item.getInfoitem().getGPrice());

		if (typeContentlist.get(arg0).getAddNum() > 0) {
			holder.tv_add_id.setBackgroundResource(R.drawable.addtypeicon);
			holder.tv_reduce_id.setBackgroundResource(R.drawable.reducetypeicon);
			holder.tv_reduce_id.setVisibility(View.VISIBLE);
			holder.tv_num_id.setVisibility(View.VISIBLE);
			holder.tv_num_id.setText(typeContentlist.get(arg0).getAddNum() + "");
		} else {
			holder.tv_add_id.setBackgroundResource(R.drawable.addcarting_circlebg);
			holder.tv_reduce_id.setVisibility(View.GONE);
			holder.tv_num_id.setVisibility(View.GONE);
		}

		Bundle bun = new Bundle();
		bun.putInt("position", item.getPosition());
		bun.putInt("sign", arg0);
		holder.tv_add_id.setTag(bun);
		holder.tv_add_id.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View arg0, MotionEvent arg1) {
				// TODO Auto-generated method stub
				switch (arg1.getAction()) {
				case MotionEvent.ACTION_DOWN:
					Bundle bundle = (Bundle) arg0.getTag();

					int position = (Integer) bundle.getInt("position");
					int sign = (Integer) bundle.getInt("sign");

					TypeContentItem typebean = (TypeContentItem) ConstantsUtils.TYPECONTENT_LIST.get(position);
					int oldsum = typebean.getAddNum();
					ConstantsUtils.TYPECONTENT_LIST.get(typebean.getPosition()).setAddNum(oldsum + 1);
					typeContentlist.get(sign).setAddNum(oldsum + 1);
					ConstantsUtils.startPaint(arg0);

					notifyDataSetChanged();
					refreshUiInterface.refreshUi("");
					break;
				default:
					break;
				}
				return true;
			}
		});

		holder.tv_reduce_id.setTag(bun);
		holder.tv_reduce_id.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View arg0, MotionEvent arg1) {
				// TODO Auto-generated method stub
				switch (arg1.getAction()) {
				case MotionEvent.ACTION_DOWN:

					Bundle bundle = (Bundle) arg0.getTag();

					int position = (Integer) bundle.getInt("position");
					int sign = (Integer) bundle.getInt("sign");

					TypeContentItem typebean = (TypeContentItem) ConstantsUtils.TYPECONTENT_LIST.get(position);
					int oldsum = typebean.getAddNum();
					if (oldsum == 1) {
						typeContentlist.get(sign).setAddNum(0);
						ConstantsUtils.TYPECONTENT_LIST.get(typebean.getPosition()).setAddNum(0);
					} else {
						typeContentlist.get(sign).setAddNum(oldsum - 1);
						ConstantsUtils.TYPECONTENT_LIST.get(typebean.getPosition()).setAddNum(oldsum - 1);
					}

					notifyDataSetChanged();
					refreshUiInterface.refreshUi(null);

					break;
				default:
					break;
				}
				return true;
			}
		});

		return arg1;
	}

	class ViewHolder {
		TextView tv_typeName_id, tv_price_id, tv_reduce_id, tv_num_id, tv_add_id;
		ImageView iv_typeicon_id;
	}

}
