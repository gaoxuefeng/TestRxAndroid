package cn.com.ethank.yunge.app.discover.util;

import java.util.ArrayList;
import java.util.List;

import android.media.MediaPlayer;

import cn.com.ethank.yunge.app.discover.bean.DiscoverInfo;

public class DisCoverConstantUtils {

	public List<String> musicUrlList = new ArrayList<String>();
	public List<String> musicNameList = new ArrayList<String>();

	public static int disCoverIndex = 0;
	public static List<DiscoverInfo> disCoverList = null;

	// 播放界面的控件
	public static MediaPlayer player = null;

	// 播放模式
	public static int playModel = 1;

}
