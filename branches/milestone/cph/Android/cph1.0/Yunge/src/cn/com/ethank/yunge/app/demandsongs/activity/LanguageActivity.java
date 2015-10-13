package cn.com.ethank.yunge.app.demandsongs.activity;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import cn.com.ethank.yunge.R;
import cn.com.ethank.yunge.app.demandsongs.activity.adapter.LanguageAdapter;
import cn.com.ethank.yunge.app.demandsongs.beans.LanguageBean;
import cn.com.ethank.yunge.app.startup.BaseApplication;
import cn.com.ethank.yunge.app.startup.BaseTitleActivity;

public class LanguageActivity extends BaseTitleActivity implements View.OnClickListener, AdapterView.OnItemClickListener {

	private ListView lv_languages;
	private LanguageAdapter languageAdapter;
	private ArrayList<LanguageBean> languagelist = new ArrayList<LanguageBean>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_language);
		BaseApplication.getInstance().cacheActivityList.add(this);
		
		initView();
		initData();
	}

	private void initData() {
		initLanguageData();
		languageAdapter = new LanguageAdapter(context, languagelist);
		lv_languages.setAdapter(languageAdapter);
	}

	private void initLanguageData() {
		// 1
		LanguageBean languageBean = new LanguageBean();
		languageBean.setLanguageName("国语 ");
		languageBean.setType("1");
		languagelist.add(languageBean);
		// 2
		languageBean = new LanguageBean();
		languageBean.setLanguageName("粤语");
		languageBean.setType("2");
		languagelist.add(languageBean);
		// 3
		languageBean = new LanguageBean();
		languageBean.setLanguageName("台语 ");
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
		title.setTitle(R.string.title_langue);
		title.setBtnBackText("点歌");
		title.showBtnFunction();
		lv_languages = (ListView) findViewById(R.id.lv_languages);
		lv_languages.setOnItemClickListener(this);
	}

	private void toSongListActivity(LanguageBean languageBean) {
		Intent intent = new Intent(context, SongListByLanguageTypeActivity.class);
		intent.putExtra("languageBean", languageBean);
		startActivity(intent);
	}

	@Override
	public void onClick(View view) {

		switch (view.getId()) {

		default:
			super.onClick(view);
			break;
		}
	}

	@Override
	public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
		switch (adapterView.getId()) {
		case R.id.lv_languages:
			toSongListActivity(languagelist.get(position));
			break;
		}
	}
}
