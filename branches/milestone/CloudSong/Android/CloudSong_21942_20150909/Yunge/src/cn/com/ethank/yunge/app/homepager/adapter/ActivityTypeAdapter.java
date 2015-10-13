package cn.com.ethank.yunge.app.homepager.adapter;

import java.util.List;

import com.coyotelib.app.ui.util.UICommonUtil;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.sax.StartElementListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.homepager.HomePagerByTypeActivity;
import cn.com.ethank.yunge.app.homepager.bean.ActivityTypeBean;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.MyImageLoader;
import cn.com.ethank.yunge.app.util.ToastUtil;

public class ActivityTypeAdapter extends BaseAdapter {

	private Context context;
	private List<ActivityTypeBean> activityTypeBeanList;

	public ActivityTypeAdapter(Activity activity, List<ActivityTypeBean> activityTypeBeanList) {
		this.context = activity;
		this.activityTypeBeanList = activityTypeBeanList;

	}

	@Override
	public int getCount() {
		if (activityTypeBeanList.size() > 4) {
			return 4;
		}
		return activityTypeBeanList.size();
	}

	@Override
	public ActivityTypeBean getItem(int position) {
		if (position >= 0 && position < activityTypeBeanList.size()) {
			return activityTypeBeanList.get(position);
		}
		return new ActivityTypeBean();
	}

	@Override
	public long getItemId(int position) {
		return position % activityTypeBeanList.size();
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_activity_type, null);
			viewHolder.iv_actiivty_type = (ImageView) convertView.findViewById(R.id.iv_actiivty_type);
			initViewHeight(viewHolder.iv_actiivty_type);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		final ActivityTypeBean activityTypeBean = getItem(position);
		if (position == 0) {
			MyImageLoader.displayImage(viewHolder.iv_actiivty_type, activityTypeBean.getRequestUrl(), R.drawable.home_city_button);
		} else if (position == 1) {
			MyImageLoader.displayImage(viewHolder.iv_actiivty_type, activityTypeBean.getRequestUrl(), R.drawable.home_star_button);
		} else if (position == 2) {
			MyImageLoader.displayImage(viewHolder.iv_actiivty_type, activityTypeBean.getRequestUrl(), R.drawable.home_hot_button);
		} else {
			MyImageLoader.displayImage(viewHolder.iv_actiivty_type, activityTypeBean.getRequestUrl(), R.drawable.home_await_button);
		}
		viewHolder.iv_actiivty_type.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (!Constants.isClickAble()) {
					return;
				} else {
					Constants.setLongUnClickAble();
				}
				if (activityTypeBean.getRequestUrl().isEmpty()) {
					ToastUtil.show("更多精彩，敬请期待...");
					return;
				}
				Intent intent = new Intent(context, HomePagerByTypeActivity.class);
				intent.putExtra("activityTypeBean", activityTypeBean);
				context.startActivity(intent);
			}
		});
		return convertView;
	}

	private void initViewHeight(View view) {
		LayoutParams layoutParams = view.getLayoutParams();
		if (layoutParams == null) {
			return;
		}
		if (layoutParams.width <= 0) {
			layoutParams.height = (int) (UICommonUtil.getScreenWidthPixels(context) * 104f / 720);
		} else {
			layoutParams.height = (int) (layoutParams.width * 104f / 165);
		}
		view.setLayoutParams(layoutParams);
	}

	class ViewHolder {

		public ImageView iv_actiivty_type;

	}

	public void setList(List<ActivityTypeBean> activityTypeBeanList) {
		this.activityTypeBeanList = activityTypeBeanList;
		notifyDataSetChanged();

	}
}
