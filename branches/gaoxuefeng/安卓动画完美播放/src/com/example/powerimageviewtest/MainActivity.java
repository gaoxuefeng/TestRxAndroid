package com.example.powerimageviewtest;

import android.os.Bundle;
import android.widget.ListView;
import android.app.Activity;

public class MainActivity extends Activity {

	private ListView lv_gif_list;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.layout_gif);
//		lv_gif_list=(ListView)findViewById(R.id.lv_gif_list);
//		Adapter adapter=new Adapter(this);
//		lv_gif_list.setAdapter(adapter);
	}

	
}
