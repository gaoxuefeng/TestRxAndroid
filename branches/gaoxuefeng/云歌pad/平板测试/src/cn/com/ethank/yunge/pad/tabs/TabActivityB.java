package cn.com.ethank.yunge.pad.tabs;

import android.os.Bundle;
import cn.com.ethank.yunge.pad.R;

public class TabActivityB extends MainTabActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_tab_activity_b);
	}

	@Override
	public void initBaseView() {
		super.initBaseView();
		setCenterText(R.string.title_activity_tab_activity_b);
		
	}
}
