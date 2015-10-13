package cn.com.ethank.yunge.app.mine.adapter;

import in.srain.cube.image.CubeImageView;
import in.srain.cube.image.ImageLoader;

import java.io.File;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.imageloader.ImageLoaderUtil;
import cn.com.ethank.yunge.app.imageloader.MyImageLoader;
import cn.com.ethank.yunge.app.mine.activity.MapActivity;
import cn.com.ethank.yunge.app.mine.activity.PartInActivity;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.MainTabActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

public class MyRoomAdapter extends BaseAdapter {
	Context context;
	List<BoxDetail> rooms;
	private ViewHolder holder;
	private BoxDetail myRoomInfoBean;
	private ImageLoader imageLoader;

	public MyRoomAdapter(Context context, List<BoxDetail> rooms) {
		this.context = context;
		this.rooms = rooms;
		imageLoader = ImageLoaderUtil.CreatImageLoader(context, R.drawable.sing_default_head, true);
	}

	@Override
	public int getCount() {
		return rooms.size();
	}

	@Override
	public Object getItem(int position) {
		return rooms.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		myRoomInfoBean = rooms.get(position);
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = View.inflate(context, R.layout.item_myroom, null);
			holder.iv_userhead = (CubeImageView) convertView.findViewById(R.id.iv_userhead);
			holder.tv_username = (TextView) convertView.findViewById(R.id.tv_username);
			holder.tv_shopname = (TextView) convertView.findViewById(R.id.tv_shopname);
			holder.tv_descrip = (TextView) convertView.findViewById(R.id.tv_descrip);
			holder.tv_address = (TextView) convertView.findViewById(R.id.tv_address);
			holder.tv_jioncount = (TextView) convertView.findViewById(R.id.tv_jioncount);
			holder.rl = (RelativeLayout) convertView.findViewById(R.id.rl);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.iv_userhead.loadImage(imageLoader, myRoomInfoBean.getReservationAvatarUrl());
		holder.tv_username.setText(myRoomInfoBean.getReservationName());
		holder.tv_shopname.setText(myRoomInfoBean.getKtvName());
		holder.tv_descrip.setText(myRoomInfoBean.getDiscribe());
		if (myRoomInfoBean.getServiceDate() - myRoomInfoBean.getStartTime() > 0) {
			holder.tv_descrip.setBackgroundResource(R.drawable.mine_list_tag_finish);
		} else {
			holder.tv_descrip.setBackgroundResource(R.drawable.mine_list_tag_begin);
		}
		holder.tv_address.setText(myRoomInfoBean.getAddress());
		holder.tv_jioncount.setText("参与人数: " + myRoomInfoBean.getJoinCount() + "人");
		// final double lat = myRoomInfoBean.getLat();
		// final double lng = myRoomInfoBean.getLng();

		holder.tv_jioncount.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(context, PartInActivity.class);
				intent.putExtra("reserveBoxId", rooms.get(position).getReserveBoxId());
				context.startActivity(intent);
			}
		});
		holder.rl.setTag(position);

		holder.tv_address.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent intent = new Intent(context, MapActivity.class);
				// intent.putExtra("lat", 34.264642646862);
				// intent.putExtra("lng", 108.95108518068);
				Bundle bundle = new Bundle();
				bundle.putSerializable("myRoomInfoBean", rooms.get(position));
				intent.putExtras(bundle);
				context.startActivity(intent);

			}
		});
		holder.rl.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				int a = (Integer) v.getTag();
				SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.reserveBoxId, rooms.get(a).getReserveBoxId());
				JSONObject jsonObject = (JSONObject) JSON.toJSON(rooms.get(a));
				SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.boxInfo, jsonObject.toJSONString());
				// SharePreferencesUtil.deleteData(Constants.getPreBoxId());
				Intent intent = new Intent(context, MainTabActivity.class);
				intent.setType(MainTabActivity.TAB_RESERVE);
				// 临时先这样
				if (!Constants.isBinded()) {
					Constants.setBinded(true);
				}
				context.startActivity(intent);
			}
		});
		return convertView;
	}

	public void setList(List<BoxDetail> rooms2) {
		this.rooms = rooms2;
		notifyDataSetChanged();
	}

	public class ViewHolder {
		RelativeLayout rl;
		CubeImageView iv_userhead;
		TextView tv_username;
		TextView tv_shopname;
		TextView tv_descrip;
		TextView tv_address;
		TextView tv_jioncount;

	}

	/**
	 * 判断是否安装目标应用
	 * 
	 * @param packageName
	 *            目标应用安装后的包名
	 * @return 是否已安装目标应用
	 */
	private boolean isInstallByread(String packageName) {
		return new File("/data/data/" + packageName).exists();
	}

}
