package com.thesonderapp.sonder;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

public class LaunchActivity extends Activity {

	protected TextView mLogInTextView;
	protected TextView mSignUpTextView;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_launch);
		
		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.empty_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_HOME|ActionBar.DISPLAY_SHOW_CUSTOM);
		
		
		mSignUpTextView = (TextView)findViewById(R.id.LaunchSignUpButton);
		mSignUpTextView.setOnClickListener(new View.OnClickListener(){

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(LaunchActivity.this, SignUpActivity.class);
				startActivity(intent);
				
			}
		});
		
		
		mLogInTextView = (TextView)findViewById(R.id.launchLogInButton);
		mLogInTextView.setOnClickListener(new View.OnClickListener(){

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(LaunchActivity.this, LoginActivity.class);
				startActivity(intent);
				
			}
		});
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.launch, menu);
		return true;
	}
/*
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
	*/
}
