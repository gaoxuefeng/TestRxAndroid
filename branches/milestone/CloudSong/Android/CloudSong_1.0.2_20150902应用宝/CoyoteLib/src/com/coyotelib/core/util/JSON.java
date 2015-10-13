package com.coyotelib.core.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Pair;

public final class JSON {
	public static JSONObject jsonFromString(String str) {
		if (str == null) {
			return null;
		}
		try {
			return new JSONObject(str);
		} catch (JSONException e) {
			return null;
		}
	}

	public static String getString(JSONObject j, String key, String def) {
		try {
			return null != j && j.has(key) ? j.getString(key) : def;
		} catch (Exception e) {
			return def;
		}
	}

	public static double getDouble(JSONObject j, String key, double def) {
		try {
			return null != j && j.has(key) ? j.getDouble(key) : def;
		} catch (Exception e) {
			return def;
		}
	}

	public static int getInt(JSONObject j, String key, int def) {
		try {
			return null != j && j.has(key) ? j.getInt(key) : def;
		} catch (Exception e) {
			return def;
		}
	}

	public static long getLong(JSONObject j, String key, long def) {
		try {
			return null != j && j.has(key) ? j.getLong(key) : def;
		} catch (Exception e) {
			return def;
		}
	}

	public static JSONObject getObj(JSONObject j, String key, JSONObject def) {
		try {
			return null != j && j.has(key) ? j.getJSONObject(key) : def;
		} catch (Exception e) {
			return def;
		}
	}

	public static JSONArray getArray(JSONObject j, String key, JSONArray def) {
		try {
			return null != j && j.has(key) ? j.getJSONArray(key) : def;
		} catch (Exception e) {
			return def;
		}
	}

    public static boolean getBoolean(JSONObject j, String key, boolean def) {

        try {
            return null != j && j.has(key) ? j.getBoolean(key) : def;
        } catch (Exception e) {
            return def;
        }
    }

	public static Map<String, String> getMap(Object o) {
		JSONObject j = null;
		if (o instanceof JSONObject) {
			j = (JSONObject) o;
		} else if (o instanceof String) {
			try {
				j = new JSONObject((String) o);
			} catch (Exception e) {
				return null;
			}
		}
		Map<String, String> map = new HashMap<String, String>();
		try {
			if (null != j) {
				for (Iterator<?> iter = j.keys(); iter.hasNext();) {
					String k = (String) iter.next();
					String v = JSON.getString(j, k, "");
					map.put(k.trim(), v.trim());
				}
			}
		} catch (Exception e) {
			return null;
		}
		return map.isEmpty() ? null : map;
	}

	public static ArrayList<Pair<String, String>> getItems(Object o) {
		if (o instanceof JSONObject) {
			return getItems(o);
		} else if (o instanceof String) {
			try {
				JSONObject j = new JSONObject((String) o);
				return getItems(j);
			} catch (Exception e) {
				return null;
			}
		}
		return null;
	}

	public static ArrayList<Pair<String, String>> getItems(JSONObject j) {
		ArrayList<Pair<String, String>> list = new ArrayList<Pair<String, String>>();
		try {
			if (null != j) {
				for (Iterator<?> iter = j.keys(); iter.hasNext();) {
					String k = (String) iter.next();
					String v = JSON.getString(j, k, "");
					list.add(new Pair<String, String>(k, v));
				}
			}
		} catch (Exception e) {
			return null;
		}
		return list.size() != 0 ? list : null;
	}
}
