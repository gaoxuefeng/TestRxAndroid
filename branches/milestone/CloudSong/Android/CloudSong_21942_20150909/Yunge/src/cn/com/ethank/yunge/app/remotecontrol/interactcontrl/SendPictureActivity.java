package cn.com.ethank.yunge.app.remotecontrol.interactcontrl;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Path;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Base64;
import android.util.FloatMath;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.room.bean.RoomStateInfo;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.HttpUtils;
import cn.com.ethank.yunge.app.util.SDCardPathUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.UUIDGenerator;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.core.threading.BackgroundTask;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;
import com.nostra13.universalimageloader.utils.MemoryCacheUtils;

public class SendPictureActivity extends BaseTitleActivity implements OnClickListener {
	private ImageView iv_send_picture;
	private Matrix matrix = new Matrix();
	private Matrix savedMatrix = new Matrix();
	private PointF start = new PointF();
	private PointF mid = new PointF();
	private static final int NONE = 0;
	private static final int DRAG = 1;
	private static final int ZOOM = 2;
	private int mode = NONE;
	protected float oldDist = 0;
	private float minScaleR = 0;
	private float maxScale = 0;
	private float scale = 0;
	private Bitmap bitmapSrc;
	private ImageView iv_choose;
	private String imagePath = "";
	private final int IMAGE_CAPTURE = 500;
	private String ktvIP = "";
	private String reserveBoxId = "";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		super.setContentView(R.layout.activity_send_pictures);

