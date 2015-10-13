package cn.com.ethank.yunge.app.homepager.adapter;

import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.homepager.ActivityWebWithTitleActivity;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.picmanager.PictureManager;
import cn.com.ethank.yunge.app.picmanager.PictureManager.OnPictureDownloadFinished;
import cn.com.ethank.yunge.app.util.Constants;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.umeng.socialize.utils.Log;

public class AcyivityByTypeListAdapter extends BaseAdapter {

	private Context context;
	private List<ActivityBean> activityByTypeList;
	private RefreshUiInterface refreshUiInterface;
	private View view;
	PictureManager pictureManager = new PictureManager();
	OnPictureDownloadFinished downloadFinished = new OnPictureDownloadFinished() {

		@Override
		public void notifyPictureDownloaded() {
			notifyDataSetChanged();
		}
	};

//	public AcyivityByTypeListAdapter(Context context, List<ActivityBean> activityByTypeList) {
//		this.context = context;
//		this.activityByTypeList = activityByTypeList;
//		view = initNullConvertView(context);
//	}

	public AcyivityByTypeListAdapter(Context context, List<ActivityBean> activityByTypeList, RefreshUiInterface refreshUiInterface) {
		this.context = context;
		this.refreshUiInterface = refreshUiInterface;
		this.activityByTypeList = activityByTypeList;
		view = initNullConvertView(context);
	}

	@Override
	public int getCount() {
		return activityByTypeList.size();
	}

