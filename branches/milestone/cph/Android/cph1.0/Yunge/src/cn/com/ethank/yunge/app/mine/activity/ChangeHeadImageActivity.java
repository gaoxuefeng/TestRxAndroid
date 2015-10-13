package cn.com.ethank.yunge.app.mine.activity;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import android.app.ActionBar.LayoutParams;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Path;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Base64;
import android.util.FloatMath;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.Toast;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.ImageTools;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.mine.bean.UserPicInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.alibaba.fastjson.JSON;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.BitmapUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.bitmap.callback.BitmapLoadFrom;
import com.lidroid.xutils.view.annotation.ViewInject;

/**
 * 更换头像
 */
public class ChangeHeadImageActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.head_ll_left)
	private LinearLayout head_ll_left; // --返回个人主页--

	@ViewInject(R.id.head_but_img)
	private Button head_but_img; // --更换头像--

	@ViewInject(R.id.img)
	private ImageView img; // --头像--

	@ViewInject(R.id.img_rl_parent)
	private RelativeLayout img_rl_parent;

	@ViewInject(R.id.fl)
	private FrameLayout fl;

	private LinearLayout imgSave;
	private ImageView imgView, imgScreenshot;
	private String imgPath;

	private static final int NONE = 0;
	private static final int DRAG = 1;
	private static final int ZOOM = 2;

	private int mode = NONE;
	private float oldDist;
	private Matrix matrix = new Matrix();
	private Matrix savedMatrix = new Matrix();
	private PointF start = new PointF();
	private PointF mid = new PointF();
	private View pop_photo;

	private PopupWindow window;

	private Button btnImg;

	/**
	 * 表示选择的是相机--0
	 */
	private final int IMAGE_CAPTURE = 0;
	/**
	 * 表示选择的是相册--1
	 */
	private final int IMAGE_MEDIA = 1;

	/**
	 * 图片保存SD卡位置
	 */
	private final static String IMG_PATH = Environment.getExternalStorageDirectory() + "/chillax/imgs/" + "Text.png";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_change_head_img);
		BaseApplication.getInstance().cacheActivityList.add(this);

		ViewUtils.inject(this);

		pop_photo = View.inflate(getApplicationContext(), R.layout.pop_photo, null);

		head_ll_left.setOnClickListener(this);
		head_but_img.setOnClickListener(this);

		imgView = (ImageView) this.findViewById(R.id.screenshot_img);
		imgScreenshot = (ImageView) this.findViewById(R.id.screenshot);
		// imgSave = (LinearLayout)findViewById(R.id.img_save);

		String token = Constants.getToken();
		if (!TextUtils.isEmpty(token)) {
			String result = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result);
			UserInfo userInfo = JSON.parseObject(result, UserInfo.class);
			String gender = userInfo.getData().getUserInfo().getGender();

			String imageUrl = userInfo.getData().getUserInfo().getHeadUrl();
			if (!TextUtils.isEmpty(userInfo.getData().getUserInfo().getHeadUrl())) {
				BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
				bitmapUtils.display(img, imageUrl);
			} else {
				if (gender != null && gender.equals("女")) {
					img.setBackgroundResource(R.drawable.mine_default_avatar_female);
				} else {
					img.setBackgroundResource(R.drawable.mine_defaultavatar);
				}

			}
		}

		pop_photo.findViewById(R.id.photo_tv).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
				String fileName = "image.jpg";
				Uri imageUri = Uri.fromFile(new File(Environment.getExternalStorageDirectory(), fileName));
				// 指定照片保存路径（SD卡），image.jpg为一个临时文件，每次拍照后这个图片都会被替换
				intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
				startActivityForResult(intent, IMAGE_CAPTURE);
				window.dismiss();
			}
		});

		pop_photo.findViewById(R.id.photo_tv_alum).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
				intent.setType("image/*");
				startActivityForResult(intent, IMAGE_MEDIA);
				window.dismiss();
			}
		});

		pop_photo.findViewById(R.id.photo_cancel).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				window.dismiss();

			}
		});

	}

	/**
	 * 弹出选择照片选择
	 */
	private void showPopupWindow() {
		window = new PopupWindow(pop_photo, LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

		// 参数1 爹是谁 挂载的对象 参数2
		int[] location = new int[2]; // 现在数据里面没有值
		// 获取到每个条目view对象的具体位置
		img_rl_parent.getLocationInWindow(location);// 往数组里面写入 x和y两个值
		int x = location[0];
		int y = location[1];

		// 使其聚焦
		window.setFocusable(true);
		// 设置允许在外点击消失
		window.setOutsideTouchable(true);
		// 刷新状态
		window.update();
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		// 为了能够播放动画,添加背景
		window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		window.showAtLocation(img_rl_parent, Gravity.LEFT | Gravity.BOTTOM, 0, 0);// 在代码中出现的单位
		// window. showAsDropDown(this.findViewById(R.id.rl_bottom), 0, 0);
		TranslateAnimation translate = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f,
				Animation.RELATIVE_TO_PARENT, 1.0f, Animation.RELATIVE_TO_SELF, 0f);
		translate.setDuration(250);
		translate.setFillAfter(true);
		pop_photo.startAnimation(translate);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_ll_left:
			finish();
			break;
		case R.id.img:
			Intent head = new Intent(getApplicationContext(), HeadImageActivity.class);
			startActivity(head);
			finish();
			break;
		case R.id.head_but_img:
			if ("更换头像".equals(head_but_img.getText().toString())) {
				showPopupWindow();
			} else {
				finish();
			}
			break;

		}
	}

	/**
	 * 根据用户选择,返回图片资源
	 */
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == -1) {
			if (requestCode == IMAGE_MEDIA) {
				if (data == null)
					return;
				// 将保存在本地的图片取出并缩小后显示在界面上
				ContentResolver resolver = getContentResolver();

				// 照片的原始资源地址
				Uri originalUri = data.getData();
				if (originalUri == null)
					return;

				try {
					// 使用ContentProvider通过URI获取原始图片
					Bitmap photo = MediaStore.Images.Media.getBitmap(resolver, originalUri);
					if (photo != null) {
						// 为防止原始图片过大导致内存溢出，这里先缩小原图显示，然后释放原始Bitmap占用的内存
						Bitmap smallBitmap = ImageTools.zoomBitmap(photo, photo.getWidth() / 3, photo.getHeight() / 3);
						// 释放原始图片占用的内存，防止out of memory异常发生
						photo.recycle();

						fl.setVisibility(View.VISIBLE);
						img.setVisibility(View.GONE);
						imgView.setImageBitmap(smallBitmap);
						imgView.setOnTouchListener(touch);
						head_but_img.setOnClickListener(imgClick);
						head_but_img.setText("确认更换");
					}
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}

			} else if (requestCode == IMAGE_CAPTURE) {// 相机

				Bitmap bitmap = BitmapFactory.decodeFile(Environment.getExternalStorageDirectory() + "/image.jpg");

				if (bitmap == null)
					return;
				Bitmap newBitmap = ImageTools.zoomBitmap(bitmap, bitmap.getWidth() / 3, bitmap.getHeight() / 3);
				// 由于Bitmap内存占用较大，这里需要回收内存，否则会报out of memory异常
				bitmap.recycle();

				// 将处理过的图片显示在界面上，并保存到本地

				fl.setVisibility(View.VISIBLE);
				img.setVisibility(View.GONE);
				imgView.setImageBitmap(newBitmap);
				imgView.setOnTouchListener(touch);
				head_but_img.setOnClickListener(imgClick);
				head_but_img.setText("确认更换");

				/*
				 * ImageTools.savePhotoToSDCard(newBitmap,
				 * Environment.getExternalStorageDirectory().getAbsolutePath(),
				 * String.valueOf(System.currentTimeMillis()));
				 */

			}
		}

	}

	private void getImage(String imgPath) {
		Bitmap bitmap1 = getImgSource(IMG_PATH);

		if (bitmap1 != null) {

			fl.setVisibility(View.VISIBLE);
			img.setVisibility(View.GONE);
			imgView.setImageBitmap(bitmap1);
			imgView.setOnTouchListener(touch);
			head_but_img.setOnClickListener(imgClick);
			head_but_img.setText("确认更换");

		}
	}

	/**
	 * 從指定路徑讀取圖片資源
	 */
	public Bitmap getImgSource(String pathString) {

		Bitmap bitmap = null;
		BitmapFactory.Options opts = new BitmapFactory.Options();
		opts.inSampleSize = 1;

		try {
			File file = new File(pathString);
			if (file.exists()) {
				bitmap = BitmapFactory.decodeFile(pathString, opts);
			}
			if (bitmap == null) {
				return null;
			} else {
				return bitmap;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 保存图片到app指定路径
	 * 
	 * @param bm头像图片资源
	 * @param fileName保存名称
	 */
	public static void saveFile(Bitmap bm, String filePath) {
		try {
			String Path = filePath.substring(0, filePath.lastIndexOf("/"));
			File dirFile = new File(Path);
			if (!dirFile.exists()) {
				dirFile.mkdirs();
			}
			File myCaptureFile = new File(filePath);
			BufferedOutputStream bo = null;
			bo = new BufferedOutputStream(new FileOutputStream(myCaptureFile));
			bm.compress(Bitmap.CompressFormat.PNG, 100, bo);

			bo.flush();
			bo.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	OnClickListener imgClick = new OnClickListener() {
		private String picValue;

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			imgView.setDrawingCacheEnabled(true);
			Bitmap bitmap = Bitmap.createBitmap(imgView.getDrawingCache());

			int w = imgScreenshot.getWidth();
			int h = imgScreenshot.getHeight();

			int left = imgScreenshot.getLeft();
			int right = imgScreenshot.getRight();
			int top = imgScreenshot.getTop();
			int bottom = imgScreenshot.getBottom();

			Bitmap targetBitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);

			Canvas canvas = new Canvas(targetBitmap);
			Path path = new Path();

			path.addCircle((float) ((right - left) / 2), ((float) ((bottom - top)) / 2), (float) (w / 2), Path.Direction.CCW);

			canvas.clipPath(path);

			canvas.drawBitmap(bitmap, new Rect(left, top, right, bottom), new Rect(0, 0, right - left, bottom - top), null);

			String imgPath = IMG_PATH;

			// TODO 上传图像
			ChangeHeadImageActivity.saveFile(targetBitmap, imgPath);

			ByteArrayOutputStream arrayOutputStream = null;
			try {
				arrayOutputStream = new ByteArrayOutputStream();
				targetBitmap.compress(Bitmap.CompressFormat.JPEG, 100, arrayOutputStream);
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
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

			final Map<String, String> map = new HashMap<String, String>();
			map.put("picName", imgPath);
			map.put("picValue", picValue);
			map.put("token", Constants.getToken());

			BackgroundTask<String> backgroundTask = new BackgroundTask<String>() {
				@Override
				protected String doWork() throws Exception {
					return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.savePic, map).toString();
				}

				protected void onCompletion(String result, Throwable exception, boolean cancelled) {
					if (!TextUtils.isEmpty(result)) {
						UserPicInfo picInfo = JSON.parseObject(result, UserPicInfo.class);
						if (picInfo.getCode() == 0) {
							if (picInfo.getData() != null) {
								String imageUrl = picInfo.getData().getImageUrl();
								SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.imageUrl, imageUrl);
								//Toast.makeText(getBaseContext(), "保存成功", Toast.LENGTH_LONG).show();
							} else {
								ToastUtil.show("没有保存成功！");
							}
							
						} else {
							picInfo.getMessage();
						}
					} else {
						ToastUtil.show("当前网络出现异常,请稍后再试");
					}
					finish();
				};
			};
			backgroundTask.run();

		}
	};

	/**
	 * 触摸事件
	 */
	OnTouchListener touch = new OnTouchListener() {
		@Override
		public boolean onTouch(View v, MotionEvent event) {
			ImageView view = (ImageView) v;
			switch (event.getAction() & MotionEvent.ACTION_MASK) {
			case MotionEvent.ACTION_DOWN:
				savedMatrix.set(matrix); // 把原始 Matrix对象保存起来
				start.set(event.getX(), event.getY()); // 设置x,y坐标
				mode = DRAG;
				break;
			case MotionEvent.ACTION_UP:
			case MotionEvent.ACTION_POINTER_UP:
				mode = NONE;
				break;
			case MotionEvent.ACTION_POINTER_DOWN:
				oldDist = spacing(event);
				if (oldDist > 10f) {
					savedMatrix.set(matrix);
					midPoint(mid, event); // 求出手指两点的中点
					mode = ZOOM;
				}
				break;
			case MotionEvent.ACTION_MOVE:
				if (mode == DRAG) {
					matrix.set(savedMatrix);

					matrix.postTranslate(event.getX() - start.x, event.getY() - start.y);
				} else if (mode == ZOOM) {
					float newDist = spacing(event);
					if (newDist > 10f) {
						matrix.set(savedMatrix);
						float scale = newDist / oldDist;
						matrix.postScale(scale, scale, mid.x, mid.y);
					}
				}
				break;
			}
			System.out.println(event.getAction());
			view.setImageMatrix(matrix);
			return true;
		}
	};

	// 求两点距离
	private float spacing(MotionEvent event) {
		float x = event.getX(0) - event.getX(1);
		float y = event.getY(0) - event.getY(1);
		return FloatMath.sqrt(x * x + y * y);
	}

	// 求两点间中点
	private void midPoint(PointF point, MotionEvent event) {
		float x = event.getX(0) + event.getX(1);
		float y = event.getY(0) + event.getY(1);
		point.set(x / 2, y / 2);
	}

}
