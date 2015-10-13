package org.app;

import java.io.Serializable;

public class MusicBean implements Serializable {
	private int _id;// 存放音乐文件的id数组
	private String _titles;// 存放音乐文件的标题数组
	private String _artists; // 存放音乐艺术家的标题数组
	private String _path;// 存放音乐路过的标题数组
	private String _times;// 存放总时间的标题数组
	private String _album;// 存放专辑的标题数组
	private int album_id;// 存放专辑id
	private int _sizes;// 存放文件大小的标题数组
	private String _displayname;//存放名称的标题数组
	public int getAlbum_id() {
		return album_id;
	}
	public void setAlbum_id(int album_id) {
		this.album_id = album_id;
	}
	public int get_id() {
		return _id;
	}
	public void set_id(int _id) {
		this._id = _id;
	}
	public String get_titles() {
		return _titles;
	}
	public void set_titles(String _titles) {
		this._titles = _titles;
	}
	public String get_artists() {
		return _artists;
	}
	public void set_artists(String _artists) {
		this._artists = _artists;
	}
	public String get_path() {
		return _path;
	}
	public void set_path(String _path) {
		this._path = _path;
	}
	public String get_times() {
		return _times;
	}
	public void set_times(String _times) {
		this._times = _times;
	}
	public String get_album() {
		return _album;
	}
	public void set_album(String _album) {
		this._album = _album;
	}
	public int get_sizes() {
		return _sizes;
	}
	public void set_sizes(int _sizes) {
		this._sizes = _sizes;
	}
	public String get_displayname() {
		return _displayname;
	}
	public void set_displayname(String _displayname) {
		this._displayname = _displayname;
	}
}
