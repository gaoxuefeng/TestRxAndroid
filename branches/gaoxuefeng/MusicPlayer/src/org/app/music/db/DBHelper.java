package org.app.music.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteDatabase.CursorFactory;

public class DBHelper extends SQLiteOpenHelper {
	/**游标***/
	private Cursor c = null;
	/**建立表的语句**/
	private static final String CREATE_TAB = "create table "+ "music(_id integer primary key autoincrement,music_id integer,clicks integer," +"latest text)";
	/**列名***/
	private static final String TAB_NAME = "music";
	/**数据库***/
	private SQLiteDatabase db = null;
	/***构造函数**/
	public DBHelper(Context context, String name, CursorFactory factory,
			int version) {
		super(context, name, factory, version);
	}
    /***构造一个数据库，如果没有就创建一个数据库***/
	@Override
	public void onCreate(SQLiteDatabase db) {
		this.db = db;
		db.execSQL(CREATE_TAB);
	}
	/**插入数据**/
	public void insert(ContentValues values){
		SQLiteDatabase db = getWritableDatabase();
		db.insert(TAB_NAME, null, values);
		db.close();
	}
     /*** 更新数据*/
	public void update(ContentValues values,int id){
		SQLiteDatabase db = getWritableDatabase();
		db.update(TAB_NAME, values, "music_id="+id, null);
		db.close();
	}
	/**删除数据*/
	public void delete(int id){
		if (db == null){
			db = getWritableDatabase();
		}
		db.delete(TAB_NAME, "music_id=?", new String[]{String.valueOf(id)});
	}
	/***查找数据*/
	public Cursor query(int id){
		SQLiteDatabase db = getReadableDatabase();
		c = db.query(TAB_NAME, null, "music_id=?", new String[]{String.valueOf(id)}, null, null, null);
		db.close();
		return c;
	}
	/***按点击量查询**/
	public Cursor queryByClicks(){
		SQLiteDatabase db = getReadableDatabase();
		c = db.query(TAB_NAME, null, null, null, null, null, "clicks desc");
		return c;
	}
	/***按时间降序查询**/
	public Cursor queryRecently(){
		SQLiteDatabase db = getReadableDatabase();
		c = db.query(TAB_NAME, null, null, null, null, null, "latest desc");
		return c;
	}
	/***关闭数据库***/
	public void close(){
		if (db != null){
			db.close();
			db=null;
		}
		if (c!=null){
			c.close();
			c=null;
		}
	}
	
	@Override
	public void onUpgrade(SQLiteDatabase db, int arg1, int arg2) {
               
	}

}
