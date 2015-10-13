package cn.com.ethank.yunge.app.search.city;

import java.util.Arrays;
import java.util.List;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Pair;
import android.widget.LinearLayout;
import cn.com.ethank.yunge.R;

/**
 * Created by lvhonghe on 15/4/29.
 */
public class HotCityCheatView extends LinearLayout {

	private LinearLayout mBackContainer;

	private HotCityView hotCityView;

	private HotCityView hotOuterView;

	public HotCityCheatView(Context context, AttributeSet attrs) {
		super(context, attrs);
		inflate(context, R.layout.hotcity_cheat_view, this);
		mBackContainer = (LinearLayout) findViewById(R.id.hot_city_cheat_view_container);
		initCity(context);

	}

	private void initCity(Context context) {
		hotCityView = new HotCityView(context);
		Pair<String, List<String>> hotCityPair = new Pair<String, List<String>>("热门国内城市", Arrays.asList(hotCitys));
		// Pair<String, List<String>> hotCityOuterPair = new Pair<String,
		// List<String>>("海外热门目的地", Arrays.asList(hotOutSeaCity));
		hotCityView.initGpsCity();
		hotCityView.initHotCityView(hotCityPair);
		mBackContainer.addView(hotCityView);

		hotOuterView = new HotCityView(context);

		// hotOuterView.initHotCityView(hotCityOuterPair);
		// mBackContainer.addView(hotOuterView);
	}

	private final static String[] hotCitys = { "上海", "北京", "杭州", "广州", "南京", "深圳", "成都", "重庆", "天津", "武汉", "西安" };

}
