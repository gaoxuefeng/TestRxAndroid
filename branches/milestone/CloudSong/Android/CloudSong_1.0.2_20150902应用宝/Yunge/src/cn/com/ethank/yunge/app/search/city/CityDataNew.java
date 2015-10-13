package cn.com.ethank.yunge.app.search.city;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.util.Pair;

public class CityDataNew {

	// 存储DTMF Tones
	private static final HashMap<String, Integer> mCityMap = new HashMap<String, Integer>();

	private static final ArrayList<CityListitem> citys = new ArrayList<CityListitem>();

	/*
	 * private static final ArrayList<String> citys = new ArrayList<String>();
	 */
	public static int getPosition(String s) {
		if (mCityMap.size() == 0) {
			mCityMap.put("#", 0);
			mCityMap.put("A", getApos());
			mCityMap.put("B", getBpos());
			mCityMap.put("C", getCpos());
			mCityMap.put("D", getDpos());
			mCityMap.put("E", getEpos());
			mCityMap.put("F", getFpos());
			mCityMap.put("G", getGpos());

			mCityMap.put("H", getHpos());
			mCityMap.put("I", getIpos());
			mCityMap.put("J", getJpos());
			mCityMap.put("K", getKpos());
			mCityMap.put("L", getLpos());
			mCityMap.put("M", getMpos());
			mCityMap.put("N", getNpos());

			mCityMap.put("O", getOpos());
			mCityMap.put("P", getPpos());
			mCityMap.put("Q", getQpos());
			mCityMap.put("R", getRpos());
			mCityMap.put("S", getSpos());
			mCityMap.put("T", getTpos());

			mCityMap.put("U", getUpos());
			mCityMap.put("V", getVpos());
			mCityMap.put("W", getWpos());
			mCityMap.put("X", getXpos());
			mCityMap.put("Y", getYpos());
			mCityMap.put("Z", getZpos());
		}
		return mCityMap.get(s);
	}

	public static ArrayList<CityListitem> getCitys() {
		return citys;
	}

	private final static String[] gpsCity = { "北京" };

	private final static String[] hotCitys = { "上海", "北京", "杭州", "广州", "南京", "深圳", "成都", "重庆", "天津", "武汉", "西安" };

	private final static String[] aCitys = { "阿坝", "阿城", "阿克苏", "阿拉善盟", "阿勒泰", "阿里", "阿图什", "鞍山", "安康", "安庆", "安顺", "安阳" };

	private final static String[] bCitys = { "巴彦淖尔", "巴音郭楞", "巴中", "巴州", "白城", "白山", "白银", "百色", "蚌埠", "包头", "保定", "保山", "宝鸡", "北海", "北京", "本溪", "毕节", "滨州", "博尔塔拉", "博乐", "博州", "亳州" };

	private final static String[] cCitys = { "沧州", "昌都", "昌吉", "常德", "常熟", "常州", "长春", "长沙", "长治", "朝阳", "潮州", "巢湖", "郴州", "成都", "承德", "池州", "赤峰", "重庆", "崇左", "滁州", "楚雄" };

	private final static String[] dCitys = { "达州", "大理", "大连", "大庆", "大同", "大兴安岭", "丹东", "德宏", "德阳", "德州", "迪庆", "定西", "东川", "东胜", "东营", "东莞", "都匀" };

	private final static String[] eCitys = { "鄂尔多斯", "鄂州", "恩施" };

	private final static String[] fCitys = { "防城港", "佛山", "涪陵", "福州", "抚顺", "抚州", "阜新", "阜阳" };

	private final static String[] gCitys = { "甘南", "甘孜", "赣州", "格尔木", "固原", "广安", "广西", "广元", "广州", "桂林", "贵港", "贵阳", "果洛" };

	private final static String[] hCitys = { "哈尔滨", "哈密", "海北", "海东", "海口", "海拉尔", "海西", "邯郸", "汉中", "杭州", "菏泽", "和田", "合肥", "河池", "河源", "鹤壁", "鹤岗", "贺州", "黑河", "衡水", "衡阳", "红河", "呼和浩特", "呼伦贝尔",
			"葫芦岛", "湖州", "怀化", "淮安", "淮北", "珲春", "淮南", "黄冈", "黄南", "黄山", "黄石", "潢川", "惠州" };

	private final static String[] iCitys = {

	};

	private final static String[] jCitys = { "鸡西", "吉安", "吉林", "吉首", "集宁", "济南", "济宁", "济源", "嘉兴", "嘉峪关", "佳木斯", "江汉", "江门", "焦作", "揭阳", "金昌", "金华", "锦州", "晋城", "晋中", "荆门", "荆州", "景德镇", "九江", "酒泉" };

	private final static String[] kCitys = { "喀什", "开封", "凯里", "克拉玛依", "克州", "库尔勒", "奎屯", "昆明" };

