package com.example.ducksdemo.takepic;

import android.annotation.SuppressLint;

public class MyInterger {

	private static int num = 0;

	@SuppressLint("NewApi")
	public static int parseInt(String strnum) {
		if (strnum != null && !strnum.isEmpty()) {
			try {
				num = Integer.parseInt(strnum);
			} catch (Exception e) {
				e.printStackTrace();
				num = 0;
			}
		} else {
			num = 0;
		}

		return num;

	}
}
