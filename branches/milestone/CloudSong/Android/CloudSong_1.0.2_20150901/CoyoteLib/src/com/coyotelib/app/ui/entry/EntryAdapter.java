package com.coyotelib.app.ui.entry;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import com.coyotelib.app.ui.BasicGeneratorAdapter;

public class EntryAdapter extends BasicGeneratorAdapter<EntryUIItem> {

    public EntryAdapter(Context context) {
        super(context);
        entryViewGenerator = new EntryViewGenerator(context);
    }
	private EntryViewGenerator entryViewGenerator;


    @Override
	public View getView(int position, View contractView, ViewGroup parent) {
		EntryUIItem item = getItem(position);
		if(item != null) {
			return entryViewGenerator.generatorView(item, contractView);
		} else {
			return contractView;
		}
	}

}
