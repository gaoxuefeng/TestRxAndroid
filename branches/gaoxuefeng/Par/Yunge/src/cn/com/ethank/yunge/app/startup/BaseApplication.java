package cn.com.ethank.yunge.app.startup;

import android.app.Activity;
import android.app.Application;
import android.os.Environment;

import com.coyotelib.app.sys.SysInfoImp;
import com.coyotelib.core.database.DB;
import com.coyotelib.core.network.HttpService;
import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.setting.SharedPreferenceSetting;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.DefaultThreadingService;
import com.coyotelib.core.threading.IThreadingService;
import com.coyotelib.framework.database.CoyoteDB;
import com.coyotelib.framework.network.DefaultHttpService;
import com.coyotelib.framework.network.INetworkStatusService;
import com.coyotelib.framework.sys.CoyoteSystemImp;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import cn.com.ethank.yunge.app.crash.UncaughtExceptionHandler;
import cn.com.ethank.yunge.app.debuginfo.DebugDefine;
import cn.com.ethank.yunge.app.debuginfo.DebugSwitch;
import cn.com.ethank.yunge.app.imageloader.DemoDuiTangImageReSizer;
import cn.com.ethank.yunge.app.net.DefaultNetworkStatusService;
import cn.jpush.android.api.JPushInterface;
import in.srain.cube.Cube;
import in.srain.cube.diskcache.lru.SimpleDiskLruCache;
import in.srain.cube.image.ImageLoaderFactory;
import in.srain.cube.util.CubeDebug;

/**
 * Created by lvhonghe on 14/12/14.
 */
public class BaseApplication extends Application {

    private static BaseApplication instance;
    public static final int DB_VERSION = 1;
    private static final String DB_NAME = "yunge";
    private CoyoteDB DB_APP;
    private SysInfoImp SYS_INFO;
    private CoyoteSystemImp SYS;

    public static HttpService mHttpService;
    public INetworkStatusService mNetworkStatusSvc;
    private IThreadingService mThreadingSvc;
    public static ISettingService mSettingSvc;

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        DebugSwitch.init(this);
        initCrashCatcher();
        initSys();
        initJpush();
        initPhotoLoad(0);
        initCube();
    }

    private void initCube() {
        // debug options
        SimpleDiskLruCache.DEBUG = true;
        CubeDebug.DEBUG_LIFE_CYCLE = false;
        CubeDebug.DEBUG_CACHE = true;
        CubeDebug.DEBUG_IMAGE = true;
        CubeDebug.DEBUG_REQUEST = true;
        Cube.onCreate(this);
        initImageLoader();
    }

    private void initImageLoader() {


        File path1 = Environment.getExternalStoragePublicDirectory("cube/test1/a/b/c");
        ImageLoaderFactory.customizeCache(
                this,
                // memory size
                1024 * 10,
                // disk cache directory
                path1.getAbsolutePath(),
//                null,
                // disk cache size
                ImageLoaderFactory.DEFAULT_FILE_CACHE_SIZE_IN_KB
        );

//        DefaultImageLoadHandler handler = new DefaultImageLoadHandler(this);
//        // handler.setLoadingImageColor("#999999");
//
//        ImageLoaderFactory.setDefaultImageLoadHandler(handler);
        ImageLoaderFactory.setDefaultImageReSizer(DemoDuiTangImageReSizer.getInstance());

    }

    public void initPhotoLoad(int defaultSrc) {
        // 添加你的配置需求
        DisplayImageOptions displayImageOptions = DisplayImageOptions.createSimple();
        ImageLoaderConfiguration configuration = new ImageLoaderConfiguration.Builder(this).build();
        ImageLoader.getInstance().init(configuration);

    }

    private void initJpush() {
        // DisplayUtil.px2sp(18)*1.125;
        JPushInterface.setDebugMode(true); // 设置开启日志,发布时请关闭日志
        JPushInterface.init(this); // 初始化 JPush

    }

    private void initCrashCatcher() {
        if (DebugDefine.beDebug) {
            Thread.setDefaultUncaughtExceptionHandler(new UncaughtExceptionHandler(this.getApplicationContext()));
        }
    }

    private void initSys() {

        mSettingSvc = new SharedPreferenceSetting(this.getApplicationContext(), "AppSettingPre", Activity.MODE_PRIVATE);
        SYS_INFO = new SysInfoImp(this.getApplicationContext(), mSettingSvc, 0);
        SYS = new CoyoteSystemImp(this.getApplicationContext(), SYS_INFO);
        CoyoteSystem.setCurrent(SYS);

        SYS.addService(ISettingService.class, mSettingSvc);

        mNetworkStatusSvc = new DefaultNetworkStatusService(false);

        SYS.addService(INetworkStatusService.class, mNetworkStatusSvc);

        mHttpService = new DefaultHttpService();
        SYS.addService(HttpService.class, mHttpService);

        DB_APP = new CoyoteDB(this.getApplicationContext(), DB_VERSION, DB_NAME);
        SYS.addService(DB.class, DB_APP);

        mThreadingSvc = new DefaultThreadingService();
        SYS.addService(IThreadingService.class, mThreadingSvc);

    }

    public List<Activity> cacheActivityList = new ArrayList<Activity>();

    public void exit() {
        if (cacheActivityList.size() > 0) {
            for (int i = 0; i < cacheActivityList.size(); i++) {
                cacheActivityList.get(i).finish();
            }
        }
    }

    public void exitObjectActivity(Class<?> c) {
        if (cacheActivityList.size() > 0) {
            for (int i = 0; i < cacheActivityList.size(); i++) {
                if (cacheActivityList.get(i).getClass() == c) {
                    cacheActivityList.get(i).finish();
                }
            }
        }
    }

    public static BaseApplication getInstance() {

        return instance;
    }
}
