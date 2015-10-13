package com.coyotelib.core.network;

import java.net.URI;

public interface OnHttpResponseListener {
	void onHttpResponse(URI request, String response);
}
