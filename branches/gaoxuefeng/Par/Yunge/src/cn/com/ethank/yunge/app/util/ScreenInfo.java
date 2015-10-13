package cn.com.ethank.yunge.app.util;

import android.app.Activity;
import android.util.DisplayMetrics;

import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.sys.CoyoteSystem;

public class ScreenInfo {
	
	private boolean isInit = false;
	private ISettingService settingService = (ISettingService)CoyoteSystem.getCurrent()
			.getService(ISettingService.class);
	
	private int widthPixels;
	private int heightPixels;
	private float density;
	private int densityDpi;
	private float scaledDensity;
		
	private static final int ERROR_INT = -1;
	private static final float ERROR_FLOAT = -1F;
	
	public ScreenInfo(Activity activityContext) {
		init(activityContext);
	}
	
	private void init(Activity activityContext) {
		if(!isInit) {
			DisplayMetrics mertic = new DisplayMetrics();
			activityContext.getWindowManager().getDefaultDisplay().getMetrics(mertic);
			widthPixels = mertic.widthPixels;
			heightPixels = mertic.heightPixels;
			density = mertic.density;
			densityDpi = mertic.densityDpi;
			scaledDensity = mertic.scaledDensity;
			isInit = true;
			
		}
	}
	
	public int getWidthPixels() {
		if(isInit) {
			return widthPixels;
		} 
		return ERROR_INT;
	}
	
	public int getheightPixels() {
		if(isInit) {
			return heightPixels;
		}
		return ERROR_INT;
	}
	
	public float getDensity() {
		if(isInit) {
			return density;
		}
		return ERROR_FLOAT;
	}
	
	public int getDensityDpi() {
		if(isInit) {
			return densityDpi;
		}
		return ERROR_INT;
	}
	
	public float getScaledDensity() {
		if(isInit) {
			return scaledDensity;
		}
		return ERROR_FLOAT;
	}
	
	
}
