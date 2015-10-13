package cn.com.ethank.yunge.app;

import android.app.Fragment;

public abstract class BaseFragment extends Fragment {
	public BaseFragment() {
	}

	

	public abstract void setBind(boolean isBind);

	public abstract void OnFragmentResume();
	public abstract void OnFragmentChanged();
}
