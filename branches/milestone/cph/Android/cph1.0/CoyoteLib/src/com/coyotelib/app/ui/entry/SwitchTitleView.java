package com.coyotelib.app.ui.entry;

import android.content.Context;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.coyotelib.R;

/**
 * Created by lvhonghe on 2014/10/30.
 */
public class SwitchTitleView extends LinearLayout {

    private TextView mTitle;
    private TextView mSubTitle;

    public SwitchTitleView(Context context) {
        super(context);
        inflate(context, R.layout.entry_switch_title, this);

        mTitle = (TextView) findViewById(R.id.switch_title);
        mSubTitle = (TextView) findViewById(R.id.switch_sub_title);

    }

    public void setTitle(CharSequence title) {
        mTitle.setText(title);
    }

    public void setSubTitle(String subTitle) {
        mSubTitle.setText(subTitle);
    }

    public void hidSub() {
        mSubTitle.setVisibility(GONE);
    }

    public void showSub() {
        mSubTitle.setVisibility(VISIBLE);
    }


}
