package cn.com.ethank.yunge.app.mine.adapter;

import java.util.List;

import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.SongOnlineDemanded;

import cn.com.ethank.yunge.app.mine.activity.OnRecordListner;
import cn.com.ethank.yunge.app.mine.bean.RecordInfoXin;
import cn.com.ethank.yunge.app.mine.bean.RecordXin;
import cn.com.ethank.yunge.app.util.SimpleDateFormatUtil;
import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class MyRecordAdapter extends BaseAdapter {
	Context context;
	List<RecordXin> records;
	private String recordUrl;
	OnRecordListner onRecordListner;

	public MyRecordAdapter(Context context, List<RecordXin> records, OnRecordListner onRecordListner) {
		this.context = context;
		this.records = records;
		this.onRecordListner = onRecordListner;
	}

	@Override
	public int getCount() {
		return records.size();
	}

	@Override
	public Object getItem(int position) {
		return records.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;
		RecordXin record = records.get(position);
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = View.inflate(context, R.layout.item_record_xin, null);
			holder.rl_item = (RelativeLayout) convertView.findViewById(R.id.rl_item);
			holder.tv_musicname = (TextView) convertView
					.findViewById(R.id.tv_musicname);
			holder.tv_recordtime = (TextView) convertView 
					.findViewById(R.id.tv_recordtime);
			holder.tv_duration = (TextView) convertView.findViewById(R.id.tv_duration);
			holder.iv_share = (ImageView) convertView.findViewById(R.id.iv_share);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.tv_musicname.setText(record.getMusicName());
		holder.tv_recordtime.setText(SimpleDateFormatUtil.getDate(record.getRecordTime()).substring(5));
		holder.tv_duration.setText(SimpleDateFormatUtil.getTime(record.getDuration()));
		recordUrl = record.getRecordUrl();//音乐路径
		holder.rl_item .setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if(onRecordListner != null){
					onRecordListner.playRecord(recordUrl);
				}
			}
		});
		holder.iv_share.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				//分享
				onRecordListner.share();
			}
		});
		return convertView;
	}

	public class ViewHolder {
		RelativeLayout rl_item;
		TextView tv_musicname;
		TextView tv_recordtime;
		TextView tv_duration;
		ImageView iv_share;
	}

	public void setList(List<RecordXin> records2) {
		this.records=records2;
		notifyDataSetChanged();
	}
	
}
