package cn.com.ethank.yunge.app.search;

import android.content.Context;
import android.graphics.Color;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

public class SearchTabView extends RelativeLayout {

	public TextView mTabName;
	private TabTextChangeListener tabTextChangeListener;

	public SearchTabView(Context context, AttributeSet attrs) {
		super(context, attrs);
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		View view = inflater.inflate(R.layout.search_tab_item, this);
		mTabName = (TextView) findViewById(R.id.tab_name);
		mTabName.setTextColor(Color.parseColor("#9799A2"));
	}

	public void setTabName(int strRes) {
		String beforeTabName = mTabName.getText().toString();
		mTabName.setText(strRes);
		if (tabTextChangeListener != null && !beforeTabName.equals(getContext().getResources().getText(strRes))) {
			tabTextChangeListener.changeBottomTab(getContext().getResources().getText(strRes).toString());
			tabTextChangeListener.requestNetWork(getContext().getResources().getText(strRes).toString());
		}
	}

	public String getTabName() {
		return mTabName.getText().toString();

	}

	public void setTabName(String text) {
		String beforeTabName = mTabName.getText().toString();
		mTabName.setText(text);
		if (tabTextChangeListener != null && !beforeTabName.equals(text)) {
			tabTextChangeListener.changeBottomTab(text);
			tabTextChangeListener.requestNetWork(text);
		}

	}

	public void changeTvDrawableUp() {
		mTabName.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.schedule_up, 0);
	}

	public void changeTvDrawableDown() {
		mTabName.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.schedule_down, 0);
	}

	

	public interface TabTextChangeListener {

		void changeBottomTab(String tanName);

		void requestNetWork(String tanName);

	};

	public void SetOnTabTextChangeListener(TabTextChangeListener tabTextChangeListener) {
		this.tabTextChangeListener = tabTextChangeListener;
	}
}
