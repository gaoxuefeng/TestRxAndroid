package com.coyotelib.framework.network;

import java.net.URI;
import java.net.URISyntaxException;

import android.text.TextUtils;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.sys.SysInfo;
import com.coyotelib.core.util.coding.AbstractCoding;

public class DefaultURIBuilder {
	private String mScheme = "http";
	private String mHost;
	private String mAPI;
	private String mOrigParam;
	private String mFragment;
	private StringBuilder mParamBuilder;
	private StringBuilder mAdditionalParamBuilder;
	private AbstractCoding mCoding;
	private SysInfo mSysInfo;

	public DefaultURIBuilder(HostApiInfo hostApiInfo, AbstractCoding coding) {
		this(hostApiInfo.getHost(), hostApiInfo.getAPI(), coding);
	}

	public DefaultURIBuilder(HostApiInfo hostApiInfo) {
		this(hostApiInfo.getHost(), hostApiInfo.getAPI(),
				new Base64CryptoCoding());
	}

	public DefaultURIBuilder(String host, String api, AbstractCoding coding) {
		mHost = host;
		mAPI = api;
		if (!mAPI.startsWith("/"))
			mAPI = "/" + mAPI;
		mCoding = coding;
		mParamBuilder = new StringBuilder();
		mAdditionalParamBuilder = new StringBuilder();
	}
	
	public DefaultURIBuilder(URI url, AbstractCoding coding) {
		this(url.getAuthority(), url.getPath(), coding);
		mScheme = url.getScheme();
		mOrigParam = url.getQuery();
		mFragment = url.getFragment();
	}
	
	public DefaultURIBuilder(URI url) {
		this(url, new Base64CryptoCoding());
	}

	public DefaultURIBuilder(String host, String api) {
		this(host, api, new Base64CryptoCoding());
	}

	public DefaultURIBuilder addParam(String key, String value) {
		mParamBuilder.append(String.format("&%s=%s", key, value));
		return this;
	}

	public DefaultURIBuilder addRawParams(String rawParams) {
		if (TextUtils.isEmpty(rawParams))
			return this;
		if (rawParams.startsWith("&"))
			rawParams = rawParams.substring(1);
		if (TextUtils.isEmpty(rawParams))
			return this;
		mParamBuilder.append(String.format("&%s", rawParams));
		return this;
	}

	public DefaultURIBuilder addAdditionalParam(String key, String value) {
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

			String p = String.format("v=%s&parames=%s%s",
					mSysInfo.getProtocolVersion(), encodedParam,
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
		return String.format("hid=%s&is=%s&r=%s&dev=%s&appvers=%s&rom=%s",
				sysInfo.getHID(), sysInfo.getIMSI(),
				sysInfo.getChannelIDWithOrigin(), sysInfo.getPlatform(),
				sysInfo.getFullVersionString(), sysInfo.getRomInfo());
	}

	@Override
	public String toString() {
		return toURI().toString();
	}
}
