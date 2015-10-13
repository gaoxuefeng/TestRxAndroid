package com.coyotelib.core.util.file;

import java.io.File;

import android.text.TextUtils;

public final class Path {
	private String mPathStringNoTrailingSlash;

	private static String removeTailingSlash(String pathString) {
		if (TextUtils.isEmpty(pathString))
			return null;
		final int N = pathString.length();
		int pos = N - 1;
		while (pos >= 1 && pathString.charAt(pos) == File.separatorChar) {
			pos -= 1;
		}
		if (pos == N - 1)
			return pathString;

		return pathString.substring(0, pos + 1);
	}

	private static String removeHeadingSlash(String pathString) {
		if (TextUtils.isEmpty(pathString))
			return pathString;
		final int N = pathString.length() - 1;
		int pos = 0;
		while (pos <= N && pathString.charAt(pos) == File.separatorChar) {
			pos += 1;
		}
		if (pos == 0)
			return pathString;

		return pos <= N ? pathString.substring(pos) : null;
	}

	private Path(String pathString) {
		mPathStringNoTrailingSlash = removeTailingSlash(pathString);
	}

	public static Path getPath(String pathString) {
		return new Path(pathString);
	}

	public boolean isEmpty() {
		return TextUtils.isEmpty(mPathStringNoTrailingSlash);
	}

	public String getPathString() {
		return mPathStringNoTrailingSlash;
	}

	public Path append(Path other) {
		if (this.isEmpty())
			return other;
		else if (other == null || other.isEmpty())
			return this;
		else {
			other = new Path(removeHeadingSlash(other.getPathString()));
			if (other.isEmpty()) {
				return this;
			} else {
				return new Path(String.format("%s%c%s",
						this.mPathStringNoTrailingSlash, File.separatorChar,
						other.mPathStringNoTrailingSlash));
			}
		}
	}

	public Path parentPath() {
		String pathString = new File(mPathStringNoTrailingSlash).getParent();
		return new Path(pathString);
	}

	public String getName() {
		return new File(mPathStringNoTrailingSlash).getName();
	}

	public Path append(String pathChild) {
		return this.append(new Path(pathChild));
	}

	public static Path append(String pathParent, String pathChild) {
		return new Path(pathParent).append(pathChild);
	}

	public static String appendedString(String pathParent, String pathChild) {
		return append(pathParent, pathChild).getPathString();
	}
}
