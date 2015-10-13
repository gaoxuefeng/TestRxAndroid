package cn.com.ethank.yunge.pad.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.pad.BaseApplication;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.bean.MusicStyleBean;


/**
 * Created by dddd on 2015/4/28.
 */
public class MusicStyleAdapter extends BaseAdapter {
    private ArrayList<MusicStyleBean> musicStyleList;
    private Context context;

    public MusicStyleAdapter(Context context, ArrayList<MusicStyleBean> musicStyleList) {

    	
        this.context = context;
        this.musicStyleList = musicStyleList;
    }

    @Override
    public int getCount() {

        return musicStyleList.size();
    }

    @Override
    public Object getItem(int i) {
        return musicStyleList.get(i);
    }

    @Override
    public long getItemId(int i) {

        return i;
    }

    @Override
    public View getView(int position, View view, ViewGroup viewGroup) {
        ViewHolder viewHolder;
        MusicStyleBean musicStyleBean = musicStyleList.get(position);
        if (view == null) {
            viewHolder = new ViewHolder();
            view = LayoutInflater.from(context).inflate(R.layout.item_music_style, null);
            viewHolder.tv_music_style = (TextView) view.findViewById(R.id.tv_music_style);
            viewHolder.iv_music_style = (ImageView) view.findViewById(R.id.iv_music_style);
            view.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) view.getTag();
        }
        viewHolder.tv_music_style.setText(musicStyleBean.getListTypeName());
        BaseApplication.bitmapUtils.display(viewHolder.iv_music_style, musicStyleBean.getImageSrc());

        return view;
    }

    class ViewHolder {

        TextView tv_music_style;
        public ImageView iv_music_style;
    }
    public void setList(ArrayList<MusicStyleBean> musicStyleList) {
		this.musicStyleList = musicStyleList;
		notifyDataSetChanged();
	}

}