		initTitle();
		initView();
		initData();

	}

	private void initData() {
		Bundle bundle = getIntent().getExtras();
		if (bundle.containsKey("imagePath")) {
			imagePath = bundle.getString("imagePath");
		}
		ktvIP = getIntent().getStringExtra("ktvIP");
		reserveBoxId = getIntent().getStringExtra("reserveBoxId");
		setBitmap(imagePath);
	}

	private void initTitle() {
		title.setTitle("");
		title.showBtnFunction();
		title.setBtnFunctionImage(0);
		title.setBtnFunctionText("使用照片");
		title.setBtnBackImage(0);
		title.setBtnBackText("重拍");

	}

	private void setBitmap(String imagePath) {
		if (TextUtils.isEmpty(imagePath)) {
			ToastUtil.show("图片选择错误,请重新选择");
			finish();
			return;
		}
		MemoryCacheUtils.removeFromCache(imagePath, ImageLoader.getInstance().getMemoryCache());
		ImageLoader.getInstance().displayImage(imagePath, iv_send_picture, new ImageLoadingListener() {

			@Override
			public void onLoadingStarted(String imageUri, View view) {

			}

			@Override
			public void onLoadingFailed(String imageUri, View view, FailReason failReason) {
				ToastUtil.show("图片选择错误,请重新选择");
				finish();
			}

			@Override
			public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {
				if (view instanceof ImageView) {
					if (loadedImage != null) {
						ImageView imageView = (ImageView) view;
						bitmapSrc = loadedImage;
						imageView.setImageBitmap(loadedImage);
						initImageBitmap();
						imageView.setOnTouchListener(imageViewTouch);
					} else {
						ToastUtil.show("图片选择错误,请重新选择");
						finish();
					}

				}

			}

			@Override
			public void onLoadingCancelled(String imageUri, View view) {
				ToastUtil.show("图片选择错误,请重新选择");
				finish();
			}
		});

	}

	private void initView() {
		iv_send_picture = (ImageView) findViewById(R.id.iv_send_picture);
		iv_choose = (ImageView) findViewById(R.id.iv_choose);
		setLayoutHeight(iv_choose, UICommonUtil.getScreenWidthPixels(context));
	}

	private void setLayoutHeight(View view, int height) {
		LayoutParams layoutParams = view.getLayoutParams();
		layoutParams.height = height;
		view.setLayoutParams(layoutParams);
	}

	protected void initImageBitmap() {
		Matrix m = new Matrix();
		int dWidth = bitmapSrc.getWidth();
		scale = UICommonUtil.getScreenWidthPixels(this) * 1.0f / dWidth;
		m.setScale(scale, scale);
		minScaleR = scale;
		maxScale = 3 * scale;
		iv_send_picture.setImageMatrix(m);
		matrix.set(m);

	}

	OnTouchListener imageViewTouch = new OnTouchListener() {

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
			case MotionEvent.ACTION_CANCEL:
				CheckView();
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
						scale = newDist / oldDist;
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
	@SuppressLint("FloatMath")
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
	 */
	private void CheckView() {
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
		center(true, true);
	}

	/**
	 * 横向、纵向居中
	 */
	protected void center(boolean horizontal, boolean vertical) {
		int screenWidth = UICommonUtil.getScreenWidthPixels(this);
		float imageViewTop = (iv_send_picture.getHeight() - screenWidth) * 1f / 2;// bitmap可显示的最高边缘
		float imageViewBottom = (iv_send_picture.getHeight() - (iv_send_picture.getHeight() - screenWidth) * 1f / 2);// bitmap可显示的最低边缘
		Matrix m = new Matrix();
		m.set(matrix);
		RectF rect = new RectF(0, 0, bitmapSrc.getWidth(), bitmapSrc.getHeight());
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
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.btn_back:
			// 重拍
			reTakePhoto();
			break;
		case R.id.title_function:
			// 发送图片
			savePicture();
			break;

		default:
			super.onClick(view);
			break;
		}

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
				return HttpUtils.getJsonByPost(Constants.getKTVIP() + Constants.ADDINFO, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					RoomStateInfo picInfo = JSON.parseObject(result, RoomStateInfo.class);
					if (picInfo.getCode() == 0) {
						ToastUtil.show("发送成功");

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

	/**
	 * 重拍
	 */
	private void reTakePhoto() {
		String pictureRootFile = SDCardPathUtil.getImagePath();
		File picFile = new File(pictureRootFile, "temppic.jpg");
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(picFile));
		intent.putExtra(MediaStore.Images.Media.ORIENTATION, 0);
		startActivityForResult(intent, IMAGE_CAPTURE);
	}

	private void savePicture() {
		iv_send_picture.setDrawingCacheEnabled(true);
		Bitmap bitmap = Bitmap.createBitmap(iv_send_picture.getDrawingCache());

		int w = iv_choose.getWidth();
		int h = iv_choose.getHeight();

		int left = iv_choose.getLeft();
		int right = iv_choose.getRight();
		int top = iv_choose.getTop();
		int bottom = iv_choose.getBottom();
		Bitmap targetBitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
		try {
			Canvas canvas = new Canvas(targetBitmap);
			Path path = new Path();
			// path.addCircle((float) ((right - left) / 2), ((float) ((bottom -
			// top)) / 2), (float) (w / 2), Path.Direction.CCW);
			path.addRect(left, 0, right - left, bottom - top, Path.Direction.CCW);// 生成矩形图片
			canvas.clipPath(path);

			canvas.drawBitmap(bitmap, new Rect(left, top, right, bottom), new Rect(0, 0, right - left, bottom - top), null);
			String savepicName = UUIDGenerator.getUUID() + ".jpg";
			File imgPath = new File(SDCardPathUtil.getImagePath(), savepicName);
			iv_choose.setImageBitmap(targetBitmap);
			saveFile(targetBitmap, imgPath.getPath());
			recyleBitmap(bitmap);
			releaseImageViewResouce(iv_send_picture);
			String picValue = null;
			uploadImage(picValue, targetBitmap, imgPath.getPath());
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 保存图片到app指定路径
	 * 
	 * @param bm头像图片资源
	 * @param fileName保存名称
	 */
	public void saveFile(Bitmap bm, String filePath) {
		try {

			File myCaptureFile = new File(filePath);
			BufferedOutputStream bo = null;
			bo = new BufferedOutputStream(new FileOutputStream(myCaptureFile));
			bm.compress(Bitmap.CompressFormat.JPEG, 100, bo);

			bo.flush();
			bo.close();
			ToastUtil.show("保存图片在" + filePath);
			// finish();

			// recyleBitmap(bm);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void recyleBitmap(Bitmap bm) {
		try {
			if (bm != null && !bm.isRecycled()) {
				bm.recycle();
				bm = null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {

		super.onActivityResult(requestCode, resultCode, data);
		switch (requestCode) {
		case IMAGE_CAPTURE:
			if (resultCode == -1) {

				ToastUtil.show("拍照成功");
				String pictureRootFile = SDCardPathUtil.getImagePath();
				File picFile = new File(pictureRootFile, "temppic.jpg");
				setBitmap(picFile.getAbsolutePath());
			}

			break;

		default:
			break;
		}
	}

	public static void releaseImageViewResouce(ImageView imageView) {
		if (imageView == null)
			return;
		Drawable drawable = imageView.getDrawable();
		if (drawable != null && drawable instanceof BitmapDrawable) {
			BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
			Bitmap bitmap = bitmapDrawable.getBitmap();
			if (bitmap != null && !bitmap.isRecycled()) {
				bitmap.recycle();
			}
		}
		drawable = imageView.getBackground();
		if (drawable != null && drawable instanceof BitmapDrawable) {
			BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
			Bitmap bitmap = bitmapDrawable.getBitmap();
			if (bitmap != null && !bitmap.isRecycled()) {
				bitmap.recycle();
			}
		}
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}
}
