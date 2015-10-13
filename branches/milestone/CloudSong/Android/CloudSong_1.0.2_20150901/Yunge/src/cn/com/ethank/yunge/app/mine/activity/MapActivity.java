package cn.com.ethank.yunge.app.mine.activity;

import java.io.File;
import java.net.URISyntaxException;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.room.bean.BoxDetail;
import cn.com.ethank.yunge.app.startup.BaseActivity;
import cn.com.ethank.yunge.app.util.DisplayUtil;
import cn.com.ethank.yunge.app.util.ToastUtil;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.LocationClientOption.LocationMode;
import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MapViewLayoutParams;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.model.LatLng;

public class MapActivity extends BaseActivity implements OnClickListener {
	private MapView mapview;
	private double lat;
	private double lng;
	String tag = "MapActivity";
	private BaiduMap baiduMap;
	private LatLng hmPos;
	private TextView head_tv_left;
	private PopupWindow window;
	private LocationClient mLocationClient;
	private double currentLat = 0;
	private double currentLng = 0;
	private String ktvName;
	private BoxDetail myRoomInfoBean;
	private TextView tv_ktvname;
	private TextView tv_ktvadress;
	
	private static double lat1 = 31.22997;
	private static double lon = 121.640756;
	public static double x_pi = lat1 * lon / 180.0;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		// 初始化地图 校验key
		initSDK();
		setContentView(R.layout.activity_map);
myRoomInfoBean = (BoxDetail) getIntent().getSerializableExtra("myRoomInfoBean");
		lat = myRoomInfoBean.getLat();
		lng = myRoomInfoBean.getLng();
		ktvName = myRoomInfoBean.getKtvName();
//		ToastUtil.show(myRoomInfoBean.getKtvName()+"...."+myRoomInfoBean.getAddress());
		initView();
		init();
		// 绘制pop
		draw();
	}

	private void init() {
		// 设置地图的缩放级别（V2.X 3~19 V1.X 3~18）
		// V2.X与V1.X的主要区别
		// ①优化了地图文件的格式 优化了空间的使用（北京市 110M 15）
		// ②增加了级别，增加了3D效果（18 19）

		// BaiduMap 管理具体的某一个MapView 操作：旋转，缩放，移动

		baiduMap = mapview.getMap();

		hmPos = new LatLng(lat, lng);
		MapStatusUpdate statusUpdate = MapStatusUpdateFactory.zoomTo(15);
		baiduMap.setMapStatus(statusUpdate);// 设置地图的状态
		// 设置地图中心点 默认
		LatLng latlng = hmPos;// 经纬度 坐标
		MapStatusUpdate pointStatusUpdate = MapStatusUpdateFactory
				.newLatLng(latlng);
		baiduMap.setMapStatus(pointStatusUpdate);

		mapview.showZoomControls(false);// 显示缩放按钮 默认是true
		mapview.showScaleControl(false);// 显示标尺 默认是true
	}

	private void draw() {
		MarkerOptions option = new MarkerOptions();
		option.position(hmPos).icon(
				BitmapDescriptorFactory.fromResource(R.drawable.map_end));
		baiduMap.addOverlay(option);
		View view = View.inflate(getApplicationContext(),
				R.layout.mine_map_pop_layout, null);

		tv_ktvname = (TextView) view.findViewById(R.id.tv_ktvname);
		tv_ktvadress = (TextView) view.findViewById(R.id.tv_ktvadress);
		ImageView iv_gps = (ImageView) view.findViewById(R.id.iv_gps);
		iv_gps.setOnClickListener(this);
//		tv_ktvname.setText(myRoomInfoBean.getKtvName());
//		tv_ktvadress.setText(myRoomInfoBean.getAddress());
		
		MapViewLayoutParams params = new MapViewLayoutParams.Builder()
				.layoutMode(MapViewLayoutParams.ELayoutMode.mapMode	)
				// 指定 MapViewLayoutParams 的方式：屏幕坐标或者地图经纬度坐标
				.position(hmPos)
				// 不能传递null 当模式设置为mapMode时，必须设置positon
				.width(MapViewLayoutParams.WRAP_CONTENT)
				.height(MapViewLayoutParams.WRAP_CONTENT)
				.yOffset(
						-DisplayUtil.dip2px(getResources().getDimension(
								R.dimen.design_30px))).build()
								;
		mapview.addView(view, params);
		if (view != null) {
			view.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					showPopWindow();

				}
			});
		}
	}

	private void initView() {
		head_tv_left = (TextView) findViewById(R.id.head_tv_left);
		TextView head_tv_title = (TextView) findViewById(R.id.head_tv_title);
		head_tv_title.setText("地图");
		mapview = (MapView) findViewById(R.id.mapview);
		head_tv_left.setOnClickListener(this);
	}

	private void initSDK() {
		// 初始化 校验key
		SDKInitializer.initialize(getApplicationContext());
		MyBroadCast broadCast = new MyBroadCast();
		IntentFilter filter = new IntentFilter();
		filter.addAction(SDKInitializer.SDK_BROADCAST_ACTION_STRING_NETWORK_ERROR);// 网络错误
		filter.addAction(SDKInitializer.SDK_BROADTCAST_ACTION_STRING_PERMISSION_CHECK_ERROR);// 校验结果
		registerReceiver(broadCast, filter);
	}

	class MyBroadCast extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			// 校验key的结果
			String result = intent.getAction();
			if (result
					.equals(SDKInitializer.SDK_BROADCAST_ACTION_STRING_NETWORK_ERROR)) {
				// 网络错误
				Toast.makeText(getApplicationContext(), "无网络", 0).show();
				Log.e(tag, "无网络");

			} else if (result
					.equals(SDKInitializer.SDK_BROADTCAST_ACTION_STRING_PERMISSION_CHECK_ERROR)) {
				// 校验失败
				Toast.makeText(getApplicationContext(), "校验失败", 0).show();
				Log.e(tag, "校验失败");
			}
		}

	}

	@Override
	protected void onResume() {
		mapview.onResume();
		super.onResume();
	}

	@Override
	protected void onPause() {
		mapview.onPause();
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		mapview.onDestroy();
		super.onDestroy();
		if (window != null) {
			window.dismiss();
			window = null;
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.head_tv_left:
			finish();
			break;
		case R.id.tv_cancle:
			// 取消
			window.dismiss();
			break;
		case R.id.iv_gps:
			showPopWindow();
			break;
		case R.id.tv_baidu:
			if (isInstallByread("com.baidu.BaiduMap")) {
				try {
					@SuppressWarnings("deprecation")
//					Intent intent = Intent.getIntent("intent://map/geocoder?location="+ lat+ ","+ lng+ "&coord_type=gcj02&output=html#Intent;scheme=bdapp;package=com.baidu.BaiduMap;end");
					Intent intent = Intent.getIntent("intent://map/geocoder?location="+lat+","+lng+"&coord_type=bd09ll&src=yishangkeji|yunge#Intent;scheme=bdapp;package=com.baidu.BaiduMap;end"); 
					startActivity(intent); // 启动调用
				} catch (URISyntaxException e) {
					e.printStackTrace();
				}

			} else {
				// 指导用户下载百度地图
				ToastUtil.show("百度地图客户端没有安装");
			}
			break;
		case R.id.tv_gaode:
			String bd_decrypt = bd_decrypt(lat,lng);
			String[] split = bd_decrypt.split(",");
			if (isInstallByread("com.autonavi.minimap")) {
				Intent intent_gaode = new Intent("android.intent.action.VIEW",android.net.Uri.parse("androidamap://viewMap?sourceApplication=appname&poiname="+ktvName+"&lat="+split[0]+"&lon="+split[1]+"&dev=0"));
				intent_gaode.addCategory("android.intent.category.DEFAULT");
				intent_gaode.setPackage("com.autonavi.minimap");
				startActivity(intent_gaode);
			} else {
				ToastUtil.show("高德地图客户端没有安装");
			}
			
			break;
		default:
			break;
		}
	}
	

	private void showPopWindow() {
		// ToastUtil.show("点到了");
		View inflate = View.inflate(getApplicationContext(),
				R.layout.mine_map_popwindow, null);
		TextView tv_cancle = (TextView) inflate.findViewById(R.id.tv_cancle);
		TextView tv_baidu = (TextView) inflate.findViewById(R.id.tv_baidu);
		TextView tv_gaode = (TextView) inflate.findViewById(R.id.tv_gaode);
		window = new PopupWindow(inflate, LayoutParams.MATCH_PARENT,
				LayoutParams.MATCH_PARENT, true);
		window.setOutsideTouchable(false);
		window.update();
		window.setBackgroundDrawable(new ColorDrawable());
		ColorDrawable cb = new ColorDrawable(0x65000000);
		window.setBackgroundDrawable(cb);
		window.showAtLocation(head_tv_left, 0, 0, 0);
		tv_cancle.setOnClickListener(this);
		tv_baidu.setOnClickListener(this);
		tv_gaode.setOnClickListener(this);
	}

	/**
	 * 判断是否安装目标应用
	 * 
	 * @param packageName
	 *            目标应用安装后的包名
	 * @return 是否已安装目标应用
	 */
	private boolean isInstallByread(String packageName) {
		return new File("/data/data/" + packageName).exists();
	}
	@Override
	protected void onStart() {
		super.onStart();
		if (tv_ktvname != null) {
			tv_ktvname.setText(myRoomInfoBean.getKtvName());
		}
		if(tv_ktvadress != null){
			tv_ktvadress.setText(myRoomInfoBean.getAddress());
		}
	}
	
	
	private void getLocationPosition() {
//		ProgressDialogUtils.show(context);
		mLocationClient = new LocationClient(context);
		LocationClientOption option = new LocationClientOption();
		option.setLocationMode(LocationMode.Hight_Accuracy);// 设置定位模式
		option.setCoorType("gcj02");// 返回的定位结果是百度经纬度，默认值gcj02
		option.setScanSpan(10000);// 设置发起定位请求的间隔时间为5000ms
		option.setIsNeedAddress(true);// 返回的定位结果包含地址信息
		mLocationClient.setLocOption(option);
		MyLocationListener mMyLocationListener = new MyLocationListener();
		mLocationClient.registerLocationListener(mMyLocationListener);
		mLocationClient.start();
		mLocationClient.requestLocation();
	}
	/**
	 * 实现实位回调监听
	 */
	public class MyLocationListener implements BDLocationListener {

		@Override
		public void onReceiveLocation(BDLocation location) {
			try {
				mLocationClient.unRegisterLocationListener(this);
				mLocationClient.stop();
			} catch (Exception e) {
				e.printStackTrace();
			}


			// 经纬度
			currentLat = location.getLatitude();
			currentLng = location.getLongitude();
			
		}
	}
	public  String bd_decrypt(double bd_lat, double bd_lon) 
	 { 
	     double x = bd_lon - 0.0065, y = bd_lat - 0.006; 
	     double z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * x_pi); 
	     double theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * x_pi); 
	     double gg_lon = z * Math.cos(theta); 
	     double gg_lat = z * Math.sin(theta);
	     return gg_lat+","+gg_lon;
	 }

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}

}