	@Override
	public Object getItem(int position) {
		return activityByTypeList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	ViewHolder viewHolder;

	@Override
	public View getView(final int position, View convertView, final ViewGroup parent) {
		long startTime = System.currentTimeMillis();
		Log.i("itemtime" + "开始" + position, "加载开始");
		if (convertView == null) {
			if (position == 3) {
				convertView = view;
				viewHolder = (ViewHolder) view.getTag();
			} else {
				viewHolder = new ViewHolder();
				convertView = LayoutInflater.from(context).inflate(R.layout.item_homepager_activity2, null);
				viewHolder.rl_item_layout = (View) convertView.findViewById(R.id.rl_item_layout);
				initLayoutParam(viewHolder.rl_item_layout);
				viewHolder.tv_activity_theme = (TextView) convertView.findViewById(R.id.tv_activity_theme);
				viewHolder.tv_city_name = (TextView) convertView.findViewById(R.id.tv_city_name);
				viewHolder.tv_activity_time = (TextView) convertView.findViewById(R.id.tv_activity_time);
				viewHolder.tv_activity_address = (TextView) convertView.findViewById(R.id.tv_activity_address);
				viewHolder.tv_instance = (TextView) convertView.findViewById(R.id.tv_instance);
				viewHolder.tv_activity_ktvname = (TextView) convertView.findViewById(R.id.tv_activity_ktvname);
				viewHolder.tv_ispraised = (TextView) convertView.findViewById(R.id.tv_ispraised);
				viewHolder.iv_activiti_image = (ImageView) convertView.findViewById(R.id.iv_activiti_image);
				viewHolder.iv_city_tag_bg = (ImageView) convertView.findViewById(R.id.iv_city_tag_bg);
				viewHolder.iv_activitydengji_id = (ImageView) convertView.findViewById(R.id.iv_activitydengji_id);
				// 热门类型
				viewHolder.iv_hot_type = (ImageView) convertView.findViewById(R.id.iv_hot_type);
				convertView.setTag(viewHolder);
			}
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}

		Log.i("itemtime" + "初始化结束" + position, System.currentTimeMillis() - startTime + "");
		initConvertViewData(position, convertView, viewHolder);
		Log.i("itemtime" + "加载结束" + position, System.currentTimeMillis() - startTime + "");

		return convertView;
	}

	private void initConvertViewData(int position, View convertView, final ViewHolder viewHolder) {

		ActivityBean activityBean = activityByTypeList.get(position);
		Object a = viewHolder.iv_activiti_image.getTag();
		if (a != null && a instanceof ActivityBean) {
			if (a == activityBean || ((ActivityBean) a).getActivityId().equals(activityBean.getActivityId())) {
				return;
			}
		}
		try {
			viewHolder.iv_city_tag_bg.setImageDrawable(new ColorDrawable(Color.parseColor(activityBean.getColorCode())));
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			String ktvname = activityBean.getKTVName();
			viewHolder.tv_activity_ktvname.setText(ktvname);
		} catch (Exception e) {
		}

		viewHolder.tv_activity_theme.setText(activityBean.getActivityTheme());
		viewHolder.tv_activity_time.setText(activityBean.getActivityTime());

		long instance = 0L;
		try {
			instance = activityBean.getDistance() / 1000;
		} catch (Exception e) {
			instance = 0L;
		}
		if (instance > 0L && activityBean.getCityName().equals(Constants.locationCity)) {
			if (viewHolder.tv_instance != null) {
				viewHolder.tv_instance.setVisibility(View.VISIBLE);
				viewHolder.tv_instance.setText(String.valueOf(instance) + "km");
			}
			viewHolder.tv_city_name.setText("附近 · " + activityBean.getActivityTag());
		} else {
			if (viewHolder.tv_instance != null) {
				viewHolder.tv_instance.setVisibility(View.GONE);
			}
			viewHolder.tv_city_name.setText(activityBean.getShowCityName() + " · " + activityBean.getActivityTag());
		}

		viewHolder.tv_activity_address.setText(activityBean.getAddress());
		Bitmap bitmap1 = pictureManager.getmenuLogo(activityBean.getActivityImageUrl(), false, downloadFinished);
		if (bitmap1 != null) {
			viewHolder.iv_activiti_image.setImageBitmap(bitmap1);
		} else {
			viewHolder.iv_activiti_image.setImageDrawable(context.getResources().getDrawable(R.drawable.home_defaultimg_bg));
		}
		Bitmap bitmap2 = pictureManager.getmenuLogo(activityBean.getTypeImageUrl(), false, downloadFinished);
		if (bitmap2 != null) {
			viewHolder.iv_hot_type.setImageBitmap(bitmap2);
		}
		try {
			Bitmap bitmap3 = pictureManager.getmenuLogo(activityBean.getActivityIcon(), false, downloadFinished);
			if (bitmap3 != null) {
				viewHolder.iv_activitydengji_id.setImageBitmap(bitmap3);
			} else {
				viewHolder.iv_activitydengji_id.setBackgroundColor(Color.TRANSPARENT);
			}
		} catch (Exception e) {
		}
		// BaseApplication.bitmapUtils.display(viewHolder.iv_activiti_image,
		// activityBean.getActivityImageUrl(), R.drawable.home_defaultimg_bg);
		// BaseApplication.bitmapUtils.display(viewHolder.iv_hot_type,
		// activityBean.getTypeImageUrl());

		Log.i("图片URL", activityBean.getActivityImageUrl());
		initPraise(viewHolder, activityBean);

		viewHolder.iv_activiti_image.setTag(activityBean);
		viewHolder.iv_activiti_image.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (!Constants.isClickAble()) {
					return;
				} else {
					Constants.setLongUnClickAble();
				}
				Constants.activityBeanitem = (ActivityBean) v.getTag();
				if (Constants.activityBeanitem.getUidpass() == 1 && !Constants.getLoginState()) {
					// 去登陆
					refreshUiInterface.refreshUi(true);
					return;
				}
				// if (activityBean.getHtmlUrl().isEmpty()) {
				// ToastUtil.show("更多精彩，敬请期待...");
				// return;
				// }
				Intent intent = new Intent(context, ActivityWebWithTitleActivity.class);
				intent.putExtra("activityBean", Constants.activityBeanitem);
				context.startActivity(intent);
			}
		});

		viewHolder.iv_activiti_image.setTag(activityBean);

	}

	private void initPraise(final ViewHolder viewHolder, final ActivityBean activityBean) {
		viewHolder.tv_ispraised.setText(activityBean.getActivityPraiseCount());
		if (Constants.actitityPraisedList.contains(activityBean.getActivityId())) {
			// 已经点过赞了
			viewHolder.tv_ispraised.getBackground().setLevel(1);
		} else {
			viewHolder.tv_ispraised.getBackground().setLevel(0);
		}
	}

	private void initLayoutParam(View view) {
		LayoutParams layoutParams = view.getLayoutParams();
		layoutParams.height = (int) (0.5f + UICommonUtil.getScreenWidthPixels(context) * 260f / 640);
		view.setLayoutParams(layoutParams);

	}

	public void setList(List<ActivityBean> activityByTypeList) {
		this.activityByTypeList = activityByTypeList;
		notifyDataSetChanged();

	}

	class ViewHolder {

		public ImageView iv_city_tag_bg, iv_activitydengji_id;
		public ImageView iv_hot_type;
		public TextView tv_activity_address, tv_instance, tv_activity_ktvname;
		public TextView tv_ispraised;
		public ImageView iv_activiti_image;
		public TextView tv_activity_time;
		public TextView tv_city_name;
		public TextView tv_activity_theme;
		// public ImageView iv_conmany_logo;
		public View rl_item_layout;

	}

	View initNullConvertView(Context context) {
		ViewHolder holder = new ViewHolder();
		View view = LayoutInflater.from(context).inflate(R.layout.item_homepager_activity2, null);
		holder.rl_item_layout = (View) view.findViewById(R.id.rl_item_layout);
		initLayoutParam(holder.rl_item_layout);
		holder.tv_activity_theme = (TextView) view.findViewById(R.id.tv_activity_theme);
		holder.tv_city_name = (TextView) view.findViewById(R.id.tv_city_name);
		holder.tv_activity_time = (TextView) view.findViewById(R.id.tv_activity_time);
		holder.tv_activity_address = (TextView) view.findViewById(R.id.tv_activity_address);
		holder.tv_ispraised = (TextView) view.findViewById(R.id.tv_ispraised);
		holder.iv_activiti_image = (ImageView) view.findViewById(R.id.iv_activiti_image);
		holder.iv_city_tag_bg = (ImageView) view.findViewById(R.id.iv_city_tag_bg);
		// 热门类型
		holder.iv_hot_type = (ImageView) view.findViewById(R.id.iv_hot_type);
		view.setTag(holder);
		return view;
	}
}
