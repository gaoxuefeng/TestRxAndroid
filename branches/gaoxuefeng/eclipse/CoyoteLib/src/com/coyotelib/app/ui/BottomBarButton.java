package com.coyotelib.app.ui;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.sledogbaselib.R;

public class BottomBarButton extends FrameLayout {

    private ImageView mTabIcon;
    private TextView mTabName;

    private Context mContext;
    public BottomBarButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(R.layout.bottom_bar_btn, this);

        mContext = context;
        mTabIcon = (ImageView) findViewById(R.id.tab_img);
        mTabName = (TextView) findViewById(R.id.tab_name);
    }

    private int mNormalIcon, mSelectIcon;

    public void initState(int normal, int select) {

        mNormalIcon = normal;
        mSelectIcon = select;

        setNormalState();
    }

    public void setTabName(String name) {
        mTabName.setText(name);
    }

    public void setNormalState() {
        mTabIcon.setBackgroundResource(mNormalIcon);
        mTabName.setTextColor(mContext.getResources().getColor(R.color.tab_name_unselected));
    }

    public void setSelectState() {
        mTabIcon.setBackgroundResource(mSelectIcon);
        mTabName.setTextColor(mContext.getResources().getColor(R.color.tab_name_selected));
    }
}
