package cn.com.ethank.yunge.app.discover;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.discover.activity.AudioPlayerActivity;
import cn.com.ethank.yunge.app.discover.adapter.DisCoverAdapter;
import cn.com.ethank.yunge.app.discover.adview.DisCoverAdvertImagePagerAdapter;
import cn.com.ethank.yunge.app.discover.adview.DisCoverAutoScrollViewPager;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.discover.bean.DiscoverSubjectBean;
import cn.com.ethank.yunge.app.discover.service.GetDisCoverListRequest;
import cn.com.ethank.yunge.app.discover.service.RequestDiscoverAutoPhotos;
import cn.com.ethank.yunge.app.discover.util.DisCoverConstantUtils;
import cn.com.ethank.yunge.app.startup.BaseFragment;
import cn.com.ethank.yunge.app.util.DeviceUtil;
import cn.com.ethank.yunge.app.util.NetStatusUtil;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.HeaderGridView;
import cn.com.ethank.yunge.view.MyPullToRefreshHeadGridView;
import cn.com.ethank.yunge.view.NetworkLayout;
import cn.com.ethank.yunge.view.recyleviewpager.CirclePageIndicator;

import com.alibaba.fastjson.JSON;
import com.coyotelib.app.ui.widget.BasicTitle;
import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.network.OnNetworkChangedListener;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

@SuppressLint("CutPasteId")
public class DiscoverFragment extends BaseFragment implements OnNetworkChangedListener {
	public boolean isLastpage = false;
	private static final String ARG_PARAM1 = "param1";
	private static final String ARG_PARAM2 = "param2";
	protected static final int SUCCESS = 0;
	protected BasicTitle title;
	private HeaderGridView mrfg_discover;
	private DisCoverAdapter adapter;
	private MyPullToRefreshHeadGridView pullToRefreshGridView;
	private List<DiscoverInfo> list = new ArrayList<DiscoverInfo>();
	private View discover_list_head;
	private DisCoverAutoScrollViewPager davp_view_pager_advert;
	private CirclePageIndicator cpi_indicator;
	private List<DiscoverSubjectBean> imageIdList = new ArrayList<DiscoverSubjectBean>();
	private OnDiscoverListner onDiscover;
	private View view;
	private NetworkLayout network_discover;
	public static boolean isConnectNetDiscover =true;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		view = inflater.inflate(R.layout.fragment_discover, container, false);
		initTitle(view);
		pullToRefreshGridView = (MyPullToRefreshHeadGridView) view.findViewById(R.id.mrfg_discover);
		network_discover = (NetworkLayout) view.findViewById(R.id.network_discover);
		if(NetStatusUtil.isNetConnect()){
			network_discover.setVisibility(View.GONE);
			pullToRefreshGridView.setVisibility(View.VISIBLE);
			initViewMethod(view);
			isConnectNetDiscover= true;
		}else{
//			view = inflater.inflate(R.layout.activity_net, null, false);
			network_discover.setVisibility(View.VISIBLE);
			pullToRefreshGridView.setVisibility(View.GONE);
			initNetView(network_discover);
			isConnectNetDiscover = false;
		}
		
