package com.coyotelib.app.ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;

import com.coyotelib.R;

/**
 * Created by lvhonghe on 2015/1/9.
 */
public class FloatBtn extends RelativeLayout {

    private View icon;

    public FloatBtn(Context context, AttributeSet attrs) {
        super(context, attrs);
        inflate(context, R.layout.float_button, this);
        icon = findViewById(R.id.function_icon);
    }

    public void setIcon(int iconResource) {
        icon.setBackgroundResource(iconResource);
    }

    public void setOnclickListener(OnClickListener listener) {
        this.setOnClickListener(listener);
    }

}
