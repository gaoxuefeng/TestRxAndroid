package cn.com.ethank.yunge.app.discover;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.BaseFragment;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.discover.activity.AudioPlayerActivity;
import cn.com.ethank.yunge.app.discover.adapter.DisCoverAdapter;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.discover.service.GetDisCoverListRequest;
import cn.com.ethank.yunge.app.discover.util.DisCoverConstantUtils;
import cn.com.ethank.yunge.app.util.DeviceUtil;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.coyotelib.app.ui.widget.BasicTitle;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshGridView;

@SuppressLint("CutPasteId")
public class DiscoverFragment extends BaseFragment {
	public boolean isLastpage = false;
	private static final String ARG_PARAM1 = "param1";
	private static final String ARG_PARAM2 = "param2";
	protected static final int SUCCESS = 0;
	protected BasicTitle title;
	private GridView mrfg_discover;
	private DisCoverAdapter adapter;
	private PullToRefreshGridView pullToRefreshGridView;
	private List<DiscoverInfo> list;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		final View view = inflater.inflate(R.layout.fragment_discover, container, false);
		initViewMethod(view);
		return view;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void initViewMethod(final View view) {

		// 清空音乐列表缓存
		DisCoverConstantUtils utils = new DisCoverConstantUtils();
		utils.musicUrlList = new ArrayList<String>();

		title = (BasicTitle) view.findViewById(R.id.title);
		title.setTitle(R.string.tab_third);
		title.setTitleColor(Color.parseColor("#a8a8a5"));
		title.setBackgroundColor(Color.parseColor("#151417"));

		pullToRefreshGridView = (PullToRefreshGridView) view.findViewById(R.id.mrfg_discover);
		mrfg_discover = pullToRefreshGridView.getRefreshableView();

		mrfg_discover.setOnScrollListener(new OnScrollListener() {

			@Override
			public void onScrollStateChanged(AbsListView arg0, int arg1) {
			}

			@Override
			public void onScroll(AbsListView absListView, int firstVisibleItem, int visibleItemCount, int totalItemCount) {

				if (totalItemCount > 0) {
					// 如果第0个，title则完全显示
					if (firstVisibleItem == 0) {
						title.setAlpha(1f);
						return;
					}
					// 为了title效果明显和滑动到最后时完全透明，则让透明度增加20%
					title.setAlpha(1 - (firstVisibleItem * 1f / totalItemCount + 0.2f));
				} else {
					title.setAlpha(1f);
				}
				if (title.getAlpha() > 0.1f) {
					title.setClickable(true);
				} else {
					title.setClickable(false);
				}

			}
		});

		mrfg_discover.setNumColumns(2);
		// --列之间的距离
		mrfg_discover.setHorizontalSpacing(5);
		// --行之间的距离--
		mrfg_discover.setVerticalSpacing(5);
		// --去除点击是出现的黄色边框--
		mrfg_discover.setSelector(new ColorDrawable(Color.TRANSPARENT));

		pullToRefreshGridView.setPullToRefreshOverScrollEnabled(false);
		pullToRefreshGridView.setMode(Mode.BOTH);

		pullToRefreshGridView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener2() {
			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				// 上拉加载
				GetDataTask();
			}

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {

				startIndex = 0;
				adapter = null;
				list = null;

				setHeaderView();
				GetDataTask();
			}
		});

		// z增加headerview
		setHeaderView();

		// --第一次从网络获取数据--
		GetDataTask();
	}

	private void setHeaderView() {
		// z增加两个空对象，因为第1和第2个是header
		DiscoverInfo info1 = new DiscoverInfo();
		DiscoverInfo info2 = new DiscoverInfo();
		list = new ArrayList<DiscoverInfo>();
		list.add(info1);
		list.add(info2);

		setAdapterMethod(list);
	}

	int startIndex = 0;

	private void GetDataTask() {

		if (!DeviceUtil.isMobileConnected(getActivity())) {
			ToastUtil.show("请检查网络");
			pullToRefreshGridView.onRefreshComplete();
			ProgressDialogUtils.dismiss();
			return;
		}

		ProgressDialogUtils.show(getActivity());
		Map<String, String> map = new HashMap<String, String>();
		map.put("startIndex", String.valueOf(startIndex));
		new GetDisCoverListRequest(new RefreshUiInterface() {

			@SuppressWarnings("unchecked")
			@Override
			public void refreshUi(Object result) {
				List<DiscoverInfo> resultList = (List<DiscoverInfo>) result;
				if (resultList != null) {
					list.addAll(resultList);
					startIndex = list.size() - 2;
					setAdapterMethod(list);
				}

				pullToRefreshGridView.onRefreshComplete();
				ProgressDialogUtils.dismiss();
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
				// 第0个和第1个是headerView
				Intent intent = new Intent(getActivity(), AudioPlayerActivity.class);
				DisCoverConstantUtils.disCoverIndex = position;
				DisCoverConstantUtils.disCoverList = list;
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
		// TODO Auto-generated method stub
	}

	@Override
	public void setBind(boolean isBind) {
		// TODO Auto-generated method stub

	}

	@Override
	public void OnFragmentChanged() {
		// TODO Auto-generated method stub

	}
}