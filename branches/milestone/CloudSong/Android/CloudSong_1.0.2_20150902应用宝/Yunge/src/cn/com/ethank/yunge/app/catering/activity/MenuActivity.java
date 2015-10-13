package cn.com.ethank.yunge.app.catering.activity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.TranslateAnimation;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.catering.adapter.MenuTypeContentAdapter;
import cn.com.ethank.yunge.app.catering.adapter.MenuTypeListAdapter;
import cn.com.ethank.yunge.app.catering.adapter.ShoppingListAdapter;
import cn.com.ethank.yunge.app.catering.bean.TypeContentItem;
import cn.com.ethank.yunge.app.catering.network.RequestCartingThread;
import cn.com.ethank.yunge.app.catering.network.RequestMenuTypeThread;
import cn.com.ethank.yunge.app.catering.utils.CanvsPaint;
import cn.com.ethank.yunge.app.catering.utils.ConstantsUtils;
import cn.com.ethank.yunge.app.catering.utils.DipToPx;
import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import cn.com.ethank.yunge.app.catering.utils.SubZeroAndDot;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;
import cn.com.ethank.yunge.app.util.Constants;
import cn.com.ethank.yunge.app.util.DisplayUtil;
import cn.com.ethank.yunge.app.util.ProgressDialogUtils;
import cn.com.ethank.yunge.app.util.SharePreferencesUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;
import cn.com.ethank.yunge.view.ScrollListView;

import com.alibaba.fastjson.JSONObject;

/**
 * @author yinzhengwei
 * 
 *         餐点酒水菜单页面
 */

public class MenuActivity extends BaseTitleActivity implements OnClickListener {

	private ScrollListView listview_typelist_id, listview_typecontent_id;
	private TextView iv_num_id, tv_totalright_id, tv_pay_id;
	// private ImageView anim_iv_id, iv_carlist_id;
	private RelativeLayout addsumshoppingcarlayout_id;
	private LinearLayout paintlist_layout_id;
	private MenuTypeListAdapter typelistAdapter = null;
	private MenuTypeContentAdapter contentAdapter = null;

	private PopupWindow mPopupWindow = null;// 购物车window

	private List<String> typelist = null;

	private int checkTypeSign = 0;

	private String ktvip = "", boxId = "";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		super.setContentView(R.layout.activity_menu);
		BaseApplication.getInstance().cacheActivityList.add(this);

		ktvip = getIntent().getStringExtra("ktvip");
		boxId = getIntent().getStringExtra("boxId");

		Rect rect = new Rect();
		this.getWindow().getDecorView().getWindowVisibleDisplayFrame(rect);
		ConstantsUtils.DisplayTopHeight = rect.top;// 状态栏高度
		ConstantsUtils.AcitivityTitleHeight = DipToPx.dip2px(this, 80);// 标题栏高度

		listview_typelist_id = (ScrollListView) findViewById(R.id.listview_typelist_id);
		listview_typecontent_id = (ScrollListView) findViewById(R.id.listview_typecontent_id);
		listview_typelist_id.setVerticalScrollBarEnabled(false);
		listview_typecontent_id.setVerticalScrollBarEnabled(false);

		listview_typecontent_id.setCacheColorHint(Color.TRANSPARENT);// 防止滑动时列表颜色变化
		iv_num_id = (TextView) findViewById(R.id.iv_num_id);
		tv_totalright_id = (TextView) findViewById(R.id.tv_totalright_id);
		tv_pay_id = (TextView) findViewById(R.id.tv_pay_id);
		addsumshoppingcarlayout_id = (RelativeLayout) findViewById(R.id.addsumshoppingcarlayout_id);
		paintlist_layout_id = (LinearLayout) findViewById(R.id.paintlist_layout_id);
		title.showBtnBack(false);
		title.showBtnFunction(true);
		title.setBtnFunctionImage(R.drawable.remote_close_btn);
		title.setTitle("超市");
		title.setPadding(-15, 0, 0, 0);

		title.setOnBtnFunctionClickAction(this);
		addsumshoppingcarlayout_id.setOnClickListener(this);
		tv_pay_id.setOnClickListener(this);

