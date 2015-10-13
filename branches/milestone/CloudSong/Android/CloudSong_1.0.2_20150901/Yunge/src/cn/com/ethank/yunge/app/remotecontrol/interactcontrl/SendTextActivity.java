package cn.com.ethank.yunge.app.remotecontrol.interactcontrl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import android.content.Context;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.remotecontrol.ControlCode;
import cn.com.ethank.yunge.app.remotecontrol.interactcontrl.PopAdapter.OnItemClickLiistener;
import cn.com.ethank.yunge.app.remotecontrol.requestnetwork.RequestBoxInteract;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.ToastUtil;

public class SendTextActivity extends BaseTitleActivity implements OnClickListener {

	private LinearLayout footer_for_emoticons;
	private RelativeLayout rl_above_keyboard;
	private View pop_emoticons;
	private PopupWindow popupWindow;
	private int keyboardHeight;
	protected boolean isKeyBoardVisible = false;
	private LinearLayout ll_emotion;
	private EditText et_send_text;
	protected int previousHeightDiffrence;
	private ImageView iv_open_keyboard;
	private TextView tv_text_size;
	private ListView lv_pop_inittext;
	private ArrayList<String> stringList = new ArrayList<String>();
	private PopAdapter popAdapeter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_send_text);
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
		iv_open_keyboard.setOnClickListener(new OnClickListener() {

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
		et_send_text.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				Log.i("", "");
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				Log.i("", "");
			}

			@Override
			public void afterTextChanged(Editable s) {
				Log.i("", "");
				if (s.length() > 16 && !s.toString().contains("'")) {
					ToastUtil.show("最多只能输16个字");
					int selectionStart = et_send_text.getSelectionStart();
					int selectionEnd = et_send_text.getSelectionEnd();
					s.delete(selectionStart - 1, selectionEnd);
					int tempSelection = selectionStart;
					et_send_text.setText(s);
					et_send_text.setSelection(tempSelection > s.length() ? s.length() : tempSelection - 1);
				}
				tv_text_size.setText((s.length() > 16 ? 16 : s.length()) + "/" + 16);
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
		for (int i = 0; i < 30; i++) {
			stringList.add("唱的可以啊!" + i);
		}
		popupWindow = new PopupWindow(pop_emoticons, LayoutParams.MATCH_PARENT, (int) keyboardHeight, false);
		popupWindow.setBackgroundDrawable(new ColorDrawable(0x00000000));
		lv_pop_inittext = (ListView) pop_emoticons.findViewById(R.id.lv_pop_inittext);
		popAdapeter = new PopAdapter(context, stringList, new OnItemClickLiistener() {

			@Override
			public void OnItemClick(int position) {
				et_send_text.setText(stringList.get(position));
				et_send_text.setSelection(et_send_text.getText().toString().length());
			}
		});
		lv_pop_inittext.setAdapter(popAdapeter);

	}

	private void initView() {
		et_send_text = (EditText) findViewById(R.id.et_send_text);
		tv_text_size = (TextView) findViewById(R.id.tv_text_size);
		iv_open_keyboard = (ImageView) findViewById(R.id.iv_open_keyboard);
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

	/**
	 * 显示键盘
	 */
	public void showInputMethod() {
		footer_for_emoticons.setVisibility(View.VISIBLE);
		InputMethodManager imm = (InputMethodManager) this.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.showSoftInput(et_send_text, InputMethodManager.RESULT_SHOWN);
		imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, InputMethodManager.HIDE_IMPLICIT_ONLY);
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.title_function:
			ToastUtil.show("发送");
			sengTextNetWork();
			break;

		default:
			super.onClick(view);
			break;
		}

	}

	private void sengTextNetWork() {
		String sendText = et_send_text.getText().toString();
		if (!sendText.isEmpty()) {
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("data", sendText);
			hashMap.put("type", ControlCode.INTERACTION_WITH_TEXT + "");
			RequestBoxInteract boxInteract = new RequestBoxInteract(context, hashMap);
			boxInteract.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					et_send_text.getText().clear();
				}

				@Override
				public void onLoaderFail() {

				}
			});
		}

	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (popupWindow != null && popupWindow.isShowing()) {
				popupWindow.dismiss();
				return true;
			}
			// 这里写你要在用户按下返回键同时执行的动作
			// moveTaskToBack(false); //核心代码：屏蔽返回行为

		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
