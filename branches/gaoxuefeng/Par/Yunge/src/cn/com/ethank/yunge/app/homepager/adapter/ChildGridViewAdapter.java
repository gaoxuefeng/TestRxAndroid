package cn.com.ethank.yunge.app.homepager.adapter;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.homepager.ActivityWebWithTitleActivity;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.util.DisplayUtil;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.umeng.socialize.utils.Log;

public class ChildGridViewAdapter extends BaseAdapter {

	private Context context;
	private ArrayList<ActivityBean> homePagerInfoBeans;
	private int listPosition;
	private ImageLoader imageLoader;

	public ChildGridViewAdapter(Context context, ArrayList<ActivityBean> homePagerInfoBeans, int listPosition) {
		this.context = context;
		this.homePagerInfoBeans = homePagerInfoBeans;
		this.listPosition = listPosition;
		imageLoader = ImageLoaderUtil.CreatImageLoader(context, true, R.drawable.home_defaultimg_bg);
	}

	@Override
	public int getCount() {
		return homePagerInfoBeans.size();
	}

	@Override
	public Object getItem(int position) {
		return homePagerInfoBeans.size();
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@SuppressLint("ViewHolder")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		GridViewItemHolder gridViewItemHolder;
		final ActivityBean activityBean = homePagerInfoBeans.get(position);
		if (convertView == null) {
			gridViewItemHolder = new GridViewItemHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_home_page_small, null);
			initItemHeight(convertView, gridViewItemHolder);
			gridViewItemHolder.iv_item_bg = (CubeImageView) convertView.findViewById(R.id.iv_item_bg);
			gridViewItemHolder.tv_home_type = (TextView) convertView.findViewById(R.id.tv_home_type);
			gridViewItemHolder.tv_home_theme = (TextView) convertView.findViewById(R.id.tv_home_theme);
			convertView.setTag(gridViewItemHolder);
		} else {
			gridViewItemHolder = (GridViewItemHolder) convertView.getTag();
		}
		if (gridViewItemHolder.tv_home_type.getBackground() != null) {
			gridViewItemHolder.tv_home_type.getBackground().setLevel(activityBean.getBgTag());
		}

		gridViewItemHolder.tv_home_theme.setText(activityBean.getActivityTheme());
		gridViewItemHolder.tv_home_type.setText(activityBean.getActivityTag());
		gridViewItemHolder.iv_item_bg.loadImage(imageLoader, activityBean.getActivityImageUrl());
		Log.i("图片URL", activityBean.getActivityImageUrl());
		convertView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View view) {
				Intent intent = new Intent(context, ActivityWebWithTitleActivity.class);
				intent.putExtra("activityBean", activityBean);
				context.startActivity(intent);

			}
		});
		return convertView;
	}

	private void initItemHeight(View convertView, GridViewItemHolder gridViewItemHolder) {
		gridViewItemHolder.rl_item = (RelativeLayout) convertView.findViewById(R.id.rl_item);
		LayoutParams layoutParams = gridViewItemHolder.rl_item.getLayoutParams();
		layoutParams.height = (int) (0.5 + (UICommonUtil.getScreenWidthPixels(context) - DisplayUtil.dip2px(32)) * 1f / 3);
		gridViewItemHolder.rl_item.setLayoutParams(layoutParams);
	}

	public void setList(ArrayList<ActivityBean> homePagerInfoBeans, int listPosition) {
		this.homePagerInfoBeans = homePagerInfoBeans;
		this.listPosition = listPosition;
		notifyDataSetChanged();
	}

	class GridViewItemHolder {

		public TextView tv_home_theme;
		public TextView tv_home_type;
		public RelativeLayout rl_item;
		public CubeImageView iv_item_bg;

	}
}
