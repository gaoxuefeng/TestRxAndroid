package cn.com.ethank.yunge.app.search.city;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

/**
 * Created by lvhonghe on 15/4/27.
 */
public class HotCityRow extends LinearLayout {

	private TextView cityName1;
	private TextView cityName2;
	private TextView cityName3;

	public HotCityRow(Context context) {
		super(context);

		init(context);
	}

	public HotCityRow(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}

	private void init(Context context) {
		inflate(context, R.layout.hotcity_row, this);
		cityName1 = (TextView) findViewById(R.id.name1);
		cityName2 = (TextView) findViewById(R.id.name2);
		cityName3 = (TextView) findViewById(R.id.name3);
		
	}

	private void setCityName(TextView cityTx, String tx) {
		cityTx.setText(tx);
		cityTx.setVisibility(View.VISIBLE);
	}

	public void setCityNameByIndex(int index, String tx) {
		switch (index) {
		case 1:
			setCityName1(tx);
			break;
		case 2:
			setCityName2(tx);
			break;
		case 3:
			setCityName3(tx);
			break;
		default:
			break;
		}
	}

	private void setCityName1(String tx) {
		setCityName(cityName1, tx);
	}

	private void setCityName2(String tx) {
		setCityName(cityName2, tx);
	}

	private void setCityName3(String tx) {
		setCityName(cityName3, tx);
	}

	
}