		getDataMethod();
		CreateShoppingCarPopu();
	}

	/* 餐点类型列表 */
	void getDataMethod() {
		ProgressDialogUtils.show(this, false);
		new RequestMenuTypeThread().getTypeContentData(ktvip, boxId, new RefreshUiInterface() {

			@SuppressWarnings("unchecked")
			@Override
			public void refreshUi(Object result) {
				if (result != null) {
					typelist = (List<String>) result;
					typelistAdapter = new MenuTypeListAdapter(MenuActivity.this, typelist);
					listview_typelist_id.setAdapter(typelistAdapter);
					listview_typelist_id.setOnItemClickListener(new listener());

					/* 餐点类型列表所对应的内容 */
					List<TypeContentItem> list = ConstantsUtils.TYPECONTENT_LIST;
					if (list != null) {
						// 设置第一项的列表内容
						checkTypeGetList();
					}
				}
			}
		}, Constants.getCartingUrl(ktvip, false));
	}

	// 点击餐点类型筛选对应的列表内容
	class listener implements OnItemClickListener {
		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
			// TODO Auto-generated method stub
			if (arg2 == typelistAdapter.getTouchViewSign()) {
				return;
			}
			typelistAdapter.setTouchViewSign(arg2);
			typelistAdapter.notifyDataSetChanged();

			checkTypeSign = arg2;
			checkTypeGetList();
		}
	}

	private void checkTypeGetList() {
		if (typelist != null && typelist.size() > 0) {
			List<TypeContentItem> newlist = new ArrayList<TypeContentItem>();
			for (int i = 0; i < ConstantsUtils.TYPECONTENT_LIST.size(); i++) {
				if (ConstantsUtils.TYPECONTENT_LIST.get(i).getInfoitem().getGType().equals(typelist.get(checkTypeSign).toString())) {
					newlist.add(ConstantsUtils.TYPECONTENT_LIST.get(i));
				}
			}
			if (!newlist.isEmpty()) {
				setTypeContentList(newlist);
			}
		}
	}

	// 启动点餐时的小红点动画
	private void startAnimMethod() {
		final int[] locationStart = ConstantsUtils.locationStart;
		int[] locationTemp = new int[2];
		addsumshoppingcarlayout_id.getLocationOnScreen(locationTemp);
		final int[] locationEnd = new int[2];

		addsumshoppingcarlayout_id.getLocationOnScreen(locationEnd);
		if (locationTemp[0] == locationEnd[0]) {
			locationEnd[0] += DipToPx.dip2px(MenuActivity.this, 25);
		}

		// 创建并启动动画
		CanvsPaint view = new CanvsPaint(MenuActivity.this);
		paintlist_layout_id.addView(view);
		CreatePaint(view, locationStart, locationEnd);
	}

	private int dpTopx(int dp) {
		return DisplayUtil.dip2px(dp);
	}

	boolean flag = false;

	@SuppressLint("NewApi")
	private void CreatePaint(final View view, int[] locationStart, int[] locationEnd) {

		int startx = 0;
		int endx = 0;
		int starty = 0;
		int endy = 0;
		/**
		 * 由于此动画第一次总是不准确，所以根据布局将第一次动画目标对象的坐标和
		 * 
		 * 之后的坐标分别设置不同值，使其达到每次准确到达目标坐标点
		 */
		startx = locationStart[0] - dpTopx(62);
		if (flag) {
			endx = locationEnd[0] - dpTopx(15);
		} else {
			endx = locationEnd[0] - dpTopx(10);
		}
		flag = true;
		starty = locationStart[1] - dpTopx(85);
		endy = locationEnd[1] - dpTopx(90);

		TranslateAnimation anim = new TranslateAnimation(startx, endx, starty, endy);
		// 设置动画持续时间
		anim.setDuration(700);
		view.setAnimation(anim);
		anim.startNow();

		anim.setAnimationListener(new AnimationListener() {

			@Override
			public void onAnimationStart(Animation arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onAnimationRepeat(Animation arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onAnimationEnd(Animation arg0) {
				// TODO Auto-generated method stub
				// /** 结束动画 */
				// anim.cancel();
				view.setVisibility(View.GONE);
				paintlist_layout_id.removeAllViews();
			}
		});
	}

	// boolean isCreateBlur = false;

	// 刷新列表适配器
	void setTypeContentList(List<TypeContentItem> list) {

		contentAdapter = new MenuTypeContentAdapter(list, MenuActivity.this, new RefreshUiInterface() {
			@Override
			public void refreshUi(Object result) {
				// TODO Auto-generated method stub
				if (result != null) {
					startAnimMethod();
				}
				addlist = getaddShoppingDataMethod();
				setPayView(addlist);
			}
		});
		listview_typecontent_id.setAdapter(contentAdapter);

		// if (!isCreateBlur) {
		// // 设置模糊背景
		// new CreateBlurUtils(MenuActivity.this, iv_bg_id).applyBlur();
		// }
		// isCreateBlur = !isCreateBlur;
	}

	String sumprice = "";

	// 刷新费用view的计算和数量变更
	private void setPayView(List<TypeContentItem> addlist) {
		int sum = 0;
		for (int i = 0; i < addlist.size(); i++) {
			int addsum = addlist.get(i).getAddNum();
			sum += addsum;
		}
		if (sum > 0) {
			iv_num_id.setVisibility(View.VISIBLE);
			iv_num_id.setText(sum + "");
		} else {
			iv_num_id.setVisibility(View.GONE);
		}

		// float类型的价格计算总价
		BigDecimal paysum = BigDecimal.ZERO;
		for (int i = 0; i < addlist.size(); i++) {
			TypeContentItem bean = addlist.get(i);
			int itemsum = bean.getAddNum();
			if (itemsum > 0) {
				BigDecimal unitpriceBigDecimal = BigDecimal.valueOf(Double.valueOf(bean.getInfoitem().getGPrice()));
				BigDecimal oneDetailSum = unitpriceBigDecimal.multiply(BigDecimal.valueOf(bean.getAddNum()));
				paysum = paysum.add(oneDetailSum);
			}
		}

		if (paysum.floatValue() > 0) {
			// 正则去掉小数点后的无效数字0
			tv_totalright_id.setVisibility(View.VISIBLE);
			sumprice = SubZeroAndDot.subZeroAndDot(String.valueOf(paysum));
			tv_totalright_id.setText("合计: ￥" + sumprice);
		} else {
			tv_totalright_id.setText("合计: ￥0");
		}
	}

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		switch (arg0.getId()) {
		case R.id.title_function:
			finish();
			break;
		case R.id.addsumshoppingcarlayout_id:
			if (iv_num_id.getVisibility() == View.VISIBLE) {
				// addlist = getaddShoppingDataMethod();
				if (!addlist.isEmpty() && addlist.size() != 0) {
					// showShoppingCarPopu();
					adapter.setList(addlist);
					adapter.notifyDataSetChanged();

					cariv_num_id.setText(iv_num_id.getText().toString());
					tv_total_id.setText(tv_totalright_id.getText().toString());

					// 计算列表高度
					setListViewHeight(addlist.size(), listview_shoppingcarlist_id);

					// mPopupWindow.setAnimationStyle(R.anim.anim_out);
					mPopupWindow.showAsDropDown(title, 0, 0);
				}
			} else {
				ToastUtil.show(getResources().getString(R.string.shoppingcar_isempty));
			}
			break;
		case R.id.tv_pay_id:
			if (iv_num_id.getVisibility() == View.VISIBLE) {
				RequestOrderidMethod();
			} else {
				ToastUtil.show(getResources().getString(R.string.shoppingcar_isempty));
			}
			break;
		default:
			break;
		}
	}

	private void RequestOrderidMethod() {
		ProgressDialogUtils.show(this);
		new RequestCartingThread().getTypeContentData(sumprice, new RefreshUiInterface() {

			@Override
			public void refreshUi(Object result) {
				ProgressDialogUtils.dismiss();
				if (!TextUtils.isEmpty(result.toString())) {
					try {
						JSONObject jsonObj = JSONObject.parseObject(result.toString());
						if (jsonObj.getIntValue("code") == 0) {
							SharePreferencesUtil.saveStringData("cartingorderInfo", jsonObj.getString("data"));
							// --跳转到订单支付界面--
							Intent intent = new Intent(MenuActivity.this, SubmitOrderActivity.class);
							startActivity(intent);
						} else {
							ToastUtil.show(jsonObj.getString("message"));
						}
					} catch (Exception e) {
						ToastUtil.show("数据异常");
					}
				} else {
					ToastUtil.show("联网失败");
				}
			}
		}, ktvip, boxId, addlist);
	}

	List<TypeContentItem> addlist = null;
	ScrollListView listview_shoppingcarlist_id = null;
	ShoppingListAdapter adapter = null;
	TextView cariv_num_id = null;
	TextView tv_total_id = null;
	ImageView iv_bg_id;

	private void CreateShoppingCarPopu() {
		View popview = LayoutInflater.from(this).inflate(R.layout.popu_shoppingcar, null, true);// 弹出窗口包含的视图
		listview_shoppingcarlist_id = (ScrollListView) popview.findViewById(R.id.listview_shoppingcarlist_id);
		iv_bg_id = (ImageView) popview.findViewById(R.id.iv_bg_id);
		listview_shoppingcarlist_id.setCacheColorHint(Color.TRANSPARENT);// 防止滑动时列表颜色变化
		tv_total_id = (TextView) popview.findViewById(R.id.tv_total_id);
		cariv_num_id = (TextView) popview.findViewById(R.id.iv_num_id);
		final TextView tv_clearcar_id = (TextView) popview.findViewById(R.id.tv_clearcar_id);
		TextView tv_pay_id = (TextView) popview.findViewById(R.id.tv_pay_id);
		tv_pay_id.setOnClickListener(this);
		listview_shoppingcarlist_id.setVerticalScrollBarEnabled(false);

		mPopupWindow = new PopupWindow(popview, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, true);
		mPopupWindow.setBackgroundDrawable(new ColorDrawable());
		mPopupWindow.setOutsideTouchable(true);
		mPopupWindow.setFocusable(true);

		// 设置弹出窗口的背景
		ColorDrawable cd = new ColorDrawable();
		mPopupWindow.setBackgroundDrawable(cd);
		mPopupWindow.update();

		addlist = getaddShoppingDataMethod();

		setShoppingPayView(cariv_num_id, tv_total_id, addlist);

		popview.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				diaMissPopu();
			}
		});
		tv_clearcar_id.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				ClearShoppingCar_Method();
			}
		});

		// 计算列表高度
		setListViewHeight(addlist.size(), listview_shoppingcarlist_id);

		adapter = new ShoppingListAdapter(MenuActivity.this, addlist, new RefreshUiInterface() {
			@Override
			public void refreshUi(Object result) {
				// TODO Auto-generated method stub
				// 更新费用和添加数量等view值
				setShoppingPayView(cariv_num_id, tv_total_id, addlist);

				// 计算列表高度
				setListViewHeight(addlist.size(), listview_shoppingcarlist_id);
			}
		});
		listview_shoppingcarlist_id.setAdapter(adapter);

		mPopupWindow.setOnDismissListener(new OnDismissListener() {

			@Override
			public void onDismiss() {
				// TODO Auto-generated method stub
				// 接着刷新主界面列表里的添加数量
				checkTypeGetList();
			}
		});
	}

	// 判断如果数据大于5条的话就将列表的高设为屏幕的1/2，防止太高超屏或满屏
	private void setListViewHeight(int sum, ListView listview) {
		if (sum > 5) {
			listview.getLayoutParams().height = getWindow().getWindowManager().getDefaultDisplay().getHeight() / 2;
		} else {
			listview.getLayoutParams().height = LayoutParams.WRAP_CONTENT;
		}
	}

	// 清理购物车并刷新界面
	private void ClearShoppingCar_Method() {
		for (int i = 0; i < ConstantsUtils.TYPECONTENT_LIST.size(); i++) {
			ConstantsUtils.TYPECONTENT_LIST.get(i).setAddNum(0);
		}

		checkTypeSign = 0;
		checkTypeGetList();

		typelistAdapter.setTouchViewSign(0);
		typelistAdapter.notifyDataSetChanged();

		setPayView(ConstantsUtils.TYPECONTENT_LIST);
		diaMissPopu();
	}

	private void setShoppingPayView(TextView cariv_num_id, TextView tv_total_id, List<TypeContentItem> addlist) {
		setPayView(addlist);
		// popu里费用总数和数量总数与主界面的一致，所以直接从主界面view上可以直接获取
		cariv_num_id.setVisibility(View.VISIBLE);
		tv_total_id.setText(tv_totalright_id.getText().toString());
		cariv_num_id.setText(iv_num_id.getText().toString());
		if (addlist.size() == 0) {
			diaMissPopu();
		}
	}

	// 获取已选择的餐点
	private List<TypeContentItem> getaddShoppingDataMethod() {
		List<TypeContentItem> list = ConstantsUtils.TYPECONTENT_LIST;
		List<TypeContentItem> addlist = new ArrayList<TypeContentItem>();
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getAddNum() > 0) {
				addlist.add(list.get(i));
			}
		}
		return addlist;
	}

	void diaMissPopu() {
		if (mPopupWindow != null && mPopupWindow.isShowing()) {
			mPopupWindow.dismiss();
		}
	}

	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		// 清理缓存
		ConstantsUtils.TYPECONTENT_LIST = new ArrayList<TypeContentItem>();
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub

	}
}
