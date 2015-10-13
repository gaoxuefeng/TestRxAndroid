package cn.com.ethank.yunge.app.mine.activity;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;

import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.ViewUtils;
public class SongSingHisttory extends BaseActivity{
	
	private MyAdapter myAdapter;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.activity_sing_song_history);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);
		initData();
		initView();
	}
	
	private void initData() {
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return "";
			}
		};
		
	}
	private void initView() {
		if(myAdapter == null){
			myAdapter = new MyAdapter();
		}
		
	}
	
	class MyAdapter extends BaseAdapter{
		@Override
		public int getCount() {
			return 0;
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
			return null;
		}
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
