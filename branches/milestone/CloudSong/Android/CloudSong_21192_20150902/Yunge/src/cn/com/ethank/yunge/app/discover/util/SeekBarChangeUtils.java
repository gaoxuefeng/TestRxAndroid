package cn.com.ethank.yunge.app.discover.util;

import cn.com.ethank.yunge.app.catering.utils.RefreshUiInterface;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;

public class SeekBarChangeUtils {

	public static void seekLisener(SeekBar sb_aduio_progress, final RefreshUiInterface refreshUiInterface) {
		sb_aduio_progress.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {

			@Override
			public void onStopTrackingTouch(SeekBar seekBar) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onStartTrackingTouch(SeekBar seekBar) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
				if (fromUser) {
					refreshUiInterface.refreshUi(progress);
				}
			}
		});
	}

}
