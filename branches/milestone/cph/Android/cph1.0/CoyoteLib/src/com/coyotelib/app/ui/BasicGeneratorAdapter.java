package com.coyotelib.app.ui;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.ArrayList;
import java.util.Collections;

public abstract class BasicGeneratorAdapter<V> extends BaseAdapter {

	protected ArrayList<V> mList = new ArrayList<V>();

	protected LayoutInflater mInflater;

    public BasicGeneratorAdapter(Context mContext) {
        mInflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

	public void setData(ArrayList<V> list) {
		this.mList = list;
	}

	public void setData(V[] array) {
		this.mList.clear();
        Collections.addAll(this.mList, array);
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
	public abstract View getView(int arg0, View arg1, ViewGroup arg2);

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
}