		return view;
	}
	private void initNetView(View view2) {
		TextView tv_refresh = (TextView) view2.findViewById(R.id.tv_refresh);
		tv_refresh.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
//				ToastUtil.show("点击刷新");
				onDiscover.OnUpdateDiscover();
			}
		});
	}
	public  interface OnDiscoverListner{
		void OnUpdateDiscover();
	}
	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		onDiscover = (OnDiscoverListner) activity;
	}

	/**
	 * 轮播图
	 * 
	 */
	private void initAdView() {
		discover_list_head = LayoutInflater.from(getActivity()).inflate(R.layout.discover_head, null);
		mrfg_discover.addHeaderView(discover_list_head, null, false);
		davp_view_pager_advert = (DisCoverAutoScrollViewPager) discover_list_head.findViewById(R.id.davp_view_pager_advert);
		cpi_indicator = (CirclePageIndicator) discover_list_head.findViewById(R.id.discover_indicator);
		requestDiscoverSubject();

	}

	private void requestDiscoverSubject() {
		RequestDiscoverAutoPhotos requestDiscoverAutoPhotos = new RequestDiscoverAutoPhotos(getActivity());
		requestDiscoverAutoPhotos.start(new RequestCallBack() {

			@SuppressWarnings("unchecked")
			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					imageIdList = (List<DiscoverSubjectBean>) map.get("data");
					davp_view_pager_advert.setAdapter(new DisCoverAdvertImagePagerAdapter(getActivity(), imageIdList));
					cpi_indicator.setViewPager(davp_view_pager_advert);
					davp_view_pager_advert.setInterval(2000);
					davp_view_pager_advert.startAutoScroll();
					davp_view_pager_advert.setCurrentItem(10000);
				} catch (Exception e) {
					e.printStackTrace();
				}

			}

			@Override
			public void onLoaderFail() {

			}
		});

	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void initViewMethod(final View view) {

		// 清空音乐列表缓存
		DisCoverConstantUtils utils = new DisCoverConstantUtils();
		utils.musicUrlList = new ArrayList<String>();
//		pullToRefreshGridView = (MyPullToRefreshHeadGridView) view.findViewById(R.id.mrfg_discover);
		mrfg_discover = pullToRefreshGridView.getRefreshableView();
		initAdView();

		mrfg_discover.setNumColumns(2);
		// --列之间的距离
		mrfg_discover.setHorizontalSpacing(12);
		// --行之间的距离--
		mrfg_discover.setVerticalSpacing(12);
		// --去除点击是出现的黄色边框--
		mrfg_discover.setSelector(new ColorDrawable(Color.TRANSPARENT));
		setAdapterMethod(list);
		pullToRefreshGridView.setPullToRefreshOverScrollEnabled(false);
		pullToRefreshGridView.setMode(Mode.BOTH);

		pullToRefreshGridView.setOnRefreshListener(new OnRefreshListener2() {
			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				GetDataTask(false);
				if (imageIdList == null || imageIdList.size() == 0) {
					requestDiscoverSubject();
				}
			}

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				GetDataTask(true);
				if (imageIdList == null || imageIdList.size() == 0) {
					requestDiscoverSubject();
				}
			}
		});

		// --第一次从网络获取数据--
		GetDataTask(true);
	}

	private void initTitle(final View view) {
		title = (BasicTitle) view.findViewById(R.id.title);
		title.setTitle(R.string.tab_third);
		title.showBtnBack(false);
		title.showBtnFunction(false);
		title.setBackgroundColor(Color.parseColor("#241938"));
		title.setTitleColor(Color.parseColor("#FFFFFF"));
	}

	// 如果是手动的才需要显示diaolog
	private void GetDataTask(final boolean isFirstRequest) {
		int startIndex = 0;
		if (!DeviceUtil.isMobileConnected(getActivity())) {
			ToastUtil.show(R.string.connectfailtoast);
			pullToRefreshGridView.onRefreshComplete();
			return;
		}
		if (!isFirstRequest && list != null) {
			startIndex = list.size();

		}
		Map<String, String> map = new HashMap<String, String>();
		map.put("startIndex", startIndex + "");
		new GetDisCoverListRequest(new RefreshUiInterface() {

			@SuppressWarnings("unchecked")
			@Override
			public void refreshUi(Object result) {
				List<DiscoverInfo> resultList = (List<DiscoverInfo>) result;
				if (resultList != null) {
					if (list == null) {
						list = new ArrayList<DiscoverInfo>();
					}
					if (isFirstRequest) {
						list = resultList;
					} else {
						list.addAll(resultList);
					}

					setAdapterMethod(list);
				}

				pullToRefreshGridView.onRefreshComplete();

			}
		}, map).requestData();
	}

	void setAdapterMethod(final List<DiscoverInfo> list) {
		if (adapter != null) {
			adapter.setList(list);
		} else {
			adapter = new DisCoverAdapter(list, getActivity());
			mrfg_discover.setAdapter(adapter);
		}
		mrfg_discover.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// 因为在头部加了一个View,所以id才是真正的position
				Intent intent = new Intent(getActivity(), AudioPlayerActivity.class);
				DisCoverConstantUtils.disCoverIndex = (int) id;
				DisCoverConstantUtils.disCoverList = list;
				SharePreferencesUtil.saveIntData("id", (int) id);
				SharePreferencesUtil.saveStringData("list", JSON.toJSONString(list));
				startActivity(intent);
			}
		});
	}

	public interface OnFragmentInteractionListener {
		public void onFragmentInteraction(Uri uri);
	}

	public static DiscoverFragment newInstance(String param1, String param2) {
		DiscoverFragment fragment = new DiscoverFragment();
		Bundle args = new Bundle();
		args.putString(ARG_PARAM1, param1);
		args.putString(ARG_PARAM2, param2);
		fragment.setArguments(args);
		return fragment;
	}

	@Override
	public void OnFragmentResume() {
	}

	@Override
	public void setBind(boolean isBind) {

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
}