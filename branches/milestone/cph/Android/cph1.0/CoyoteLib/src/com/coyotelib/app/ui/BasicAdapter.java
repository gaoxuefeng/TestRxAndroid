package com.coyotelib.app.ui;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.ArrayList;

public abstract class BasicAdapter<V> extends BaseAdapter {



	protected ArrayList<V> mList = new ArrayList<V>();

    protected int layout_res;
    protected LayoutInflater mInflater;


    public BasicAdapter(int layout_res, Context context) {

        this.layout_res = layout_res;
        mInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }


	public void setData(ArrayList<V> list) {
		this.mList = list;
	}

	public void setData(V[] array) {
		this.mList.clear();
		for (V v : array) {
			this.mList.add(v);
		}
	}

	public void appendData(V v) {
		if (v != null) {
			mList.add(v);
		}
	}

	@Override
	public int getCount() {
		return mList.size();
	}

	@Override
	public V getItem(int position) {
		if (position < 0 || position >= mList.size()) {
			return null;
		}
		return mList.get(position);
	}

	@Override
	public long getItemId(int id) {
		return id;
	}

	@Override
	public View getView(int position, View convertView,
			ViewGroup parent) {
        final View view = (convertView == null) ? LayoutInflater.from(
                parent.getContext()).inflate(layout_res,
                parent, false) : convertView;
        V v = getItem(position);
        if(v != null) {
            fullfillView(v, view);
        }
        return view;

    }

    protected abstract void fullfillView(V v, View view);

	public void updateNewData(ArrayList<V> list) {
		setData(list);
		notifyDataSetChanged();
	}

	public void updateNewData(V[] array) {
		setData(array);
		notifyDataSetChanged();
	}

	public void clear() {
		mList.clear();
		notifyDataSetChanged();
	}

    private static class ViewHolder{
        public View view;
    }




}
