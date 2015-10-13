package org.app.music.tool;

import java.io.File;
import java.io.FileFilter;
import java.io.FilenameFilter;

public class Other {

	/**
	 * �ļ���������1
	 * */
	public class ScanMusicFilenameFilter implements FilenameFilter {
		private static final String suffixs=".MP3.WMA.AAC.M4A";
		public boolean accept(File dir, String filename) {
			if(suffixs.contains("."+Contsant.getSuffix(filename))){
				return true;
			}
			return false;
		}

	}
	/**
	 * �ļ�������
	 * */
	public class ScanMusicFilterFile implements FileFilter{

		public boolean accept(File pathname) {
			if(pathname.isDirectory()&&pathname.canRead()){
				return pathname.list().length>0;
			}
			return false;
		}
	}
	
}
