package com.thesonderapp.sonder;

import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseUser;
import com.parse.SaveCallback;

public class EditSocialMediaActivity extends Activity{
	
	
	
	protected TextView mFinishButton;
	protected EditText mTwitter;
	protected EditText mInstagram;
	protected Button mConnectFacebook;

	protected TextView mTitle;

	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_sign_up_social_media);
		
		mFinishButton = (TextView)findViewById(R.id.Finish);
		mTwitter = (EditText)findViewById(R.id.twitterField);
		mInstagram = (EditText)findViewById(R.id.instagramField);
		mConnectFacebook = (Button)findViewById(R.id.facebookButton);

		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.back_left_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		mTitle = (TextView)findViewById(R.id.home_title);
		mTitle.setText("Settings");
	
		
		
		mConnectFacebook.setOnClickListener(new View.OnClickListener(){

			
			

			@Override
			public void onClick(View v) {
				
			}
		});
		
		
		mFinishButton.setOnClickListener(new View.OnClickListener(){


			@Override
			public void onClick(View v) {
				
				
				String twitter = mTwitter.getText().toString();
				String instagram = mInstagram.getText().toString();
				twitter = twitter.trim();
				instagram = instagram.trim();
				
				
					ParseUser currentUser = ParseUser.getCurrentUser();

					
					
					if (twitter != null){
					currentUser.put("twitter", twitter);
					}
					if (instagram != null){
					currentUser.put("instagram", instagram);
					}
					
					currentUser.saveInBackground(new SaveCallback() {
						@SuppressLint("InlinedApi") public void done(ParseException e) {
						    if (e == null) {
						      // Hooray! Let them use the app now.
						    	 Toast.makeText(EditSocialMediaActivity.this,
						 		        "Success!", Toast.LENGTH_SHORT).show();
						    	Intent intent = new Intent(EditSocialMediaActivity.this, SettingsActivity.class);
						    	intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						    	intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
								startActivity(intent);
						    } else {
						      // Sign up didn't succeed. Look at the ParseException
						      // to figure out what went wrong
						    	AlertDialog.Builder builder = new AlertDialog.Builder(EditSocialMediaActivity.this);
								builder.setMessage(e.getMessage())
									.setTitle(R.string.signup_error_title)
									.setPositiveButton(android.R.string.ok, null);
								AlertDialog dialog = builder.create();
								dialog.show();
						    }
						  }
						});
					
				
				}
				
				
				
			//}

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
		Intent intent = new Intent(EditSocialMediaActivity.this, SettingsActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);
	}
}