	private final static String[] lCitys = { "拉萨", "莱芜", "来宾", "兰州", "廊坊", "漯河", "乐山", "丽江", "丽水", "连云港", "凉山", "聊城", "辽阳", "辽源", "林芝", "临沧", "临汾", "临河", "临夏", "临沂", "柳州", "六安", "六盘水", "龙岩", "陇南",
			"娄底", "吕梁", "洛阳", "泸州" };

	private final static String[] mCitys = { "马鞍山", "茂名", "梅河口", "梅州", "眉山", "绵阳", "牡丹江" };

	private final static String[] nCitys = { "那曲", "南昌", "南充", "南京", "南宁", "南平", "南通", "南阳", "内江", "内蒙古", "宁波", "宁德", "怒江" };

	private final static String[] oCitys = {};

	private final static String[] pCitys = { "攀枝花", "盘锦", "萍乡", "平顶山", "平凉", "莆田", "普洱", "濮阳" };

	private final static String[] qCitys = { "七台河", "齐齐哈尔", "黔东南", "黔江", "黔南", "黔西南", "钦州", "秦皇岛", "青岛", "清远", "庆阳", "曲靖", "泉州", "衢州" };

	private final static String[] rCitys = { "日喀则", "日照" };

	private final static String[] sCitys = { "三门峡", "三明", "三沙", "三亚", "山南", "汕头", "汕尾", "商洛", "商丘", "商州", "上海", "上饶", "韶关", "邵阳", "绍兴", "深圳", "沈阳", "十堰", "石河子", "石家庄", "石嘴山", "双鸭山", "朔州", "四平", "松原",
			"苏州", "宿迁", "宿州", "随州", "绥化", "遂宁" };

	private final static String[] tCitys = { "塔城", "台州", "泰安", "泰州", "太原", "唐山", "天津", "天水", "铁岭", "通化", "通辽", "铜川", "铜陵", "铜仁", "吐鲁番" };

	private final static String[] uCitys = {

	};

	private final static String[] vCitys = {

	};

	private final static String[] wCitys = { "万州", "威海", "潍坊", "渭南", "温州", "文山", "乌海", "乌兰察布", "乌兰浩特", "乌鲁木齐", "无锡", "芜湖", "梧州", "吴忠", "武汉", "武威" };

	private final static String[] xCitys = { "西安", "西藏", "西昌", "西峰", "西宁", "西双版纳", "锡林郭勒盟", "锡林浩特", "厦门", "仙桃", "咸宁", "咸阳", "襄樊", "襄阳", "湘潭", "湘西", "孝感", "新乡", "新余", "忻州", "信阳", "兴安盟", "兴义", "邢台",
			"徐州", "许昌", "宣城" };

	private final static String[] yCitys = { "雅安", "烟台", "盐城", "延安", "延边", "延吉", "扬州", "阳江", "阳泉", "伊春", "伊犁", "伊宁", "宜宾", "宜昌", "宜春", "益阳", "银川", "鹰潭", "营口", "永州", "榆林", "玉林", "玉树", "玉溪", "岳阳",
			"云浮", "运城" };

	private final static String[] zCitys = { "枣庄", "湛江", "漳州", "张家界", "张家口", "张掖", "昭通", "肇庆", "镇江", "郑州", "中山", "中卫", "舟山", "周口", "珠海", "株洲", "驻马店", "资阳", "淄博", "自贡", "遵义" };

	static {
		if (citys.isEmpty()) {
			// 热门城市
			ArrayList<CityBean> myhotList = new ArrayList<CityBean>();
			CityBean bean = new CityBean();
			for (int i = 0; i < hotCitys.length; i++) {
				bean.setCityTitle("热门国内城市");
				bean.setCityName(hotCitys[i]);
				myhotList.add(bean);
			}
			Pair<String, List<CityBean>> hotPair = new Pair<String, List<CityBean>>("热门国内城市", myhotList);
			ArrayList<Pair<String, List<CityBean>>> hotList = new ArrayList<Pair<String, List<CityBean>>>(1);
			hotList.add(hotPair);
			citys.add(CityListitem.createHotItem(hotList));

			if (aCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("A", changeCityBean("A", aCitys), getApos()));
			}

			if (bCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("B", changeCityBean("B", bCitys), getBpos()));
			}

