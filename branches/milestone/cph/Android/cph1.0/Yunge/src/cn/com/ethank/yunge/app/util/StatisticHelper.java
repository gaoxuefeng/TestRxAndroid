package cn.com.ethank.yunge.app.util;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.framework.statistics.IStatisticService;

public class StatisticHelper {
	
	private static StatisticHelper INST = new StatisticHelper();
	
	private StatisticHelper() {
		mStatisticSvc = (IStatisticService) CoyoteSystem.getCurrent().getService(IStatisticService.class);
	}
	
	public static StatisticHelper getInst() {
		return INST;
	}
	
	private IStatisticService mStatisticSvc;
	
	
	public void increamentStatisticCount(String name) {
		mStatisticSvc.increamentStatisticCount(name);
	}

	public void addStatisticCount(String name, int count) {
		mStatisticSvc.addStatisticCount(name, count);
	}

	public void addStatisticContent(String name, String content, boolean overwrite) {
		mStatisticSvc.addStatisticContent(name, content, overwrite);
	}

	public void tryReportNow() {
		mStatisticSvc.tryReportNow();
	}

	public void oneWayReport(String... params) {
		mStatisticSvc.oneWayReport(params);
	}
}
