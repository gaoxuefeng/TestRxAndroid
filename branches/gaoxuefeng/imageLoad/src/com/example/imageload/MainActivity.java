package com.example.imageload;

import in.srain.cube.image.ImageLoader;
import in.srain.cube.image.ImageLoaderFactory;
import android.app.Activity;
import android.os.Bundle;
import android.widget.ListView;

public class MainActivity extends Activity {

	private ImageLoader mImageLoader;
	private ListView load_more_small_image_list_view;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		load_more_small_image_list_view = (ListView) findViewById(R.id.load_more_small_image_list_view);
		mImageLoader = ImageLoaderFactory.create(this);
		ViewAdapter viewAdapter=new ViewAdapter(this,mImageLoader,Images.getImages());
		load_more_small_image_list_view.setAdapter(viewAdapter);
	}
}