			if (cCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("C", changeCityBean("C", cCitys), getCpos()));
			}

			if (dCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("D", changeCityBean("D", dCitys), getDpos()));
			}

			if (eCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("E", changeCityBean("E", eCitys), getEpos()));
			}

			if (fCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("F", changeCityBean("F", fCitys), getFpos()));
			}

			if (gCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("G", changeCityBean("G", gCitys), getGpos()));
			}

			if (hCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("H", changeCityBean("H", hCitys), getHpos()));
			}

			if (iCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("I", changeCityBean("I", iCitys), getIpos()));
			}

			if (jCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("J", changeCityBean("J", jCitys), getJpos()));
			}

			if (kCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("K", changeCityBean("K", kCitys), getKpos()));
			}

			if (lCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("L", changeCityBean("L", lCitys), getLpos()));
			}

			if (mCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("M", changeCityBean("M", mCitys), getMpos()));
			}

			if (nCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("N", changeCityBean("N", nCitys), getNpos()));
			}

			if (oCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("O", changeCityBean("O", oCitys), getOpos()));
			}

			if (pCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("P", changeCityBean("P", pCitys), getPpos()));
			}

			if (qCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("Q", changeCityBean("Q", qCitys), getQpos()));
			}

			if (rCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("R", changeCityBean("R", rCitys), getRpos()));
			}

			if (sCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("S", changeCityBean("S", sCitys), getSpos()));
			}

			if (tCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("T", changeCityBean("T", tCitys), getTpos()));
			}

			if (uCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("U", changeCityBean("U", uCitys), getUpos()));
			}

			if (vCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("V", changeCityBean("V", vCitys), getVpos()));
			}

			if (wCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("W", changeCityBean("W", wCitys), getWpos()));
			}

			if (xCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("X", changeCityBean("X", xCitys), getXpos()));
			}

			if (yCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("Y", changeCityBean("Y", yCitys), getYpos()));
			}

			if (zCitys.length != 0) {
				citys.add(CityListitem.createNormalListItem("Z", changeCityBean("Z", zCitys), getZpos()));
			}
		}
	}

	private static int getApos() {
		return 1 + hotCitys.length;
	}

	private static int getBpos() {

		return getApos() + aCitys.length;
	}

	private static int getCpos() {
		return getBpos() + bCitys.length;
	}

	private static int getDpos() {
		return getCpos() + cCitys.length;
	}

	private static int getEpos() {
		return getDpos() + dCitys.length;
	}

	private static int getFpos() {
		return getEpos() + eCitys.length;
	}

	private static int getGpos() {
		return getFpos() + fCitys.length;
	}

	private static int getHpos() {
		return getGpos() + gCitys.length;
	}

	private static int getIpos() {
		return getHpos() + hCitys.length;
	}

	private static int getJpos() {
		return getIpos() + iCitys.length;
	}

	private static int getKpos() {
		return getJpos() + jCitys.length;
	}

	private static int getLpos() {
		return getKpos() + kCitys.length;
	}

	private static int getMpos() {
		return getLpos() + lCitys.length;
	}

	private static int getNpos() {
		return getMpos() + mCitys.length;
	}

	private static int getOpos() {
		return getNpos() + nCitys.length;
	}

	private static int getPpos() {
		return getOpos() + oCitys.length;
	}

	private static int getQpos() {
		return getPpos() + pCitys.length;
	}

	private static int getRpos() {
		return getQpos() + qCitys.length;
	}

	private static int getSpos() {
		return getRpos() + rCitys.length;
	}

	private static int getTpos() {
		return getSpos() + sCitys.length;
	}

	private static int getUpos() {
		return getTpos() + tCitys.length;
	}

	private static int getVpos() {
		return getUpos() + uCitys.length;
	}

	private static int getWpos() {
		return getVpos() + vCitys.length;
	}

	private static int getXpos() {
		return getWpos() + wCitys.length;
	}

	private static int getYpos() {
		return getXpos() + xCitys.length;
	}

	private static int getZpos() {
		return getYpos() + yCitys.length;
	}

	public static boolean isInCityList(String city) {
		return true;
		/*
		 * for (int i = 0; i < citys.size(); i++) { for (String str :
		 * citys.get(i)) { if (str.equals(city)) { return true; } } } return
		 * false;
		 */
	}

	public static ArrayList<String> getMacthCitys(String cityPre) {
		ArrayList<String> matchCitys = new ArrayList<String>();
		/*
		 * for (int i = 0; i < citys.size(); i++) { for (String str :
		 * citys.get(i).second) { if (TextUtils.isEmpty(str)) { continue; } if
		 * (str.contains(cityPre)) { if (matchCitys.contains(str)) { continue; }
		 * matchCitys.add(str); } } }
		 */
		return matchCitys;
	}

	public static boolean isAvailableCity(String cityName) {
		/*
		 * for (Pair<String, List<String>> citylist : citys) { if
		 * (citylist.second.contains(cityName)) return true; }
		 */
		return false;
	}

	static List<CityBean> changeCityBean(String cityTitle, String[] cityStrArray) {
		ArrayList<CityBean> cityBeans = new ArrayList<CityBean>();
		
		for (int i = 0; i < cityStrArray.length; i++) {
			CityBean cityBean = new CityBean();
			cityBean.setCityTitle(cityTitle);
			cityBean.setCityName(cityStrArray[i]);
			cityBeans.add(cityBean);
		}
		return cityBeans;
	}
}
