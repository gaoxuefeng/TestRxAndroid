package cn.com.ethank.yunge.app.demandsongs.util;

import java.util.Comparator;

import cn.com.ethank.yunge.app.demandsongs.beans.MusicBean;

public class CompareBySong implements Comparator<MusicBean> {

    @Override
    public int compare(MusicBean gu1, MusicBean gu2) {

        String name1 = gu1.getTitle();
        String name2 = gu2.getTitle();

        return name1.compareTo(name2);
    }

}
