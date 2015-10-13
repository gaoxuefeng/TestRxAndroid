package cn.com.ethank.yunge.pad.requsetnetwork;

/**
 * 分页加载需要的参数
 * 
 * @author dddd
 * 
 */
public class Pagination {

	private int startIndex = 0;// 开始startIndex
	private boolean isLastPage = false;

	public int getStartIndex() {
		return startIndex;
	}

	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

	public boolean isLastPage() {
		return isLastPage;
	}

	public void setLastPage(boolean isLastPage) {
		this.isLastPage = isLastPage;
	}

	public void init() {
		setLastPage(false);
		setStartIndex(0);
	}
}
