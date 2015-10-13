package cn.com.ethank.yunge.app.catering.utils;

import java.util.ArrayList;
import java.util.List;

import android.view.View;

import cn.com.ethank.yunge.app.catering.bean.TypeContentItem;

public class ConstantsUtils {

	// 保存餐点列表数据
	public static List<TypeContentItem> TYPECONTENT_LIST = new ArrayList<TypeContentItem>();

	// 添加菜品时启动的动画开始点
	public static int[] locationStart = new int[2];

	public static int[] startPaint(View view) {
		view.getLocationOnScreen(locationStart);
		return locationStart;
	}

	// 屏幕状态栏高度
	public static int DisplayTopHeight = 0;
	
	// 屏幕状态栏高度
	public static int AcitivityTitleHeight = 0;

}
