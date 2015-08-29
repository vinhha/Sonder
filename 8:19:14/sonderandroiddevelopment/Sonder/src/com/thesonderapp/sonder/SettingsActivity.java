package com.thesonderapp.sonder;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.view.Window;
import android.widget.TextView;

import com.parse.ParseUser;

public class SettingsActivity extends Activity{

	public static final String TAG = SettingsActivity.class.getSimpleName();
	protected TextView mLogOutTextView;
	protected TextView mUpdateBioTextView;
	protected TextView mEditProfileTextView;
	protected TextView mEditSocialMediaTextView;
	protected TextView mTermsTextView;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		
		
		requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
		setContentView(R.layout.activity_settings);
		
		ActionBar actionBar = getActionBar();
		actionBar.setDisplayShowHomeEnabled(false);
		actionBar.setCustomView(R.layout.back_left_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		

		mUpdateBioTextView = (TextView)findViewById(R.id.updateBio);
		mTermsTextView = (TextView)findViewById(R.id.terms);
		mEditProfileTextView = (TextView)findViewById(R.id.editProfile);
		mEditSocialMediaTextView = (TextView)findViewById(R.id.editSocialMedia);
		mLogOutTextView = (TextView)findViewById(R.id.logOutButton);
		
		
		mLogOutTextView.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View v) {
				ParseUser.logOut();
				Intent intent = new Intent(SettingsActivity.this, LaunchActivity.class);
				intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
				startActivity(intent);
			}
		});
		mUpdateBioTextView.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(SettingsActivity.this, EditAboutActivity.class);
				startActivity(intent);
			}
		});
		mEditProfileTextView.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(SettingsActivity.this, EditProfileActivity.class);
				startActivity(intent);
			}
		});
		
		mEditSocialMediaTextView.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(SettingsActivity.this, EditSocialMediaActivity.class);
				startActivity(intent);
			}
		});
		mTermsTextView.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(SettingsActivity.this, TermsActivity.class);
				startActivity(intent);
			}
		});
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
	// Inflate the menu; this adds items to the action bar if it is present.
	getMenuInflater().inflate(R.menu.settings, menu);
	return true;
	}

	public void Back (View v) {
		Intent intent = new Intent(SettingsActivity.this, HomeActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);
	}
	
}
	
	
	
	
//	@SuppressLint("InlinedApi") @Override
//	public boolean onOptionsItemSelected(MenuItem item) {
//	int itemId = item.getItemId();
//	if (itemId == R.id.action_settings) {
//		ParseUser.logOut();
//		
//		
//	}
//	return false;
//	}
	
//return super.onOptionsItemSelected(item);
//	}
//	@Override
//	public void onListItemClick(ListView l, View v, int position, long id) {
//		super.onListItemClick(l,  v,  position, id);
//		switch (position){
//		case 0:
//		
//		Intent intent = new Intent(v.getContext(), LoginActivity.class);
//		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
//		startActivity(intent);
//		break;
//	}
//	}










