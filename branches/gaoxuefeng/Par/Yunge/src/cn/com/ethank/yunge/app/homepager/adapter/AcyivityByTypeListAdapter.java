package cn.com.ethank.yunge.app.homepager.adapter;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;
import in.srain.cube.image.ImageLoaderFactory;
import in.srain.cube.image.impl.DefaultImageLoadHandler;

import java.util.List;

import android.content.Context;
import android.content.Intent;
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
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.DisplayUtil;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.umeng.socialize.utils.Log;

public class AcyivityByTypeListAdapter extends BaseAdapter {

	private Context context;
	private List<ActivityBean> activityByTypeList;
	private RefreshUiInterface refreshUiInterface;
	private View view;
	private ImageLoader mImageRoundLoader;
	private ImageLoader mImageLoader;

	public AcyivityByTypeListAdapter(Context context, List<ActivityBean> activityByTypeList, RefreshUiInterface refreshUiInterface) {
		this.context = context;
		// 圆角
		mImageRoundLoader = ImageLoaderUtil.CreatImageLoader(context, true, R.drawable.home_defaultimg_bg);
		// 正常
		mImageLoader = ImageLoaderUtil.CreatImageLoader(context);
		this.refreshUiInterface = refreshUiInterface;
		this.activityByTypeList = activityByTypeList;
		view = initNullConvertView(context);// 提前创建一个空的view,以备复用
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

	@Override
	public View getView(final int position, View convertView, final ViewGroup parent) {
		long startTime = System.currentTimeMillis();
		Log.i("itemtime" + "开始" + position, "加载开始");
		ViewHolder viewHolder;
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
				viewHolder.iv_activiti_image = (CubeImageView) convertView.findViewById(R.id.iv_activiti_image);
				viewHolder.iv_city_tag_bg = (ImageView) convertView.findViewById(R.id.iv_city_tag_bg);
				viewHolder.iv_activitydengji_id = (CubeImageView) convertView.findViewById(R.id.iv_activitydengji_id);
				// 热门类型
				viewHolder.iv_hot_type = (CubeImageView) convertView.findViewById(R.id.iv_hot_type);
				convertView.setTag(viewHolder);
			}
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		if (activityByTypeList.size() <= position) {
			return convertView;
		}

		ActivityBean activityBean = activityByTypeList.get(position);
		Log.i("itemtime" + "初始化结束" + position, System.currentTimeMillis() - startTime + "");
		initConvertViewData(position, convertView, viewHolder, activityBean);
		Log.i("itemtime" + "加载结束" + position, System.currentTimeMillis() - startTime + "");

		return convertView;
	}

