package org.app.musicplayer;


import org.app.music.tool.Contsant;
import org.app.music.tool.Setting;
import org.app.netmusic.NetMusicAdapter;
import org.app.netmusic.XmlParse;

import android.os.Bundle;
import android.widget.ListView;
import android.widget.Toast;
/*
 * 在线音乐界面
 * @author 涙星
 */
public class MusicOnlineActivity extends BaseActivity {
	private ListView listview;
    private Toast toast;
    
   
    @Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.net_music);
		listview = (ListView) findViewById(R.id.net_list);
		
		if (!Contsant.getNetIsAvailable(MusicOnlineActivity.this)) {
		 toast=Contsant.showMessage(toast, MusicOnlineActivity.this, "网络连接超时..请检查");
		}
		listview.setAdapter(new NetMusicAdapter(this, XmlParse.parseWebSongList(this)));
		
       
	}
	@Override
 	protected void onResume() {
 		super.onResume();
 		// 设置皮肤背景
 		Setting setting = new Setting(this, false);
 		listview.setBackgroundResource(setting.getCurrentSkinResId());//这里只设置listview的皮肤而已。
 		
 	}  
	
	
}
