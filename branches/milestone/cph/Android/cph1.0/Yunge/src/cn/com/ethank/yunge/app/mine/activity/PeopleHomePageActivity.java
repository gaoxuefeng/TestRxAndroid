package cn.com.ethank.yunge.app.mine.activity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.mine.bean.PeopleInfo;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
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
import com.lidroid.xutils.view.annotation.ViewInject;
import com.umeng.analytics.MobclickAgent;

public class PeopleHomePageActivity extends BaseActivity implements OnClickListener {
	@ViewInject(R.id.people_tv_edit)
	private TextView people_tv_edit; // --跳转到编辑页面--
	@ViewInject(R.id.login_tv_exit)
	private TextView login_tv_exit; // --跳转到我的页面--
	private GridView people_gv; // --喜欢的歌曲--

	public List<PeopleInfo> list;

	@ViewInject(R.id.user_tv_gender)
	private TextView user_tv_gender; // --用户的性别--
	@ViewInject(R.id.people_tv_age)
	private TextView people_tv_age; // --用户的年龄--
	@ViewInject(R.id.people_tv_uname)
	private TextView people_tv_uname; // --昵称--

	@ViewInject(R.id.people_tv_star)
	private TextView people_tv_star; // --星座--

	@ViewInject(R.id.people_tv_blood)
	private TextView people_tv_blood; // --血型--

	@ViewInject(R.id.people_tv_loveSingers)
	private TextView people_tv_loveSingers; // --喜欢的歌手--

	@ViewInject(R.id.people_tv_loveSongs)
	private TextView people_tv_loveSongs; // --喜欢的歌曲--

	@ViewInject(R.id.people_tv_whatIsUp)
	private TextView people_tv_whatIsUp; // --签名--

	@ViewInject(R.id.people_iv_head)
	private ImageView people_iv_head; // --头部图像--

	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_people_homepage);
		BaseApplication.getInstance().cacheActivityList.add(this);
		ViewUtils.inject(this);

		people_tv_edit.setOnClickListener(this);
		login_tv_exit.setOnClickListener(this);
		people_iv_head.setOnClickListener(this);

		//initData();
		//initView();

	}

	@Override
	protected void onStart() {
		super.onStart();
		
		if(Constants.getToken() != null && Constants.getImageUrl() != null){
			BitmapUtils bitmap = new BitmapUtils(getApplicationContext());
			bitmap.display(people_iv_head, Constants.getImageUrl());
		}
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		initData();
		initView();
	}

	private void initData() {
		final Map<String, String> map = new HashMap<String, String>();
		map.put(SharePreferenceKeyUtil.token, Constants.getToken());
		new BackgroundTask<String>() {
			@Override
			protected String doWork() throws Exception {
				return HttpUtils.getJsonByPost(Constants.hostUrlCloud + Constants.QUERYINFO, map).toString();
			}

			protected void onCompletion(String result, Throwable exception, boolean cancelled) {
				if (!TextUtils.isEmpty(result)) {
					UserInfo info = JSON.parseObject(result, UserInfo.class);
					if (info.getCode() == 0) {
						SharePreferencesUtil.saveStringData("login_result", result);

					}
				} else {
					ToastUtil.show("联网失败");
				}
			};

		}.run();
	}

	private void initView() {
		new Runnable() {
			@Override
			public void run() {
				UserInfo info = JSON.parseObject(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result), UserInfo.class);
				String gender = info.getData().getUserInfo().getGender();
				if (!TextUtils.isEmpty(gender))
					user_tv_gender.setText(gender);

				String uname = info.getData().getUserInfo().getNickName();
				if (!TextUtils.isEmpty(uname))
					people_tv_uname.setText(uname);

				
				if (!TextUtils.isEmpty(info.getData().getUserInfo().getHeadUrl())) {
					BitmapUtils bitmap = new BitmapUtils(getApplicationContext());
					bitmap.display(people_iv_head, info.getData().getUserInfo().getHeadUrl());
					
					if(gender != null && gender.equals("女")){
						Drawable drawable = getResources().getDrawable(R.drawable.mine_female);
						// 这一步必须要做,否则不会显示.
						drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
						people_tv_uname.setCompoundDrawables(null, null, drawable, null);
					}else{
						Drawable drawable = getResources().getDrawable(R.drawable.mine_man);
						// 这一步必须要做,否则不会显示.
						drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
						people_tv_uname.setCompoundDrawables(null, null, drawable, null);
					}
					
				} else {
					if (gender != null && gender.equals("女")) {
						Drawable drawable = getResources().getDrawable(R.drawable.mine_female);
						// 这一步必须要做,否则不会显示.
						drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
						people_tv_uname.setCompoundDrawables(null, null, drawable, null);

						people_iv_head.setBackgroundResource(R.drawable.mine_default_avatar_female);
					} else {
						Drawable drawable = getResources().getDrawable(R.drawable.mine_man);
						// 这一步必须要做,否则不会显示.
						drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
						people_tv_uname.setCompoundDrawables(null, null, drawable, null);
						people_iv_head.setBackgroundResource(R.drawable.mine_defaultavatar);
					}

				}

				String age = info.getData().getUserInfo().getAge();
				if (!TextUtils.isEmpty(age))
					people_tv_age.setText(age);

				String star = info.getData().getUserInfo().getConstellation();
				if (!TextUtils.isEmpty(star))
					people_tv_star.setText(star);

				String blood = info.getData().getUserInfo().getBloodType();
				if (!TextUtils.isEmpty(blood))
					people_tv_blood.setText(blood);

				String singers = info.getData().getUserInfo().getLoveSingers();
				if (!TextUtils.isEmpty(singers))
					people_tv_loveSingers.setText(singers);

				String songs = info.getData().getUserInfo().getLoveSongs();
				if (!TextUtils.isEmpty(songs))
					people_tv_loveSongs.setText(songs);

				String whatIsUp = info.getData().getUserInfo().getWhatIsUp();
				if (!TextUtils.isEmpty(whatIsUp))
					people_tv_whatIsUp.setText(whatIsUp);

			}
		}.run();

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		// --跳转到信息编辑页面--
		case R.id.people_tv_edit:
			Intent info = new Intent(getApplicationContext(), InfoEditorActivity.class);
			startActivity(info);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineInfoEdit");
			break;
		case R.id.login_tv_exit:
			finish();
			break;
		case R.id.people_iv_head:
			Intent intent = new Intent(getApplicationContext(), ChangeHeadImageActivity.class);
			startActivity(intent);
			break;
		}
	}

}