	private void initConvertViewData(int position, View convertView, final ViewHolder viewHolder, ActivityBean activityBean) {
		if (activityBean == null) {
			return;
		}
		Object a = viewHolder.rl_item_layout.getTag();
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
		viewHolder.tv_activity_ktvname.setText(activityBean.getKTVName());
		viewHolder.tv_activity_theme.setText(activityBean.getActivityTheme());
		viewHolder.tv_activity_time.setText(activityBean.getActivityTime());
		viewHolder.tv_city_name.setText(activityBean.getShowCityNameAndTag());
		viewHolder.tv_activity_address.setText(activityBean.getAddress());
		viewHolder.tv_ispraised.setText(activityBean.getActivityPraiseCount());
		long dinstance = activityBean.getDistance() / 1000;
		if (dinstance > 0L && activityBean.isCurrentCity()) {
			viewHolder.tv_instance.setVisibility(View.VISIBLE);
			viewHolder.tv_instance.setText(dinstance + "km");
		} else {
			viewHolder.tv_instance.setVisibility(View.GONE);
		}
		viewHolder.iv_activiti_image.loadImage(mImageRoundLoader, activityBean.getActivityImageUrl());
		viewHolder.iv_hot_type.loadImage(mImageLoader, activityBean.getTypeImageUrl());
		viewHolder.iv_activitydengji_id.loadImage(mImageLoader, activityBean.getActivityIcon());
		// MyImageLoader.displayImage(viewHolder.iv_activiti_image,
		// activityBean.getActivityImageUrl(), R.drawable.home_defaultimg_bg);
		// MyImageLoader.displayImage(viewHolder.iv_hot_type,
		// activityBean.getTypeImageUrl());
		// MyImageLoader.displayImage(viewHolder.iv_activitydengji_id,
		// activityBean.getActivityIcon());
		Log.i("图片URL", activityBean.getActivityImageUrl());
		// initPraise(viewHolder, activityBean);

		viewHolder.iv_activiti_image.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (!Constants.isClickAble()) {
					return;
				} else {
					Constants.setLongUnClickAble();
				}
				Constants.activityBeanitem = (ActivityBean) viewHolder.rl_item_layout.getTag();
				if (Constants.activityBeanitem.getUidpass() == 1 && !Constants.getLoginState()) {
					// 去登陆
					refreshUiInterface.refreshUi(true);
					return;
				}

				Intent intent = new Intent(context, ActivityWebWithTitleActivity.class);
				intent.putExtra("activityBean", Constants.activityBeanitem);
				context.startActivity(intent);
			}
		});

		viewHolder.rl_item_layout.setTag(activityBean);

	}

	// private void initPraise(final ViewHolder viewHolder, final ActivityBean
	// activityBean) {
	// if (Constants.actitityPraisedList.contains(activityBean.getActivityId()))
	// {
	// // 已经点过赞了
	// viewHolder.tv_ispraised.getBackground().setLevel(1);
	// } else {
	// viewHolder.tv_ispraised.getBackground().setLevel(0);
	// }
	// }

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

		public ImageView iv_city_tag_bg;
		public CubeImageView iv_activitydengji_id;
		public CubeImageView iv_hot_type;
		public TextView tv_activity_address, tv_instance, tv_activity_ktvname;
		public TextView tv_ispraised;
		public CubeImageView iv_activiti_image;
		public TextView tv_activity_time;
		public TextView tv_city_name;
		public TextView tv_activity_theme;
		public View rl_item_layout;

	}

	View initNullConvertView(Context context) {
		ViewHolder viewHolder = new ViewHolder();
		View convertView = LayoutInflater.from(context).inflate(R.layout.item_homepager_activity2, null);
		viewHolder.rl_item_layout = (View) convertView.findViewById(R.id.rl_item_layout);
		initLayoutParam(viewHolder.rl_item_layout);
		viewHolder.tv_activity_theme = (TextView) convertView.findViewById(R.id.tv_activity_theme);
		viewHolder.tv_city_name = (TextView) convertView.findViewById(R.id.tv_city_name);
		viewHolder.tv_activity_time = (TextView) convertView.findViewById(R.id.tv_activity_time);
		viewHolder.tv_activity_address = (TextView) convertView.findViewById(R.id.tv_activity_address);
		viewHolder.tv_instance = (TextView) convertView.findViewById(R.id.tv_instance);
		viewHolder.tv_activity_ktvname = (TextView) convertView.findViewById(R.id.tv_activity_ktvname);
		viewHolder.tv_ispraised = (TextView) convertView.findViewById(R.id.tv_ispraised);
		viewHolder.iv_activiti_image = (CubeImageView) convertView.findViewById(R.id.iv_activiti_image);
		viewHolder.iv_city_tag_bg = (ImageView) convertView.findViewById(R.id.iv_city_tag_bg);
		viewHolder.iv_activitydengji_id = (CubeImageView) convertView.findViewById(R.id.iv_activitydengji_id);
		// 热门类型
		viewHolder.iv_hot_type = (CubeImageView) convertView.findViewById(R.id.iv_hot_type);
		convertView.setTag(viewHolder);
		return convertView;
	}
}
