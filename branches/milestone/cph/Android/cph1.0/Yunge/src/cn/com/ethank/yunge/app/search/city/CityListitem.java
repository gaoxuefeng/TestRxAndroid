package cn.com.ethank.yunge.app.search.city;

import java.util.ArrayList;
import java.util.List;

import android.util.Pair;

/**
 * Created by lvhonghe on 15/4/28.
 */
public class CityListitem {
    private String cityTitle;
    private List<CityBean> cityStingList;
    private ArrayList<Pair<String, List<CityBean>>> hotCityItem;

    private boolean isHot = false;
    private int currentPos = 0;

    private CityListitem() {

    }

    public static CityListitem createHotItem(ArrayList<Pair<String, List<CityBean>>> hotCityItem) {
        CityListitem result = new CityListitem();
        result.hotCityItem = hotCityItem;
        result.currentPos =1;
        result.isHot = true;
        result.cityTitle="热门城市";
        return result;
    }

    public static CityListitem createNormalListItem(String title, List<CityBean> citys, int position) {
        CityListitem result = new CityListitem();
        result.cityStingList = citys;
        result.cityTitle = title;
        result.currentPos = position;
        result.isHot = false;
        return result;
    }

    public String getCityTitle() {
        return cityTitle;
    }

    public List<CityBean> getCityStingList() {
        return cityStingList;
    }

    public ArrayList<Pair<String, List<CityBean>>> getHotCityItem() {
        return hotCityItem;
    }

    public boolean isHot() {
        return isHot;
    }

    public int getCurrentPos() {
        return currentPos;
    }
}
