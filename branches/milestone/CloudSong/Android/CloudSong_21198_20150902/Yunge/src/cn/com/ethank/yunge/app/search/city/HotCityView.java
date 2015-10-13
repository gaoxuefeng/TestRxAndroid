package cn.com.ethank.yunge.app.search.city;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Pair;
import android.widget.LinearLayout;
import cn.com.ethank.yunge.R;

/**
 * Created by lvhonghe on 15/4/27.
 */
public class HotCityView extends LinearLayout {

	private LinearLayout container;
	private Context mContext;

	public HotCityView(Context context) {
		super(context);
		mContext = context;
		inflate(context, R.layout.hotcity_view, this);
		container = (LinearLayout) findViewById(R.id.hotcity_container);
	}

	public HotCityView(Context context, AttributeSet attrs) {
		super(context, attrs);
		inflate(context, R.layout.hotcity_view, this);
		container = (LinearLayout) findViewById(R.id.hotcity_container);
	}

	public void setTitle(String tx) {
		// title.setText(tx);
	}

	public void addCityRow(HotCityRow hcr) {
		container.addView(hcr);
	}

	public void initHotCityView(ArrayList<Pair<String, List<String>>> citys) {
		for (Pair<String, List<String>> hotCityPair : citys) {
			initHotCityView(hotCityPair);
		}
	}

	public void initHotCityView(Pair<String, List<String>> citys) {
		// title.setText(citys.first);
		int i = citys.second.size();
		if (i != 0) {
			int rows = i / 3;
			int remainder = i % 3;
			int totalRow = rows + (remainder == 0 ? 0 : 1);
			int currentCity = 0;
			for (int currentRow = 0; currentRow < totalRow; ++currentRow) {
				HotCityRow hcr = new HotCityRow(mContext);
				if (currentRow < rows) {
					hcr.setCityNameByIndex(1, citys.second.get(currentCity++));
					hcr.setCityNameByIndex(2, citys.second.get(currentCity++));
					hcr.setCityNameByIndex(3, citys.second.get(currentCity++));
				} else {
					for (int rindex = remainder; rindex > 0; --rindex) {
						hcr.setCityNameByIndex(rindex, citys.second.get(currentCity++));
					}
				}
				this.addCityRow(hcr);
			}
		}

	}

	public void initGpsCity() {

	}

}
