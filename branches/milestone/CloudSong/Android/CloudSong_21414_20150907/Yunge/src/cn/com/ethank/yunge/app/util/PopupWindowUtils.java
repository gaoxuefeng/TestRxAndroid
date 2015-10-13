package cn.com.ethank.yunge.app.util;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager.LayoutParams;
import android.widget.PopupWindow;

import com.coyotelib.app.ui.util.UICommonUtil;

public class PopupWindowUtils {
	
	private static PopupWindow window;

	public static void show(Context context, View view, View parent,boolean isTouch) {
		
		window = new PopupWindow(view, android.widget.RelativeLayout.LayoutParams.MATCH_PARENT,
				LayoutParams.MATCH_PARENT);

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(isTouch);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(parent, Gravity.CENTER, 0, 0);

	}
	
	public static void dismiss(){
		if(window != null && window.isShowing())
		window.dismiss();
	}
}
