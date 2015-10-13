package cn.com.ethank.yunge.app.remotecontrol.interactcontrl;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.RoomBaseActivity;
import cn.com.ethank.yunge.app.demandsongs.childfragment.BitmapHelp;
import cn.com.ethank.yunge.app.room.bean.RoomStateInfo;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SDCardPathUtil;
import cn.com.ethank.yunge.app.util.SpecialPictureUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.UUIDGenerator;
import cn.com.ethank.yunge.view.MyRadioGroup;
import cn.com.ethank.yunge.view.MyRadioGroup.OnCheckedChangeListener;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.BitmapUtils;

public class DrawHraffitiActivity extends RoomBaseActivity implements OnClickListener {

	private String imagePath;
	private int length, abs;

	private DrawPictureView mdp_picture;
	private TextView mag_top;
	Timer timer = new Timer();
	private SeekBar sb_type;
	private LinearLayout ll_thickness;
	private LinearLayout ll_select_color;
	private LinearLayout ll_back;
	private View layout_select_color;
	private View layout_setting;
	private View layout_thickness;
	private ImageView iv_thickness_ok;
	private ImageView iv_select_color_ok;
	private MyRadioGroup mrg_selectColor;
	private Button bt_send_duck;
	private Button bt_exit_duck;
	private String duckImagePath = "";
	private BitmapUtils bitmapUtils;
	private Bitmap bitmap;
	private static final int TAB_MAIN = 0;
	private static final int TAB_THICKNESS = 1;
	private static final int TAB_COLOR = 2;
	// 画笔粗细
	private static final int wideStrokeWidth = 15;
	private static final int defaultStrokeWidth = 10;
	private static final int smallStrokeWidth = 5;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.picture_diy);
		bitmapUtils = BitmapHelp.getBitmapUtils(this);
		initParams();
		initView();
		title.setVisibility(View.GONE);
		initBottom();
		iniData();

	}

	private void initBottom() {
		// 3个layout
		layout_setting = (View) findViewById(R.id.layout_setting);
		layout_select_color = (View) findViewById(R.id.layout_select_color);
		layout_thickness = (View) findViewById(R.id.layout_thickness);
		// 主页面的3个按钮

		ll_thickness = (LinearLayout) findViewById(R.id.ll_thickness);
		ll_thickness.setOnClickListener(this);
		ll_select_color = (LinearLayout) findViewById(R.id.ll_select_color);
		ll_select_color.setOnClickListener(this);
		ll_back = (LinearLayout) findViewById(R.id.ll_back);
		ll_back.setOnClickListener(this);
		selectLayout(TAB_MAIN);

		// 颜色
		mrg_selectColor = (MyRadioGroup) findViewById(R.id.mrg_selectColor);
		for (int i = 0; i < mrg_selectColor.getChildCount(); i++) {
			View view = ((ViewGroup) mrg_selectColor.getChildAt(i));
			android.view.ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
			layoutParams.height = (int) (UICommonUtil.getScreenWidthPixels(this) * 1f / 8);
			layoutParams.width = (int) (UICommonUtil.getScreenWidthPixels(this) * 1f / 8);
			view.setLayoutParams(layoutParams);
		}
		iv_thickness_ok = (ImageView) findViewById(R.id.iv_thickness_ok);
		iv_select_color_ok = (ImageView) findViewById(R.id.iv_select_color_ok);
		iv_thickness_ok.setOnClickListener(this);
		iv_select_color_ok.setOnClickListener(this);
		mrg_selectColor.setOnCheckedChangeListener(new OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(MyRadioGroup group, int checkedId) {
				// 设置画笔颜色0.
				Log.i("", "");
				int position = getCheckPositionByCheckedId(checkedId);// 选择的第几个
				if (position <= 7) {
					mdp_picture.setPaintByPosition(position);
				}
			}
		});

		setCheckPosition(0);
	}

	/**
	 * 设置底部选择哪个Tab
	 * 
	 * @param tab
	 */
	private void selectLayout(int tab) {
		switch (tab) {
		case TAB_MAIN:
			// 主页
			layout_setting.setVisibility(View.VISIBLE);
			layout_select_color.setVisibility(View.GONE);
			layout_thickness.setVisibility(View.GONE);
			break;
		case TAB_THICKNESS:
			// 粗细
			layout_setting.setVisibility(View.GONE);
			layout_select_color.setVisibility(View.GONE);
			layout_thickness.setVisibility(View.VISIBLE);
			break;
		case TAB_COLOR:
			// 颜色
			layout_setting.setVisibility(View.GONE);
			layout_select_color.setVisibility(View.VISIBLE);
			layout_thickness.setVisibility(View.GONE);
			break;

		default:
			layout_setting.setVisibility(View.VISIBLE);
			layout_select_color.setVisibility(View.GONE);
			layout_thickness.setVisibility(View.GONE);
			break;
		}

	}

	private void initParams() {
		int screenWidth = UICommonUtil.getScreenWidthPixels(this);
		int screenHeight = UICommonUtil.getScreenHeightPixels(this);
		length = screenWidth > screenHeight ? screenHeight : screenWidth;
		abs = Math.abs(screenHeight - screenWidth);
	}

	private void initView() {
		mdp_picture = (DrawPictureView) findViewById(R.id.mdp_picture);

		bt_send_duck = (Button) findViewById(R.id.bt_send_duck);
		bt_send_duck.setOnClickListener(this);
		bt_exit_duck = (Button) findViewById(R.id.bt_exit_duck);
		bt_exit_duck.setOnClickListener(this);
		mag_top = (TextView) findViewById(R.id.mag_top);
		RelativeLayout.LayoutParams layoutParams2 = (RelativeLayout.LayoutParams) mdp_picture.getLayoutParams();
		layoutParams2.width = length;
		layoutParams2.height = length;
		mdp_picture.setLayoutParams(layoutParams2);
		LayoutParams magParams = (LayoutParams) mag_top.getLayoutParams();
		magParams.height = abs / 4;
		mag_top.setLayoutParams(magParams);
		sb_type = (SeekBar) findViewById(R.id.sb_type);
		sb_type.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			private int progress = 0;

			@Override
			public void onStopTrackingTouch(SeekBar seekBar) {
				// 先改为可以任意滑动
				mdp_picture.setPaintTrickness((int) (smallStrokeWidth + (seekBar.getProgress() * 10f / seekBar.getMax())));
				// 原来
				// if (seekBar.getProgress() <= seekBar.getMax() / 4) {
				// seekBar.setProgress(0);
				// mdp_picture.setPaintTrickness(smallStrokeWidth);
				// Log.i("seekbar", "停止" + "1");
				// } else if (seekBar.getProgress() > seekBar.getMax() / 4 &&
				// progress < seekBar.getMax() * 3 / 4) {
				// seekBar.setProgress(seekBar.getMax() / 2);
				// mdp_picture.setPaintTrickness(defaultStrokeWidth);
				// Log.i("seekbar", "停止" + "2" + "_" + seekBar.getMax() / 2);
				// } else {
				// seekBar.setProgress(seekBar.getMax());
				// mdp_picture.setPaintTrickness(wideStrokeWidth);
				// Log.i("seekbar", "停止" + "3" + (seekBar.getMax() - 1));
				// }
			}

			@Override
			public void onStartTrackingTouch(SeekBar seekBar) {

			}

			@Override
			public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
				this.progress = progress;
				Log.i("seekbar", fromUser + "");
			}
		});

	}

	@SuppressWarnings("deprecation")
	private void iniData() {
		// 原图片路径
		Bundle bundle = getIntent().getExtras();
		if (bundle != null && bundle.containsKey("imagePath")) {
			imagePath = getIntent().getStringExtra("imagePath");

			bitmap = SpecialPictureUtil.getSpecialBitmap(imagePath);
		}
		if (bitmap == null) {
			bitmap = SpecialPictureUtil.cutBitmap(null);
		}
		mdp_picture.setBackgroundDrawable(new BitmapDrawable(bitmap));

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.bt_send_duck:
			Bitmap bitmap= getBitmapFromView();
			Intent intent = new Intent();
			intent.putExtra("imagePath", duckImagePath);
			setResult(-1, intent);
			String picValue = null;
			uploadImage(picValue, bitmap, System.currentTimeMillis()+"");
			
			ToastUtil.show("图片保存在:" + duckImagePath.toString());
			finish();
			break;
		// 主bottom
		case R.id.ll_thickness:
			// 粗细
			selectLayout(TAB_THICKNESS);
			break;
		case R.id.ll_select_color:
			// 选择颜色
			selectLayout(TAB_COLOR);
			break;
		case R.id.ll_back:
			// 撤销
			mdp_picture.deleteDrawPath();
			break;
		case R.id.iv_select_color_ok:
		case R.id.iv_thickness_ok:
			selectLayout(TAB_MAIN);
			break;
		case R.id.bt_exit_duck:
			finish();
			break;

		default:
			break;
		}
	}

	/**
	 * 保存涂鸦图片到内存卡
	 */
	private Bitmap getBitmapFromView() {
		Bitmap tempBitmap = null;
		Bitmap bitmap = null;
		if (length != 0) {
			tempBitmap = Bitmap.createBitmap(length, length, Bitmap.Config.ARGB_8888);
			Canvas canvas = new Canvas(tempBitmap);
			mdp_picture.layout(0, 0, length, length);
			mdp_picture.draw(canvas);
		}
		bitmap = Bitmap.createScaledBitmap(tempBitmap, 600, 600, false);
		closeBitmap(tempBitmap);
		String filename = UUIDGenerator.getUUID() + ".jpg";// 最终保存名字
		File file = new File(SDCardPathUtil.getImagePath(), filename);
		return bitmap;

//		SpecialPictureUtil.savePicture(bitmap, file.getAbsolutePath());
//		duckImagePath = file.getAbsolutePath();
//		closeBitmap(bitmap);
	}

	private void uploadImage(String picValue, Bitmap smallBitmap, String picName) {
		ByteArrayOutputStream arrayOutputStream = null;
		try {
			arrayOutputStream = new ByteArrayOutputStream();
			smallBitmap.compress(Bitmap.CompressFormat.JPEG, 100, arrayOutputStream);
			arrayOutputStream.flush();
			arrayOutputStream.close();
			byte[] imgBytes = arrayOutputStream.toByteArray();
			picValue = Base64.encodeToString(imgBytes, Base64.DEFAULT);

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				arrayOutputStream.flush();
				arrayOutputStream.close();
				closeBitmap(smallBitmap);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		final Map<String, String> map = new HashMap<String, String>();
		map.put("msgContent", picValue);
		map.put("picName", picName);
		map.put("msgType", "1");
		map.put("reserveBoxId", Constants.getReserveBoxId());
		map.put("token", Constants.getToken());

		ToastUtil.show("上传");

		BackgroundTask<String> backgroundTask = new BackgroundTask<String>() {

			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.getKTVIP()+Constants.ADDINFO, map).toString();
			}
			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					RoomStateInfo picInfo = JSON.parseObject(result, RoomStateInfo.class);
					if (picInfo.getCode() == 0) {
						ToastUtil.show("发送成功");
						
						/*final Map<String, String> map = new HashMap<String, String>();
						map.put("msgId", "0");
						map.put("reserveBoxId", Constants.getReserveBoxId());
						map.put("token", Constants.getToken());*/
						
						//new GetRoomData(map,new1).run();
					} else {
						ToastUtil.show(picInfo.getMessage());
					}
				} else {
					ToastUtil.show(R.string.connectfailtoast);
				}
				finish();
			};
		};
		backgroundTask.run();

	}

	
	
	private void closeBitmap(Bitmap bitmap) {
		if (bitmap != null) {
			bitmap.recycle();
			bitmap = null;
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {

			finish();
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	protected void onResume() {
		super.onResume();

	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		timer.cancel();
	}

	private void setCheckPosition(int position) {
		mrg_selectColor.check(((ViewGroup) mrg_selectColor.getChildAt(position)).getChildAt(0).getId());
	}

	private int getCheckPositionByCheckedId(int checkedId) {
		int position = 0;
		for (int i = 0; i < mrg_selectColor.getChildCount(); i++) {
			if (((ViewGroup) mrg_selectColor.getChildAt(i)).getChildAt(0).getId() == checkedId) {
				position = i;
				break;

			}

		}
		return position;

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
