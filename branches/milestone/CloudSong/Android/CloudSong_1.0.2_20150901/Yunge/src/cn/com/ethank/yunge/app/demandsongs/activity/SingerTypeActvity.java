package cn.com.ethank.yunge.app.demandsongs.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ScrollView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.RoomBaseActivity;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.SingersOnlineGridAdapter;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.SinglerTypeAdapter;
import cn.com.ethank.yunge.app.demandsongs.activity.searchsong.SearchSongActivity;
import cn.com.ethank.yunge.app.demandsongs.beans.SingerTypeBean;
import cn.com.ethank.yunge.app.demandsongs.beans.SinglerOnLine;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.RequestSinggerList;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.JsonCacheKeyUtil;
import cn.com.ethank.yunge.app.util.JsonCacheUtil;
import cn.com.ethank.yunge.view.MyGridView;
import cn.com.ethank.yunge.view.MyListView;

/**
 * 歌星列表
 * 
 * @author GaoXuefeng
 * 
 */
public class SingerTypeActvity extends RoomBaseActivity implements View.OnClickListener, AdapterView.OnItemClickListener {

	private MyGridView gv_singers;
	private MyListView lv_types;
	private SingersOnlineGridAdapter singersAdapter;
	private SinglerTypeAdapter singlerTypeAdapter;

	private ArrayList<SinglerOnLine> singlerList = new ArrayList<SinglerOnLine>();
	private ArrayList<SingerTypeBean> singerTypeList = new ArrayList<SingerTypeBean>();
	private ScrollView sv_singer_type;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_singgers_actvity);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
		initView();
		initData();
	}

	private void initData() {
		addSingler();
		addSinggerType();
		initAdapterAnddata();

	}

	private void initAdapterAnddata() {
		singersAdapter = new SingersOnlineGridAdapter(context, singlerList);
		gv_singers.setAdapter(singersAdapter);
		singlerTypeAdapter = new SinglerTypeAdapter(context, singerTypeList);
		lv_types.setAdapter(singlerTypeAdapter);
		sv_singer_type.smoothScrollTo(0, 0);// 滚动到顶部
		try {
			@SuppressWarnings("unchecked")
			List<SinglerOnLine> myCacheList = (List<SinglerOnLine>) JsonCacheUtil.getArrayList(JsonCacheKeyUtil.top6Singer, SinglerOnLine.class);
			if (myCacheList != null && myCacheList.size() != 0) {
				singlerList.addAll(myCacheList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void addSinggerType() {
		// 1：大陆男歌星 2：大陆女歌星 3：港台男歌星 4：港台女歌星 5：中国组合 6：外国歌星 7：外国组合
		SingerTypeBean
		// 0
		// singerTypeBean = new SingerTypeBean();
		// singerTypeBean.setSingerTypeId(0);
		// singerTypeBean.setSingerTypeName("全部歌星");
		// singerTypeList.add(singerTypeBean);

		// 1
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(1);
		singerTypeBean.setSingerTypeName("内地男歌星");
		singerTypeList.add(singerTypeBean);

		// 2
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(2);
		singerTypeBean.setSingerTypeName("内地女歌星");
		singerTypeList.add(singerTypeBean);

		// 3
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(3);
		singerTypeBean.setSingerTypeName("内地组合");
		singerTypeList.add(singerTypeBean);

		// 4
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(4);
		singerTypeBean.setSingerTypeName("港台男歌星");
		singerTypeList.add(singerTypeBean);

		// 5
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(5);
		singerTypeBean.setSingerTypeName("港台女歌星");
		singerTypeList.add(singerTypeBean);

		// 6
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(6);
		singerTypeBean.setSingerTypeName("港台组合");
		singerTypeList.add(singerTypeBean);

		// 7
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(7);
		singerTypeBean.setSingerTypeName("外国男歌星");
		singerTypeList.add(singerTypeBean);

		// 8
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(8);
		singerTypeBean.setSingerTypeName("外国女歌星");
		singerTypeList.add(singerTypeBean);

		// 9
		singerTypeBean = new SingerTypeBean();
		singerTypeBean.setSingerTypeId(9);
		singerTypeBean.setSingerTypeName("外国组合");
		singerTypeList.add(singerTypeBean);

	}

	private void addSingler() {
		// 增加top6歌手
		HashMap<String, String> hashMap = new HashMap<String, String>();
		String url =Constants.REQUEST_TOP_6_SINGER_LIST;
		RequestSinggerList requestSinggerList = new RequestSinggerList(context, hashMap, url);
		requestSinggerList.start(new RequestCallBack() {

			@Override
			public void onLoaderFinish(Map<String, ?> map) {
				if (map != null && map.containsKey("data")) {
					@SuppressWarnings("unchecked")
					List<SinglerOnLine> mySinggerList = (List<SinglerOnLine>) map.get("data");
					if (singlerList.size() != 0 && mySinggerList != null && mySinggerList.size() != 0) {
						singlerList.clear();
						singersAdapter.setList(singlerList);
					}
					singlerList.addAll(mySinggerList);
					singersAdapter.setList(singlerList);
				}
			}

			@Override
			public void onLoaderFail() {

			}
		});

	}

	private void initView() {
		title.setTitle(R.string.title_singger);
		title.setBtnBackText("点歌");
		title.showBtnFunction();
		title.setOnBtnFunctionClickAction(this);
		gv_singers = (MyGridView) findViewById(R.id.gv_singers);
		lv_types = (MyListView) findViewById(R.id.lv_types);
		sv_singer_type = (ScrollView) findViewById(R.id.sv_singer_type);
		lv_types.setOnItemClickListener(this);
		gv_singers.setOnItemClickListener(this);
	}

	@Override
	public void onClick(View view) {

		switch (view.getId()) {
		case R.id.title_function:
			Intent intent = new Intent(this, SearchSongActivity.class);
			intent.setAction(Constants.SINGER_ACTION);
			startActivity(intent);
			break;

		default:
			super.onClick(view);
			break;
		}
	}

	// 歌手类型列表
	private void toSingerListActivity(SingerTypeBean singerTypeBean) {
		Intent intent = new Intent(context, SinglerListActivity.class);
		intent.putExtra("singerTypeBean", singerTypeBean);
		startActivity(intent);
	}

	@Override
	public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
		switch (adapterView.getId()) {

		case R.id.lv_types:
			toSingerListActivity(singerTypeList.get(position));
			break;

		}
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}

}
