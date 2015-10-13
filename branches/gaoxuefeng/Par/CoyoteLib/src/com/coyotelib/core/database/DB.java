package com.coyotelib.core.database;

import android.database.sqlite.SQLiteDatabase;

public abstract class DB {
	private SQLiteDatabase mDatabase;
	private int mPreviousDBVersion;
	private int mCurrentDBVersion;

	public DB(SQLiteDatabase db, int currentDBVersion) {
		mDatabase = db;
		if (db != null)
			mPreviousDBVersion = db.getVersion();
		mCurrentDBVersion = currentDBVersion;
	}

	public SQLiteDatabase getDataBase() {
		return mDatabase;
	}

	public int getPreviousVersion() {
		return mPreviousDBVersion;
	}

	public int getCurrentVersion() {
		return mCurrentDBVersion;
	}
	
	protected void updateCurrentDBVersion() {
		SQLiteDatabase db = this.getDataBase();
		if (db != null)
			db.setVersion(this.getCurrentVersion());
	}
}
