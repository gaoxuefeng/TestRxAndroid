package cn.com.ethank.yunge.app.mine.activity;

import android.annotation.SuppressLint;
import android.app.ActionBar.LayoutParams;
import android.content.ContentResolver;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Path;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.FloatMath;
import android.view.Gravity;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.lidroid.xutils.BitmapUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.ImageTools;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.mine.bean.UserPicInfo;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

/**
 * 更换头像
 */
public class ChangeHeadImageActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.head_ll_left)
	private LinearLayout head_ll_left; // --返回个人主页--

	@ViewInject(R.id.head_but_img)
	private Button head_but_img; // --更换头像--

	private ImageView change_img; // --头像--

	@ViewInject(R.id.img_rl_parent)
	private RelativeLayout img_rl_parent;

	@ViewInject(R.id.fl)
	private RelativeLayout fl;

	@ViewInject(R.id.big_img)
	private ImageView big_img;

	@ViewInject(R.id.rl_head_all)
	private RelativeLayout rl_head_all;
	private ImageView imgView, imgScreenshot;

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

	private float scale = 0;

	private PopupWindow window;

	private float minScaleR = 0;
	private float maxScale = 0;

	private String imageUrl = "";

	private BitmapUtils bitmapUtils;
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

    public Handler handler;
	@SuppressLint("NewApi")
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

		change_img = (ImageView) findViewById(R.id.change_img);

		String token = Constants.getToken();
		String result = SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result);
		if (TextUtils.isEmpty(token) || result == null) {
			return ;
		}
		userInfo = JSON.parseObject(result, UserInfo.class);
		gender = userInfo.getData().getUserInfo().getGender();



		bitmapUtils = new BitmapUtils(getApplicationContext());

		if(!TextUtils.isEmpty(Constants.getImageUrl())){
			bitmapUtils.display(change_img, Constants.getImageUrl());
			imageUrl = Constants.getImageUrl();
		}else if(!TextUtils.isEmpty(userInfo.getData().getUserInfo().getHeadUrl())){
			bitmapUtils.display(change_img, userInfo.getData().getUserInfo().getHeadUrl());
            imageUrl = userInfo.getData().getUserInfo().getHeadUrl();
			
		}else{
			if(gender != null && "女".equals(userInfo.getData().getUserInfo().getGender())){
				change_img.setBackground(getResources().getDrawable(R.drawable.mine_default_avatar_female));
			}else{
				change_img.setBackground(getResources().getDrawable(R.drawable.mine_default_avatar_man));
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

		change_img.setOnClickListener(this);
		big_img.setOnClickListener(this);
		
		img_rl_parent.setOnClickListener(this);

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

	@SuppressLint("NewApi")
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.big_img:
			big_img.setVisibility(View.GONE);
			head_ll_left.setVisibility(View.VISIBLE);
			head_but_img.setVisibility(View.VISIBLE);
			break;
		case R.id.img_rl_parent:
			head_ll_left.setVisibility(View.VISIBLE);
			head_but_img.setVisibility(View.VISIBLE);
			big_img.setVisibility(View.GONE);

			break;
		case R.id.head_ll_left:
			finish();
			break;
		case R.id.change_img:

			//img_rl_parent.setBackgroundColor(getResources().getColor(R.color.BLACK));
			img_rl_parent.setBackground(getResources().getDrawable(R.drawable.homepager_bg));
			head_but_img.setVisibility(View.GONE);
		    big_img.setVisibility(View.VISIBLE);

			head_ll_left.setVisibility(View.GONE);

			big_img.setScaleType(ScaleType.CENTER_CROP);
			if(!TextUtils.isEmpty(imageUrl)){
				bitmapUtils.display(big_img, imageUrl);
			}else{
				if(gender != null && "女".equals(userInfo.getData().getUserInfo().getGender())){
					big_img.setBackground(getResources().getDrawable(R.drawable.mine_default_avatar_female));
				}else{
					big_img.setBackground(getResources().getDrawable(R.drawable.mine_default_avatar_man));
				}
			}

			DisplayMetrics displayMetrics = new DisplayMetrics();
			getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
			int width = displayMetrics.widthPixels;

			android.view.ViewGroup.LayoutParams lp = big_img.getLayoutParams();
			lp.height = width;
			big_img.setLayoutParams(lp);

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
						Bitmap smallBitmap = ImageTools.zoomBitmap(photo, photo.getWidth(), photo.getHeight());
						// Bitmap smallBitmap = ImageTools.zoomBitmap(photo,
						// photo.getWidth() , photo.getHeight() );
						// 释放原始图片占用的内存，防止out of memory异常发生
						// photo.recycle();

						fl.setVisibility(View.VISIBLE);
						change_img.setVisibility(View.GONE);
						imgView.setImageBitmap(smallBitmap);

						initImageBitmap(smallBitmap);

						CheckView(smallBitmap);

						imgView.setOnTouchListener(touch);
						head_but_img.setOnClickListener(imgClick);
						head_but_img.setText("确认更换");
						
						// 释放原始图片占用的内存，防止out of memory异常发生
						//photo.recycle();
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
				// Bitmap newBitmap = ImageTools.zoomBitmap(bitmap,
				// bitmap.getWidth(), bitmap.getHeight());
				// 由于Bitmap内存占用较大，这里需要回收内存，否则会报out of memory异常
				// bitmap.recycle();

				// 将处理过的图片显示在界面上，并保存到本地

				fl.setVisibility(View.VISIBLE);
				change_img.setVisibility(View.GONE);
				imgView.setImageBitmap(newBitmap);

				initImageBitmap(newBitmap);

				CheckView(newBitmap);

				imgView.setOnTouchListener(touch);
				head_but_img.setOnClickListener(imgClick);
				head_but_img.setText("确认更换");
				
				bitmap.recycle();
				/*
				 * ImageTools.savePhotoToSDCard(newBitmap,
				 * Environment.getExternalStorageDirectory().getAbsolutePath(),
				 * String.valueOf(System.currentTimeMillis()));
				 */

			}
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

			// path.addCircle((float) ((right - left) / 2), ((float) ((bottom -
			// top)) / 2), (float) (w / 2), Path.Direction.CCW);
			path.addRect(0, 0, right - left, bottom - top, Path.Direction.CCW);// 生成矩形图片
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

			ProgressDialogUtils.show(ChangeHeadImageActivity.this);

			BackgroundTask<String> backgroundTask = new BackgroundTask<String>() {
				@Override
				protected String doWork() throws Exception {
					return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.savePic, map).toString();
				}

				protected void onCompletion(String result, Throwable exception, boolean cancelled) {
					if (!TextUtils.isEmpty(result)) {
						UserPicInfo picInfo = JSON.parseObject(result, UserPicInfo.class);
						if (null != picInfo) {
							if (picInfo.getCode() == 0) {
								if (picInfo.getData() != null) {
									String imageUrl = picInfo.getData().getImageUrl();
									SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.imageUrl, imageUrl);
									// Toast.makeText(getBaseContext(), "保存成功",
									// Toast.LENGTH_LONG).show();
								} else {
									ToastUtil.show("没有保存成功！");
								}

							} else {
								picInfo.getMessage();
							}
						} else {
							ToastUtil.show(R.string.connectfailtoast);
						}
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

	private String gender;

	private UserInfo userInfo;

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

	/**
	 * 限制最大最小缩放比例，自动居中
	 * 
	 * @param smallBitmap
	 */
	private void CheckView(Bitmap smallBitmap) {
		float p[] = new float[9];
		matrix.getValues(p);
		if (mode == ZOOM) {
			if (p[0] < minScaleR) {
				// Log.d("", "当前缩放级别:"+p[0]+",最小缩放级别:"+minScaleR);
				matrix.setScale(minScaleR, minScaleR);
			}
			if (p[0] > maxScale) {
				// Log.d("", "当前缩放级别:"+p[0]+",最大缩放级别:"+MAX_SCALE);
				matrix.set(savedMatrix);
			}
		}
		center(true, true, smallBitmap);
	}

	protected void initImageBitmap(Bitmap smallBitmap) {
		Matrix m = new Matrix();
		int dWidth = smallBitmap.getWidth();
		scale = UICommonUtil.getScreenWidthPixels(this) * 1.0f / dWidth;
		m.setScale(scale, scale);
		minScaleR = scale;
		maxScale = 3 * scale;
		imgView.setImageMatrix(m);
		matrix.set(m);

	}

	/**
	 * 横向、纵向居中
	 * 
	 * @param smallBitmap
	 */
	protected void center(boolean horizontal, boolean vertical, Bitmap smallBitmap) {
		int screenWidth = UICommonUtil.getScreenWidthPixels(this);
		float imageViewTop = (imgView.getHeight() - screenWidth) * 1f / 2;// bitmap可显示的最高边缘
		float imageViewBottom = (imgView.getHeight() - (imgView.getHeight() - screenWidth) * 1f / 2);// bitmap可显示的最低边缘
		Matrix m = new Matrix();
		m.set(matrix);
		RectF rect = new RectF(0, 0, smallBitmap.getWidth(), smallBitmap.getHeight());
		m.mapRect(rect);

		@SuppressWarnings("unused")
		float height = rect.height();
		float width = rect.width();

		float deltaX = 0, deltaY = 0;

		if (vertical) {
			// 图片小于屏幕大小，则居中显示。大于屏幕，上方留空则往上移，下方留空则往下移

			// if (height < imageViewHeight) {
			// deltaY = (screenHeight - height) / 2 - rect.top;
			// } else
			if (rect.top > imageViewTop) {
				deltaY = -(rect.top - imageViewTop);
			} else if (rect.bottom < imageViewBottom) {
				deltaY = (imageViewBottom - rect.bottom);
			}
		}

		if (horizontal) {

			if (width < screenWidth) {
				deltaX = (screenWidth - width) / 2 - rect.left;
			} else if (rect.left > 0) {
				deltaX = -rect.left;
			} else if (rect.right < screenWidth) {
				deltaX = screenWidth - rect.right;
			}
		}
		matrix.postTranslate(deltaX, deltaY);
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}

}
