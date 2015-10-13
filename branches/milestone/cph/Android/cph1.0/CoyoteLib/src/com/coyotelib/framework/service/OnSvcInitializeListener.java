package com.coyotelib.framework.service;

public interface OnSvcInitializeListener {
	void onInitialize() throws Exception;

	void onClearInitedState();
}
