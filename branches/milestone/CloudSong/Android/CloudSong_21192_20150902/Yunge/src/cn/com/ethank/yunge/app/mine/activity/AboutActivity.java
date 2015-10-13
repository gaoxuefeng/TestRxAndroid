package cn.com.ethank.yunge.app.mine.activity;

import java.util.Hashtable;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.PopupWindowUtils;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

public class AboutActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.about_tv_exit)
	private TextView about_tv_exit; // --退后到设置--

	@ViewInject(R.id.set_rl_service)
	private RelativeLayout set_rl_service;

	@ViewInject(R.id.about_tv_phone)
	private TextView about_tv_phone;

	@ViewInject(R.id.about_ll_parent)
	private LinearLayout about_ll_parent;

	@ViewInject(R.id.about_tv_code)
	private TextView about_tv_code;

	@ViewInject(R.id.about_tv_info)
	private TextView about_tv_info;
	
	@ViewInject(R.id.about_img_code)
	private ImageView about_img_code;
	
	private RelativeLayout pop_utils;

	@ViewInject(R.id.about_tv_copy)
	private TextView about_tv_copy;

	private PopupWindow window;

	private ImageView qr_image;

	private ImageView pop_share_bg;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		initView();

	}

	private void initView() {
		setContentView(R.layout.activity_about);
		BaseApplication.getInstance().cacheActivityList.add(this);

		ViewUtils.inject(this);
		about_tv_exit.setOnClickListener(this);

		set_rl_service.setOnClickListener(this);
		about_tv_phone.setOnClickListener(this);
		about_tv_info.setOnClickListener(this);
		//about_img_code.setOnClickListener(this);
		
		try {
			about_tv_code.setText("当前版本号："+getVersionName() +"(Build 129743)");
		} catch (Exception e) {
			e.printStackTrace();
		}

		pop_utils = (RelativeLayout) View.inflate(getApplicationContext(), R.layout.pop_share_code, null);
		pop_share_bg = (ImageView) pop_utils.findViewById(R.id.pop_share_bg);
		//--二维码
		qr_image = (ImageView) pop_utils.findViewById(R.id.qr_image);
		

	}

	// 生成QR图
    private void createImage() {
        try {
            // 需要引入core包
            QRCodeWriter writer = new QRCodeWriter();

            int QR_WIDTH = 100;
            int QR_HEIGHT = 100;
            String text = "http://a.app.qq.com/o/simple.jsp?pkgname=cn.com.ethank.yunge";
            if (text == null || "".equals(text) || text.length() < 1) {
                return;
            }

            // 把输入的文本转为二维码
            BitMatrix martix = writer.encode(text, BarcodeFormat.QR_CODE,
                    QR_WIDTH, QR_HEIGHT);

            System.out.println("w:" + martix.getWidth() + "h:"
                    + martix.getHeight());

            Hashtable<EncodeHintType, String> hints = new Hashtable<EncodeHintType, String>();
            hints.put(EncodeHintType.CHARACTER_SET, "utf-8");
            BitMatrix bitMatrix = new QRCodeWriter().encode(text,
                    BarcodeFormat.QR_CODE, QR_WIDTH, QR_HEIGHT, hints);
            int[] pixels = new int[QR_WIDTH * QR_HEIGHT];
            for (int y = 0; y < QR_HEIGHT; y++) {
                for (int x = 0; x < QR_WIDTH; x++) {
                    if (bitMatrix.get(x, y)) {
                        pixels[y * QR_WIDTH + x] = 0xff000000;
                    } else {
                        pixels[y * QR_WIDTH + x] = 0xffffffff;
                    }

                }
            }

            Bitmap bitmap = Bitmap.createBitmap(QR_WIDTH, QR_HEIGHT,
                    Bitmap.Config.ARGB_8888);

            bitmap.setPixels(pixels, 0, QR_WIDTH, 0, 0, QR_WIDTH, QR_HEIGHT);
            
            qr_image.setImageBitmap(bitmap);

        } catch (WriterException e) {
            e.printStackTrace();
        }
    }

	
	public String getVersionName() throws Exception {
		// 获取packagemanager的实例
		PackageManager packageManager = getPackageManager();
		// getPackageName()是你当前类的包名，0代表是获取版本信息
		PackageInfo packInfo = packageManager.getPackageInfo(getPackageName(), 0);
		String version = packInfo.versionName;
		return version;
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.about_img_code:
			/*PopupWindowUtils.show(getApplicationContext(), pop_utils, about_ll_parent,true);
			createImage();
			pop_utils.findViewById(R.id.pop_share_bg).setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					PopupWindowUtils.dismiss();
				}
			});*/
			break;
		case R.id.about_tv_info:
			Intent service = new Intent(getApplicationContext(), ServiceActivity.class);
			startActivity(service);
			break;
		/*case R.id.pop_but_left:
			PopupWindowUtils.dismiss();
			break;
		case R.id.pop_but_right:
			Intent intent2 = new Intent(Intent.ACTION_CALL, Uri.parse("tel:010-84775234"));
			startActivity(intent2);
			break;*/
		case R.id.about_tv_exit:
			finish();
			break;
		case R.id.set_rl_service:
			Intent intent = new Intent(getApplicationContext(), ServiceActivity.class);
			startActivity(intent);
			break;
		case R.id.about_tv_phone:
			break;
		}
	}
	


	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
