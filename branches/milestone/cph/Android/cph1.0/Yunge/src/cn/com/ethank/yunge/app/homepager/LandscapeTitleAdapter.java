package cn.com.ethank.yunge.app.homepager;

import java.util.List;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.manoeuvre.bean.TagsBean;

import com.coyotelib.app.ui.util.UICommonUtil;

@SuppressLint("ViewHolder")
public class LandscapeTitleAdapter extends BaseAdapter {

	private Context context;
	private List<TagsBean> typeList;
	private int selectPosition;

	public LandscapeTitleAdapter(Context context, List<TagsBean> typyList) {
		this.context = context;
		this.typeList = typyList;
		this.selectPosition = 0;
	}

	@Override
	public int getCount() {
		return typeList.size();
	}

	@Override
	public Object getItem(int position) {
		return typeList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public int getSelectedPosition() {
		return selectPosition;
	}

	public String getSelectedType(int position) {
		if (typeList.size() > position) {
			return typeList.get(position).getTagName();
		}
		return "";
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder = null;
		// if (convertView == null) {
		viewHolder = new ViewHolder();
		convertView = LayoutInflater.from(context).inflate(R.layout.item_homepager_type, null);
		viewHolder.rl_type_layout = convertView.findViewById(R.id.rl_type_layout);
		LayoutParams layoutParams = viewHolder.rl_type_layout.getLayoutParams();
		layoutParams.width = (int) (UICommonUtil.getScreenWidthPixels(context) * 1f / 6);
		viewHolder.rl_type_layout.setLayoutParams(layoutParams);
		viewHolder.tv_type = (TextView) convertView.findViewById(R.id.tv_type);
		viewHolder.iv_bottom_line = (ImageView) convertView.findViewById(R.id.iv_bottom_line);
		convertView.setTag(viewHolder);
		// } else {
		// viewHolder = (ViewHolder) convertView.getTag();
		// }
		if (position == selectPosition) {
			viewHolder.tv_type.setTextColor(Color.parseColor("#c20399"));
			viewHolder.iv_bottom_line.setVisibility(View.VISIBLE);
		} else {
			viewHolder.tv_type.setTextColor(Color.parseColor("#FFFFFF"));
			viewHolder.iv_bottom_line.setVisibility(View.INVISIBLE);
		}
		viewHolder.tv_type.setText(typeList.get(position).getTagName());
		return convertView;
	}

	public void setList(List<TagsBean> typeList) {
		this.typeList = typeList;
		selectPosition = 0;
		notifyDataSetChanged();

	}

	class ViewHolder {

		public ImageView iv_bottom_line;
		private TextView tv_type;
		private View rl_type_layout;

	}

	public void setSelectPosition(int position) {
		if (selectPosition == position) {
			return;
		} else {
			selectPosition = position;
			notifyDataSetChanged();
		}

	}

}
