package cn.com.ethank.yunge.app.startup;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.searchsong.SearchSongActivity;

import com.coyotelib.app.ui.widget.BasicTitle;

public abstract class BaseTitleActivity extends BaseActivity implements View.OnClickListener {

	protected BasicTitle title;
	protected Activity context;
	private LayoutInflater mInflater;
	private FrameLayout fl_base_content;
	protected RelativeLayout rl_base_layout;
	protected View netlv_networkerror;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		super.setContentView(R.layout.activity_dermand_base);
		BaseApplication.getInstance().cacheActivityList.add(this);
		rl_base_layout = (RelativeLayout) findViewById(R.id.rl_base_layout);
		netlv_networkerror=findViewById(R.id.netlv_networkerror);
		initBitmap();
	}

	private void initBitmap() {
		title = (BasicTitle) findViewById(R.id.title);
		title.showBtnBack();
		title.setBtnBackImage(R.drawable.nav_back);
		title.setBtnBackTextColor("#F844A8");
		title.setBtnFunctionTextColor("#F844A8");
		title.setBtnBackText("返回");
		title.setOnBtnBackClickAction(this);
		title.setBackgroundColor(Color.parseColor("#241938"));
		title.setFunctionDrawable(R.drawable.nav__right_search);
		title.setOnBtnFunctionClickAction(this);
		title.setTitleColor(Color.parseColor("#FFFFFF"));
		fl_base_content = (FrameLayout) findViewById(R.id.fl_base_content);
		context = this;
		mInflater = getLayoutInflater();
	}

	@Override
	public void setContentView(int layoutResID) {
		View view = mInflater.inflate(layoutResID, null);
		fl_base_content.addView(view, 0);
	}

	protected void hasTitle(boolean istitleVisible) {
		if (istitleVisible) {
			title.setVisibility(View.VISIBLE);
		} else {
			title.setVisibility(View.GONE);
		}
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.btn_back:
			finish();
			break;
		case R.id.title_function:
			Intent intent = new Intent(this, SearchSongActivity.class);
			startActivity(intent);
			break;
		}

	}

	// 点歌按钮实现
	public interface DemandClickCallBack {
		public void onClickListener(View view, int position, Object viewHolder);

	}

	@Override
	public abstract void onNetworkConnectChanged(boolean isConnect);

}
