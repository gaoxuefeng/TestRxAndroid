package com.coyotelib.app.ui.entry;

import android.content.Context;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.coyotelib.R;

/**
 * Created by lvhonghe on 2014/10/29.
 */
public class EntryEditView extends LinearLayout {

    private ImageView mEditIcon;
    private EditText mEditText;

    public EntryEditView(Context context, AttributeSet attrs) {
        super(context, attrs);
        inflate(context, R.layout.entry_edit_basic, this);
        mEditIcon = (ImageView) findViewById(R.id.edit_icon);
        mEditText = (EditText) findViewById(R.id.edit_content);
    }

    public void setIcon(int iconRes) {
        mEditIcon.setBackgroundResource(iconRes);
    }

    public String getEditContent() {
        return mEditText.getText().toString();
    }

    public void setHint(String hint) {
        mEditText.setHint(hint);
    }

    public void setMaxInputLine(int maxLines) {
        mEditText.setMaxLines(maxLines);
    }

    public void setLines(int lines) {
        mEditText.setLines(lines);
    }

    public void clearInput() {
        mEditText.setText("");
    }

    public void setText(String text) {
        mEditText.setText(text);
    }

    public void addTextChangeListener(TextWatcher watcher) {
        mEditText.addTextChangedListener(watcher);
    }

    public EditText getEditText() {
        return mEditText;
    }

}
