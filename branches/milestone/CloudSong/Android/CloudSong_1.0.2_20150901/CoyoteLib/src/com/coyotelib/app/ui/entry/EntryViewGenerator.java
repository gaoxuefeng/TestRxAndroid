package com.coyotelib.app.ui.entry;

import android.content.Context;
import android.view.View;

public class EntryViewGenerator {

    private Context mContext;
    public EntryViewGenerator(Context mContext) {
        this.mContext = mContext;
    }


	public View generatorView(EntryUIItem item, View view) {
		View result = null;
		if(item != null) {
			switch (item.getType()) {
			case EntryUIItem.TYPE_TITLE:
				result = generatorTitleView(item, view);
				break;
			case EntryUIItem.TYPE_ENTRENCE:
				result = generateEnterenceView(item, view);
				break;

            case EntryUIItem.TYPE_SWITCH_1:
                result = generateSwitchView(item, view);
                break;

            case EntryUIItem.TYPE_TX:
                result = generateTxView(item, view);
                break;

            case EntryUIItem.TYPE_SPLITER:
                result = generateSpliterView(item, view);
                break;

			default:
				break;
			}
		}
		return result;
	}
	
	private View generatorTitleView(EntryUIItem item, View view) {
		
		if((view == null || !(view instanceof EntryTitleView))) {
            EntryTitleView result = new EntryTitleView(mContext);
			result.setTitle(item.getTitle());
			return result;
		} else {
			((EntryTitleView) view).setTitle(item.getTitle());
			return view;
		}
	}
	
	private View generateEnterenceView(EntryUIItem item, View view) {
		if((view == null || !(view instanceof EntryEntrenceView))) {
            EntryEntrenceView result = new EntryEntrenceView(mContext);
			result.setIcon(item.getIconRes());
			result.setTitle(item.getTitle());
			result.showNew(item.showNewSign());
         //   result.setBottomLine(item.isShowLongLine());
         //   result.hideArrow(item.isHideArrow());
			return result;
		} else {
			((EntryEntrenceView) view).setTitle(item.getTitle());
			((EntryEntrenceView) view).setIcon(item.getIconRes());
			((EntryEntrenceView) view).showNew(item.showNewSign());
		//	((SettingEntrenceView) view).setBottomLine(item.isShowLongLine());
        //    ((SettingEntrenceView) view).hideArrow(item.isHideArrow());
            return view;
		}
	}

    private View generateSwitchView(EntryUIItem item, View view) {
       /* if((view == null || !(view instanceof SwitchTitleView))) {
            SwitchTitleView result = new SwitchTitleView(mContext);
            result.setSwitchTitle(item.getTitle());
            result.setSubTitle(item.getSubTitle());
            result.setChecked(item.isChecked());
            result.setSwitchHandler(item.getSwitchClicked());
            return result;
        } else {
            ((SlgSwitchView2) view).setSwitchTitle(item.getTitle());
            ((SlgSwitchView2) view).setSubTitle(item.getSubTitle());
            ((SlgSwitchView2) view).setChecked(item.isChecked());
            ((SlgSwitchView2) view).setSwitchHandler(item.getSwitchClicked());
            return view;
        }*/
        return view;
    }

    private View generateTxView(EntryUIItem item, View view) {
        if((view == null || !(view instanceof EntryTxView))) {
            EntryTxView result = new EntryTxView(mContext);
            result.setTitle(item.getTitle());
            result.setSubTitle(item.getInfo());
            return result;
        } else {
            ((EntryTxView) view).setTitle(item.getTitle());
            ((EntryTxView) view).setSubTitle(item.getInfo());
            return view;
        }
    }

    private View generateSpliterView(EntryUIItem item, View view) {
        if((view == null) || view instanceof EntrySpliterView) {
            view = new EntrySpliterView(mContext);
        }
        return view;
    }
}
