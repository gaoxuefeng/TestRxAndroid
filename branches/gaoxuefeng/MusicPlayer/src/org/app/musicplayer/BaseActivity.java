package org.app.musicplayer;

import org.app.music.adapter.MenuAdapter;
import org.app.music.tool.Setting;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
/**
 * ��ʼ��Activity
 * @author ����
 *
 */
public class BaseActivity extends Activity {
	public static final String BROADCASTRECEVIER_ACTON="org.app.music.commonrecevier";
	private CommonRecevier commonRecevier;
	public float brightnesslevel=0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        // ����Ƥ������
		Setting setting = new Setting(this, false);
		String brightness=setting.getValue(Setting.KEY_BRIGHTNESS);
		android.view.WindowManager.LayoutParams attributes = getWindow().getAttributes();
		brightnesslevel=attributes.screenBrightness;
		if(brightness!=null&&brightness.equals("0")){//ҹ��ģʽ
			attributes.screenBrightness=Setting.KEY_DARKNESS;	
			getWindow().setAttributes(attributes);
		}
		this.getWindow().setBackgroundDrawableResource(
				setting.getCurrentSkinResId());
		commonRecevier=new CommonRecevier();
	}
	/**
	 * ��������ģʽ��ҹ��ģʽ
	 * */
	public void setBrightness(View v) {
       Setting setting = new Setting(this, true);
		String brightness=setting.getValue(Setting.KEY_BRIGHTNESS);
		MenuAdapter.ViewHolder viewHolder=(MenuAdapter.ViewHolder)v.getTag();
	   WindowManager.LayoutParams attributes = getWindow().getAttributes();
		if(brightness!=null&&brightness.equals("0")){//ҹ��ģʽ
			viewHolder.tv_title.setText(getResources().getString(R.string.darkness_title));
			viewHolder.btn_menu.setBackgroundResource(R.drawable.btn_menu_darkness);
			attributes.screenBrightness=brightnesslevel;
			setting.setValue(Setting.KEY_BRIGHTNESS, "1");
			getWindow().setAttributes(attributes);
		}else{//����ģʽ
			viewHolder.tv_title.setText(getResources().getString(R.string.brightness_title));
			viewHolder.btn_menu.setBackgroundResource(R.drawable.btn_menu_brightness);
			attributes.screenBrightness=Setting.KEY_DARKNESS;	
			setting.setValue(Setting.KEY_BRIGHTNESS, "0");
			getWindow().setAttributes(attributes);
		}
	
	} 
	


	@Override
	protected void onStart() {
		super.onStart();
		registerReceiver(commonRecevier, new IntentFilter(BROADCASTRECEVIER_ACTON));
	}



	@Override
	protected void onStop() {
		super.onStop();
		unregisterReceiver(commonRecevier);
	}



	public class CommonRecevier extends BroadcastReceiver{
		@Override
		public void onReceive(Context context, Intent intent) {
			finish();
		}
	}
}
