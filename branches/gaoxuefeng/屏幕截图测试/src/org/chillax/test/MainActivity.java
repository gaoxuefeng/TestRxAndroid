package org.chillax.test;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.chillax.screenshot.ScreenshotImg;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ContentResolver;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity {
	
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
	private final static String IMG_PATH = Environment
			.getExternalStorageDirectory() + "/chillax/imgs/";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		btnImg = (Button)findViewById(R.id.btn_find_img);
		btnImg.setOnClickListener(BtnClick);
	}
	
	OnClickListener BtnClick = new OnClickListener() {
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			setImage();
		}
	};
	
	/**
	 * 选择图片
	 */
	public void setImage() {
		final AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("选择图片");
		builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {}
		});
		builder.setPositiveButton("相机", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
				startActivityForResult(intent, IMAGE_CAPTURE);
			}
		});
		builder.setNeutralButton("相册", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
				intent.setType("image/*");
				startActivityForResult(intent, IMAGE_MEDIA);
			}
		});
		AlertDialog alert = builder.create();
		alert.show();
	}
	
	/**
	 * 根据用户选择,返回图片资源
	 */
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		
		ContentResolver resolver = this.getContentResolver();
		
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inSampleSize = 2;// 图片高宽度都为本来的二分之一，即图片大小为本来的大小的四分之一
		options.inTempStorage = new byte[5 * 1024];
		
		if (data != null){
			if (requestCode == IMAGE_MEDIA){
				try {
					if(data.getData() == null){
					}else{
						
						// 获得图片的uri
						Uri uri = data.getData();
	
						// 将字节数组转换为ImageView可调用的Bitmap对象
						Bitmap bitmap = BitmapFactory.decodeStream(
								resolver.openInputStream(uri), null,options);
						
						//图片路径
						String imgPath = IMG_PATH+"Test.png";
						
						//保存图片
						saveFile(bitmap, imgPath);
						
						Intent i = new Intent(MainActivity.this,ScreenshotImg.class);
						i.putExtra("ImgPath", imgPath);
						this.startActivity(i);
						
					}
				} catch (Exception e) {
					System.out.println(e.getMessage());
				}

			}else if(requestCode == IMAGE_CAPTURE) {// 相机
				if (data != null) {
					if(data.getExtras() == null){
					}else{
						
						// 相机返回的图片数据
						Bitmap bitmap = (Bitmap) data.getExtras().get("data");
						
						//图片路径
						String imgPath = IMG_PATH+"Test.png";
						
						//保存图片
						saveFile(bitmap, imgPath);
						
						Intent i = new Intent(MainActivity.this,ScreenshotImg.class);
						i.putExtra("ImgPath", imgPath);
						this.startActivity(i);
					}
				}
			}
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

}
