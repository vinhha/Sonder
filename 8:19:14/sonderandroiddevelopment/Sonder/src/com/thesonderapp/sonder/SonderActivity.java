package com.thesonderapp.sonder;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;

public class SonderActivity extends Activity{

public static final String TAG = SonderActivity.class.getSimpleName();

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
		setContentView(R.layout.activity_sonder);

		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.sonder_default_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		
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
	
	public void More (View v) {

		ActionBar actionBar = getActionBar();
		actionBar.setDisplayShowHomeEnabled(false);
		actionBar.setCustomView(R.layout.filter_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		
	}
}
	
