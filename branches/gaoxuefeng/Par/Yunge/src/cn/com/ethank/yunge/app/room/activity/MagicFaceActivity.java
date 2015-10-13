package cn.com.ethank.yunge.app.room.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.RoomBaseActivity;
import cn.com.ethank.yunge.app.room.adapter.MagicFaceAdapter;

import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class MagicFaceActivity extends RoomBaseActivity implements OnClickListener{
	
	
	@ViewInject(R.id.magic_gv)
	private GridView magci_gv;
	
	@ViewInject(R.id.room_tv_left)
	private TextView room_tv_left;
	
	@ViewInject(R.id.room_tv_title)
	private TextView room_tv_title;
	private MagicFaceAdapter magicFaceAdapter;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_magic_face);
		initView();
		title.setVisibility(View.GONE);
	}
	
	private void initView() {
		ViewUtils.inject(this);
		
		room_tv_left.setText("房间");
		room_tv_left.setOnClickListener(this);
		
		room_tv_title.setText("魔法表情");
		
		if(magicFaceAdapter == null){
			magicFaceAdapter = new MagicFaceAdapter(this);
		}
		magci_gv.setAdapter(magicFaceAdapter);
		
		magci_gv.setOnItemClickListener(new OnItemClickListener() {
			String[] strings = getResources().getStringArray(R.array.magic_name);
			
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				Intent data = new Intent();
				data.putExtra("name", strings[arg2]);
				setResult(-1, data);
				finish();
			}
		});
	}


	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.room_tv_left:
			finish();
			break;
		}
		
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
