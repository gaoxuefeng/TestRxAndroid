package cn.com.ethank.yunge.app.discover.adapter;

import java.util.List;

import com.coyotelib.app.ui.util.UICommonUtil;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.DisplayUtil;
import cn.com.ethank.yunge.app.util.XCRoundImageViewByXfermode;

public class DisCoverAdapter extends BaseAdapter {

	private List<DiscoverInfo> list;
	private Context context;

	public DisCoverAdapter(List<DiscoverInfo> list, Context context) {
		super();
		this.list = list;
		this.context = context;
	}

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	public void setList(List<DiscoverInfo> list) {
		this.list = list;
		notifyDataSetChanged();
	}

	String text = "下拉刷新...";

	public void setText(String text) {
		this.text = text;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = View.inflate(context, R.layout.layout_discover_item, null);
			holder.content_layout_id = (RelativeLayout) convertView.findViewById(R.id.content_layout_id);
			holder.layout_id = (RelativeLayout) convertView.findViewById(R.id.layout_id);
			holder.img = (ImageView) convertView.findViewById(R.id.discover_img);
			holder.progresslayout_id = (RelativeLayout) convertView.findViewById(R.id.progresslayout_id);
			holder.img = (ImageView) convertView.findViewById(R.id.discover_img);
			holder.dis_img_small = (XCRoundImageViewByXfermode) convertView.findViewById(R.id.dis_img_small);
			holder.dis_tv_name = (TextView) convertView.findViewById(R.id.dis_tv_name);
			holder.dis_tv_musicname = (TextView) convertView.findViewById(R.id.dis_tv_musicname);
			holder.dis_tv_listsen = (TextView) convertView.findViewById(R.id.dis_tv_listsen);
			holder.dis_tv_bestdesc = (TextView) convertView.findViewById(R.id.dis_tv_bestdesc);
			holder.refreshtv_id = (TextView) convertView.findViewById(R.id.refreshtv_id);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		holder.refreshtv_id.setText(text);
		if (position == 0 || position == 1) {
			holder.layout_id.setVisibility(View.GONE);
			holder.img.setVisibility(View.GONE);
			holder.content_layout_id.setBackgroundColor(Color.TRANSPARENT);
			if (position == 0) {
				convertView.setLayoutParams(new AbsListView.LayoutParams(UICommonUtil.getScreenWidthPixels(context) * 2 / 3 - 60, DisplayUtil.dip2px(60)));
				holder.progresslayout_id.setVisibility(View.VISIBLE);
			} else {
				convertView.setLayoutParams(new AbsListView.LayoutParams(UICommonUtil.getScreenWidthPixels(context) / 3 + 60, DisplayUtil.dip2px(60)));
				holder.progresslayout_id.setVisibility(View.GONE);
			}
		} else {
			holder.content_layout_id.setBackgroundColor(Color.parseColor("#1a1a1e"));
			holder.layout_id.setVisibility(View.VISIBLE);
			holder.img.setVisibility(View.VISIBLE);
			holder.progresslayout_id.setVisibility(View.GONE);

			DiscoverInfo bean = list.get(position);
			convertView.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.WRAP_CONTENT, AbsListView.LayoutParams.WRAP_CONTENT));
			BaseApplication.bitmapUtils.display(holder.img, bean.getMusicPhotoUrl(), R.drawable.finddefaulticon);
			BaseApplication.bitmapUtils.display(holder.dis_img_small, bean.getAvatarUrl(), R.drawable.mine_defaultavatar);
			holder.dis_tv_name.setText(bean.getUserNickName());

			String musicname = bean.getMusicName();
			if (!bean.getMusicName().isEmpty()) {
				if (musicname.length() > 5) {
					musicname = musicname.substring(0, 5) + "...";
				}
			}
			holder.dis_tv_musicname.setText(musicname);
			holder.dis_tv_listsen.setText(" " + String.valueOf(bean.getListenCount()));
			holder.dis_tv_bestdesc.setText(" " + String.valueOf(bean.getPraiseCount()));
		}

		return convertView;
	}

	class ViewHolder {
		private RelativeLayout content_layout_id, layout_id, progresslayout_id;
		public ImageView img;
		public XCRoundImageViewByXfermode dis_img_small;
		public TextView dis_tv_name, dis_tv_listsen, dis_tv_bestdesc, dis_tv_musicname;
		private TextView refreshtv_id;
	}
}