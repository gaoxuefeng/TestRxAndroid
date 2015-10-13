package cn.com.ethank.yunge.app.ui.button;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;

public class CenterButton extends FrameLayout {

    private ImageView mTabIcon;
    private TextView mTabName;

    private LinearLayout mBgView;
    private Context mContext;
    public CenterButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(R.layout.centerbtn, this);

        mContext = context;
        mTabIcon = (ImageView) findViewById(R.id.tab_img);
        mTabName = (TextView) findViewById(R.id.tab_name);
        
        mBgView = (LinearLayout) findViewById(R.id.bg_view);
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
    
    public void setBackgroundColor(int resid) {
    	mBgView.setBackgroundResource(resid);
    }
    
}