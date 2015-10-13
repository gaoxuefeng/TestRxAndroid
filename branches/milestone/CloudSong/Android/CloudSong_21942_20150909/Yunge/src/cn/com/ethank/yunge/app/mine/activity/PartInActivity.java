package cn.com.ethank.yunge.app.mine.activity;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.PartPeopleInfo;
import cn.com.ethank.yunge.app.mine.bean.PartPeopleInfo.People;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.lidroid.xutils.BitmapUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
/**
 * 已参与页面 
 */
public class PartInActivity extends BaseActivity implements OnClickListener{
	
	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;
	
	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;
	
	@ViewInject(R.id.part_mrlv)
	private MyRefreshListView part_mrlv;
	
	private ListView part_lv;

	private MyAdapter adapter;

	private List<People> list;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_part_in);
		ViewUtils.inject(this);

		list = new ArrayList<People>();
		
		initData();
		initView();
	}

	private void initData() {
		String reserveBoxId = getIntent().getStringExtra("reserveBoxId");
		final Map<String, String> map = new HashMap<String, String>();
		map.put("reserveBoxId", reserveBoxId);
		map.put("token", Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud+Constants.JOIN_PEOPLE, map).toString();
			}
			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if(result != null){
					PartPeopleInfo partPeopleInfo = JSON.parseObject(result, PartPeopleInfo.class);
					if(partPeopleInfo != null){
						
						if(partPeopleInfo.getCode() == 0){
							list = partPeopleInfo.getData();
						}else{
							ToastUtil.show(partPeopleInfo.getMessage());
						}
					}
				}else{
					ToastUtil.show(R.string.connectfailtoast);
				}
			};
			
		}.run();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void initView() {
		
		head_tv_left.setOnClickListener(this);
		head_tv_title.setText("已参与");
		
		part_lv = part_mrlv.getRefreshableView();
		
		if(adapter == null){
			adapter = new MyAdapter();
		}
		
		part_lv.setAdapter(adapter);
		
		part_mrlv.setOnRefreshListener(new OnRefreshListener2() {
			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				adapter.notifyDataSetChanged();
			}
		});
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		}
	}
	
	
	
	class MyAdapter extends BaseAdapter{
		@Override
		public int getCount() {
			return list.size();
		}

		@Override
		public Object getItem(int arg0) {
			return null;
		}

		@Override
		public long getItemId(int arg0) {
			return 0;
		}

		@Override
		public View getView(int arg0, View convertView, ViewGroup arg2) {
			//return View.inflate(getApplicationContext(), R.layout.item_part_in, null);
			ViewHolder viewHolder = null;
			if(convertView == null){
				viewHolder = new ViewHolder();
				convertView = View.inflate(getApplicationContext(), R.layout.item_part_in, null);
				
				viewHolder.part_iv_img = (ImageView) convertView.findViewById(R.id.part_iv_img);
				viewHolder.part_tv_name = (TextView) convertView.findViewById(R.id.part_iv_name);
				viewHolder.part_tv_phone = (TextView) convertView.findViewById(R.id.part_tv_phone);
				viewHolder.part_tv_time = (TextView) convertView.findViewById(R.id.part_tv_time);
				viewHolder.part_iv_gender = (ImageView) convertView.findViewById(R.id.part_iv_gender);
				convertView.setTag(viewHolder);
			}else{
				viewHolder = (ViewHolder) convertView.getTag();
			}
			BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
			bitmapUtils.display(viewHolder.part_iv_img, list.get(arg0).getUserIcon());
			viewHolder.part_tv_name.setText(list.get(arg0).getUserName());
			viewHolder.part_tv_phone.setText(list.get(arg0).getUserPhoneNum());
			Date date = new Date(list.get(arg0).getServerTimeStamp()*1000L);
			Date date2 = new Date(list.get(arg0).getJoinTimeStamp()*1000L);
			Long miniter = date.getTime()/1000L - date2.getTime()/1000L;
			viewHolder.part_tv_time.setText("已加入"+miniter.toString()+"分钟");
			bitmapUtils.display(viewHolder.part_iv_gender, list.get(arg0).getUserGender());
			return convertView;
		}
		
	} 
	
	class ViewHolder{
		ImageView part_iv_img;
		TextView part_tv_name;
		TextView part_tv_phone;
		TextView part_tv_time;
		ImageView part_iv_gender;
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
