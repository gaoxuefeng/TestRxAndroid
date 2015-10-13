package cn.com.ethank.yunge.pad;

import android.content.Intent;
import android.os.Bundle;

public class LoadingActivity extends BaseActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_loading);
		Intent intent = new Intent(this, MainActivity.class);
		startActivity(intent);
		finish();
	}

	@Override
	public void initBaseView() {

	}

	@Override
	protected void onResume() {
		super.onResume();
	}
}
