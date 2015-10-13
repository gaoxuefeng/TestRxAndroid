package cn.com.ethank.yunge.app.startup;

import android.app.Activity;
import android.app.Fragment;

public abstract class BaseFragment extends Fragment {
	public BaseFragment() {
	}

	
	public abstract void setBind(boolean isBind);

	public abstract void OnFragmentResume();

	public abstract void OnFragmentChanged();

//	public View setContentView(int layoutResID, LayoutInflater inflater, ViewGroup container) {
//		View viewBase = inflater.inflate(R.layout.fragment_base_layout, container);
//		ViewGroup fl_base_content = (ViewGroup) viewBase.findViewById(R.id.fl_base_content_fragment);
//		View view = LayoutInflater.from(getActivity()).inflate(layoutResID, null);
//		fl_base_content.addView(view, 0);
//		return viewBase;
//	}
}
