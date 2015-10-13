package cn.com.ethank.yunge.app.search.city;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
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
import android.widget.ListView;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.home.PredeteFragment;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.util.ThreadingService;
import cn.com.ethank.yunge.framework.location.LocationInfo;
import cn.com.ethank.yunge.framework.location.LocationUtil;
import cn.com.ethank.yunge.framework.location.OnCityFindListener;

import com.coyotelib.app.ui.indexlist.LetterListView;

public class ChooseCityActivity extends Activity implements OnItemClickListener {

	EditText mCityInput;
	PinnedHeaderListView mCityList;
	ListView mCityResultList;
	ChooseCityAdapter2 mAdapter;
	CityResultAdapter mRAdapter;

	private String mGpsCity;
	private LetterListView letterListView;
	private TextView overlay;
	private OverlayThread overlayThread;

	public static final String CURRENT_CITY_INTENT = "ChooseCityActivity_current_city_intent";
	public static final String INTENT_CITY_CHANGED_BROADCAST = "ChooseCityActivity_broadcast_city_change_intent";

	public static final String INTENT_ACTION_BROADCAST_CITY_CHANGE = "com.sg.sledog.SEARCH_CITY_CHANGE";
	public static final String INTENT_EXTRA_CITY_CHANGE_NAME = "city";

	private InputMethodManager imm;
	// private boolean mBroadCastCityChange;

	public static String GPS_LOCATE_RECEIVER = "ChooseCityActivity.GpsLocateReciver";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.choose_city_layout);
		BaseApplication.getInstance().cacheActivityList.add(this);
		imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		mCityList = (PinnedHeaderListView) findViewById(R.id.city_list);

		mCityList.setOnItemClickListener(this);
		mCityList.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				hideInputMethod();
				return false;
			}

		});
		mCityList.setDivider(null);
		mAdapter = new ChooseCityAdapter2(this, mCityList, null);// 用这个参数得改
		mCityList.setAdapter(mAdapter);
		mCityList.setOnScrollListener(mAdapter);
		mCityList.setPinnedHeaderView(LayoutInflater.from(this).inflate(R.layout.city_header, mCityList, false));

		mCityResultList = (ListView) findViewById(R.id.city_result_list);
		mCityResultList.setOnItemClickListener(this);
		mCityResultList.setOnScrollListener(onScroll);
		mRAdapter = new CityResultAdapter();
		mCityResultList.setAdapter(mRAdapter);
		mCityResultList.setVisibility(View.GONE);
		mCityResultList.setDivider(null);

		LocationUtil lu = LocationUtil.getInst();

		mCityInput = (EditText) findViewById(R.id.city_input);
		mCityInput.setHint(R.string.search_change_city_hint);
		mCityInput.setOnEditorActionListener(mInputListener);
		mCityInput.addTextChangedListener(cityInputWatcher);
		mCityInput.setOnKeyListener(keyListener);

		letterListView = (LetterListView) findViewById(R.id.LetterListView);
		letterListView.setOnTouchingLetterChangedListener(new LetterListViewListener());
		letterListView.setColor("#8D2960");

		overlayThread = new OverlayThread();
		initOverlay();

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

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			this.finish();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	// 初始化汉语拼音首字母弹出提示框
	private void initOverlay() {
		LayoutInflater inflater = LayoutInflater.from(this);
		overlay = (TextView) inflater.inflate(R.layout.message_contact_overlay, null);
		overlay.setVisibility(View.INVISIBLE);
		WindowManager.LayoutParams lp = new WindowManager.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT, WindowManager.LayoutParams.TYPE_APPLICATION,
				WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE, PixelFormat.TRANSLUCENT);
		WindowManager windowManager = (WindowManager) this.getSystemService(Context.WINDOW_SERVICE);
		windowManager.addView(overlay, lp);
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

	private void hideInputMethod() {
		if (imm.isActive(mCityInput)) {
			imm.hideSoftInputFromWindow(mCityInput.getWindowToken(), 0);
		}
	}

	public Integer getCharPosition(String s) {
		return CityDataTmp.getPosition(s);
	}

	@Override
	protected void onDestroy() {
		cleanUp();
		super.onDestroy();
	}

	private void cleanUp() {
		try {
			if (cfl != null) {
				LocationUtil.getInst().stopLocateCity(cfl);
				cfl = null;
			}
			if (overlay != null) {
				WindowManager windowManager = (WindowManager) this.getSystemService(Context.WINDOW_SERVICE);
				windowManager.removeView(overlay);
				overlay = null;
			}

			ThreadingService.getInst().cancelForegroundTask(overlayThread);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private TextWatcher cityInputWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {
			searchCity();
		}
	};

	private TextView.OnEditorActionListener mInputListener = new TextView.OnEditorActionListener() {
		@Override
		public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
			System.currentTimeMillis();
			if (actionId == EditorInfo.IME_NULL && event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
				hideResult();
				String gpsCity = mGpsCity;
				if (TextUtils.isEmpty(gpsCity)) {
					gpsCity = CityConstant.LOAD_CITY_FAIL;
				}
				// mAdapter.setGpsCity(gpsCity);
				mAdapter.notifyDataSetChanged();
			}
			return false;
		}
	};

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

	private void hideResult() {
		mCityList.setVisibility(View.VISIBLE);
		letterListView.setVisibility(View.VISIBLE);
		mCityResultList.setVisibility(View.GONE);
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View view, int position, long id) {
		// TODO 城市点击操作
		if (position == 0) {
			Object objBean = mAdapter.getItem(position);
			if (objBean instanceof CityBean) {
				String cityName = ((CityBean) objBean).getCityName();
				setResult(PredeteFragment.CHANGE_CITY, (new Intent()).setAction(cityName));
				cleanUp();
				this.finish();
			} else {

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

			setResult(PredeteFragment.CHANGE_CITY, (new Intent()).setAction(cityName));
			cleanUp();
			this.finish();
		}

	}

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
		setResult(RESULT_OK, (new Intent()).setAction(cityName));
		cleanUp();
		this.finish();
	}

	private OnCityFindListener cfl = new OnCityFindListener() {

		@Override
		public void cityFindAction(LocationInfo locInfo) {
			// if (locInfo == null || TextUtils.isEmpty(locInfo.getCityName()))
			// {
			// mAdapter.setGpsCity(CityConstant.LOAD_CITY_FAIL);
			// } else {
			// mAdapter.setGpsCity(locInfo.getCityName());
			// }
			mAdapter.notifyDataSetChanged();

		}
	};

	public class CityConstant {
		public static final String LOADING_CITY = "正在定位当前城市...";
		public static final String LOAD_CITY_FAIL = "定位失败";
		public static final String HOT_CITY = "热门国内城市";
		public static final String GPS_CITY = "你可能在";
		public static final String NO_CITY_FOUND = "没有找到城市";
		public static final String TRAIN_NO_CITY_FOUND = "没有找到出发站所在的城市";
	}

}
