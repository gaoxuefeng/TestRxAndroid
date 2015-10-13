package cn.com.ethank.yunge.app.mine;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.activity.ChargeBackActivity;
import cn.com.ethank.yunge.app.mine.activity.AutographActivity;
import cn.com.ethank.yunge.app.mine.activity.ConsumeActivity;
import cn.com.ethank.yunge.app.mine.activity.InfoEditorActivity;
import cn.com.ethank.yunge.app.mine.activity.InfoEditorXinActivity;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.mine.activity.MyRecordXin;
import cn.com.ethank.yunge.app.mine.activity.MyRoomActivity;
import cn.com.ethank.yunge.app.mine.activity.PeopleHomePageActivity;
import cn.com.ethank.yunge.app.mine.activity.SettingActivity;
import cn.com.ethank.yunge.app.mine.activity.UserInfoActivity;
import cn.com.ethank.yunge.app.mine.bean.UserInfo;
import cn.com.ethank.yunge.app.remotecontrol.interactcontrl.SendPictureActivity;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseFragment;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.SharePreferenceKeyUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.app.util.XCRoundImageViewByXfermode;

import com.alibaba.fastjson.JSON;
import com.lidroid.xutils.BitmapUtils;
import com.umeng.analytics.MobclickAgent;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;

/**
 * A simple {@link Fragment} subclass. Activities that contain this fragment
 * must implement the {@link MineFragment.OnFragmentInteractionListener}
 * interface to handle interaction events. Use the
 * {@link MineFragment#newInstance} factory method to create an instance of this
 * fragment.
 */
public class MineFragment extends BaseFragment implements View.OnClickListener {
	// TODO: Rename parameter arguments, choose names that match
	// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
	private static final String ARG_PARAM1 = "param1";
	private static final String ARG_PARAM2 = "param2";

	private TextView myselftv_id;
	private boolean isLogin = false;
	private UMSocialService mController = UMServiceFactory.getUMSocialService(Constants.DESCRIPTOR);

	private Button mine_but_login;
	private cn.com.ethank.yunge.app.util.XCRoundImageViewByXfermode mine_iv;
	private TextView frag_name;
	private TextView frag_constel;
	private RelativeLayout frag_consume;
	private RelativeLayout frag_voice;
	private RelativeLayout frag_mine_setting;
	private RelativeLayout mine_rl_mark;
	private ImageView frag_ll_exit;
	private ImageView frag_mine_exit;
	private RelativeLayout mine_rl_box;
	private View mine_view;
	private RelativeLayout mine_rl_box2;
	private RelativeLayout frag_history;

	/**
	 * Use this factory method to create a new instance of this fragment using
	 * the provided parameters.
	 * 
	 * @param param1
	 *            Parameter 1.
	 * @param param2
	 *            Parameter 2.
	 * @return A new instance of fragment MineFragment.
	 */
	// TODO: Rename and change types and number of parameters
	public static MineFragment newInstance(String param1, String param2) {
		MineFragment fragment = new MineFragment();
		Bundle args = new Bundle();
		args.putString(ARG_PARAM1, param1);
		args.putString(ARG_PARAM2, param2);
		fragment.setArguments(args);
		return fragment;
	}

