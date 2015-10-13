package cn.com.ethank.yunge.app.discover.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.discover.adapter.DisCoverAdapter;
import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;
import cn.com.ethank.yunge.app.discover.bean.DiscoverSubjectBean;
import cn.com.ethank.yunge.app.discover.service.RequestDiscoverListBySubject;
import cn.com.ethank.yunge.app.discover.util.DisCoverConstantUtils;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.view.HeaderGridView;
import cn.com.ethank.yunge.view.MyPullToRefreshHeadGridView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;

public class DisCoverSubjectActivity extends BaseTitleActivity {

	private MyPullToRefreshHeadGridView prgv_discover_subject;
	private HeaderGridView headerGridView;
	List<DiscoverInfo> disCoverList = new ArrayList<DiscoverInfo>();
	private DisCoverAdapter disCoverAdapter;
	private DiscoverSubjectBean discoverSubjectBean;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_discover_subject);
		initTitle();
		initView();
		requestData(true);
	}

	private void requestData(final boolean isFirstRequest) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("specialId", discoverSubjectBean.getSpecialId());
		hashMap.put("startIndex", (isFirstRequest ? 0 : disCoverList.size()) + "");
		RequestDiscoverListBySubject requestDiscoverListBySubject = new RequestDiscoverListBySubject(context, hashMap);
		requestDiscoverListBySubject.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				try {
					@SuppressWarnings("unchecked")
					List<DiscoverInfo> discoverInfos = (List<DiscoverInfo>) map.get("data");
					if (isFirstRequest) {
						clearDisCoverList();
					}
					disCoverList.addAll(discoverInfos);
					disCoverAdapter.setList(disCoverList);
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (prgv_discover_subject != null) {
					prgv_discover_subject.onRefreshComplete();
				}

			}

			@Override
			public void onLoaderFail() {
				if (prgv_discover_subject != null) {
					prgv_discover_subject.onRefreshComplete();
				}

			}
		});
	}

	protected void clearDisCoverList() {
		if (disCoverList != null) {
			disCoverList.clear();
		} else {
			return;
		}

		if (disCoverAdapter != null) {
			disCoverAdapter.setList(disCoverList);
		}

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initView() {
		prgv_discover_subject = (MyPullToRefreshHeadGridView) findViewById(R.id.prgv_discover_subject);
		prgv_discover_subject.setMode(Mode.BOTH);
		headerGridView = prgv_discover_subject.getRefreshableView();
		headerGridView.setHorizontalSpacing(10);
		headerGridView.setVerticalSpacing(10);
		disCoverAdapter = new DisCoverAdapter(disCoverList, context);
		headerGridView.setAdapter(disCoverAdapter);
		prgv_discover_subject.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				requestData(true);
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				requestData(false);
			}
		});
		headerGridView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent intent = new Intent(context, AudioPlayerActivity.class);
				DisCoverConstantUtils.disCoverIndex = (int) id;
				DisCoverConstantUtils.disCoverList = disCoverList;
				startActivity(intent);
			}
		});
	}

	private void initTitle() {
		Bundle bundle = getIntent().getExtras();
		if (bundle != null && bundle.containsKey("discoverSubjectBean")) {
			try {
				discoverSubjectBean = (DiscoverSubjectBean) bundle.getSerializable("discoverSubjectBean");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (discoverSubjectBean == null) {
			discoverSubjectBean = new DiscoverSubjectBean();
			discoverSubjectBean.setSpecialName("发现专题");
		}
		title.setTitle(discoverSubjectBean.getTitlelName());
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
