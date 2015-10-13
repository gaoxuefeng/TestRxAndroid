package cn.com.ethank.yunge.pad;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.TabHost.TabSpec;
import cn.com.ethank.yunge.pad.tabs.TabMainActivity;
import cn.com.ethank.yunge.pad.utils.ContentValues;

import com.coyotelib.app.ui.util.UICommonUtil;

@SuppressWarnings("deprecation")
public class MainActivity extends TabActivity {

	private TabSpec tabSpecA;
	public static boolean isexit = false;
	public static ArrayList<String> tabSpecsList = new ArrayList<String>();

	private RelativeLayout rl_bottom;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		setView();
	}

	private void setView() {
		ContentValues.tabhost = getTabHost();
		rl_bottom = (RelativeLayout) findViewById(R.id.rl_bottom);
		LayoutParams layoutParams = rl_bottom.getLayoutParams();
		layoutParams.height = (int) (UICommonUtil.getScreenWidthPixels(this) * 8f / 27);
		Intent tabActivityA = new Intent(this, TabMainActivity.class);
		tabSpecA = ContentValues.tabhost.newTabSpec(ContentValues.tabA).setIndicator(ContentValues.tabA).setContent(tabActivityA);
		ContentValues.tabhost.addTab(tabSpecA);

		setCurrentTabByTag(ContentValues.tabA, true);

	}

	public static String getLastTabTag() {
		if (tabSpecsList.size() != 0) {
			return tabSpecsList.get(tabSpecsList.size() - 1);
		} else {
			return ContentValues.tabA;
		}

	}

	/**
	 * 
	 * @param tag需要跳转的tag
	 * @param isNewTag
	 *            是否是新的tag,新的是要跳转到的true,旧的是点击返回的false
	 */
	public static void setCurrentTabByTag(String tag, boolean isNewTag) {
		if (tag.equals(ContentValues.tabhost.getCurrentTabTag())) {
			return;
		}
		if (tag.equals(ContentValues.tabA)) {
			clearViews();
			tabSpecsList.clear();
			tabSpecsList.add(tag);
			ContentValues.tabhost.setCurrentTabByTag(tag);
		} else if (isNewTag) {
			tabSpecsList.add(tag);
			ContentValues.tabhost.setCurrentTabByTag(tag);
		} else if (!isNewTag) {
			ContentValues.tabhost.setCurrentTabByTag(tag);
		}
	}

	// 点击返回到首页
	private static void clearViews() {
		ViewGroup view = ContentValues.tabhost.getTabContentView();
		int count = view.getChildCount();
		for (int i = 0; i < view.getChildCount(); i++) {
			// 这儿要移除除了首页以外的页面
		}
		view.removeViewAt(count - 1);

	}

	@SuppressLint("HandlerLeak")
	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 0:
				isexit = false;
				break;
			case 1:

				break;
			default:
				break;
			}

		};
	};
}
