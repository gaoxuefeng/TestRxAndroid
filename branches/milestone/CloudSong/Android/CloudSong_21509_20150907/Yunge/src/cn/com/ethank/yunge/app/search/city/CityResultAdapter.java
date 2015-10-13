package cn.com.ethank.yunge.app.search.city;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.sys.CoyoteSystem;

public class CityResultAdapter extends BaseAdapter {

	private ArrayList<String> mList = new ArrayList<String>();

	public void setContent(ArrayList<String> list) {
		mList = list;
	}

	@Override
	public int getCount() {
		if (mList == null)
			return 0;
		return mList.size();
	}

	@Override
	public String getItem(int position) {

		if (position < 0 || position >= mList.size()) {
			return null;
		}
		return mList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final View view = (convertView != null) ? convertView : LayoutInflater.from(parent.getContext()).inflate(R.layout.city_result_item, parent, false);

		String city = getItem(position);

		if (city != null) {
			final TextView name = (TextView) view.findViewById(R.id.city_name);
			final Context context = CoyoteSystem.getCurrent().getAppContext();
			name.setText(city);
			name.setPadding(UICommonUtil.dip2px(context, 12), UICommonUtil.dip2px(context, 16), UICommonUtil.dip2px(context, 12), UICommonUtil.dip2px(context, 16));
		}
		return view;
	}

}
