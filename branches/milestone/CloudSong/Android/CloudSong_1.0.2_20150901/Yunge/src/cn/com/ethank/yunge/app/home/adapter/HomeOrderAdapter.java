package cn.com.ethank.yunge.app.home.adapter;

import java.math.BigDecimal;
import java.util.List;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.bean.HomeInfo;
import cn.com.ethank.yunge.app.picmanager.PictureManager;
import cn.com.ethank.yunge.app.picmanager.PictureManager.OnPictureDownloadFinished;
import cn.com.ethank.yunge.app.startup.BaseApplication;

public class HomeOrderAdapter extends BaseAdapter {
	PictureManager pictureManager = new PictureManager();
	OnPictureDownloadFinished downloadFinished = new OnPictureDownloadFinished() {

		@Override
		public void notifyPictureDownloaded() {
			notifyDataSetChanged();

		}
	};
	Context context;
	List<HomeInfo> homeInfos;
	// 宝乐迪一般条目
	private int LOAD_VIEW_ITEM = 0;
	// 大众点评的条目
	private int LOAD_TEXT_ITEM = 1;
	private double distance;

	public HomeOrderAdapter(Context context, List<HomeInfo> homeInfos) {
		this.context = context;
		this.homeInfos = homeInfos;
	}

	// 多一个条目
	@Override
	public int getCount() {
		return homeInfos.size();
	}

