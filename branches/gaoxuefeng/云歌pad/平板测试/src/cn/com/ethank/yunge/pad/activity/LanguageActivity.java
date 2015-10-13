package cn.com.ethank.yunge.pad.activity;

import java.util.ArrayList;

import com.coyotelib.app.ui.util.UICommonUtil;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import android.widget.ListView;
import cn.com.ethank.yunge.pad.R;
import cn.com.ethank.yunge.pad.adapter.LanguageAdapter;
import cn.com.ethank.yunge.pad.bean.LanguageBean;
import cn.com.ethank.yunge.pad.tabs.NomalTabActivity;

public class LanguageActivity extends NomalTabActivity implements OnClickListener {
	private ListView lv_languages;
	private LanguageAdapter languageAdapter;
	private ArrayList<LanguageBean> languagelist = new ArrayList<LanguageBean>();
	private View ll_language;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_language);
		initView();
		initData();
	}

	private void initData() {
		initLanguageData();
		languageAdapter = new LanguageAdapter(this, languagelist);
		// lv_languages.setAdapter(languageAdapter);
	}

	private void initLanguageData() {
		// 1
		LanguageBean languageBean = new LanguageBean();
		languageBean.setLanguageName("华语 ");
		languageBean.setType("1");
		languagelist.add(languageBean);
		// 2
		languageBean = new LanguageBean();
		languageBean.setLanguageName("粤语");
		languageBean.setType("2");
		languagelist.add(languageBean);
		// 3
		languageBean = new LanguageBean();
		languageBean.setLanguageName("闽南语");
		languageBean.setType("3");
		languagelist.add(languageBean);

		// 4
		languageBean = new LanguageBean();
		languageBean.setLanguageName("英语  ");
		languageBean.setType("4");
		languagelist.add(languageBean);

		// 5
		languageBean = new LanguageBean();
		languageBean.setLanguageName("日语 ");
		languageBean.setType("5");
		languagelist.add(languageBean);

		// 6
		languageBean = new LanguageBean();
		languageBean.setLanguageName("韩语 ");
		languageBean.setType("6");
		languagelist.add(languageBean);

		// 7
		languageBean = new LanguageBean();
		languageBean.setLanguageName("其他 ");
		languageBean.setType("7");
		languagelist.add(languageBean);

	}

	private void initView() {
		setCenterText(R.string.title_langue);
		ll_language = (View) findViewById(R.id.ll_language);
		LayoutParams layoutParams = ll_language.getLayoutParams();
		layoutParams.height = (int) ((UICommonUtil.getScreenWidthPixels(this) * 1010f / 1008) + 0.5f);
		ll_language.setLayoutParams(layoutParams);
		// 华语
		ImageView iv_chinese_language = (ImageView) findViewById(R.id.iv_chinese_language);
		// 韩语
		ImageView iv_Korean_language = (ImageView) findViewById(R.id.iv_Korean_language);
		// 日语
		ImageView iv_Japanese_language = (ImageView) findViewById(R.id.iv_Japanese_language);
		// 粤语
		ImageView iv_Cantonese_language = (ImageView) findViewById(R.id.iv_Cantonese_language);
		// 闽南语
		ImageView iv_Taiwanese_language = (ImageView) findViewById(R.id.iv_Taiwanese_language);
		// 英语
		ImageView iv_English_language = (ImageView) findViewById(R.id.iv_English_language);
		// 其他
		ImageView iv_Other_language = (ImageView) findViewById(R.id.iv_Other_language);
		iv_chinese_language.setOnClickListener(this);
		iv_Korean_language.setOnClickListener(this);
		iv_Japanese_language.setOnClickListener(this);
		iv_Cantonese_language.setOnClickListener(this);
		iv_Taiwanese_language.setOnClickListener(this);
		iv_English_language.setOnClickListener(this);
		iv_Other_language.setOnClickListener(this);

	}

	private void toSongListActivity(LanguageBean languageBean) {
		// Intent intent = new Intent(context,
		// SongListByLanguageTypeActivity.class);
		// intent.putExtra("languageBean", languageBean);
		// startActivity(intent);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.iv_chinese_language:
			toSongListActivity(languagelist.get(0));
			break;
		case R.id.iv_Korean_language:
			toSongListActivity(languagelist.get(5));
			break;
		case R.id.iv_Japanese_language:
			toSongListActivity(languagelist.get(4));
			break;
		case R.id.iv_Cantonese_language:
			toSongListActivity(languagelist.get(1));
			break;
		case R.id.iv_Taiwanese_language:
			toSongListActivity(languagelist.get(2));
			break;
		case R.id.iv_English_language:
			toSongListActivity(languagelist.get(3));
			break;
		case R.id.iv_Other_language:
			toSongListActivity(languagelist.get(6));
			break;

		default:
			break;
		}
	}

}
