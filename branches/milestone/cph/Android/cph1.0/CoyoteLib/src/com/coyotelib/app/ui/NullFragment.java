package com.coyotelib.app.ui;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.coyotelib.R;


/**
 * Created by lvhonghe on 14/12/14.
 */
public class NullFragment extends Fragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View convertView = inflater.inflate(R.layout.null_fragment, container, false);
        return convertView;
    }
}