	@Override
	public Object getItem(int position) {
		return homeInfos.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	// 增加一种类型
	@Override
	public int getViewTypeCount() {
		return super.getViewTypeCount() + 1;
	}

	@Override
	public int getItemViewType(int position) {
		if (position == 0 && !homeInfos.get(0).isLocalData()) {
			return LOAD_TEXT_ITEM;// 加titleS数据
		} else if (position != 0) {
			if (homeInfos.get(position - 1).isLocalData() && !homeInfos.get(position).isLocalData()) {
				return LOAD_TEXT_ITEM;
			}
		}
		return LOAD_VIEW_ITEM;// 默认普通数据

	}

	@Override
	public View getView(int position, View view, ViewGroup parent) {
		ViewHolder viewHolder;
		if (view == null) {
			viewHolder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.layout_reserve_item, null);
			// ktv类型
			viewHolder.tv_type_title = (TextView) view.findViewById(R.id.tv_type_title);
			// ktv图片
			viewHolder.iv_reserve_image = (ImageView) view.findViewById(R.id.iv_reserve_image);
			viewHolder.iv_reserve_top_tag = (ImageView) view.findViewById(R.id.iv_reserve_top_tag);
			// ktve名称
			viewHolder.tv_KTV_name = (TextView) view.findViewById(R.id.tv_KTV_name);
			// 是否团购
			viewHolder.iv_tuan = (ImageView) view.findViewById(R.id.iv_tuan);
			// 是否促销
			viewHolder.iv_cu = (ImageView) view.findViewById(R.id.iv_cu);
			// ka
			viewHolder.iv_ka = (ImageView) view.findViewById(R.id.iv_ka);
			// 惠
			viewHolder.iv_hui = (ImageView) view.findViewById(R.id.iv_hui);
			// 星级评价
			viewHolder.app_star = (RatingBar) view.findViewById(R.id.app_star);
			// 单价
			viewHolder.tv_price = (TextView) view.findViewById(R.id.tv_price);
			// 折扣
			viewHolder.tv_discount = (TextView) view.findViewById(R.id.tv_discount);
			// 位置
			viewHolder.tv_ktv_location = (TextView) view.findViewById(R.id.tv_ktv_location);
			// 距离
			viewHolder.tv_distance = (TextView) view.findViewById(R.id.tv_distance);
			view.setTag(viewHolder);

		} else {
			viewHolder = (ViewHolder) view.getTag();
		}
		viewHolder.tv_distance.setVisibility(View.VISIBLE);
		viewHolder.tv_type_title.setVisibility(View.GONE);
		// 获取数据
		HomeInfo homeInfo = homeInfos.get(position);

		String ktvName = homeInfo.getKTVName();
		// 暂时未返回
		// String address = homeInfo.getAddress();
		// 团促卡惠
		int[] iconMegArray = homeInfo.getDiscountIconArray();
		// 团
		if (iconMegArray[0] == 1) {
			viewHolder.iv_tuan.setVisibility(View.VISIBLE);
		} else {
			viewHolder.iv_tuan.setVisibility(View.GONE);
		}
		// 促
		if (iconMegArray[1] == 1) {
			viewHolder.iv_cu.setVisibility(View.VISIBLE);
		} else {
			viewHolder.iv_cu.setVisibility(View.GONE);
		}
		// 卡
		if (iconMegArray[2] == 1) {
			viewHolder.iv_ka.setVisibility(View.VISIBLE);
		} else {
			viewHolder.iv_ka.setVisibility(View.GONE);
		}
		// 惠
		if (iconMegArray[3] == 1) {
			viewHolder.iv_hui.setVisibility(View.VISIBLE);
		} else {
			viewHolder.iv_hui.setVisibility(View.GONE);
		}
		if (homeInfo.isLocalData()) {
			viewHolder.iv_reserve_top_tag.setVisibility(View.VISIBLE);
		} else {
			viewHolder.iv_reserve_top_tag.setVisibility(View.GONE);
		}

		// 折扣
		String discountMeg = homeInfo.getDiscountMeg();

		// 距离
		if (homeInfo.getDistance() / 1000 >= 0) {

			distance = homeInfo.getDistance() / 1000;
			if (distance < 20) {
				viewHolder.tv_distance.setText("  " + getNumber(distance) + "km");
			} else {
				viewHolder.tv_distance.setVisibility(View.INVISIBLE);
			}

		} else {
			distance = homeInfo.getDistance();
			viewHolder.tv_distance.setText(getNumber(distance) + "m");
		}
		String imageUrl = homeInfo.getImageUrl();
		int price = homeInfo.getPrice();
		// 星级评价
		double rating = homeInfo.getRating();
		// 大众点评网的url
		// String shopUrl = homeInfo.getShopUrl();
		//
		String circleName = homeInfo.getCircleName();
		Bitmap bitmap = pictureManager.getmenuLogo(imageUrl, false, downloadFinished);
		if (bitmap != null) {
			viewHolder.iv_reserve_image.setImageBitmap(bitmap);
		}
		// BaseApplication.bitmapUtils.display(viewHolder.iv_reserve_image,
		// imageUrl, R.drawable.ktvbgj);
		viewHolder.tv_KTV_name.setText(ktvName);
		viewHolder.app_star.setRating((float) rating / 10);
		if (price <= 0) {
			viewHolder.tv_price.setVisibility(View.INVISIBLE);
		} else {
			viewHolder.tv_price.setVisibility(View.VISIBLE);
			viewHolder.tv_price.setText("￥" + price + "/人");
		}

		viewHolder.tv_ktv_location.setText(circleName);

		if (homeInfo.hasDiscountMeg()) {
			viewHolder.tv_discount.setVisibility(View.VISIBLE);
			viewHolder.tv_discount.setText(discountMeg + "折");
		} else {
			viewHolder.tv_discount.setVisibility(View.INVISIBLE);
		}

		if (getItemViewType(position) == LOAD_TEXT_ITEM) {
			// 增加大众点评一行字
			viewHolder.tv_type_title.setVisibility(View.VISIBLE);
			viewHolder.tv_type_title.setText(" 以下来自大众点评网");
		}
		return view;
	}

	public class ViewHolder {
		public ImageView iv_reserve_top_tag;
		public ImageView iv_hui;
		public ImageView iv_ka;
		public TextView tv_type_title;
		ImageView iv_reserve_image;
		TextView tv_KTV_name;
		ImageView iv_tuan;
		ImageView iv_cu;
		RatingBar app_star;
		TextView tv_price;
		TextView tv_discount;
		TextView tv_ktv_location;
		TextView tv_distance;

	}

	public void setList(List<HomeInfo> homeInfos) {
		this.homeInfos = homeInfos;
		notifyDataSetChanged();

	}

	BigDecimal getNumber(double d) {
		BigDecimal bd = new BigDecimal(d);
		return bd.setScale(1, BigDecimal.ROUND_HALF_UP);
	}
}
