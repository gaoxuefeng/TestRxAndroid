package cn.com.ethank.yunge.pad;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TabHost.TabSpec;
import android.widget.TextView;
import cn.com.ethank.yunge.pad.tabs.NomalTabActivity;
import cn.com.ethank.yunge.pad.utils.ContentValues;

public class TopActivity extends NomalTabActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_top);
		TextView tv = (TextView) findViewById(R.id.tv);
		tv.setText("tab:" + getIntent().hashCode() + "--" + "count:" + ContentValues.tabhost.getTabContentView().getChildCount());
		tv.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				//
				Intent intent = new Intent(context, TopActivity.class);
				String tabTag = intent.hashCode() + "";

				TabSpec tabTop = ContentValues.tabhost.newTabSpec(tabTag).setIndicator(tabTag).setContent(intent);
				ContentValues.tabhost.addTab(tabTop);
				MainActivity.setCurrentTabByTag(tabTag, true);
			}
		});
	}
}
