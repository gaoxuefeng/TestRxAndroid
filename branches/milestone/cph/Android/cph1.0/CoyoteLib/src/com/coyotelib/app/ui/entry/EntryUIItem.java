package com.coyotelib.app.ui.entry;


import android.view.View;

public class EntryUIItem {
	public static final int TYPE_TITLE = 1;
	public static final int TYPE_ENTRENCE = 2;
    public static final int TYPE_SWITCH_1 = 3;
    public static final int TYPE_SWITCH_2 = 4;
    public static final int TYPE_TX = 5;
    public static final int TYPE_SPLITER = 6;

    public static final String SETTING_NEW_SIGN_KEY_PRE = "setting_new_sign_key_pre";
	
	private String title;
    private String subTitle;
	private int icon;
	private int type;
	private boolean newSign;
    private String newSingKey;

    private OnEntryListClicked itemClicked;

    private View.OnClickListener switchClicked;

    private String switch_key;

    private boolean switch_defval;

    private String info;
    private String info_key;

    private boolean showLongLine;

    private boolean hideArrow = false;


/*    private String switchOnPingBack;
    private String switchOffPingBack;*/
	
	private EntryUIItem() {
		
	}

    public static EntryUIItem createSpliter() {
        EntryUIItem result = new EntryUIItem();
        result.type = TYPE_SPLITER;
        return result;
    }
	
	public static EntryUIItem createTitle(String title) {
		EntryUIItem result = new EntryUIItem();
		result.type = TYPE_TITLE;
		result.title = title;
		return result;
	}
	
	public static EntryUIItem createEntrence(int icon, String title, boolean newSign, String newSignKey, OnEntryListClicked itemClicked) {
		return createEntrence(icon, title, newSign, newSignKey, itemClicked, false);
	}

    public static EntryUIItem createEntrence(int icon, String title, boolean newSign, String newSignKey, OnEntryListClicked itemClicked, boolean showLongSpliter) {
        EntryUIItem result = new EntryUIItem();
        result.type = TYPE_ENTRENCE;
        result.icon = icon;
        result.title = title;
        result.newSign = newSign;
        result.itemClicked = itemClicked;
        result.newSingKey = newSignKey;
        result.showLongLine = showLongSpliter;
        return result;
    }

    public static EntryUIItem createEntrence(int icon, String title, boolean newSign, String newSignKey, OnEntryListClicked itemClicked, boolean showLongSpliter, boolean hideArrow) {
        EntryUIItem result = new EntryUIItem();
        result.type = TYPE_ENTRENCE;
        result.icon = icon;
        result.title = title;
        result.newSign = newSign;
        result.itemClicked = itemClicked;
        result.newSingKey = newSignKey;
        result.showLongLine = showLongSpliter;
        result.hideArrow = hideArrow;
        return result;
    }


    public static EntryUIItem createSwitch(String title, String subTitle, View.OnClickListener l, String switch_key, boolean defVal) {
        EntryUIItem result = new EntryUIItem();
        result.type = TYPE_SWITCH_1;
        result.title = title;
        result.subTitle = subTitle;
        result.switchClicked = l;
        result.switch_key = switch_key;
        result.switch_defval = defVal;
        return result;
    }

    public static EntryUIItem createTx(String title, String info, String info_key) {
        EntryUIItem result = new EntryUIItem();
        result.type = TYPE_TX;
        result.title = title;
        result.info = info;
        result.info_key = info_key;
        return result;
    }

	public int getType() {
		return type;
	}
	
	public int getIconRes() {
		return icon;
	}
	
	public String getTitle() {
		return title;
	}
	
	public boolean showNewSign() {
		return false;// Setting.getInst().getBoolean(String.format("%s_%s", SETTING_NEW_SIGN_KEY_PRE, newSingKey), newSign);
	}

    public void clearNew() {
      //  Setting.getInst().setBoolean(String.format("%s_%s", SETTING_NEW_SIGN_KEY_PRE, newSingKey), false);
    }

    public String getSubTitle() {
        return subTitle;
    }

    public OnEntryListClicked getItemClicked() {
        return itemClicked;
    }

    public View.OnClickListener getSwitchClicked() {
        return switchClicked;
    }

    public String getSwitch_key() {
        return switch_key;
    }

    public boolean isChecked() {
        return false; //Setting.getInst().getBoolean(switch_key, switch_defval);
    }

    public String getInfo() {
        return ""; // Setting.getInst().getString(info_key, info);
    }

    public boolean isShowLongLine() {
        return showLongLine;
    }

    public boolean isHideArrow() {
        return hideArrow;
    }
}
