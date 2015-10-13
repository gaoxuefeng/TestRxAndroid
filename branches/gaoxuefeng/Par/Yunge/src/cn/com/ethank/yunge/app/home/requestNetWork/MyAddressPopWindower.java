package cn.com.ethank.yunge.app.home.requestNetWork;

import java.util.ArrayList;
import java.util.Map;

import android.content.Context;
import android.graphics.PixelFormat;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.requestnetwork.BaseRequest.RequestCallBack;
import cn.com.ethank.yunge.app.search.city.ChooseCityActivity.CityConstant;
import cn.com.ethank.yunge.app.search.city.ChooseCityAdapter2;
import cn.com.ethank.yunge.app.search.city.CityBean;
import cn.com.ethank.yunge.app.search.city.CityDataTmp;
import cn.com.ethank.yunge.app.search.city.CityResultAdapter;
import cn.com.ethank.yunge.app.search.city.PinnedHeaderListView;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.RequestLoactionCity;
import cn.com.ethank.yunge.app.util.ThreadingService;
import cn.com.ethank.yunge.framework.location.LocationUtil;

import com.coyotelib.app.ui.indexlist.LetterListView;

public class MyAddressPopWindower extends PopupWindow implements OnClickListener, OnItemClickListener {

	private Context context;
	private View popView;
	private InputMethodManager imm;
	private PinnedHeaderListView mCityList;
	private ChooseCityAdapter2 mAdapter;
	private ListView mCityResultList;
	private CityResultAdapter mRAdapter;
	private EditText mCityInput;
	private LetterListView letterListView;
	private OverlayThread overlayThread;
	private ImageView iv_get_lacation;
	private RequestLoactionCity requestLoactionCity;
	private TextView city_textview;
	private RelativeLayout rl_inputlayout;

	public MyAddressPopWindower(Context context, View popView, int fillParent, int fillParent2, boolean b) {
		super(popView, fillParent, fillParent2, b);
		this.context = context;
		this.popView = popView;
		this.setOutsideTouchable(true);
		this.setBackgroundDrawable(context.getResources().getDrawable(R.drawable.homepager_bg_short));
		this.setWidth(LayoutParams.MATCH_PARENT);
		initView(popView);
		setAdapter();
		initListener();
	}

