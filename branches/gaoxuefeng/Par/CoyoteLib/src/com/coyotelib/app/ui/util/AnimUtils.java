package com.coyotelib.app.ui.util;

import android.util.Pair;
import android.view.View;

public class AnimUtils {
    public static long frame2during(int frameCount) {
        return frameCount * 1000 / 24;
    }

    //返回控件所在屏幕的位置
    public static Pair<Integer, Integer> posOnScreen(View v) {
        int location[] = {0, 0};
        v.getLocationOnScreen(location);
        return new Pair<Integer, Integer>(location[0], location[1]);
    }

    //两个控件之间的坐标做距离
    public static Pair<Integer, Integer> calDeltaBetween(View v1, View v2) {
        int location1[] = {0, 0};
        int location2[] = {0, 0};
        v1.getLocationOnScreen(location1);
        v2.getLocationOnScreen(location2);
        return new Pair<Integer, Integer>(location1[0] - location2[0],
                location1[1] - location2[1]);
    }

    //延时
    public static void doPostDelay(View v, long delay, Runnable run) {
        if (v != null && run != null && delay >= 0) {
            v.postDelayed(run, delay);
        }
    }

    //几秒钟后可见或者不可见
    public static void setVisibility(final View v, long delay,
                                     final int visibility) {
        if (v != null && delay >= 0) {
            v.postDelayed(new Runnable() {
                @Override
                public void run() {
                    v.setVisibility(visibility);
                }
            }, delay);
        }
    }
}
