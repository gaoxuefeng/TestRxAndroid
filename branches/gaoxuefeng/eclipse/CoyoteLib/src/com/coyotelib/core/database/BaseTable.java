package com.coyotelib.core.database;

import java.util.ArrayList;
import java.util.List;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public abstract class BaseTable {

	public interface CursorProcessor {
		public boolean process(Cursor cursor, Object arg1, Object arg2);
	}

	public interface CursorConverter {
		public Object toObject(Cursor cursor);
	}

	protected SQLiteDatabase mSqliteDatabase;

	// /////////////////////////////////////////////////////////
	// ///setting table
	public static final int ENUM_SETTING = 5;

	private final static CursorProcessor resultCollectProcessor = new CursorProcessor() {
		@SuppressWarnings("unchecked")
		public boolean process(Cursor cursor, Object arg1, Object arg2) {
			Object obj = ((CursorConverter) arg1).toObject(cursor);
			if (obj != null)
				((List<Object>) arg2).add(obj);
			return false;
		}
	};

	public BaseTable(DB db) {
		mSqliteDatabase = db.getDataBase();
	}

	public int getItemCount(String query) {
		return this.intFromQuery(query);
	}

	public int intFromQuery(String query, int defaultVal) {
		Object retObj = this.singleResultFromQuery(query,
				new CursorConverter() {
					public Object toObject(Cursor cursor) {
						return cursor.getInt(0);
					}
				});
		return retObj != null ? (Integer) retObj : defaultVal;
	}

	public int intFromQuery(String query) {
		return intFromQuery(query, 0);
	}

	public String stringFromQuery(String query, String defVal) {
		Object retObj = this.singleResultFromQuery(query,
				new CursorConverter() {
					public Object toObject(Cursor cursor) {
						return cursor.getString(0);
					}
				});
		return retObj != null ? (String) retObj : defVal;
	}

	public String stringFromQuery(String query) {
		return stringFromQuery(query, null);
	}

	public Object singleResultFromQuery(String query, CursorConverter converter) {
		List<Object> result = new ArrayList<Object>();
		this.resultListFromQuery(query, result, converter);
		return result.size() > 0 ? result.get(0) : null;
	}

	public void resultListFromQuery(String query, List<?> result,
			CursorConverter converter) {
		this.execQuery(query, resultCollectProcessor, converter, result);
	}

	public int execQuery(String query, CursorProcessor processor, Object arg1,
			Object arg2) {
		if (mSqliteDatabase == null)
			return -1;

		Cursor cursor = null;
		try {
			cursor = mSqliteDatabase.rawQuery(query, null);
			return BaseTable.processCursor(cursor, processor, arg1, arg2);
		} catch (Exception ex) {
			ex.printStackTrace();
			return -1;
		} finally {
			if (cursor != null && !cursor.isClosed()) {
				cursor.close();
			}
		}
	}

	public static int processCursor(Cursor cursor, CursorProcessor processor,
			Object arg1, Object arg2) {
		if (cursor == null || processor == null)
			return -1;
		int count = 0;
		while (cursor.moveToNext()) {
			++count;
			boolean stop = processor.process(cursor, arg1, arg2);
			if (stop)
				break;
		}
		return count;
	}

	public static void safeProcessCursor(Cursor cursor,
			CursorProcessor processor, Object arg1, Object arg2) {
		BaseTable.processCursor(cursor, processor, arg1, arg2);
	}

	public void execQuery(String query) {
		mSqliteDatabase.execSQL(query);
	}

	public void execQuery(String query, Object[] bindArgs) {
		mSqliteDatabase.execSQL(query, bindArgs);
	}
	
	public Cursor selectCursor(String query) {
		Cursor cursor = null;
		try {
			cursor = mSqliteDatabase.rawQuery(query, null);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return cursor;
	}
}
