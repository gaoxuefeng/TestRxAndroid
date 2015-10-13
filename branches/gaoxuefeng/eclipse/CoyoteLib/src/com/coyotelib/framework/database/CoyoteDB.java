package com.coyotelib.framework.database;

import android.content.Context;

import com.coyotelib.core.database.DB;

public class CoyoteDB extends DB {
	public CoyoteDB(Context context, int currentVersion, final String DATABASE_NAME) {
		super(context.openOrCreateDatabase(DATABASE_NAME, Context.MODE_PRIVATE,
				null), currentVersion);

		updateCurrentDBVersion();
	}
}
