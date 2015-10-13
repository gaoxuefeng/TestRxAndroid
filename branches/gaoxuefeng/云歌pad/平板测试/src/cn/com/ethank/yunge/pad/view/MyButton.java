package cn.com.ethank.yunge.pad.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.Button;

/**
 * Created by dddd on 2015/5/8.
 */
public class MyButton extends Button {
    public MyButton(Context context) {
        super(context);
    }

    public MyButton(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public MyButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public boolean onFilterTouchEventForSecurity(MotionEvent event) {
        return super.onFilterTouchEventForSecurity(event);
    }

    @Override
    public boolean isSelected() {
        return super.isSelected();
    }
}
