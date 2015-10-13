package cn.com.ethank.yunge.app.home;

import java.util.ArrayList;

import cn.com.ethank.yunge.app.home.bean.HomeInfo;

@SuppressWarnings("serial")
public class MyArrayList extends ArrayList<HomeInfo> {
	@Override
	public boolean contains(Object object) {
		try {
			HomeInfo homeInfo = (HomeInfo) object;
			for (int i = 0; i < this.size(); i++) {
				if (get(i).getAddress().equals(homeInfo.getAddress()) && get(i).getBLDKTVId().equals(homeInfo.getBLDKTVId())) {
					return true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;

	}

}
