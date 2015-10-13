package cn.com.ethank.yunge.app.homepager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.view.animation.TranslateAnimation;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.BaseFragment;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.discover.service.GetDisCoverListRequest;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.remotecontrol.MipcaActivityCapture;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.AnimationEndCallBack;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.umeng.analytics.MobclickAgent;

public class HomePagerFragment extends BaseFragment implements OnClickListener {
	private View view;
	private ListView lv_home_infos;
	private HomePagerListAdapter homePagerListAdapter;
	private List<ActivityBean> arrayList = new ArrayList<ActivityBean>();
	private View headView;
	private ImageView titleTopbg_iv_id;
	private LinearLayout ll_home_title;
	private TextView tv_enter_room, desc_tv_id;
	private LinearLayout ll_home_nationwide;
	private LinearLayout ll_home_fancy;
	private LinearLayout ll_home_hot;
	private RequestActivityRecommend requestActivityByType;
	private MyRefreshListView mrlv_home_infos;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		view = inflater.inflate(R.layout.fragment_homepaher, null, false);
		initView(view);
		initData();
		return view;
	}

	private void initData() {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		// hashMap.put("activityType", "0");
		// hashMap.put("startIndex", arrayList.size() + "");
		requestActivityByType = new RequestActivityRecommend(getActivity(), hashMap);
		requestActivityByType.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					if (map != null && map.containsKey("data") && map.get("data") != null) {
						List<ActivityBean> activityBeans = (List<ActivityBean>) map.get("data");
						arrayList.addAll(activityBeans);
						homePagerListAdapter.setList(activityBeans);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				mrlv_home_infos.onRefreshComplete();
			}

			@Override
			public void onLoaderFail() {
				mrlv_home_infos.onRefreshComplete();
			}
		});
	}

	protected void clearActiviyiList() {
		arrayList.clear();
		homePagerListAdapter.setList(arrayList);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void initView(View view) {
		titleTopbg_iv_id = (ImageView) view.findViewById(R.id.titleTopbg_iv_id);
		titleTopbg_iv_id.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, UICommonUtil.getScreenHeightPixels(getActivity()) / 2));

		ll_home_title = (LinearLayout) view.findViewById(R.id.ll_home_title);
		mrlv_home_infos = (MyRefreshListView) view.findViewById(R.id.mrlv_home_infos);
		mrlv_home_infos.setMode(Mode.DISABLED);
		lv_home_infos = mrlv_home_infos.getRefreshableView();
		headView = LayoutInflater.from(getActivity()).inflate(R.layout.fragment_list_head, null);
		initHeadView(headView);
		showAnim();
		lv_home_infos.addHeaderView(headView, null, false);
		homePagerListAdapter = new HomePagerListAdapter(getActivity(), arrayList);
		lv_home_infos.setAdapter(homePagerListAdapter);
		lv_home_infos.setOnScrollListener(new OnScrollListener() {

			@Override
			public void onScrollStateChanged(AbsListView view, int scrollState) {
			}

			@Override
			public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
				if (totalItemCount == 0) {
					ll_home_title.setAlpha(0);
				} else {
					ll_home_title.setAlpha(firstVisibleItem * 1f / totalItemCount);
				}

			}
		});
	}

	Handler hand = new Handler();

	// 展示listview的动画，动画完成后启动titleview的动画
	private void showAnim() {

		TranslateAnimation tanimation = new TranslateAnimation(0, 0, -UICommonUtil.getScreenHeightPixels(getActivity()) / 4, 0);
		tanimation.setDuration(2000);
		hand.postDelayed(new Runnable() {

			@Override
			public void run() {
				// TODO Auto-generated method stub
				showTitleChileViewAnim_Method();
			}
		}, 1000);
		lv_home_infos.setAnimation(tanimation);
	}

	Handler handler = new Handler();

	// 展示完titleview的动画后展示描述文字的渐变动画，2秒后启动切换图片的线程
	private void showTitleChileViewAnim_Method() {
		titleTopbg_iv_id.setVisibility(View.VISIBLE);
		TranslateAnimation anim = new TranslateAnimation(0, 0, -UICommonUtil.getScreenHeightPixels(getActivity()) / 2, 0);
		anim.setDuration(1500);
		titleTopbg_iv_id.setAnimation(anim);
		AnimationEndCallBack.setAnimationCallBack(anim, new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				tv_enter_room.setVisibility(View.VISIBLE);
				Animation animation = AnimationUtils.loadAnimation(getActivity(), R.anim.myalpha_scale);
				tv_enter_room.startAnimation(animation);
				AnimationEndCallBack.setAnimationCallBack(animation, new RefreshUiInterface() {

					@Override
					public void refreshUi(Object result) {
						Animation animation = AnimationUtils.loadAnimation(getActivity(), R.anim.myalpha_scale_tomin);
						tv_enter_room.startAnimation(animation);

						desc_tv_id.setVisibility(View.VISIBLE);
						AlphaAnimation anim = new AlphaAnimation(0, 1.0f);
						anim.setDuration(2000);
						anim.setFillAfter(true);
						desc_tv_id.setAnimation(anim);

						handler.postDelayed(run, 2000);
					}
				});
			}
		});
	}

	// 启动切换图片的线程，4秒后执行渐变动画并在完成后再次调用本线程
	int sign = 2;
	Runnable run = new Runnable() {

		@Override
		public void run() {
			AlphaAnimation anim = new AlphaAnimation(0.1f, 1.0f);
			anim.setDuration(700);
			anim.setFillAfter(true);
			titleTopbg_iv_id.clearAnimation();
			titleTopbg_iv_id.setAnimation(anim);

			anim.setAnimationListener(new AnimationListener() {

				@Override
				public void onAnimationStart(Animation arg0) {
					switch (sign) {
					case 1:
						sign = 2;
						titleTopbg_iv_id.setBackgroundResource(R.drawable.home_img02_bg);
						break;
					case 2:
						sign = 3;
						titleTopbg_iv_id.setBackgroundResource(R.drawable.home_img03_bg);
						break;
					case 3:
						titleTopbg_iv_id.setBackgroundResource(R.drawable.home_img01_bg);
						sign = 1;
						break;
					default:
						break;
					}
				}

				@Override
				public void onAnimationRepeat(Animation arg0) {
				}

				@Override
				public void onAnimationEnd(Animation arg0) {
					handl.postDelayed(runable, 4000);// 每张切换的图片停留的时间
				}
			});
		}
	};

	// 启动渐变动画并且在完成后执行切换图片的线程
	Handler handl = new Handler();
	Runnable runable = new Runnable() {

		@Override
		public void run() {
			// TODO Auto-generated method stub
			AlphaAnimation anim = new AlphaAnimation(1.0f, 0.1f);
			anim.setDuration(700);
			anim.setFillAfter(true);
			titleTopbg_iv_id.clearAnimation();
			titleTopbg_iv_id.setAnimation(anim);
			AnimationEndCallBack.setAnimationCallBack(anim, new RefreshUiInterface() {

				@Override
				public void refreshUi(Object result) {
					// TODO Auto-generated method stub
					handler.post(run);
				}
			});
		}
	};

	private void initHeadView(View headView) {
		desc_tv_id = (TextView) headView.findViewById(R.id.desc_tv_id);
		tv_enter_room = (TextView) headView.findViewById(R.id.tv_enter_room);
		tv_enter_room.setOnClickListener(this);
		initCenterText();
		ll_home_nationwide = (LinearLayout) headView.findViewById(R.id.ll_home_nationwide);
		ll_home_nationwide.setOnClickListener(this);
		ll_home_fancy = (LinearLayout) headView.findViewById(R.id.ll_home_fancy);
		ll_home_fancy.setOnClickListener(this);
		ll_home_hot = (LinearLayout) headView.findViewById(R.id.ll_home_hot);
		ll_home_hot.setOnClickListener(this);
		tv_enter_room.setOnLongClickListener(new OnLongClickListener() {

			@Override
			public boolean onLongClick(View v) {
				if (Constants.isBinded()) {
					Constants.setBinded(false);
					ToastUtil.show("已断开连接");
				}
				return false;
			}
		});
	}

	private void initCenterText() {
		if (Constants.isBinded()) {
			// tv_enter_room.setText("点击断开房间");
			tv_enter_room.setText(Constants.getBoxInfo().getRoomName());
			desc_tv_id.setText("到店后请开启或保持KTV内WIFI连接");
		} else {
			tv_enter_room.setText("进入房间");
			desc_tv_id.setText("预订房间或扫描点歌屏上的二维码,就能点歌啦");
		}
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.tv_enter_room:
			MobclickAgent.onEvent(BaseApplication.getInstance(), "HomeAddroom");
			if (Constants.isBinded()) {
				Constants.setBinded(false);
				return;
			} else {
				if (!Constants.getLoginState()) {
					// 没有登录
					toLogin();
				} else {
					// 暂时直接绑定
					bindBox();
					// Constants.setBinded(true);
				}

			}
			break;
		case R.id.ll_home_nationwide:
			Intent intent = new Intent(getActivity(), HomePagerByTypeActivity.class);
			intent.putExtra("type", "全国活动");
			MobclickAgent.onEvent(BaseApplication.getInstance(), "HomeNationwide");
			startActivity(intent);
			break;
		case R.id.ll_home_fancy:
			intent = new Intent(getActivity(), HomePagerByTypeActivity.class);
			intent.putExtra("type", "精品活动");
			MobclickAgent.onEvent(BaseApplication.getInstance(), "HomeBoutique");
			startActivity(intent);
			break;
		case R.id.ll_home_hot:
			intent = new Intent(getActivity(), HomePagerByTypeActivity.class);
			intent.putExtra("type", "热门活动");
			MobclickAgent.onEvent(BaseApplication.getInstance(), "HomeHot");
			startActivity(intent);
			break;

		}
	}

	private void bindBox() {
		Intent intent;
		ToastUtil.show("连接房间");
		intent = new Intent(getActivity(), MipcaActivityCapture.class);
		startActivityForResult(intent, 10);
	}

	@Override
	public void setBind(boolean isBind) {
		initCenterText();
	}

	private void toLogin() {
		Intent intent = new Intent(getActivity(), LoginActivity.class);
		startActivityForResult(intent, Constants.LOGIN_REQUEST_CODE_RETURN);
	}

	@Override
	public void OnFragmentResume() {
		try {
			if (!NetStatusUtil.isNetConnect()) {
				ToastUtil.show("当前网络出现异常,请稍后再试");
			}
			if (arrayList != null && arrayList.size() == 0) {
				initData();
			}
			initCenterText();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void OnFragmentChanged() {

	}
}
