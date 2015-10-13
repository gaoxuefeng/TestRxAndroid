package cn.com.ethank.yunge.app.mine.activity;

import java.lang.reflect.Field;
import java.util.Timer;
import java.util.TimerTask;

import android.annotation.SuppressLint;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.fragment.CustomDialogNewData;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.LoadingActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.PopupWindowUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.umeng.analytics.MobclickAgent;
import com.umeng.update.UmengUpdateAgent;
import com.umeng.update.UmengUpdateListener;
import com.umeng.update.UpdateResponse;

public class SettingActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.set_tv_exit)
	private TextView set_tv_exit; // --退出按钮--
	@ViewInject(R.id.set_rl_grade)
	private RelativeLayout set_rl_grade; // --评分--
	@ViewInject(R.id.set_rl_opinion)
	private RelativeLayout set_rl_opinion; // --意见反馈--
	@ViewInject(R.id.set_rl_about)
	private RelativeLayout set_rl_about; // --关于潮趴汇--
	@ViewInject(R.id.set_rl_cache)
	private RelativeLayout set_rl_cache; // --清除缓存--
	@ViewInject(R.id.set_ll_state)
	private LinearLayout set_ll_state;

	@ViewInject(R.id.set_rl_modifypw)
	private RelativeLayout set_rl_modifypw; // --修改密码--
	@ViewInject(R.id.set_rl_check_version_update)
	private RelativeLayout set_rl_check_version_update;// 版本更新
	@ViewInject(R.id.iv_circle_update)
	private ImageView iv_circle_update;// 版本更新

	@ViewInject(R.id.set_ll_parent)
	private LinearLayout set_ll_parent;

	@ViewInject(R.id.set_rl_login)
	private RelativeLayout set_rl_login; // --退出登录--

	private TextView dismiss_tv;
	private ImageView dismiss_iv;
	
	private RelativeLayout pop_utils;
	private TextView pop_tv_text2;
	private TextView pop_tv_text1;
	private Button pop_but_left;
	private Button pop_but_right;
	private ImageView pop_img;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_setting);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);
		set_tv_exit.setOnClickListener(this);
		set_rl_cache.setOnClickListener(this);
		set_rl_opinion.setOnClickListener(this);
		set_rl_about.setOnClickListener(this);
		set_rl_modifypw.setOnClickListener(this);
		set_rl_check_version_update.setOnClickListener(this);
		set_rl_login.setOnClickListener(this);

		pop_utils = (RelativeLayout) View.inflate(this, R.layout.pop_utils, null);
		pop_tv_text2 = (TextView) pop_utils.findViewById(R.id.pop_tv_text2);
		pop_tv_text2.setText("确定要退出？");
		pop_tv_text1 = (TextView) pop_utils.findViewById(R.id.pop_tv_text1);
		pop_tv_text1.setVisibility(View.GONE);
		pop_but_left = (Button) pop_utils.findViewById(R.id.pop_but_left);
		pop_but_left.setText("取消");
		pop_but_left.setOnClickListener(this);
		pop_but_right = (Button) pop_utils.findViewById(R.id.pop_but_right);
		pop_but_right.setText("确定");
		pop_but_right.setOnClickListener(this);

		setData();
	}

	private void setData() {
		if (!TextUtils.isEmpty(Constants.getToken())) {
			set_rl_modifypw.setVisibility(View.VISIBLE);
			set_rl_login.setVisibility(View.VISIBLE);
		} else {
			set_rl_modifypw.setVisibility(View.GONE);
			set_rl_login.setVisibility(View.GONE);
		}
		checkUpdata(false);

	}

	private void checkUpdata(final boolean ishandler) {
		if (!NetStatusUtil.isNetConnect()) {
			ToastUtil.show(R.string.connectfailtoast);
		}
		UmengUpdateAgent.setUpdateOnlyWifi(false);
		UmengUpdateAgent.setUpdateAutoPopup(ishandler);
		UmengUpdateAgent.setUpdateListener(new UmengUpdateListener() {

			@Override
			public void onUpdateReturned(int updateStatus, UpdateResponse updateInfo) {
				if (updateInfo != null) {

					if (updateStatus == 0) {
						iv_circle_update.setVisibility(View.VISIBLE);
					} else {
						iv_circle_update.setVisibility(View.GONE);
					}
					if (!ishandler) {
						return;
					}

					switch (updateStatus) {
					case 0:
						UmengUpdateAgent.update(context);
						UmengUpdateAgent.setUpdateAutoPopup(false);

						break;
					case 1:
						ToastUtil.show("已经是最新版本");
						break;
					case 2:
						ToastUtil.show("已经是最新版本");
						break;
					case 3:
						ToastUtil.show("已经是最新版本");
						break;

					default:

						break;
					}

					// showUpdateDialog(updateInfo.path, updateInfo.updateLog);
				}
				// case 0: // has update
				// case 1: // has no update
				// case 2: // none wifi
				// case 3: // time out
			}
		});
		UmengUpdateAgent.update(this);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.set_rl_login:
			PopupWindowUtils.show(this, pop_utils, set_rl_cache,false);
			break;
		case R.id.pop_but_left:
			PopupWindowUtils.dismiss();
			break;
		case R.id.pop_but_right:
			PopupWindowUtils.dismiss();
			try {
				SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.token);
				if (LoadingActivity.myRooms != null) {
					LoadingActivity.myRooms.clear();
				}
				SharePreferencesUtil.deleteData(SharePreferenceKeyUtil.imageUrl);
				Constants.setBinded(false);
				finish();
				ToastUtil.show("退出登录成功");
			} catch (Exception e) {
				e.printStackTrace();
			}

			break;
		case R.id.set_tv_exit:

			// --退出--
			finish();
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineSettingLogout");
			break;
		case R.id.set_rl_cache:
			showAlertDialog();
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineSettingClean");

			break;
		case R.id.set_rl_opinion:
			// --跳转到意见反馈页面--
			Intent opinion = new Intent(getApplicationContext(), OpinionActivity.class);
			startActivity(opinion);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineSettingFeedBack");
			break;
		case R.id.set_rl_about:
			// --跳转到关于潮趴汇界面--
			Intent about = new Intent(getApplicationContext(), AboutActivity.class);
			startActivity(about);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineSettingAbout");
			break;
		case R.id.set_rl_modifypw:
			// --跳转到修改密码界面--
			Intent intent = new Intent(getApplicationContext(), ModifyPasswordActivity.class);
			startActivity(intent);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineSettingChangePass");
			break;
		case R.id.set_rl_check_version_update:
			// 监测版本更新
			if(!NetStatusUtil.isNetConnect()){
				ToastUtil.show("网络异常");
				return;
			}
			checkUpdata(true);
			break;
		}
	}

	/**
	 * 获取状态栏的高度
	 * 
	 * @return
	 */
	public int getBarHeight() {
		Class<?> c = null;
		Object obj = null;
		Field field = null;
		int x = 0, sbar = 38;// 默认为38，貌似大部分是这样的

		try {
			c = Class.forName("com.android.internal.R$dimen");
			obj = c.newInstance();
			field = c.getField("status_bar_height");
			x = Integer.parseInt(field.get(obj).toString());
			sbar = getResources().getDimensionPixelSize(x);

		} catch (Exception e1) {
			e1.printStackTrace();
		}
		return sbar;
	}

	private Animation animation;
	protected LinearLayout item_set_progress;

	/**
	 * 弹出dialog
	 */
	private void showAlertDialog() {
		CustomDialogNewData.Builder builder = new CustomDialogNewData.Builder(this);
		builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {

			public void onClick(DialogInterface dialog, int which) {
				set_rl_cache.setClickable(false);
				dialog.dismiss();
				getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN);// 隐藏状态栏

				item_set_progress = (LinearLayout) View.inflate(getApplicationContext(), R.layout.item_set_progress, null);

				dismiss_tv = (TextView) item_set_progress.findViewById(R.id.dismiss_tv);
				dismiss_iv = (ImageView) item_set_progress.findViewById(R.id.dismiss_iv);

				animation = AnimationUtils.loadAnimation(SettingActivity.this, R.anim.translate);
				animation.setDuration(250);
				dismiss_iv.setAnimation(animation);

				LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, getBarHeight());

				set_ll_state.addView(item_set_progress, layoutParams);

				// dismissPop(set_ll_state, item_set_progress);
				handler.sendEmptyMessageDelayed(-1, 4000);

			}
		});

		builder.setNegativeButton("取消", new android.content.DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
			}
		});
		
		
		builder.create().show();
	}

	/**
	 * 定时器，4秒后提示的pop消失
	 * 
	 * @param item_set_progress
	 * @param set_ll_state
	 */
	// private void dismissPop(final LinearLayout set_ll_state, final
	// LinearLayout item_set_progress) {
	// handler.sendEmptyMessageDelayed(-1, 4000);
	// // Timer timer = new Timer();
	//
	// }

	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case -1:
				try {
					if (set_ll_state != null && dismiss_iv != null && dismiss_tv != null) {
						dismiss_tv.setText("已成功清理缓存");
						dismiss_iv.clearAnimation();
						dismiss_iv.setBackgroundResource(R.drawable.setup_clean_done);
						handler.sendEmptyMessageDelayed(-2, 2000);
					}

				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case -2:
				try {
					if (set_ll_state != null) {
						set_ll_state.removeView(item_set_progress);
						getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
						set_rl_cache.setClickable(true);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				break;
			default:
				break;
			}

		};
	};
	

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}

}
