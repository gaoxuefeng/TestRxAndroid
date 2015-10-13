package cn.com.ethank.yunge.app.room.adapter;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.gif.GifView;
import cn.com.ethank.yunge.app.room.bean.GetNewInfo.New;
import cn.com.ethank.yunge.app.util.Constants;

import com.lidroid.xutils.BitmapUtils;

public class MyAdapter extends BaseAdapter {

	final int TYPE_0 = 0;
	final int TYPE_1 = 1;
	final int TYPE_2 = 2;
	private BitmapUtils bitmapUtils;

	List<New> news;
	Context context;

	public MyAdapter(List<New> news, Context context) {
		this.news = news;
		this.context = context;
	}

	@Override
	public int getViewTypeCount() {
		return 3;
	}

	@Override
	public int getItemViewType(int position) {
		// int p = position % 3;
		int p = position;

		if (news.get(position).getMsgType() == 0) {
			p = 0;
		} else if (news.get(position).getMsgType() == 1) {
			p = 1;
		} else if (news.get(position).getMsgType() == 2) {
			p = 2;
		}
		if (p == 0) {
			return TYPE_0;
		} else if (p == 1) {
			return TYPE_2;
		} else if (p == 2) {
			return TYPE_1;
		}
		return TYPE_0;
	}

	@Override
	public int getCount() {
		return news.size();
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
		bitmapUtils = new BitmapUtils(context);
		ViewHolder0 holder0 = null;
		ViewHolder1 holder1 = null;
		ViewHolder2 holder2 = null;
		int type = getItemViewType(position);
		if (convertView == null) {
			switch (type) {
			case TYPE_0:
				convertView = View.inflate(context, R.layout.item_chat_info, null);
				holder0 = new ViewHolder0();
				holder0.chat_tv_name = (TextView) convertView.findViewById(R.id.chat_tv_name);

				holder0.room_view_line2 = convertView.findViewById(R.id.room_view_line2);
				holder0.room_view_line1 = convertView.findViewById(R.id.room_view_line1);

				holder0.chat_iv_img = (ImageView) convertView.findViewById(R.id.chat_iv_img);
				holder0.room_tv_active = (TextView) convertView.findViewById(R.id.room_tv_active);

				convertView.setTag(holder0);
				break;
			case TYPE_1:
				convertView = View.inflate(context, R.layout.item_chat_face, null);
				holder1 = new ViewHolder1();
				holder1.face_iv_img = (ImageView) convertView.findViewById(R.id.face_iv_img);
				holder1.face_tv_name = (TextView) convertView.findViewById(R.id.face_tv_name);
				holder1.gf = (GifView) convertView.findViewById(R.id.face_gf);
				holder1.face_img_view1 = convertView.findViewById(R.id.face_img_view1);
				convertView.setTag(holder1);
				break;
			case TYPE_2:
				convertView = View.inflate(context, R.layout.item_chat_img, null);
				holder2 = new ViewHolder2();
				holder2.img_view_line1 = convertView.findViewById(R.id.img_view_line1);

				holder2.chat_iv_img1 = (ImageView) convertView.findViewById(R.id.chat_iv_img1);
				holder2.chat_iv_img2 = (ImageView) convertView.findViewById(R.id.chat_iv_img2);
				holder2.chat_tv_name1 = (TextView) convertView.findViewById(R.id.chat_tv_name1);
				convertView.setTag(holder2);

				break;

			}
		} else {
			switch (type) {
			case TYPE_0:
				holder0 = (ViewHolder0) convertView.getTag();
				break;
			case TYPE_1:
				holder1 = (ViewHolder1) convertView.getTag();
				break;
			case TYPE_2:
				holder2 = (ViewHolder2) convertView.getTag();
				break;

			}
		}

		switch (type) {
		
		case TYPE_0:
			if (position == 0) {
				//holder0.chat_tv_name.setTextColor(context.getResources().getColor(R.color.room_yunge));
				holder0.room_view_line2.setVisibility(View.GONE);
				//holder0.chat_iv_img.setBackground(context.getResources().getDrawable(R.drawable.logo));
			} else {
				//holder0.chat_tv_name.setTextColor(context.getResources().getColor(R.color.room_name));
				holder0.room_view_line2.setVisibility(View.VISIBLE);
				//holder0.chat_iv_img.setBackground(context.getResources().getDrawable(R.drawable.mine_default_bg));
			}

			if (position == (news.size() - 1)) {
				holder0.room_view_line1.setVisibility(View.GONE);
			} else {
				holder0.room_view_line1.setVisibility(View.VISIBLE);
			}

			if (position == (news.size() - 1)) {
				holder0.room_tv_active.setFocusable(true);
			}
			holder0.chat_tv_name.setText(news.get(position).getUserName());
			bitmapUtils.display(holder0.chat_iv_img, news.get(position).getHeadUrl());
			holder0.room_tv_active.setText(news.get(position).getMsgContent());

			break;
		case TYPE_1:
			InputStream input = getInputgf(news.get(position).getMsgContent());
			holder1.gf.setMovieInput(input);
			bitmapUtils.display(holder1.face_iv_img, news.get(position).getHeadUrl());
			holder1.face_tv_name.setText(news.get(position).getUserName());
			if (position == (news.size() - 1)) {
				holder1.face_img_view1.setVisibility(View.GONE);
			} else {
				holder1.face_img_view1.setVisibility(View.VISIBLE);
			}
			break;
		case TYPE_2:
			if (position == (news.size() - 1)) {
				holder2.img_view_line1.setVisibility(View.GONE);
			} else {
				holder2.img_view_line1.setVisibility(View.VISIBLE);
			}
			bitmapUtils.display(holder2.chat_iv_img1, news.get(position).getHeadUrl());
			bitmapUtils.display(holder2.chat_iv_img2, news.get(position).getMsgContent());
			holder2.chat_tv_name1.setText(news.get(position).getUserName());
			break;
		}

		return convertView;
	}

	InputStream getInputgf(String str) {
		try {
			InputStream open = context.getAssets().open(str);
			return open;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	class ViewHolder0 {
		ImageView chat_iv_img;
		TextView chat_tv_name;
		View room_view_line2;
		View room_view_line1;
		TextView room_tv_active;
	}

	class ViewHolder1 {
		ImageView face_iv_img;
		TextView face_tv_name;
		View face_img_view1;
		GifView gf;
	}

	class ViewHolder2 {
		View img_view_line1;
		ImageView chat_iv_img1;
		ImageView chat_iv_img2;
		TextView chat_tv_name1;

	}
}