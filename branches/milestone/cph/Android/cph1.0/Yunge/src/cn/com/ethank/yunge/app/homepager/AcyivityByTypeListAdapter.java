package cn.com.ethank.yunge.app.homepager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.homepager.request.RequestActivityPraise;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.coyotelib.app.ui.util.UICommonUtil;

public class AcyivityByTypeListAdapter extends BaseAdapter {

	private Context context;
	private List<ActivityBean> activityByTypeList;

	public AcyivityByTypeListAdapter(Context context, List<ActivityBean> activityByTypeList) {
		this.context = context;
		this.activityByTypeList = activityByTypeList;
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
		final ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(R.layout.item_homepager_activity, null);
			viewHolder.rl_item_layout = (View) convertView.findViewById(R.id.rl_item_layout);
			viewHolder.iv_conmany_logo = (ImageView) convertView.findViewById(R.id.iv_conmany_logo);
			viewHolder.tv_activity_theme = (TextView) convertView.findViewById(R.id.tv_activity_theme);
			viewHolder.tv_city_name = (TextView) convertView.findViewById(R.id.tv_city_name);
			viewHolder.tv_activity_time = (TextView) convertView.findViewById(R.id.tv_activity_time);
			viewHolder.tv_ispraised = (TextView) convertView.findViewById(R.id.tv_ispraised);
			viewHolder.iv_activiti_image = (ImageView) convertView.findViewById(R.id.iv_activiti_image);
			initLayoutParam(viewHolder);
			convertView.setTag(viewHolder);

		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		viewHolder.tv_ispraised.setClickable(true);
		final View itemView = convertView;
		final ActivityBean activityBean = activityByTypeList.get(position);
		viewHolder.tv_activity_theme.setText(activityBean.getActivityTheme());
		viewHolder.tv_city_name.setText(activityBean.getCityName());
		viewHolder.tv_activity_time.setText(activityBean.getActivityTime());
		BaseApplication.bitmapUtils.display(viewHolder.iv_activiti_image, activityBean.getActivityImageUrl(), R.drawable.home_defaultimg_bg);
		BaseApplication.bitmapUtils.display(viewHolder.iv_conmany_logo, activityBean.getCompanyImageUrl(), R.drawable.activity_default_company);
		initPraise(viewHolder, activityBean);

		convertView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(context, ActivityWebWithTitleActivity.class);
				intent.putExtra("activityBean", activityBean);
				context.startActivity(intent);
			}
		});
		viewHolder.tv_ispraised.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View view) {
				viewHolder.tv_ispraised.setClickable(false);
				int praiseType = 0;
				if (viewHolder.tv_ispraised.getBackground().getLevel() == 0) {
					// 点赞
					praiseType = 0;
					// viewHolder.tv_ispraised.getBackground().setLevel(1);
				} else {
					// 取消赞
					// viewHolder.tv_ispraised.getBackground().setLevel(0);
					praiseType = 1;
				}
				HashMap<String, String> hashMap = new HashMap<String, String>();
				hashMap.put("activityId", activityBean.getActivityId());
				final RequestActivityPraise requestActivityPraise = new RequestActivityPraise(context, hashMap, praiseType);
				requestActivityPraise.start(new RequestCallBack() {

					@Override
					public void onLoaderFinish(Map<String, ?> map) {
						int praiseType = requestActivityPraise.getPraiseType();
						if (praiseType == 0) {
							if (!Constants.actitityPraisedList.contains(activityBean.getActivityId())) {
								Constants.actitityPraisedList.add(activityBean.getActivityId());
							}
							activityBean.setActivityPraiseCount(Integer.parseInt(activityBean.getActivityPraiseCount()) + 1 + "");
							// ToastUtil.show("点赞成功");
							// getView(position, itemView, parent);
							initPraise(viewHolder, activityBean);
						} else {
							if (Constants.actitityPraisedList.contains(activityBean.getActivityId())) {
								Constants.actitityPraisedList.remove(activityBean.getActivityId());
							}
							if (!activityBean.getActivityPraiseCount().equals("0")) {
								activityBean.setActivityPraiseCount(Integer.parseInt(activityBean.getActivityPraiseCount()) - 1 + "");
							}
							// ToastUtil.show("取消点赞成功");
						}
						// getView(position, itemView, parent);
						initPraise(viewHolder, activityBean);
						viewHolder.tv_ispraised.setClickable(true);
					}

					@Override
					public void onLoaderFail() {
						int praiseType = requestActivityPraise.getPraiseType();
						ToastUtil.show("当前没有网络，请联网后再试");
						viewHolder.tv_ispraised.setClickable(true);
					}
				});
			}
		});
		return convertView;

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

	private void initLayoutParam(ViewHolder viewHolder) {
		Typeface typeface = Typeface.createFromAsset(context.getAssets(), "fonts/dongqingiphone-en.ttf");
		viewHolder.tv_activity_theme.setTypeface(typeface);
		LayoutParams layoutParams = viewHolder.rl_item_layout.getLayoutParams();
		layoutParams.height = (int) (0.5f + UICommonUtil.getScreenWidthPixels(context) * 362f / 614);
		viewHolder.rl_item_layout.setLayoutParams(layoutParams);
		LayoutParams image_layoutParams = viewHolder.iv_conmany_logo.getLayoutParams();
		image_layoutParams.height = (int) (0.5f + UICommonUtil.getScreenWidthPixels(context) * 85f / 614);
		image_layoutParams.width = (int) (0.5f + UICommonUtil.getScreenWidthPixels(context) * 85f / 614);
		viewHolder.iv_conmany_logo.setLayoutParams(image_layoutParams);
	}

	public void setList(List<ActivityBean> activityByTypeList) {
		this.activityByTypeList = activityByTypeList;
		notifyDataSetChanged();

	}

	class ViewHolder {

		public TextView tv_ispraised;
		public ImageView iv_activiti_image;
		public TextView tv_activity_time;
		public TextView tv_city_name;
		public TextView tv_activity_theme;
		public ImageView iv_conmany_logo;
		// public ImageView iv_conmany_logo;
		public View rl_item_layout;

	}

}
