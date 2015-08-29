package com.thesonderapp.sonder;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

public class PostActivity extends Activity{

	
public static final String TAG = PostActivity.class.getSimpleName();


protected TextView mComposeTextView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_post);
		
		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.post_default_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		
		mComposeTextView = (TextView)findViewById(R.id.composeButton);
		
		mComposeTextView.setOnClickListener(new View.OnClickListener(){
			
			@Override
			public void onClick(View v) {
				
				Intent intent = new Intent(PostActivity.this, ComposeActivityPost.class);
				startActivity(intent);
				
				
			}
		});
		
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
	// Inflate the menu; this adds items to the action bar if it is present.
	getMenuInflater().inflate(R.menu.main, menu);
	return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	switch (item.getItemId())
	{
	case R.id.menu_thoughts:
		Log.i(TAG, "Thoughts Item Clicked");
		Intent intent = new Intent(this, ThoughtsActivity.class);
		startActivity(intent);
		return true;
	case R.id.menu_sonder:
		Log.i(TAG, "Sonder Item Clicked");
		Intent intent1 = new Intent(this, SonderActivity.class);
		startActivity(intent1);
		return true;
	case R.id.menu_post:
		Log.i(TAG, "Post Item Clicked");
		Intent intent2 = new Intent(this, PostActivity.class);
		startActivity(intent2);
		return true;
	case R.id.menu_inbox:
		Log.i(TAG, "Inbox Item Clicked");
		Intent intent3 = new Intent(this, InboxActivity.class);
		startActivity(intent3);
		return true;
	case R.id.menu_home:
		Log.i(TAG, "Home Item Clicked");
		Intent intent4 = new Intent(this, HomeActivity.class);
		startActivity(intent4);
		return true;
		
	default:
		return super.onOptionsItemSelected(item);
	}
	}
}
	
