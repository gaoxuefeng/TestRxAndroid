package cn.com.ethank.yunge.app.imageloader;

import android.content.res.Resources;

import cn.com.ethank.yunge.app.startup.BaseApplication;
import in.srain.cube.request.DefaultRequestProxy;
import in.srain.cube.request.FailData;
import in.srain.cube.request.IRequest;
import in.srain.cube.request.IRequestProxy;
import in.srain.cube.request.JsonData;
import in.srain.cube.request.RequestBase;
import in.srain.cube.request.RequestProxyFactory;

/**
 * process request
 */
public class DemoRequestProxy extends DefaultRequestProxy implements RequestProxyFactory {

    private static DemoRequestProxy sInstance;

    public static DemoRequestProxy getInstance() {
        if (sInstance == null) {
            sInstance = new DemoRequestProxy();
        }
        return sInstance;
    }

    @Override
    public void onRequestFail(RequestBase request, FailData failData) {

        int code = failData.getErrorType();

        Resources resources = BaseApplication.getInstance().getResources();



    }

    @Override
    public JsonData processOriginDataFromServer(RequestBase request, JsonData data) {
        return super.processOriginDataFromServer(request, data);
    }

    @Override
    public IRequestProxy createProxyForRequest(IRequest request) {
        return getInstance();
    }
}