	public MineFragment() {
		// Required empty public constructor
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		LinearLayout view = (LinearLayout) inflater.inflate(R.layout.fragment_mine, container, false);

		mine_iv = (XCRoundImageViewByXfermode) view.findViewById(R.id.mine_iv); // --默认图片--
		mine_but_login = (Button) view.findViewById(R.id.mine_but_login); // --立即登陆按钮--

		mine_view = view.findViewById(R.id.mine_view); // --可点击区域--
		mine_view.setOnClickListener(this);

		frag_name = (TextView) view.findViewById(R.id.frag_name); // --用户姓名--
		frag_constel = (TextView) view.findViewById(R.id.frag_constel); // --用户星座--
		// mine_bound_phone = (RelativeLayout)
		// view.findViewById(R.id.mine_bound_phone); // --绑定手机号--
		frag_consume = (RelativeLayout) view.findViewById(R.id.frag_consume); // --我的消费--
		frag_voice = (RelativeLayout) view.findViewById(R.id.frag_voice); // --我的录音--

		// frag_history = (RelativeLayout) view.findViewById(R.id.frag_history);
		// // --点唱历史--

		mine_rl_mark = (RelativeLayout) view.findViewById(R.id.mine_rl_mark); // --纪念册--

		// mine_tv_bound = (TextView) view.findViewById(R.id.mine_tv_bound);
		// //--未绑定--
		frag_mine_setting = (RelativeLayout) view.findViewById(R.id.frag_mine_setting); // --设置--

		// frag_mine_exit = (ImageView) view.findViewById(R.id.frag_mine_exit);
		// // --退出--
		// frag_mine_exit.setOnClickListener(this);

		mine_rl_box = (RelativeLayout) view.findViewById(R.id.mine_rl_box);
		mine_rl_box.setOnClickListener(this);

		mine_iv.setOnClickListener(this);
		mine_but_login.setOnClickListener(this);

		frag_consume.setOnClickListener(this);
		frag_voice.setOnClickListener(this);
		frag_mine_setting.setOnClickListener(this);
		mine_rl_mark.setOnClickListener(this);
		frag_name.setOnClickListener(this);

		initData();
		return view;
	}

