package cn.com.ethank.yunge.app.demandsongs.activity;

import android.os.Bundle;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseActivity;

import com.coyotelib.app.ui.util.AnimUtils;
import com.coyotelib.app.ui.util.UICommonUtil;

public class LibTestActivity extends BaseActivity {

    private TextView tv;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lib_test);
        tv = (TextView) findViewById(R.id.tv);
        //屏幕宽高和转换
        UICommonUtil.dip2px(this, 100);
        UICommonUtil.getScreenHeightPixels(this);
        UICommonUtil.getScreenWidthPixels(this);
        //
        AnimUtils.posOnScreen(tv);//获取控件在屏幕上所在的位置
    }

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}


}
