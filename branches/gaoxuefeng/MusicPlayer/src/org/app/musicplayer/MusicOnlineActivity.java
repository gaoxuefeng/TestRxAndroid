package org.app.musicplayer;


import org.app.music.tool.Contsant;
import org.app.music.tool.Setting;
import org.app.netmusic.NetMusicAdapter;
import org.app.netmusic.XmlParse;

import android.os.Bundle;
import android.widget.ListView;
import android.widget.Toast;
/*
 * �������ֽ���
 * @author ����
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
		 toast=Contsant.showMessage(toast, MusicOnlineActivity.this, "�������ӳ�ʱ..����");
		}
		listview.setAdapter(new NetMusicAdapter(this, XmlParse.parseWebSongList(this)));
		
       
	}
	@Override
 	protected void onResume() {
 		super.onResume();
 		// ����Ƥ������
 		Setting setting = new Setting(this, false);
 		listview.setBackgroundResource(setting.getCurrentSkinResId());//����ֻ����listview��Ƥ�����ѡ�
 		
 	}  
	
	
}
