package cn.com.ethank.yunge.app.debuginfo;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.protocol.HTTP;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserFactory;

import android.content.Context;

public class DebugSwitch {
	private static String DEBUG_SWITCHES = "debug_switches.xml";
	private static Map<String, Boolean> SWITCH_MAP = new HashMap<String, Boolean>();

	private DebugSwitch() {
	}

	public static boolean getSwitchValue(String switchName) {
		if (SWITCH_MAP.containsKey(switchName)) {
			return SWITCH_MAP.get(switchName);
		} else {
			return false;
		}

	}

	public static void init(Context context) {
		try {
			InputStream inStream = context.getAssets().open(DEBUG_SWITCHES);

			XmlPullParserFactory pullFactory = XmlPullParserFactory.newInstance();
			XmlPullParser parser = pullFactory.newPullParser();

			parser.setInput(inStream, HTTP.UTF_8);

			int eventType = parser.getEventType();

			String switchName = "";
			boolean switchValue = false;
			while (eventType != XmlPullParser.END_DOCUMENT) {
				switch (eventType) {
				case XmlPullParser.START_DOCUMENT:
					break;

				case XmlPullParser.START_TAG:
					String name = parser.getName();
					if ("switch_name".equals(name)) {
						switchName = parser.nextText();
					}
					if ("switch_value".equals(name)) {
						switchValue = Integer.parseInt(parser.nextText()) == 1;
					}
					break;

				case XmlPullParser.END_TAG:
					if ("item".equals(parser.getName())) {
						SWITCH_MAP.put(switchName, switchValue);
					}
					break;
				default:
					break;
				}
				eventType = parser.next();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}