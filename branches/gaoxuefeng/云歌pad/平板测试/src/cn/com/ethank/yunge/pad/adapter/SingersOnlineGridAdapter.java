package cn.com.ethank.yunge.pad.adapter;

import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.pad.BaseApplication;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.activity.SongListSearchBySingerActivity;
import cn.com.ethank.yunge.pad.bean.SinglerOnLine;

import com.coyotelib.app.ui.util.UICommonUtil;

/**
 * Created by dddd on 2015/4/28.
 */
public class SingersOnlineGridAdapter extends BaseAdapter {
	private Context context;
	private List<SinglerOnLine> singlerList;

	public SingersOnlineGridAdapter(Context context, List<SinglerOnLine> singlerList) {
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
		final SinglerOnLine singlerBean = singlerList.get(i);
		if (view == null) {
			viewHolder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.item_singers, null);
			viewHolder.iv_single = (ImageView) view.findViewById(R.id.iv_single);
			viewHolder.tv_singler_name = (TextView) view.findViewById(R.id.tv_singler_name);
			int screenWidth = UICommonUtil.getScreenWidthPixels(context);

			int screenHeight = UICommonUtil.getScreenHeightPixels(context);
			view.setTag(viewHolder);

		} else {
			viewHolder = (ViewHolder) view.getTag();
		}
		viewHolder.tv_singler_name.setText(singlerBean.getSingerName());

//		BaseApplication.bitmapUtils.display(viewHolder.iv_single, singlerBean.getSingerImageUrl(),R.drawable.ic_launcher);
		BaseApplication.bitmapUtils.display(viewHolder.iv_single, singlerBean.getSingerImageUrl());
		view.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(context, SongListSearchBySingerActivity.class);
				intent.putExtra("className", singlerBean.getSingerName());
				intent.putExtra("singlerBean", singlerBean);
				context.startActivity(intent);
			}
		});
		return view;
	}

	class ViewHolder {
		TextView tv_singler_name;
		ImageView iv_single;
	}

	public void setList(List<SinglerOnLine> singlerOnLines) {
		this.singlerList = singlerOnLines;
		notifyDataSetChanged();
	}
}
