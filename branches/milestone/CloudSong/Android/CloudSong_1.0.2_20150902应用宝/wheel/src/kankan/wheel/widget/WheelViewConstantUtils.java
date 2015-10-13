package kankan.wheel.widget;

/**
 * PADDINGLEFT:表示的是控件距离左边间距
 * 
 * ISVISIBLECENTERLINE：表示的是控件中间横条是否显示
 * 
 * VISIBLE_ITEMS表示默认要显示的条数
 * 
 * ITEMHEIGHT表示每个条目的高度
 * 
 * */

public class WheelViewConstantUtils {

	public static int PADDINGLEFT = 0;

	public static boolean ISVISIBLECENTERLINE = true;

	public static int VISIBLE_ITEMS = 5;

	public static int ITEMHEIGHT = 0;

	public static void setChildView(int pADDINGLEFT, boolean iSVISIBLECENTERLINE, int vISIBLE_ITEMS, int iTEMHEIGHT) {
		PADDINGLEFT = pADDINGLEFT;
		ISVISIBLECENTERLINE = iSVISIBLECENTERLINE;
		VISIBLE_ITEMS = vISIBLE_ITEMS;
		ITEMHEIGHT = iTEMHEIGHT;
	}

	
	public static void setChildView(int pADDINGLEFT, boolean iSVISIBLECENTERLINE) {
		PADDINGLEFT = pADDINGLEFT;
		ISVISIBLECENTERLINE = iSVISIBLECENTERLINE;
	}

	public static void setChildView(int pADDINGLEFT, boolean iSVISIBLECENTERLINE, int vISIBLE_ITEMS) {
		PADDINGLEFT = pADDINGLEFT;
		ISVISIBLECENTERLINE = iSVISIBLECENTERLINE;
		VISIBLE_ITEMS = vISIBLE_ITEMS;
	}

	
}
