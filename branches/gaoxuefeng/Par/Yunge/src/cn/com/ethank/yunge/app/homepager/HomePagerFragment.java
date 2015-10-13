package cn.com.ethank.yunge.app.homepager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.homepager.adapter.ActivityTypeAdapter;
import cn.com.ethank.yunge.app.homepager.adapter.AcyivityByTypeListAdapter;
import cn.com.ethank.yunge.app.homepager.autoad.HomePagerAdvertImagePagerAdapter;
import cn.com.ethank.yunge.app.homepager.autoad.HomePagerAutoScrollViewPager;
import cn.com.ethank.yunge.app.homepager.bean.ActivityBean;
import cn.com.ethank.yunge.app.homepager.bean.ActivityTypeBean;
import cn.com.ethank.yunge.app.homepager.bean.AutoPlayPhotos;
import cn.com.ethank.yunge.app.homepager.request.RequestActivityRecommend;
import cn.com.ethank.yunge.app.homepager.request.RequestActivityTypes;
import cn.com.ethank.yunge.app.homepager.request.RequestHomeAutoPhotos;
import cn.com.ethank.yunge.app.mine.activity.LoginActivity;
import cn.com.ethank.yunge.app.remotecontrol.MipcaActivityCapture;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseFragment;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.MyRefreshListView;
import cn.com.ethank.yunge.view.NetworkLayout;
import cn.com.ethank.yunge.view.recyleviewpager.CirclePageIndicator;

import com.coyotelib.app.ui.util.UICommonUtil;
import com.coyotelib.app.ui.widget.BasicTitle;
import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.network.OnNetworkChangedListener;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.lidroid.xutils.bitmap.PauseOnScrollListener;
import com.umeng.analytics.MobclickAgent;

/**
 * 首页
 * 
 * @author ping
 * 
 */
public class HomePagerFragment extends BaseFragment implements OnClickListener, OnNetworkChangedListener {
	private View view;
	private ListView lv_home_infos;
	// private HomePagerListAdapter homePagerListAdapter;
	private List<ActivityBean> arrayList = new ArrayList<ActivityBean>();
	private View headView;
	private ImageView titleTopbg_iv_id;
	private RequestActivityRecommend requestActivityByType;
	private MyRefreshListView mrlv_home_infos;
	private HomePagerAutoScrollViewPager asvp_view_pager_advert;
	private CirclePageIndicator cpi_indicator;
	private List<AutoPlayPhotos> imageIdList = new ArrayList<AutoPlayPhotos>();
	private List<ActivityTypeBean> activityTypeBeanList = new ArrayList<ActivityTypeBean>();
	private BasicTitle title;
	private AcyivityByTypeListAdapter acyivityByTypeListAdapter;
	private GridView gv_activity_type;
	private ActivityTypeAdapter activityTypeAdapter;
	private OnUpdateHomepagerListner onUpdateHomepagerListner;
	public static boolean isConnectNetHomePager = true;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// 判断网络连接状况
		view = inflater.inflate(R.layout.fragment_homepaher, null, false);
		initTitle(view);
		NetworkLayout network_homepager = (NetworkLayout) view.findViewById(R.id.network_homepager);
		LinearLayout ll_normal_homepager = (LinearLayout) view.findViewById(R.id.ll_normal_homepager);
		initView(view);
		if (NetStatusUtil.isNetConnect()) {
			network_homepager.setVisibility(View.GONE);
			ll_normal_homepager.setVisibility(View.VISIBLE);
			// initView(view);
			initData();
			isConnectNetHomePager = true;
		} else {
			// view = inflater.inflate(R.layout.activity_net, null, false);
			network_homepager.setVisibility(View.VISIBLE);
			ll_normal_homepager.setVisibility(View.GONE);
			initNetView(network_homepager);
			isConnectNetHomePager = false;
		}

