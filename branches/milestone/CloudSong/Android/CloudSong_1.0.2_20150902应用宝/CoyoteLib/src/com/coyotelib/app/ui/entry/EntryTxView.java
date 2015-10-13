package com.coyotelib.app.ui.entry;

import android.content.Context;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.coyotelib.R;

/**
 * Created by lvhonghe on 2014/10/30.
 */
public class EntryTxView extends LinearLayout {

    private TextView mTitle;
    private TextView mSubTitle;

    public EntryTxView(Context context) {
        super(context);
        inflate(context, R.layout.entry_tx_view, this);
        mTitle = (TextView) findViewById(R.id.simple_title);
        mSubTitle = (TextView) findViewById(R.id.simple_sub_title);
    }

    public void setTitle(String title) {
        mTitle.setText(title);
    }

    public void setSubTitle(String title) {
        mSubTitle.setText(title);
    }
}
