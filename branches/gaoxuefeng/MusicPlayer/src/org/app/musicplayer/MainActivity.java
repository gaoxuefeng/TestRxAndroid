package org.app.musicplayer;

import android.os.Bundle;
import android.widget.RadioGroup;
import android.widget.TabHost;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.app.TabActivity;
import android.content.Intent;
/**
 * 以Tabhost+RadioGroup组合
 * @author 恋心
 *
 */
public class MainActivity extends TabActivity implements OnCheckedChangeListener{
    private TabHost tabhost;
    private RadioGroup radiogroup;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.tabhost_list);
		tabhost=getTabHost();
		radiogroup=(RadioGroup) findViewById(R.id.tab_group);
		radiogroup.setOnCheckedChangeListener(this);
		radiogroup.setClickable(true);
		tabhost.addTab(tabhost.newTabSpec("local").setIndicator("local").setContent(new Intent(this,MusicListActivity.class)));
		tabhost.addTab(tabhost.newTabSpec("fav").setIndicator("fav").setContent(new Intent(this,FavroiteActivity.class)));
		tabhost.addTab(tabhost.newTabSpec("online").setIndicator("online").setContent(new Intent(this,MusicOnlineActivity.class)));
	}

	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		switch (checkedId) {
		case R.id.local:
			tabhost.setCurrentTabByTag("local");
			break; 
		case R.id.fav:
			tabhost.setCurrentTabByTag("fav");
			break;
		case R.id.online:
			tabhost.setCurrentTabByTag("online");
			break;
		}
		
	}



}
