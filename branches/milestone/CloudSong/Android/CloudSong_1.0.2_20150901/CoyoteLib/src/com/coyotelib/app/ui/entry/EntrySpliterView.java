package com.coyotelib.app.ui.entry;

import android.content.Context;
import android.widget.LinearLayout;

import com.coyotelib.R;

/**
 * Created by lvhonghe on 2015/2/11.
 */
public class EntrySpliterView extends LinearLayout {

    public EntrySpliterView(Context context) {
        super(context);
        inflate(context, R.layout.list_spliter, this);
    }
}