	private void initListener() {
		mCityList.setOnItemClickListener(this);
		mAdapter = new ChooseCityAdapter2(context, popView, this);
		mCityList.setAdapter(mAdapter);
		mCityList.setOnScrollListener(mAdapter);
		mCityList.setPinnedHeaderView(LayoutInflater.from(context).inflate(R.layout.city_header, mCityList, false));
		mCityList.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				hideInputMethod();
				return false;
			}

		});

		//
		mCityResultList.setOnItemClickListener(this);
		mCityResultList.setOnScrollListener(onScroll);
		mRAdapter = new CityResultAdapter();
		mCityResultList.setAdapter(mRAdapter);
		mCityResultList.setVisibility(View.GONE);
		mCityResultList.setDivider(null);
		//
		mCityInput.setHint(R.string.search_change_city_hint);
		mCityInput.setOnEditorActionListener(mInputListener);
		mCityInput.addTextChangedListener(cityInputWatcher);
		mCityInput.setOnKeyListener(keyListener);
		mCityInput.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				mCityInput.setCursorVisible(true);
			}
		});
		//

		letterListView.setOnTouchingLetterChangedListener(new LetterListViewListener());
		letterListView.setColor("#828282");
		overlayThread = new OverlayThread();
		try {
			initOverlay();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void setAdapter() {

	}

	private void initView(View view) {
		imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
		mCityList = (PinnedHeaderListView) view.findViewById(R.id.city_list);
		mCityResultList = (ListView) view.findViewById(R.id.city_result_list);
		mCityInput = (EditText) view.findViewById(R.id.city_input);
		rl_inputlayout = (RelativeLayout) view.findViewById(R.id.rl_inputlayout);
		city_textview = (TextView) view.findViewById(R.id.city_textview);
		letterListView = (LetterListView) view.findViewById(R.id.LetterListView);
		iv_get_lacation = (ImageView) view.findViewById(R.id.iv_get_lacation);
		iv_get_lacation.setOnClickListener(this);
		rl_inputlayout.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				mCityInput.setCursorVisible(true);
				if (mCityInput.getVisibility() == View.VISIBLE) {
					city_textview.setVisibility(View.INVISIBLE);
					return;
				} else {
					mCityInput.setVisibility(View.VISIBLE);
					city_textview.setVisibility(View.INVISIBLE);
				}
				mCityInput.setCursorVisible(true);
				mCityInput.requestFocus();
				imm.showSoftInput(mCityInput, 0);
			}
		});
	}

	private void hideInputMethod() {
		if (imm.isActive(mCityInput)) {
			imm.hideSoftInputFromWindow(mCityInput.getWindowToken(), 0);
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.iv_get_lacation:
			ProgressDialogUtils.show(context);
			requestLoactionCity = new RequestLoactionCity();
			requestLoactionCity.start(new RequestCallBack() {

				@Override
				public void onLoaderFinish(Map<String, ?> map) {
					if (ProgressDialogUtils.isShowing()) {
						String locationCity = (String) map.get("data");
						// ToastUtil.show(map.get("data").toString());
						ProgressDialogUtils.dismiss();
						String cityName = locationCity;
						popView.setTag(cityName);
						dismiss();

					}

				}

				@Override
				public void onLoaderFail() {
					ProgressDialogUtils.dismiss();
				}
			});
			break;

		default:
			break;
		}

	}

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
		// TODO 城市点击操作

		if (position == 0 && parent.getId() != R.id.city_result_list) {
			// 不是通过搜索的第一排
			Object objBean = mAdapter.getItem(position);
			if (objBean instanceof CityBean) {
				String cityName = ((CityBean) objBean).getCityName();
				popView.setTag(cityName);
				this.dismiss();
			}
		} else {

			CityBean cityBean;
			String cityName;
			if (mCityList.getVisibility() == View.VISIBLE) {
				cityBean = (CityBean) mAdapter.getItem(position);
				cityName = cityBean.getCityName();
				if (cityName.equals(CityConstant.LOAD_CITY_FAIL) || cityName.equals(CityConstant.LOADING_CITY)) {
					return;
				}
			} else {
				cityName = mRAdapter.getItem(position);
				if (cityName.equals(CityConstant.NO_CITY_FOUND) || cityName.equals(CityConstant.TRAIN_NO_CITY_FOUND))
					return;
			}

			hideInputMethod();
			LocationUtil lu = LocationUtil.getInst();
			String lastCityName = lu.getSavedCity();
			if (!cityName.equals(lastCityName)) {
				lu.setSavedCity(cityName);

			}

			popView.setTag(cityName);
			this.dismiss();
		}

	}

	private OnScrollListener onScroll = new OnScrollListener() {
		@Override
		public void onScrollStateChanged(AbsListView view, int scrollState) {
			switch (scrollState) {
			case OnScrollListener.SCROLL_STATE_IDLE:
				hideInputMethod();

				break;

			case OnScrollListener.SCROLL_STATE_FLING:
				hideInputMethod();
				break;

			case OnScrollListener.SCROLL_STATE_TOUCH_SCROLL:
				hideInputMethod();
				break;

			default:
				break;
			}
		}

		@Override
		public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {

		}
	};

	private void hideResult() {
		mCityList.setVisibility(View.VISIBLE);
		letterListView.setVisibility(View.VISIBLE);
		mCityResultList.setVisibility(View.GONE);
	}

	private TextView.OnEditorActionListener mInputListener = new TextView.OnEditorActionListener() {
		@Override
		public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
			System.currentTimeMillis();
			if (actionId == EditorInfo.IME_ACTION_SEARCH) {
				if (mCityResultList.getVisibility() == View.VISIBLE) {
					if (mRAdapter != null && mRAdapter.getItem(0) != null && !mRAdapter.getItem(0).isEmpty()) {
						if (mRAdapter.getItem(0).startsWith("没有找")) {
							return true;
						}
						popView.setTag(mRAdapter.getItem(0));
						dismiss();
						return true;
					}
				}
				// hideResult();
				// String gpsCity = "";
				// if (TextUtils.isEmpty(gpsCity)) {
				// gpsCity = CityConstant.LOAD_CITY_FAIL;
				// }
				// mAdapter.setGpsCity(gpsCity);
				// mAdapter.notifyDataSetChanged();
			}
			return true;
		}
	};
	private TextWatcher cityInputWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			// if(s.length()==0){
			// mCityInput.setGravity(Gravity.CENTER|Gravity.CENTER_VERTICAL);
			// }else {
			// mCityInput.setGravity(Gravity.LEFT|Gravity.CENTER_VERTICAL);
			// }
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {
			searchCity();
		}
	};

	private void searchCity() {
		String city_name = mCityInput.getText().toString().trim();
		if (TextUtils.isEmpty(city_name)) {
			hideResult();
			return;
		}

		ArrayList<String> cityList = CityDataTmp.getMacthCitys(city_name);

		if (cityList.isEmpty()) {
			cityList.add(CityConstant.NO_CITY_FOUND);
			showResult(cityList);

		} else {
			showResult(cityList);
		}
	}

	private void showResult(ArrayList<String> cityList) {
		mRAdapter.setContent(cityList);
		mCityResultList.setVisibility(View.VISIBLE);
		letterListView.setVisibility(View.GONE);
		mCityList.setVisibility(View.GONE);
		mRAdapter.notifyDataSetChanged();
	}

	private OnKeyListener keyListener = new OnKeyListener() {

		@Override
		public boolean onKey(View v, int keyCode, KeyEvent event) {
			if (keyCode == KeyEvent.KEYCODE_DEL) {
				searchCity();
			}
			if (keyCode == KeyEvent.KEYCODE_ENTER) {
				getCityFromInput();

			}
			return false;
		}
	};
	private TextView overlay;

	private void getCityFromInput() {
		String cityName = mCityInput.getEditableText().toString();

		if (TextUtils.isEmpty(cityName)) {
			// SledogToast.getInstance().show("请客官填写要找的城市名");
			return;
		}
		if (!CityDataTmp.isAvailableCity(cityName)) {
			// SledogToast.getInstance().show("请客官填写有效的城市名");
			return;
		}
		hideInputMethod();
		// context.setResult(10, (new Intent()).setAction(cityName));
		// cleanUp();
		this.dismiss();
	}

	private class LetterListViewListener implements LetterListView.OnTouchingLetterChangedListener {

		@Override
		public void onTouchingLetterChanged(final String s) {
			hideInputMethod();
			Integer position = getCharPosition(s);
			if (position != null) {
				mCityList.setSelection(position);
			}

			if (overlay == null) {
				return;
			}

			overlay.setText(s);
			overlay.setVisibility(View.VISIBLE);
			ThreadingService.getInst().cancelForegroundTask(overlayThread);
			ThreadingService.getInst().runForegroundTask(overlayThread, 1000);
		}
	}

	public Integer getCharPosition(String s) {
		return CityDataTmp.getPosition(s);
	}

	// 设置overlay不可见
	private class OverlayThread implements Runnable {
		@Override
		public void run() {
			try {
				if (overlay != null) {
					overlay.setVisibility(View.GONE);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	// 初始化汉语拼音首字母弹出提示框
	private void initOverlay() {

		try {
			LayoutInflater inflater = LayoutInflater.from(context);
			overlay = (TextView) inflater.inflate(R.layout.message_contact_overlay, null);
			overlay.setVisibility(View.INVISIBLE);
			WindowManager.LayoutParams lp = new WindowManager.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT,
					WindowManager.LayoutParams.TYPE_APPLICATION, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
							| WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE, PixelFormat.TRANSLUCENT);
			WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);

			windowManager.addView(overlay, lp);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void dismiss() {
		super.dismiss();
		if (requestLoactionCity != null) {
			requestLoactionCity.cancel();
		}
		if (mCityInput != null) {
			mCityInput.getText().clear();
			mCityInput.setVisibility(View.INVISIBLE);
			mCityInput.setCursorVisible(false);
		}
		if (city_textview != null) {
			city_textview.setVisibility(View.VISIBLE);
		}

	}
}
