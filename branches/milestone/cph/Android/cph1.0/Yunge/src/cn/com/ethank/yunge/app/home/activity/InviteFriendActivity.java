package cn.com.ethank.yunge.app.home.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.SnsPostListener;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.sso.SinaSsoHandler;

/** 邀请好友 */
public class InviteFriendActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.head_tv_left)
	private TextView head_tv_left; // --返回按钮--

	@ViewInject(R.id.head_tv_title)
	private TextView head_tv_title; // --标题--

	@ViewInject(R.id.head_tv_right)
	private TextView head_tv_right; // --

	@ViewInject(R.id.opinion_et)
	private EditText opinion_et;

	final UMSocialService mController = UMServiceFactory.getUMSocialService("com.umeng.share");

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_invite_friend);
		BaseApplication.getInstance().cacheActivityList.add(this);

		initView();
	}

	private void initView() {
		ViewUtils.inject(this);
		head_tv_left.setOnClickListener(this);
		head_tv_title.setText("邀请好友");
		head_tv_right.setText("邀请");
		head_tv_right.setOnClickListener(this);

		String content = opinion_et.getText().toString();
		// 分享到新浪
		com.umeng.socialize.utils.Log.LOG = true;
		// 设置分享内容
		mController.setShareContent(content + "我在潮趴汇上预定了一个ktv");
		// 设置分享图片, 参数2为图片的url地址
		mController.setShareImage(new UMImage(getApplicationContext(), R.drawable.mine_default_avatar_female));

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.head_tv_right:
			shareSina();
			break;
		}
	}

	private void shareSina() {
		// 点击分享
		// mController.openShare(this, false);
		// 参数1为Context类型对象， 参数2为要分享到的目标平台， 参数3为分享操作的回调接口
		mController.postShare(this, SHARE_MEDIA.SINA, new SnsPostListener() {
			@Override
			public void onStart() {
				// ToastUtil.show("开始分享.");
			}

			@Override
			public void onComplete(SHARE_MEDIA platform, int eCode, SocializeEntity entity) {
				if (eCode == 200) {
					//ToastUtil.show("分享成功.");
					// Intent intent = new Intent(getApplicationContext(), );
				} else {
					String eMsg = "";
					if (eCode == -101) {
						eMsg = "没有授权";
					}
					//ToastUtil.show("分享失败[" + eCode + "] " + eMsg);
				}
			}
		});

		// 设置新浪SSO handler
		mController.getConfig().setSsoHandler(new SinaSsoHandler());

	}

}
