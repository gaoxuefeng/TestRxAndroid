package cn.com.ethank.yunge.app.discover.adapter;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;

import java.util.List;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.imageloader.MyImageLoader;
import cn.com.ethank.yunge.app.util.XCRoundImageViewByXfermode;

import com.coyotelib.app.ui.util.UICommonUtil;

public class DisCoverAdapter extends BaseAdapter {

	private List<DiscoverInfo> list;
	private Context context;
	private ImageLoader circleImageLoader;
	private ImageLoader imageLoader;

	

	public DisCoverAdapter(List<DiscoverInfo> list, Context context) {
		super();
		this.list = list;
		this.context = context;
		 circleImageLoader = ImageLoaderUtil.CreatImageLoader(context,  R.drawable.mine_defaultavatar, true);
		 imageLoader = ImageLoaderUtil.CreatImageLoader(context,  R.drawable.find_deflaut_bg);
	}

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public DiscoverInfo getItem(int position) {
		if (list != null && position >= 0 && position < list.size()) {
			return list.get(position);
		}
		return new DiscoverInfo();
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public void setList(List<DiscoverInfo> list) {
		this.list = list;
		notifyDataSetChanged();
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = View.inflate(context, R.layout.layout_discover_item, null);
			holder.content_layout_id = (View) convertView.findViewById(R.id.content_layout_id);
			initHeight(convertView);
			holder.img = (CubeImageView) convertView.findViewById(R.id.discover_img);
			initImgHeight(holder.img);
			holder.dis_img_small = (CubeImageView) convertView.findViewById(R.id.dis_img_small);
			holder.dis_tv_name = (TextView) convertView.findViewById(R.id.dis_tv_name);
			holder.dis_tv_musicname = (TextView) convertView.findViewById(R.id.dis_tv_musicname);
			holder.dis_tv_listsen = (TextView) convertView.findViewById(R.id.dis_tv_listsen);
			holder.dis_tv_bestdesc = (TextView) convertView.findViewById(R.id.dis_tv_bestdesc);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		DiscoverInfo bean = getItem(position);

		if (bean != null && holder.content_layout_id.getTag() != null && bean == holder.content_layout_id.getTag()) {
			return convertView;
		}
		holder.img.loadImage(imageLoader, bean.getMusicPhotoUrl());//普通的
		holder.dis_img_small.loadImage(circleImageLoader,  bean.getAvatarUrl());//圆圈的

		
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
		holder.content_layout_id.setTag(bean);
		return convertView;
	}

	private void initImgHeight(ImageView convertView) {
		try {
			LayoutParams layoutParams = convertView.getLayoutParams();
			layoutParams.height = UICommonUtil.getScreenWidthPixels(context) / 3;
			convertView.setLayoutParams(layoutParams);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void initHeight(View convertView) {
		try {
			LayoutParams layoutParams = convertView.getLayoutParams();
			if (layoutParams != null) {
				layoutParams.height = UICommonUtil.getScreenWidthPixels(context) / 2;
				convertView.setLayoutParams(layoutParams);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	class ViewHolder {
		private View content_layout_id;
		public CubeImageView img;
		public  CubeImageView dis_img_small;
		public TextView dis_tv_name, dis_tv_listsen, dis_tv_bestdesc, dis_tv_musicname;
	}
}