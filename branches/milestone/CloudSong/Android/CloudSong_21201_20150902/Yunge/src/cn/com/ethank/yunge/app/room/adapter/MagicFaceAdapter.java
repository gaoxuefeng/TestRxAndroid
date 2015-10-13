package cn.com.ethank.yunge.app.room.adapter;

import cn.com.ethank.yunge.R;
import cn.jpush.android.api.m;
import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class MagicFaceAdapter extends BaseAdapter {

	Context context;
	int[] magic = new int[] { R.drawable.room_magic_1, R.drawable.room_magic_2, R.drawable.room_magic_3, R.drawable.room_magic_4,
			R.drawable.room_magic_5, R.drawable.room_magic_6, R.drawable.room_magic_7, R.drawable.room_magic_8, R.drawable.room_magic_9 };
	String[] info = new String[]{};
	private View view;

	public MagicFaceAdapter(Context context) {
		this.context = context;
		this.info =  context.getResources().getStringArray(R.array.magic_info);
	}

	@Override
	public int getCount() {
		return 9;
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@SuppressLint("NewApi")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		view = View.inflate(context, R.layout.item_magic, null);
		ImageView magic_iv1 = (ImageView) view.findViewById(R.id.magic_iv1);
		magic_iv1.setBackground(context.getResources().getDrawable(magic[position]));
		TextView magic_tv1 = (TextView) view.findViewById(R.id.magic_tv1);
		magic_tv1.setText(info[position]);
		return view;
	}

}