		return view;
	}

	private void initNetView(View view2) {
		TextView tv_refresh = (TextView) view2.findViewById(R.id.tv_refresh);
		tv_refresh.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// ToastUtil.show("点击刷新");
				onUpdateHomepagerListner.OnUpdateHomepager();
			}
		});
	}

	private void initTitle(View view) {
		title = (BasicTitle) view.findViewById(R.id.title);
		title.showBtnBack(false);
		title.showBtnFunction();
		title.setFunctionDrawable(R.drawable.home_link_ktv_icon);
		title.setOnBtnFunctionClickAction(this);
		title.setBackgroundColor(Color.parseColor("#241938"));
		title.setTitleColor(Color.parseColor("#FFFFFF"));
		title.setTitle("潮趴汇");
	}

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		onUpdateHomepagerListner = (OnUpdateHomepagerListner) activity;
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
						acyivityByTypeListAdapter.setList(activityBeans);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (mrlv_home_infos != null) {
					mrlv_home_infos.onRefreshComplete();
				}
			}

			@Override
			public void onLoaderFail() {
				if (mrlv_home_infos != null) {
					mrlv_home_infos.onRefreshComplete();
				}
			}
		});
	}

	protected void clearActiviyiList() {
		arrayList.clear();
		acyivityByTypeListAdapter.setList(arrayList);
	}

	private void initView(View view) {
		titleTopbg_iv_id = (ImageView) view.findViewById(R.id.titleTopbg_iv_id);
		titleTopbg_iv_id.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, UICommonUtil.getScreenHeightPixels(BaseApplication.getInstance()) / 2));

		mrlv_home_infos = (MyRefreshListView) view.findViewById(R.id.mrlv_home_infos);
		mrlv_home_infos.setMode(Mode.DISABLED);
		lv_home_infos = mrlv_home_infos.getRefreshableView();
		headView = LayoutInflater.from(getActivity()).inflate(R.layout.fragment_list_head, null);
		initHeadView(headView);
		lv_home_infos.addHeaderView(headView, null, false);
		acyivityByTypeListAdapter = new AcyivityByTypeListAdapter(getActivity(), arrayList, new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				boolean isToLogin = (Boolean) result;
				if (isToLogin) {
					Intent intent = new Intent(getActivity(), LoginActivity.class);
					startActivityForResult(intent, 1);
				}
			}
		});
		lv_home_infos.setAdapter(acyivityByTypeListAdapter);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == 1 && Constants.getLoginState()) {
			Intent intent = new Intent(getActivity(), ActivityWebWithTitleActivity.class);
			intent.putExtra("activityBean", Constants.activityBeanitem);
			startActivity(intent);
		}
	}

	private void initHeadView(View headView) {
		gv_activity_type = (GridView) headView.findViewById(R.id.gv_activity_type);
		activityTypeAdapter = new ActivityTypeAdapter(getActivity(), activityTypeBeanList);
		gv_activity_type.setAdapter(activityTypeAdapter);
		// 新加的轮播图
		asvp_view_pager_advert = (HomePagerAutoScrollViewPager) headView.findViewById(R.id.asvp_view_pager_advert);
		cpi_indicator = (CirclePageIndicator) headView.findViewById(R.id.cpi_indicator);

		requestAutoPhotos();
		requestActivityType();
	}

	private void requestActivityType() {
		RequestActivityTypes requestActivityTypes = new RequestActivityTypes(getActivity());
		requestActivityTypes.start(new RequestCallBack() {

			@SuppressWarnings("unchecked")
			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					activityTypeBeanList = (List<ActivityTypeBean>) map.get("data");
					activityTypeAdapter.setList(activityTypeBeanList);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			@Override
			public void onLoaderFail() {

			}
		});

	}

	private void requestAutoPhotos() {
		RequestHomeAutoPhotos requestHomeAutoPhotos = new RequestHomeAutoPhotos(getActivity());
		requestHomeAutoPhotos.start(new RequestCallBack() {

			@SuppressWarnings("unchecked")
			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					imageIdList = (List<AutoPlayPhotos>) map.get("data");
					if (imageIdList == null || imageIdList.size() == 0) {
						return;
					}
					asvp_view_pager_advert.setAdapter(new HomePagerAdvertImagePagerAdapter(getActivity(), imageIdList, new RefreshUiInterface() {

						@Override
						public void refreshUi(Object result) {
							boolean isToLogin = (Boolean) result;
							if (isToLogin) {
								Intent intent = new Intent(getActivity(), LoginActivity.class);
								startActivityForResult(intent, 1);
							}
						}
					}));
					cpi_indicator.setViewPager(asvp_view_pager_advert);
					asvp_view_pager_advert.setInterval(2000);
					asvp_view_pager_advert.startAutoScroll();
					asvp_view_pager_advert.setCurrentItem(1000);
				} catch (Exception e) {
					e.printStackTrace();
				}

			}

			@Override
			public void onLoaderFail() {
				try {

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.title_function:
			if (NetStatusUtil.isNetConnect()) {
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
			} else {

			}

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
	}

	private void toLogin() {
		Intent intent = new Intent(getActivity(), LoginActivity.class);
		startActivityForResult(intent, Constants.LOGIN_REQUEST_CODE_RETURN);
	}

	@Override
	public void OnFragmentResume() {
		try {
			if (!NetStatusUtil.isNetConnect()) {
				ToastUtil.show(R.string.connectfailtoast);
			}
			if (arrayList != null && arrayList.size() == 0) {
				initData();
			}
			if (imageIdList == null || imageIdList.size() == 0) {
				requestAutoPhotos();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void OnFragmentChanged() {

	}

	@Override
	public void onNetworkChanged(INetworkStatus status) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}

	public interface OnUpdateHomepagerListner {
		void OnUpdateHomepager();
	}
}
