package cn.com.ethank.yunge;

import cn.com.ethank.yunge.app.startup.BaseApplication;
import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

public class InteractActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_interact);
		BaseApplication.getInstance().cacheActivityList.add(this);
	}
}
