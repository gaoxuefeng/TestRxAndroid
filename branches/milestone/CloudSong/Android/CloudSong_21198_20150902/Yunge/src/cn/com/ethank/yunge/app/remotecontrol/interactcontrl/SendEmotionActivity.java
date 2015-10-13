package cn.com.ethank.yunge.app.remotecontrol.interactcontrl;

import android.content.Context;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RelativeLayout;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;

public class SendEmotionActivity extends BaseTitleActivity {

	private LinearLayout footer_for_emoticons;
	private RelativeLayout rl_above_keyboard;
	private View pop_emoticons;
	private PopupWindow popupWindow;
	private int keyboardHeight;
	protected boolean isKeyBoardVisible = false;
	private LinearLayout ll_emotion;
	private EditText et_send_text;
	protected int previousHeightDiffrence;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_send_emotion);
		initTitle();
		initView();
		initPop();
		checkKeyboardHeight();
		setOnListener();
	}

	private void initTitle() {
		title.setBtnBackText("遥控");
		title.setTitle("发文字");
		title.showBtnFunction();
		title.setBtnFunctionImage(0);
		title.setBtnFunctionText("发送");
	}

	private void setOnListener() {
		popupWindow.setOnDismissListener(new OnDismissListener() {

			@Override
			public void onDismiss() {
				footer_for_emoticons.setVisibility(LinearLayout.GONE);
			}
		});
		rl_above_keyboard.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View view) {

				if (!popupWindow.isShowing()) {

					popupWindow.setHeight((int) (keyboardHeight));

					if (isKeyBoardVisible) {
						footer_for_emoticons.setVisibility(LinearLayout.GONE);
					} else {
						footer_for_emoticons.setVisibility(LinearLayout.VISIBLE);
					}
					popupWindow.showAtLocation(ll_emotion, Gravity.BOTTOM, 0, 0);

				} else {
					popupWindow.dismiss();
					showInputMethod();

				}

			}
		});
		et_send_text.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				if (popupWindow.isShowing()) {

					popupWindow.dismiss();

				}

			}
		});
	}

	private void checkKeyboardHeight() {
		ll_emotion.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {

			@Override
			public void onGlobalLayout() {

				Rect r = new Rect();
				ll_emotion.getWindowVisibleDisplayFrame(r);

				int screenHeight = ll_emotion.getRootView().getHeight();
				int heightDifference = screenHeight - (r.bottom);

				if (previousHeightDiffrence - heightDifference > 50) {
					popupWindow.dismiss();
				}

				previousHeightDiffrence = heightDifference;
				if (heightDifference > 100) {

					isKeyBoardVisible = true;
					changeKeyboardHeight(heightDifference);

				} else {

					isKeyBoardVisible = false;

				}

			}
		});

	}

	private void initPop() {
		popupWindow = new PopupWindow(pop_emoticons, LayoutParams.MATCH_PARENT, (int) keyboardHeight, false);
	}

	private void initView() {
		et_send_text = (EditText) findViewById(R.id.et_send_text);
		ll_emotion = (LinearLayout) findViewById(R.id.ll_emotion);
		footer_for_emoticons = (LinearLayout) findViewById(R.id.footer_for_emoticons);
		rl_above_keyboard = (RelativeLayout) findViewById(R.id.rl_above_keyboard);
		pop_emoticons = getLayoutInflater().inflate(R.layout.pop_emoticons, null);
		final float popUpheight = getResources().getDimension(R.dimen.keyboard_height);
		changeKeyboardHeight((int) popUpheight);

	}

	private void changeKeyboardHeight(int popUpheight) {
		if (popUpheight > 100) {
			keyboardHeight = popUpheight;
			LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, keyboardHeight);
			footer_for_emoticons.setLayoutParams(params);
			if (isKeyBoardVisible) {
				footer_for_emoticons.setVisibility(LinearLayout.GONE);
			} else {
				footer_for_emoticons.setVisibility(LinearLayout.VISIBLE);
			}
		}
	}

	public void showInputMethod() {
		footer_for_emoticons.setVisibility(View.VISIBLE);
		InputMethodManager imm = (InputMethodManager) this.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.showSoftInput(et_send_text, InputMethodManager.RESULT_SHOWN);
		imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, InputMethodManager.HIDE_IMPLICIT_ONLY);
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
