package com.example.ducksdemo;

import java.io.File;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;

import com.example.ducksdemo.takepic.DrawHraffitiActivity;
import com.lidroid.xutils.BitmapUtils;

public class MainActivity extends Activity implements OnClickListener {

	private Button bt_photo_album;
	private Button bt_take_photo;
	private Button bt_wihthout_pic;
	private ImageView iv_save_photo;
	private BitmapUtils bitmapUtils;
	private final static int IMAGE_MEDIA = 501;
	private final static int IMAGE_CAPTURE = 500;
	private final static int DUCK_FINISH = 502;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		bitmapUtils = BitmapHelp.getBitmapUtils(this);
		bt_photo_album = (Button) findViewById(R.id.bt_photo_album);
		bt_take_photo = (Button) findViewById(R.id.bt_take_photo);
		bt_wihthout_pic = (Button) findViewById(R.id.bt_wihthout_pic);
		iv_save_photo = (ImageView) findViewById(R.id.iv_save_photo);

		bt_photo_album.setOnClickListener(this);
		bt_take_photo.setOnClickListener(this);
		bt_wihthout_pic.setOnClickListener(this);

	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.bt_take_photo:
			takePhoto();
			break;
		case R.id.bt_photo_album:
			selectPhoto();
			break;
		case R.id.bt_wihthout_pic:
			withoutPhoto();
			break;

		default:
			break;
		}
	}

	private void withoutPhoto() {
		Intent intent = new Intent(this, DrawHraffitiActivity.class);
		startActivityForResult(intent, DUCK_FINISH);

	}

	private void selectPhoto() {
		Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
		intent.setType("image/*");
		startActivityForResult(intent, IMAGE_MEDIA);
	}

	private void takePhoto() {
		String pictureRootFile = SDCardPathUtil.getImagePath();
		File picFile = new File(pictureRootFile, "temppic.jpg");
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(picFile));
		intent.putExtra(MediaStore.Images.Media.ORIENTATION, 0);
		startActivityForResult(intent, 500);

	}

	@SuppressLint("NewApi")
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		switch (requestCode) {
		case IMAGE_CAPTURE:
			if (resultCode == -1) {
				String pictureRootFile = SDCardPathUtil.getImagePath();
				File picFile = new File(pictureRootFile, "temppic.jpg");
				Intent intent = new Intent(this, DrawHraffitiActivity.class);
				intent.putExtra("imagePath", picFile.getPath());
				startActivityForResult(intent, DUCK_FINISH);

			}
			break;
		case IMAGE_MEDIA:
			if (resultCode == -1 && data != null && data.getData() != null) {

				// 获得图片的uri
				Uri uri = data.getData();
				if (uri != null) {

					String imagePath = SDCardPathUtil.getImageAbsolutePath(this, uri);
					if (imagePath == null || imagePath.isEmpty()) {
						return;
					}
					Intent intent = new Intent(this, DrawHraffitiActivity.class);
					intent.putExtra("imagePath", imagePath);
					startActivityForResult(intent, DUCK_FINISH);

				}

			}
			break;
		case DUCK_FINISH:
			// 涂鸦完成,显示图片
			if (resultCode == -1) {
				if (data != null && data.getExtras().containsKey("imagePath")) {
					String imagePath = data.getExtras().getString("imagePath");
					bitmapUtils.display(iv_save_photo, imagePath);
				}
			}
			break;
		default:
			super.onActivityResult(requestCode, resultCode, data);
			break;
		}
	}
}
