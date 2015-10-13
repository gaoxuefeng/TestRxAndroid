package cn.com.ethank.yunge.app.mine.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.discover.bean.Info;
import cn.com.ethank.yunge.app.mine.bean.RecordInfo;
import cn.com.ethank.yunge.app.mine.bean.RecordInfo.Record;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshGridView;
import com.lidroid.xutils.BitmapUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

/**
 * 我的录音
 */
public class MyRecord extends BaseActivity implements OnClickListener {

	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;

	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;

	@ViewInject(R.id.head_tv_right)
	private TextView head_tv_right;

	private MyAdapter adapter;

	private GridView gv_discover;

	private List<Record> infos = new ArrayList<Record>();

	private PullToRefreshGridView mrfg_discover;

	int i = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_record);

		initData(i);
		initView();

	}

	private void initData(int i) {
		final Map<String, String> map = new HashMap<String, String>();
		map.put("token", Constants.getToken());
		map.put("startIndex", i + "");
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.myRecord, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (result != null) {
					RecordInfo recordInfo = JSON.parseObject(result, RecordInfo.class);
					if (recordInfo.getCode() == 0) {
						if (recordInfo.getData().size() == 0) {
							ToastUtil.show("已经没有更多数据了");
						} else {
							for (int i = 0; i < recordInfo.getData().size(); i++) {
								infos.add(recordInfo.getData().get(i));
								adapter.notifyDataSetChanged();
							}
						}
					}
					mrfg_discover.onRefreshComplete();
					
				} else {
					ToastUtil.show("联网失败");
				}

			};
		}.run();

	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void initView() {
		ViewUtils.inject(this);

		head_tv_left.setText("我的");
		head_tv_title.setText("我的录音");

		mrfg_discover = (PullToRefreshGridView) this.findViewById(R.id.mrfg_discover);
		gv_discover = mrfg_discover.getRefreshableView();

		gv_discover.setNumColumns(2);
		// --列之间的距离
		gv_discover.setHorizontalSpacing(5);
		// --行之间的距离--
		gv_discover.setVerticalSpacing(5);
		// --去除点击是出现的黄色边框--
		gv_discover.setSelector(new ColorDrawable(Color.TRANSPARENT));

		mrfg_discover.setPullToRefreshOverScrollEnabled(false);
		mrfg_discover.setMode(Mode.PULL_FROM_END);

		if (adapter == null) {
			adapter = new MyAdapter();
		}

		gv_discover.setAdapter(adapter);

		mrfg_discover.setMode(Mode.PULL_UP_TO_REFRESH);
		mrfg_discover.setOnRefreshListener(new OnRefreshListener2() {
			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				i += 10;
				initData(i);
			}
		});
		head_tv_left.setOnClickListener(this);

	}

	class MyAdapter extends BaseAdapter {
		@Override
		public int getCount() {
			return infos.size();
		}

		@Override
		public Object getItem(int position) {
			return null;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder holder = null;
			if (convertView == null) {
				holder = new ViewHolder();
				convertView = View.inflate(getApplicationContext(), R.layout.item_record, null);
				holder.img = (ImageView) convertView.findViewById(R.id.record_img);
				holder.record_tv_name = (TextView) convertView.findViewById(R.id.record_tv_name);
				holder.record_tv_praise = (TextView) convertView.findViewById(R.id.record_tv_praise);
				holder.record_tv_song = (TextView) convertView.findViewById(R.id.record_tv_song);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}

			BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
			bitmapUtils.display(holder.img, infos.get(i).getMusicPhotoUrl());
			holder.record_tv_name.setText(infos.get(i).getMusicName());
			holder.record_tv_praise.setText(infos.get(i).getPraiseCount()+"");
			holder.record_tv_song.setText(infos.get(i).getListenCount()+"");

			return convertView;
		}
	}

	class ViewHolder {
		public ImageView img;
		public TextView record_tv_name;
		public TextView record_tv_praise; // --点赞--
		public TextView record_tv_song;
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		}
	}

}
