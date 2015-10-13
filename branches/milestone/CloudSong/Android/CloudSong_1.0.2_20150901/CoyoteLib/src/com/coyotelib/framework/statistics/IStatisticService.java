/**
 * 
 */
package com.coyotelib.framework.statistics;


/**
 * @author lvhonghe
 *
 */
public interface IStatisticService {
	
	void increamentStatisticCount(String name);

	void addStatisticCount(String name, int count);

	void addStatisticContent(String name, String content, boolean overwrite);

	void registerStatisticContentProducer(IStatisticContentProducer producer);

	void tryReportNow();

	void oneWayReport(String... params);}
