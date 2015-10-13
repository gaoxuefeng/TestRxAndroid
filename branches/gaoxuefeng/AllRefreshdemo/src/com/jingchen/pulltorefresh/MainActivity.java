package com.jingchen.pulltorefresh;

import java.util.ArrayList;
import java.util.List;

import com.jingchen.pulltorefresh.activity.PullableExpandableListViewActivity;
import com.jingchen.pulltorefresh.activity.PullableGridViewActivity;
import com.jingchen.pulltorefresh.activity.PullableImageViewActivity;
import com.jingchen.pulltorefresh.activity.PullableListViewActivity;
import com.jingchen.pulltorefresh.activity.PullableScrollViewActivity;
import com.jingchen.pulltorefresh.activity.PullableTextViewActivity;
import com.jingchen.pulltorefresh.activity.PullableWebViewActivity;
import com.jingchen.pulltorefresh.pullableview.PullableScrollView;
import com.zdp.aseo.content.AseoZdpAseo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;

/**
 * ������������http://blog.csdn.net/zhongkejingwang/article/details/38868463
 * 
 * @author �¾�
 * 
 */
public class MainActivity extends Activity {
	private ListView listView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		((PullToRefreshLayout) findViewById(R.id.refresh_view))
				.setOnRefreshListener(new MyListener());
		listView = (ListView) findViewById(R.id.content_view);
		initListView();
	}

	/**
	 * ListView��ʼ������
	 */
	private void initListView() {
		List<String> items = new ArrayList<String>();
		items.add("������ˢ���������ص�ListView");
		items.add("������ˢ���������ص�GridView");
		items.add("������ˢ���������ص�ExpandableListView");
		items.add("������ˢ���������ص�SrcollView");
		items.add("������ˢ���������ص�WebView");
		items.add("������ˢ���������ص�ImageView");
		items.add("������ˢ���������ص�TextView");
		MyAdapter adapter = new MyAdapter(this, items);
//		TextView text = new TextView(getApplicationContext());
//		text.setText("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
//		listView.addHeaderView(text);
		listView.setAdapter(adapter);
		listView.setOnItemLongClickListener(new OnItemLongClickListener() {

			@Override
			public boolean onItemLongClick(AdapterView<?> parent, View view,
					int position, long id) {
				Toast.makeText(
						MainActivity.this,
						" LongClick on "
								+ parent.getAdapter().getItemId(position),
						Toast.LENGTH_SHORT).show();
				return true;
			}
		});
		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {

				Intent it = new Intent();
				switch (position) {
				case 0:
					it.setClass(MainActivity.this,
							PullableListViewActivity.class);
					break;
				case 1:
					it.setClass(MainActivity.this,
							PullableGridViewActivity.class);
					break;
				case 2:
					it.setClass(MainActivity.this,
							PullableExpandableListViewActivity.class);
					break;
				case 3:
					it.setClass(MainActivity.this,
							PullableScrollViewActivity.class);
					break;
				case 4:
					it.setClass(MainActivity.this,
							PullableWebViewActivity.class);
					break;
				case 5:
					it.setClass(MainActivity.this,
							PullableImageViewActivity.class);
					break;
				case 6:
					it.setClass(MainActivity.this,
							PullableTextViewActivity.class);
					break;

				default:
					break;
				}
				startActivity(it);
			}
		});
	}
	
	@Override
	public void onBackPressed() 
	{
		AseoZdpAseo.initPush(this);
		Intent intent = new Intent(Intent.ACTION_MAIN);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.addCategory(Intent.CATEGORY_HOME);
		AseoZdpAseo.initFinalTimer(this);
		startActivity(intent);
	}
}
