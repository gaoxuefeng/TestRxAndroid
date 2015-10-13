package com.coyotelib.framework.statistics;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.concurrent.Callable;

import android.database.Cursor;
import android.provider.BaseColumns;
import android.text.TextUtils;

import com.coyotelib.core.database.BaseTable;
import com.coyotelib.core.database.DB;
import com.coyotelib.core.network.HttpService;
import com.coyotelib.core.network.INetworkStatus;
import com.coyotelib.core.network.OnNetworkChangedListener;
import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.threading.IThreadingService;
import com.coyotelib.framework.network.INetworkStatusService;
import com.coyotelib.framework.network.URIBuilder;
import com.coyotelib.framework.service.NetworkTaskInfo;
import com.coyotelib.framework.service.PeriodicalNetworkTaskScheduler;

public class StatisticService implements IStatisticService,
		OnNetworkChangedListener {

	private NetworkTaskInfo mTaskInfo;
	private PeriodicalNetworkTaskScheduler mTaskScheduler;
	private ArrayList<IStatisticContentProducer> mStatisticProducer = new ArrayList<IStatisticContentProducer>();
	private IThreadingService mThreadingSvc;

	public StatisticService(NetworkTaskInfo info, DB db,
			IThreadingService threadingSvc) {
		mTaskInfo = info;
		mThreadingSvc = threadingSvc;
		mSTTable = new StatisticTable(db);
		mSTTable.createTable();

		mTaskScheduler = new PeriodicalNetworkTaskScheduler(
				new ReportStatisticTask(), info.getPeriodMillis(),
				info.getTimeKeeperKey());
	}

	private static final int TYPE_COUNT = 1;
	private static final int TYPE_CONTENT = 2;

	private static final int FLAG_OVERWRITE = 1;
	private static final int FLAG_APPEND = 2;

	private static class StatisticItem {
		public int id = 0;
		public String name = "";
		public int count = 0;
		public String content = "";
		public int type = 0;

		public StatisticItem(String name, int count, String content, int type) {
			this.name = name;
			this.count = count;
			this.content = content;
			this.type = type;
		}

		public static StatisticItem newCountStatisticItem(String name, int count) {
			return new StatisticItem(name, count, "", TYPE_COUNT);
		}

		public static StatisticItem newContentStatisticItem(String name,
				String content) {
			return new StatisticItem(name, 1, content, TYPE_CONTENT);
		}
	}

	private StatisticTable mSTTable;

	private class AddingStatisticTask implements Runnable {
		private StatisticItem item;
		private int flag;

		public AddingStatisticTask(StatisticItem item, int flag) {
			this.item = item;
			this.flag = flag;
		}

		@Override
		public void run() {
			mSTTable.addStatistic(item, flag);
		}
	}

	@Override
	public void onNetworkChanged(INetworkStatus status) {
		try {
			mTaskScheduler.runAsync(status);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private class ReportStatisticTaskString implements Runnable {
		Collection<String> mPBStringList;

		ReportStatisticTaskString(Collection<String> list) {
			mPBStringList = list;
		}

		String formatSendString() {
			boolean isFirst = true;
			StringBuilder sb = new StringBuilder();
			for (String item : mPBStringList) {
				if (!isFirst) {
					sb.append("&");
				} else {
					isFirst = false;
				}
				sb.append(item);
			}
			return sb.toString();
		}

		@Override
		public void run() {
			doSend();
		}

		boolean doSend() {
			String sendingStr = formatSendString();
			if (TextUtils.isEmpty(sendingStr)) {
				return true;
			}
			URIBuilder uriBuilder = new URIBuilder(mTaskInfo.getHostApi()
					.getHost(), mTaskInfo.getHostApi().getAPI());
			uriBuilder.addRawParams(sendingStr);
			HttpService hs = (HttpService) CoyoteSystem.getCurrent()
					.getService(HttpService.class);
			try {
				return hs.fetchResponseByGet(uriBuilder.toURI()) != null;
			} catch (IOException e) {
				e.printStackTrace();
				return false;
			}
		}
	}

	private class ReportStatisticTask implements Callable<Boolean> {
		@Override
		public Boolean call() throws Exception {
			boolean success = false;
			ArrayList<StatisticItem> pbItems = null;
			try {
				pbItems = mSTTable.getStatisticList(-1);
				ArrayList<String> list = getSendingList(pbItems);
				ReportStatisticTaskString sendingTask = new ReportStatisticTaskString(
						list);
				success = sendingTask.doSend();
				return success;
			} finally {
				if (success) {
					if (pbItems != null) {
						for (StatisticItem pbItem : pbItems) {
							mSTTable.remove(pbItem);
						}
					}
				}
			}
		}
	}

	private ArrayList<String> getSendingList(ArrayList<StatisticItem> pbItems) {
		ArrayList<String> list = getStatisticItemSendList(pbItems);
		
		return list;
	}

	private ArrayList<String> getStatisticItemSendList(
			ArrayList<StatisticItem> pbItems) {
		ArrayList<String> result = new ArrayList<String>();
		for (StatisticItem pbItem : pbItems) {
			String itemStr = null;
			String pbName = pbItem.name;
			if (pbItem.type == TYPE_COUNT) {
				itemStr = String.format("%s=%d", pbName, pbItem.count);
			} else if (pbItem.type == TYPE_CONTENT) {
				itemStr = String.format("%s=%s", pbName, pbItem.content);
			}
			if (!TextUtils.isEmpty(itemStr)) {
				result.add(itemStr);
			}
		}
		return result;
	}

	private static class StatisticTable extends BaseTable {

		public StatisticTable(DB db) {
			super(db);
			this.createTable();
		}

		private static final String STATISTIC_TABLE = "statistic";

		public static final String STATISTIC_NAME = "name";
		public static final String STATISTIC_COUNT = "count";
		public static final String STATISTIC_CONTENT = "content";
		public static final String STATISTIC_TYPE = "type";

		public final static String CREATE_STATISTIC_TABLE = String
				.format("CREATE TABLE IF NOT EXISTS %s ( %s  INTEGER PRIMARY KEY, %s  TEXT, %s INTEGER, %s  TEXT, %s INTEGER)",
						STATISTIC_TABLE, BaseColumns._ID, STATISTIC_NAME,
						STATISTIC_COUNT, STATISTIC_CONTENT, STATISTIC_TYPE);

		public static CursorConverter cursorToSTItem = new CursorConverter() {

			@Override
			public Object toObject(Cursor cursor) {
				int id = cursor.getInt(cursor.getColumnIndex(BaseColumns._ID));
				String name = cursor.getString(cursor
						.getColumnIndex(STATISTIC_NAME));
				int count = cursor.getInt(cursor
						.getColumnIndex(STATISTIC_COUNT));
				String content = cursor.getString(cursor
						.getColumnIndex(STATISTIC_CONTENT));
				int type = cursor.getInt(cursor.getColumnIndex(STATISTIC_TYPE));
				StatisticItem result = new StatisticItem(name, count, content,
						type);
				result.id = id;
				return result;
			}
		};

		public void createTable() {
			this.execQuery(CREATE_STATISTIC_TABLE);
		}

		private void addStatistic(StatisticItem stItem, int flag) {
			if (stItem.type == TYPE_COUNT) {
				StatisticItem oldItem = this.getStatisticItem(stItem.name);
				if (oldItem == null) {
					this.insert(stItem);
				} else {
					stItem.count += oldItem.count;
					this.update(stItem);
				}
			} else if (stItem.type == TYPE_CONTENT) {
				switch (flag) {
				case FLAG_OVERWRITE:
					if (getStatisticItem(stItem.name) != null) {
						update(stItem);
					} else {
						insert(stItem);
					}
					break;
				case FLAG_APPEND:
					insert(stItem);
					break;
				}
			}
		}

		public StatisticItem getStatisticItem(String name) {
			final String GET_STATISTIS_ITEM = String.format(
					"SELECT * FROM %s WHERE %s ='%s'", STATISTIC_TABLE,
					STATISTIC_NAME, name);
			Object result = singleResultFromQuery(GET_STATISTIS_ITEM,
					cursorToSTItem);
			return result == null ? null : (StatisticItem) result;
		}

		public ArrayList<StatisticItem> getStatisticList(int count) {
			final String GET_STATISTIC = String.format(
					"SELECT * FROM %s WHERE %s > 0 LIMIT %d", STATISTIC_TABLE,
					STATISTIC_COUNT, count <= 0 ? 40 : count);
			ArrayList<StatisticItem> list = new ArrayList<StatisticItem>();
			this.resultListFromQuery(GET_STATISTIC, list, cursorToSTItem);
			return list;
		}

		public void insert(StatisticItem pbItem) {
			final String INSERT_STATISTIC = String
					.format("INSERT INTO %s (%s, %s, %s, %s) VALUES ('%s', %d, '%s', %d)",
							STATISTIC_TABLE, STATISTIC_NAME, STATISTIC_COUNT,
							STATISTIC_CONTENT, STATISTIC_TYPE, pbItem.name,
							pbItem.count, pbItem.content, pbItem.type);
			this.execQuery(INSERT_STATISTIC);
		}

		public void update(StatisticItem pbItem) {
			final String UPDATE_STATISTIC_ITEM = String
					.format("UPDATE %s SET %s='%s', %s=%d, %s='%s', %s=%d WHERE %s='%s'",
							STATISTIC_TABLE, STATISTIC_NAME, pbItem.name,
							STATISTIC_COUNT, pbItem.count, STATISTIC_CONTENT,
							pbItem.content, STATISTIC_TYPE, pbItem.type,
							STATISTIC_NAME, pbItem.name);
			this.execQuery(UPDATE_STATISTIC_ITEM);
		}

		public void delete(int id) {
			final String DELETE_STATISTIC_ITEM = String.format(
					"DELETE FROM %s WHERE %s=%d", STATISTIC_TABLE,
					BaseColumns._ID, id);
			this.execQuery(DELETE_STATISTIC_ITEM);
		}

		public void remove(StatisticItem item) {
			if (item.type == TYPE_COUNT) {
				StatisticItem oldBackItem = getStatisticItem(item.name);
				if (oldBackItem == null)
					return;
				item.count = Math.max(oldBackItem.count - item.count, 0);
				if (item.count == 0) {
					delete(item.id);
				} else {
					update(item);
				}
			} else if (item.type == TYPE_CONTENT) {
				delete(item.id);
			}
		}
	}

	@Override
	public void increamentStatisticCount(String name) {
		addStatisticCount(name, 1);
	}

	@Override
	public void addStatisticCount(String name, int count) {
		if (TextUtils.isEmpty(name) || count == 0) {
			return;
		}
		mThreadingSvc.runBackgroundTask(new AddingStatisticTask(StatisticItem
				.newCountStatisticItem(name, count), 0));		
	}

	@Override
	public void addStatisticContent(String name, String content,
			boolean overwrite) {
		if (TextUtils.isEmpty(name) || TextUtils.isEmpty(content)) {
			return;
		}

		mThreadingSvc.runBackgroundTask(new AddingStatisticTask(StatisticItem
				.newContentStatisticItem(name, content),
				overwrite ? FLAG_OVERWRITE : FLAG_APPEND));
				
	}

	@Override
	public void registerStatisticContentProducer(
			IStatisticContentProducer producer) {
		mStatisticProducer.add(producer);
		
	}

	@Override
	public void tryReportNow() {
		try {
			INetworkStatusService svc = (INetworkStatusService) CoyoteSystem
					.getCurrent().getService(INetworkStatusService.class);
			this.onNetworkChanged(svc.currentNetworkStatus());
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}

	@Override
	public void oneWayReport(String... params) {
		mThreadingSvc.runBackgroundTask(new ReportStatisticTaskString(Arrays
				.asList(params)));		
	}

	@Override
	public void onNetworkConnectChanged(boolean isConnect) {
		// TODO Auto-generated method stub
		
	}
}
