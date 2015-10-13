package cn.com.ethank.yunge.app.demandsongs.activity.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.beans.LanguageBean;

/**
 * Created by dddd on 2015/4/28.
 */
public class LanguageAdapter extends BaseAdapter {
	private Context context;
	private ArrayList<LanguageBean> languagelist;

	public LanguageAdapter(Context context, ArrayList<LanguageBean> languagelist) {

		this.context = context;
		this.languagelist = languagelist;
	}

	@Override
	public int getCount() {
		return languagelist.size();
	}

	@Override
	public Object getItem(int i) {
		return languagelist.get(i);
	}

	@Override
	public long getItemId(int i) {
		return i;
	}

	@Override
	public View getView(int position, View view, ViewGroup viewGroup) {
		ViewHolder viewHolder;
		if (view == null) {
			viewHolder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(R.layout.item_language, null);
			viewHolder.tv_language = (TextView) view.findViewById(R.id.tv_language);
			view.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) view.getTag();
		}
		viewHolder.tv_language.setText(languagelist.get(position).getLanguageName());

		return view;
	}

	class ViewHolder {

		TextView tv_language;
	}

}
