package com.coyotelib.framework.network;

import java.net.URI;
import java.net.URISyntaxException;

import android.text.TextUtils;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.sys.SysInfo;
import com.coyotelib.core.util.coding.AbstractCoding;
import com.coyotelib.core.util.coding.PlainCoding;

public class URIBuilder {
	private String mScheme = "http";
	private String mHost;
	private String mAPI;
	private String mOrigParam;
	private String mFragment;
	private StringBuilder mParamBuilder;
	private StringBuilder mAdditionalParamBuilder;
	private AbstractCoding mCoding;
	private SysInfo mSysInfo;

	private static final AbstractCoding DEFAULT_CODING = new Base64CryptoCoding();
//	private static final AbstractCoding DEFAULT_CODING = new PlainCoding();

	public URIBuilder(HostApiInfo hostApiInfo, AbstractCoding coding) {
		this(hostApiInfo.getHost(), hostApiInfo.getAPI(), coding);
	}

	public URIBuilder(HostApiInfo hostApiInfo) {
		this(hostApiInfo.getHost(), hostApiInfo.getAPI(),
			 new PlainCoding()	);
//		new Base64CryptoCoding()
	}

	public URIBuilder(String host, String api, AbstractCoding coding) {
		mHost = host;
		mAPI = api;
		if (!mAPI.startsWith("/"))
			mAPI = "/" + mAPI;
		mCoding = coding;
		mParamBuilder = new StringBuilder();
		mAdditionalParamBuilder = new StringBuilder();
	}
	
	public URIBuilder(URI url, AbstractCoding coding) {
		this(url.getAuthority(), url.getPath(), coding);
		mScheme = url.getScheme();
		mOrigParam = url.getQuery();
		mFragment = url.getFragment();
	}
	
	public URIBuilder(URI url) {
		this(url, DEFAULT_CODING);
	}

	public URIBuilder(String host, String api) {
		this(host, api, DEFAULT_CODING);
	}

	public URIBuilder addParam(String key, String value) {
		mParamBuilder.append(String.format("&%s=%s", key, value));
		return this;
	}

	public URIBuilder addRawParams(String rawParams) {
		if (TextUtils.isEmpty(rawParams))
			return this;
		if (rawParams.startsWith("&"))
			rawParams = rawParams.substring(1);
		if (TextUtils.isEmpty(rawParams))
			return this;
		mParamBuilder.append(String.format("&%s", rawParams));
		return this;
	}

	public URIBuilder addAdditionalParam(String key, String value) {
		if (TextUtils.isEmpty(key))
			return this;
		if (key.startsWith("&"))
			key = key.substring(1);
		if (TextUtils.isEmpty(key))
			return this;
		mAdditionalParamBuilder.append(String.format("&%s=%s", key, value));
		return this;
	}

	public URI toURI() {
		try {

			if (mSysInfo == null)
				mSysInfo = CoyoteSystem.getCurrent().getSysInfo();
			String encodedParam = getHRV() + mParamBuilder.toString();
			if (mCoding != null) {
				encodedParam = mCoding.encodeUTF8ToUTF8(encodedParam);
			}

			String p = String.format("%s&%s%s",
					getCrypoteVersion(), encodedParam,
					mAdditionalParamBuilder.toString());
			if(!TextUtils.isEmpty(mOrigParam)){
				p = p.endsWith("&") ? mOrigParam + p : mOrigParam + "&" + p;
			}
			URI uri = new URI(mScheme, mHost, mAPI, p, mFragment);
			return uri;
		} catch (URISyntaxException e) {
			return null;
		}
	}

	public static String getHRV() {
		SysInfo sysInfo = CoyoteSystem.getCurrent().getSysInfo();
		return String.format("imei=%s&imsi=%s&dev=%s&appvers=%s&rom=%s&aid=%s",
				sysInfo.getIMEI(), sysInfo.getIMSI(),
				sysInfo.getPlatform(),
				sysInfo.getFullVersionString(),
				sysInfo.getRomInfo(),
				sysInfo.getAndroidID());
	}

	private static String getCrypoteVersion() {
		return "v=1";
	}
	@Override
	public String toString() {
		return toURI().toString();
	}
}