	/**
	 * 刷新页面
	 */
	private void initData() {

		SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.mine, "");
		if (!TextUtils.isEmpty(Constants.getToken())) {
			UserInfo userInfo = JSON.parseObject(SharePreferencesUtil.getStringData(SharePreferenceKeyUtil.login_result), UserInfo.class);

			mine_view.setVisibility(View.VISIBLE);
			String headUrl = userInfo.getData().getUserInfo().getHeadUrl();

			String gender = userInfo.getData().getUserInfo().getGender();

			if (!TextUtils.isEmpty(userInfo.getData().getUserInfo().getNickName())) {
				frag_name.setText(userInfo.getData().getUserInfo().getNickName());
				frag_name.setTextSize(14);

			}

			BitmapUtils bitmapUtils = new BitmapUtils(getActivity());
			if (!TextUtils.isEmpty(Constants.getImageUrl())) {
				bitmapUtils.display(mine_iv, Constants.getImageUrl());
			} else if (!TextUtils.isEmpty(headUrl)) {
				 bitmapUtils.display(mine_iv, headUrl);
			} else {
				if (gender != null && gender.equals("女")) {
					mine_iv.setBackgroundResource(R.drawable.mine_default_avatar_female);
				} else {
					mine_iv.setBackgroundResource(R.drawable.mine_default_avatar_man);
				}
			}

			if (gender != null && gender.equals("女")) {
				Drawable drawable = getResources().getDrawable(R.drawable.mine_female);
				// 这一步必须要做,否则不会显示.
				drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
				frag_constel.setCompoundDrawables(drawable, null, null, null);
			} else {
				Drawable drawable = getResources().getDrawable(R.drawable.mine_man);
				// 这一步必须要做,否则不会显示.
				drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
				frag_constel.setCompoundDrawables(drawable, null, null, null);
			}
			
			
			frag_constel.setText(userInfo.getData().getUserInfo().getConstellation());
			frag_constel.setVisibility(View.VISIBLE);
			mine_but_login.setVisibility(View.GONE);
			frag_name.setTextColor(getResources().getColor(R.color.white));
		} else {
			mine_view.setVisibility(View.GONE);
			mine_iv.setImageResource(R.drawable.mine_default_avatar_man);
			frag_name.setText("还没登录呢？赶快登录潮趴汇KTV，享受音乐的海洋！");
			frag_name.setTextSize(11);
			frag_constel.setVisibility(View.GONE);
			mine_but_login.setVisibility(View.VISIBLE);
			frag_name.setTextColor(getResources().getColor(R.color.white_70));
			frag_name.setCompoundDrawables(null, null, null, null);
		}
	}

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
	}

	@Override
	public void onResume() {
		super.onResume();
		if (myselftv_id != null) {
			isLogin = BaseApplication.mSettingSvc.getBoolean("isLogin", false);
			if (isLogin) {
				myselftv_id.setBackgroundResource(R.drawable.default_head_icon);
			}
		}
		initData();
	}

	@Override
	public void onStart() {
		super.onStart();

	}

	@Override
	public void onDetach() {
		super.onDetach();
	}

	@Override
	public void onClick(View view) {
		if (!Constants.isClickAble()) {
			return;
		} else {
			Constants.setUnClickAble();
		}
		switch (view.getId()) {
		// --跳转登录页面--
		case R.id.mine_but_login:
			SharePreferencesUtil.saveStringData(SharePreferenceKeyUtil.mine, "mine");
			Intent login = new Intent(getActivity(), LoginActivity.class);
			startActivityForResult(login, 100);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineLogin");
			break;
		// --跳转到绑定手机界面--
		/*
		 * case R.id.mine_bound_phone: Intent bound = new Intent(getActivity(),
		 * BoundPhoneActivity.class); startActivity(bound); break;
		 */
		// --跳转到个人主页--
		case R.id.frag_name:
			/*
			 * Intent people = new Intent(getActivity(),
			 * PeopleHomePageActivity.class); startActivity(people);
			 */
			break;
		case R.id.frag_consume:
			if (TextUtils.isEmpty(Constants.getToken())) {
				Intent consume = new Intent(getActivity(), LoginActivity.class);
				startActivity(consume);
				return;
			}
			// --跳转到我的消费界面--
			Intent activity = new Intent(getActivity(), ConsumeActivity.class);
			startActivity(activity);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineConsum");
			break;
		case R.id.frag_voice:
			if (TextUtils.isEmpty(Constants.getToken())) {
				Intent record = new Intent(getActivity(), LoginActivity.class);
				startActivity(record);
				return;
			}
			// 我的录音
			Intent user = new Intent(getActivity(), MyRecordXin.class);
			startActivity(user);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineRecord");
			break;
		case R.id.frag_mine_setting:
			// --点击跳转到设置界面--
			Intent setting = new Intent(getActivity(), SettingActivity.class);
			startActivity(setting);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineSetting");
			break;
		case R.id.mine_rl_mark:
			if (TextUtils.isEmpty(Constants.getToken())) {
				Intent mark = new Intent(getActivity(), LoginActivity.class);
				startActivity(mark);
				return;
			}
			// --点击跳转到纪念册页面--
			Intent autograph = new Intent(getActivity(), AutographActivity.class);
			startActivity(autograph);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineAutograph");
			break;

		case R.id.mine_rl_box:
			if (TextUtils.isEmpty(Constants.getToken())) {
				Intent room = new Intent(getActivity(), LoginActivity.class);
				startActivity(room);
				return;
			}
			// 我的房间
			Intent intent = new Intent(getActivity(), MyRoomActivity.class);
			startActivity(intent);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineRoom");
			break;
		case R.id.mine_view:
			Intent people = new Intent(getActivity(), InfoEditorActivity.class);
			startActivity(people);
			MobclickAgent.onEvent(BaseApplication.getInstance(), "MineInfo");
			break;
		}
	}

	public interface OnFragmentInteractionListener {
		public void onFragmentInteraction(Uri uri);
	}

	@Override
	public void setBind(boolean isBind) {
		// TODO Auto-generated method stub

	}

	@Override
	public void OnFragmentResume() {
		try {
			initData();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void OnFragmentChanged() {
		// TODO Auto-generated method stub

	}

}
