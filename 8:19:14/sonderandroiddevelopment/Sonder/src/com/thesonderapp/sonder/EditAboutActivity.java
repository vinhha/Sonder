package com.thesonderapp.sonder;

import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseUser;
import com.parse.SaveCallback;

public class EditAboutActivity extends Activity{
	protected TextView mContinueButton;
	protected EditText mBio;
	

	protected TextView mTitle;


	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_sign_up_about);
		
		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.back_left_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		mTitle = (TextView)findViewById(R.id.home_title);
		mTitle.setText("Settings");
		
		mBio = (EditText)findViewById(R.id.bioField);
		
		mContinueButton = (TextView)findViewById(R.id.Continue);
		mContinueButton.setOnClickListener(new View.OnClickListener(){


			@Override
			public void onClick(View v) {
				
				
				String bio = mBio.getText().toString();
				bio = bio.trim();
				
				if (bio.isEmpty()){
					AlertDialog.Builder builder = new AlertDialog.Builder(EditAboutActivity.this);
					builder.setMessage(R.string.bio_error_nothing)
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				
				else if (bio.length() > 140){
					AlertDialog.Builder builder = new AlertDialog.Builder(EditAboutActivity.this);
					builder.setMessage("Make sure your bio is less than 140 characters.")
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else{
					//Add objects to backend
					ParseUser currentUser = ParseUser.getCurrentUser();
					
					currentUser.put("AboutMe", bio);
					
					currentUser.saveInBackground(new SaveCallback() {
						@SuppressLint("InlinedApi") public void done(ParseException e) {
						    if (e == null) {
						      // Hooray! Let them use the app now.
						    	 Toast.makeText(EditAboutActivity.this,
						 		        "Success!", Toast.LENGTH_SHORT).show();
						    	Intent intent = new Intent(EditAboutActivity.this, SettingsActivity.class);
						    	intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						    	intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
								startActivity(intent);
						    } else {
						      // Sign up didn't succeed. Look at the ParseException
						      // to figure out what went wrong
						    	AlertDialog.Builder builder = new AlertDialog.Builder(EditAboutActivity.this);
								builder.setMessage(e.getMessage())
									.setTitle(R.string.signup_error_title)
									.setPositiveButton(android.R.string.ok, null);
								AlertDialog dialog = builder.create();
								dialog.show();
						    }
						  }
						});
					
				
				}
				
				
				
			}

		});
		
		
	}

	



	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.sign_up, menu);
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
	
	public void Back (View v) {
		Intent intent = new Intent(EditAboutActivity.this, SettingsActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);
	}
}
