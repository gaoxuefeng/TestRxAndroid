package cn.com.ethank.yunge.app.mine.activity;

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.SongInfo;
import cn.com.ethank.yunge.app.mine.bean.SongInfo.Song;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.coyotelib.core.threading.BackgroundTask;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class SongHistoryActivity extends BaseActivity implements OnClickListener {

	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left;

	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title;

	private ListView history_lv;

	@ViewInject(R.id.history_mrlv)
	private MyRefreshListView history_mrlv;
	private MyAdapter adapter;

	int i = 0;
	private List<Song> songList = new ArrayList<Song>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_history);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);

		initData(i);
		initView();

	}

	private void initData(int i) {
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return null;
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				SongInfo songInfo = new SongInfo();
				for (int i = 0; i < 5; i++) {
					SongInfo.Song song = songInfo.new Song();
					songList.add(song);
				}

				history_mrlv.onRefreshComplete();
				adapter.notifyDataSetChanged();

			};
		}.run();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void initView() {
		head_tv_left.setText("我的");
		head_tv_title.setText("点唱历史");

		head_tv_left.setOnClickListener(this);

		history_lv = history_mrlv.getRefreshableView();
		history_mrlv.setMode(Mode.BOTH);

		history_mrlv.setOnRefreshListener(new OnRefreshListener2() {
			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				songList.clear();
				initData(0);
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				i+= 10;
				initData(i);
			}
		});

		if (adapter == null) {
			adapter = new MyAdapter();
		}

		history_lv.setAdapter(adapter);

	}

	class MyAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return songList.size();
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

			ViewHolder holder;
			if (convertView == null) {
				holder = new ViewHolder();
				convertView = View.inflate(getApplicationContext(), R.layout.item_song, null);
				holder.iv_single = (ImageView) convertView.findViewById(R.id.iv_single);
				holder.tv_music_name = (TextView) convertView.findViewById(R.id.tv_music_name);
				holder.tv_music_singler = (TextView) convertView.findViewById(R.id.tv_music_singler);
				holder.tv_music_author = (TextView) convertView.findViewById(R.id.tv_music_author);

				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			return convertView;
		}
	}

	class ViewHolder {
		public ImageView iv_single;  //--歌曲图片--
		public TextView tv_music_name;  //-歌曲名称--
		public TextView tv_music_singler;  //--歌曲种类
		public TextView tv_music_author;  //--作者
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		}
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
