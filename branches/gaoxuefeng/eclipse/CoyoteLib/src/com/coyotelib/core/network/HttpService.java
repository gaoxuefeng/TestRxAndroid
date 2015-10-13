package com.coyotelib.core.network;

import android.text.TextUtils;

import com.coyotelib.core.setting.ISettingService;
import com.coyotelib.core.util.JSON;
import com.coyotelib.core.util.coding.AbstractCoding;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.params.ClientPNames;
import org.apache.http.client.params.CookiePolicy;
import org.apache.http.client.protocol.ClientContext;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HTTP;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public abstract class HttpService {

    public static final int DEFAULT_HTTP_TIMEOUT = 20 * 1000;
    private ArrayList<OnHttpResponseListener> mResponseJsonListeners = new ArrayList<OnHttpResponseListener>();
    HttpContext localContext = null;
    CookieStore cookieStore = null;
    ISettingService settingService;

    public HttpService(ISettingService settingService) {
        this.settingService = settingService;
    }

    private void notifyResponseJsonListeners(URI request, String response) {
        for (OnHttpResponseListener listener : mResponseJsonListeners) {
            listener.onHttpResponse(request, response);
        }
    }

    public void register(OnHttpResponseListener listener) {
        try {
            mResponseJsonListeners.add(listener);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private byte[] parse(HttpEntity entity) {
        String str = null;
        try {
            str = EntityUtils.toString(entity, HTTP.UTF_8);
        } catch (ParseException e) {
        } catch (IOException e) {
        }
        return str != null ? str.getBytes() : null;
    }

    public byte[] fetchBytesByGet(URI uri, int timeout) throws IOException {
        return fetchBytesByGet(uri, timeout, this.defaultCoding());
    }

    /**
     * Imp hint: choose a default coding
     */
    protected abstract AbstractCoding defaultCoding();

    /**
     * Call this function will notify registered OnHttpResponseListener
     */
    final public String fetchStringByPost(URI uri, HttpEntity entity,
                                          int timeout, AbstractCoding coding) throws IOException {
        byte[] bytes = fetchBytesByPost(uri, entity, timeout, coding);
        String res = null;
        if (bytes != null) {
            try {
                res = new String(bytes, "utf-8");
                if (!TextUtils.isEmpty(res)) {
                    notifyResponseJsonListeners(uri, res);
                }
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        return res;
    }

    /**
     * Call this function will notify registered OnHttpResponseListener
     */
    final public String fetchStringByGet(URI uri, int timeout,
                                         AbstractCoding coding) throws IOException {
        byte[] bytes = fetchBytesByGet(uri, timeout, coding);
        String res = null;
        try {
            if (bytes == null) {
                return null;
            }
            res = new String(bytes, "utf-8");
            if (!TextUtils.isEmpty(res)) {
                notifyResponseJsonListeners(uri, res);
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return res;
    }

    /**
     * Functions without coding will use defaultCoding() !!!
     */
    public final byte[] fetchBytesByPost(URI uri, Map<String, String> kv)
            throws IOException {
        return fetchBytesByPost(uri, kv, DEFAULT_HTTP_TIMEOUT, defaultCoding());
    }

    public final byte[] fetchBytesByGet(URI uri) throws IOException {
        return fetchBytesByGet(uri, DEFAULT_HTTP_TIMEOUT, defaultCoding());
    }

    public final String fetchStringByGet(URI uri) throws IOException {
        return fetchStringByGet(uri, DEFAULT_HTTP_TIMEOUT, defaultCoding());
    }

    public final String fetchStringByPost(URI uri, Map<String, String> kv)
            throws IOException {
        return fetchStringByPost(uri, mapToEntity(kv), DEFAULT_HTTP_TIMEOUT,
                defaultCoding());
    }

    public final JSONObject fetchJsonByGet(URI uri) throws IOException {
        return fetchJsonByGet(uri, DEFAULT_HTTP_TIMEOUT, defaultCoding());
    }

    public final JSONObject fetchJsonByGetWithoutCoding(URI uri)
            throws IOException {
        return fetchJsonByGet(uri, DEFAULT_HTTP_TIMEOUT, null);
    }

    public final JSONObject fetchJsonByPost(URI uri, Map<String, String> kv)
            throws IOException {
        return fetchJsonByPost(uri, mapToEntity(kv), DEFAULT_HTTP_TIMEOUT,
                defaultCoding());
    }

    public byte[] fetchBytesByGet(URI uri, int timeout, AbstractCoding coding)
            throws IOException {
        HttpGet get = new HttpGet(uri);
        HttpResponse res = getResponse(get, timeout);
        if (null != res) {
            HttpEntity entity = res.getEntity();
            byte[] data = EntityUtils.toByteArray(entity);
            return null != coding ? coding.decode(data) : data;
        }
        return null;
    }

    final public byte[] fetchBytesByGet(URI uri, AbstractCoding coding)
            throws IOException {
        return fetchBytesByGet(uri, DEFAULT_HTTP_TIMEOUT, coding);
    }

    private HttpEntity mapToEntity(Map<String, String> kv) throws IOException {
        List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
        for (String key : kv.keySet()) {
            nameValuePairs.add(new BasicNameValuePair(key, kv.get(key)));
        }
        return new UrlEncodedFormEntity(nameValuePairs, HTTP.UTF_8);
    }

    final public byte[] fetchBytesByPost(URI uri, Map<String, String> kv,
                                         int timeout, AbstractCoding coding) throws IOException {
        List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
        for (String key : kv.keySet()) {
            nameValuePairs.add(new BasicNameValuePair(key, kv.get(key)));
        }
        return fetchBytesByPost(uri, mapToEntity(kv), timeout, coding);
    }


    final public byte[] fetchBytesByPost(URI uri, HttpEntity entity,
                                         int timeout, AbstractCoding coding) throws IOException {
        byte[] bytes = null;
        HttpPost post = new HttpPost(uri);
        if (entity != null) {
            post.setEntity(entity);
        }
        HttpResponse res = getResponse(post, timeout);
        if (null != res) {
            bytes = parse(res.getEntity());
        }
        return bytes != null ? coding.decode(bytes) : null;
    }


    final public byte[] fetchBytesByPost(URI uri, Map<String, String> kv,
                                         AbstractCoding coding) throws IOException {
        return fetchBytesByPost(uri, mapToEntity(kv), DEFAULT_HTTP_TIMEOUT,
                coding);
    }

    final public byte[] fetchBytesByPost(URI uri, HttpEntity entity,
                                         AbstractCoding coding) throws IOException {
        return fetchBytesByPost(uri, entity, DEFAULT_HTTP_TIMEOUT, coding);
    }

    final public String fetchStringByPost(URI uri, Map<String, String> kv,
                                          AbstractCoding coding) throws IOException {
        return fetchStringByPost(uri, mapToEntity(kv), DEFAULT_HTTP_TIMEOUT,
                coding);
    }

    final public String fetchStringByPost(URI uri, HttpEntity entity,
                                          AbstractCoding coding) throws IOException {
        return fetchStringByPost(uri, entity, DEFAULT_HTTP_TIMEOUT, coding);
    }

    final public String fetchStringByGet(URI uri, AbstractCoding coding)
            throws IOException {
        return fetchStringByGet(uri, DEFAULT_HTTP_TIMEOUT, coding);
    }

    final public JSONObject fetchJsonByGet(URI uri, int timeout,
                                           AbstractCoding coding) throws IOException {
        String str = fetchStringByGet(uri, timeout, coding);
        return JSON.jsonFromString(str);
    }

    final public JSONObject fetchJsonByGet(URI uri, AbstractCoding coding)
            throws IOException {
        return fetchJsonByGet(uri, DEFAULT_HTTP_TIMEOUT, coding);
    }

    final public JSONObject fetchJsonByPost(URI uri, HttpEntity entity,
                                            int timeout, AbstractCoding coding) throws IOException {
        String str = fetchStringByPost(uri, entity, timeout, coding);
        return JSON.jsonFromString(str);
    }

    final public JSONObject fetchJsonByPost(URI uri, Map<String, String> kv,
                                            AbstractCoding coding) throws IOException {
        return fetchJsonByPost(uri, mapToEntity(kv), DEFAULT_HTTP_TIMEOUT,
                coding);
    }

    final public JSONObject fetchJsonByPost(URI uri, HttpEntity entity,
                                            AbstractCoding coding) throws IOException {
        return fetchJsonByPost(uri, entity, DEFAULT_HTTP_TIMEOUT, coding);
    }


    final public HttpResponse fetchResponseByGet(URI uri) throws IOException {
        return fetchResponseByGet(uri, DEFAULT_HTTP_TIMEOUT);
    }

    final public HttpResponse fetchResponseByGet(URI uri, int timeout)
            throws IOException {
        HttpGet get = new HttpGet(uri);
        return getResponse(get, timeout);
    }

    public final JSONObject repeatfetchJsonByGet(URI uri,
                                                 AbstractCoding coding, int retryCount, int intervalTimeoutMillis) {
        while (retryCount-- > 0) {
            JSONObject json = null;
            try {
                json = fetchJsonByGet(uri, intervalTimeoutMillis, coding);
            } catch (IOException e) {
                continue;
            }
            if (json != null) {
                return json;
            }
        }
        return null;
    }

    public final JSONObject repeatfetchJsonByGet(URI uri, int retryCount,
                                                 int intervalTimeoutMillis) {
        return this.repeatfetchJsonByGet(uri, defaultCoding(), retryCount,
                intervalTimeoutMillis);
    }

    public final JSONObject repeatfetchJsonByGet(URI uri, int retryCount) {
        return this.repeatfetchJsonByGet(uri, retryCount, DEFAULT_HTTP_TIMEOUT);
    }

    private static final String KEY_AUTH_SESSION = "com.simiao.yaogeili.auth_session";
    private HttpResponse getResponse(HttpUriRequest req, int timeout/*, boolean saveCookies*/)
            throws IOException {
        if (localContext == null || cookieStore == null) {
            localContext = new BasicHttpContext();
            cookieStore = new BasicCookieStore();
            localContext.setAttribute(ClientContext.COOKIE_STORE, cookieStore);
      //      CookieManager.getInstance().setAcceptCookie(true);
        }

        String val = settingService.getString(KEY_AUTH_SESSION, "");

        HttpClient client = new DefaultHttpClient();
        client.getParams().setParameter(ClientPNames.COOKIE_POLICY, CookiePolicy.RFC_2109);

        client.getParams()
                .setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, timeout)
                .setParameter(CoreConnectionPNames.SO_TIMEOUT, timeout);
        if(!TextUtils.isEmpty(val)) {
          //  req.addHeader("Cookie", "auth_token=" +val + ";");
            req.setHeader("Cookie", "" + "auth_token" + "=" + val + ";");
        }

        try {
            HttpResponse response = client.execute(req, localContext);
         //   HttpResponse response = client.execute(req/*, localContext*/);
            return response;
        } catch (ClientProtocolException e) {
            throw new IOException(String.format("failed in http: %s", req
                    .getURI().toString()));
        }
    }

    public void setAuth(String val) {
        if(!TextUtils.isEmpty(val)) {
            settingService.setString(KEY_AUTH_SESSION, val);

        }
    }

    public void clearCookie() {
        if(cookieStore != null) {
            cookieStore.clear();
        }
    }
}
