package com.thesonderapp.sonder;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class TermsActivity extends Activity {

	protected TextView mTitle;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
//		addListenerRadioGroup1();

		
		setContentView(R.layout.terms_and_conditions);
		
		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.back_left_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);

		mTitle = (TextView)findViewById(R.id.home_title);
		mTitle.setText("Settings");
	}
	public void Back (View v) {
		Intent intent = new Intent(TermsActivity.this, SettingsActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);
	}
}
