package cn.com.ethank.yunge.app.record;

import java.io.IOException;

import com.coyotelib.core.sys.CoyoteSystem;
import com.coyotelib.core.util.file.Path;

import android.media.MediaRecorder;
import android.os.Environment;
import android.util.Log;

public class Recorder {
	
	private final String LOG_TAG = "RECORD";
	private static final Recorder INST = new Recorder();
	
	private MediaRecorder mRecorder = null;
	
	private Recorder() {
		
	}
	
	public static Recorder getInst() {
		return INST;
	}
	
	public void releaseRecord() {
		
	}
	
	public void startRecording(String fileName) {
		 mRecorder = new MediaRecorder();
        mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        mRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
        mRecorder.setOutputFile(getRecorderFileName(fileName));
        mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);

        try {
            mRecorder.prepare();
        } catch (IOException e) {
            Log.e(LOG_TAG, "prepare() failed");
        }

        mRecorder.start();
	}
	
	public void stopRecording() {
		mRecorder.stop();
        mRecorder.release();
        mRecorder = null;
	}
	
	private String getRecorderFileName(String fileName) {
		return Path.appendedString(CoyoteSystem.getCurrent().getDataRootDirectory(), fileName + ".mp3");
	}
	
	private static final String UPLOAD_URL = "192.168.1.226:9000/ethank-KTVCenter-deploy/box/record/upload.json";
}
